// @ts-ignore - Deno resolves this package at runtime via the Edge Function runtime.
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

declare const Deno: {
  env: {
    get(name: string): string | undefined;
  };
  serve: (handler: (req: Request) => Response | Promise<Response>) => void;
};

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SERVICE_ROLE = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
const supabase = createClient(SUPABASE_URL, SERVICE_ROLE);

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(body: unknown, status=200) {
  return new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" }});
}

function decodeJwtPayload(jwt: string): Record<string, unknown> | null {
  try {
    const payloadSegment = jwt.split(".")[1];
    if (!payloadSegment) return null;
    const normalized = payloadSegment.replace(/-/g, "+").replace(/_/g, "/");
    const padded = normalized.padEnd(Math.ceil(normalized.length / 4) * 4, "=");
    return JSON.parse(atob(padded));
  } catch {
    return null;
  }
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return json({ error: "Method not allowed" }, 405);

  const auth = req.headers.get("Authorization");
  if (!auth?.startsWith("Bearer ")) return json({ error: "Login required" }, 401);
  const jwt = auth.slice(7);

  const { data: userData, error: userError } = await supabase.auth.getUser(jwt);
  if (userError || !userData.user) return json({ error: "Invalid session" }, 401);

  const jwtPayload = decodeJwtPayload(jwt);
  const userRole = userData.user.app_metadata?.role ?? userData.user.user_metadata?.role ?? (jwtPayload?.role as string | undefined);
  if (userRole !== "ticket_admin") return json({ error: "Not authorized" }, 403);

  let body: { ticket_id?: string; qr_token?: string; qr_payload?: string };
  try { body = await req.json(); } catch { return json({ error: "Invalid JSON" }, 400); }

  let ticketId = (body.ticket_id ?? "").trim().toUpperCase();
  let token = (body.qr_token ?? "").trim().toLowerCase();
  if (body.qr_payload) {
    const parts = body.qr_payload.trim().split("|");
    if (parts.length === 3 && parts[0] === "LUXEFOODS") {
      ticketId = parts[1].trim().toUpperCase();
      token = parts[2].trim().toLowerCase();
    }
  }

  if (!/^(WALNUT|MAHOGANY)-\d{3}$/.test(ticketId) || !/^[a-f0-9]{32}$/.test(token)) {
    return json({ result: "INVALID", message: "Unrecognized QR code" }, 200);
  }

  const { data, error } = await supabase.rpc("verify_and_use_ticket", {
    p_ticket_id: ticketId,
    p_qr_token: token,
    p_user: userData.user.id,
  });
  if (error) return json({ error: "Verification service error", detail: error.message }, 500);

  const row = data?.[0] ?? { result: "INVALID" };
  return json(row, 200);
});

# Luxe Foods — Secure QR Ticket Verification v2

This package contains **70 individually rendered tickets** with real, unique QR codes:
- 20 WALNUT tickets: WALNUT-001 … WALNUT-020
- 50 MAHOGANY tickets: MAHOGANY-001 … MAHOGANY-050

Each QR payload is `LUXEFOODS|TICKET_ID|RANDOM_SECRET`. The random secret is stored in Supabase and must match for entry to be granted.

## 1. Create the database
1. Create a Supabase project.
2. Open **SQL Editor**.
3. Run `supabase/schema.sql` in one go.
4. Create a staff user in Authentication.
5. Set the staff user’s role to `ticket_admin` in Supabase Auth. The function accepts the role from the JWT/app metadata, so either of these is valid (Dashboard SQL can be used):

```sql
update auth.users
set raw_app_meta_data = coalesce(raw_app_meta_data, '{}'::jsonb) || '{"role":"ticket_admin"}'::jsonb
where email = 'YOUR-STAFF-EMAIL';
```

If you prefer to set the value explicitly in the auth metadata, use `app_metadata`/`user_metadata` in the dashboard or a custom JWT claim with the same `role` value.

## 2. Deploy the verification function
Deploy `supabase/functions/verify-ticket/index.ts` as a Supabase Edge Function named `verify-ticket`. Supabase provides `SUPABASE_URL` and `SUPABASE_SERVICE_ROLE_KEY` to the function environment. **Never put the service-role key in the website.**

## 3. Configure the website
Copy `public/config.example.js` to `public/config.js` and fill in:
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `VERIFY_FUNCTION_URL`

Then upload the `public/` folder to Cloudflare Pages or GitHub Pages.

## 4. Test
Use the QR image embedded in any ticket. The first scan should show **ENTRY GRANTED** and mark the ticket USED. Scanning the same ticket again should show **ALREADY USED**. A QR from another event or a modified token should show **INVALID**.

## 5. Important
The files in `tickets_manifest.csv` and `supabase/schema.sql` contain the QR secrets. Keep them private. Do not publish the manifest.

The old sample QR codes should not be used. Only the 70 new tickets in `PNG/` or `JPG/` are connected to this database seed.

-- Luxe Foods secure QR ticket system v2
-- Run this entire file in Supabase SQL Editor.
-- Each ticket has a random 128-bit QR token.

create extension if not exists pgcrypto;

drop function if exists public.verify_and_use_ticket(text, text, uuid);
drop table if exists public.tickets cascade;

create table public.tickets (
  ticket_id text primary key,
  ticket_type text not null check (ticket_type in ('WALNUT','MAHOGANY')),
  price integer not null,
  qr_token text not null unique,
  status text not null default 'UNUSED' check (status in ('UNUSED','USED','VOID')),
  used_at timestamptz,
  used_by uuid,
  created_at timestamptz not null default now()
);

insert into public.tickets(ticket_id,ticket_type,price,qr_token,status) values
  ('WALNUT-001', 'WALNUT', 1000, 'b3c66da6f5a6f602c2d8de62483e8500', 'UNUSED'),
  ('WALNUT-002', 'WALNUT', 1000, '95f426b6080c1825cc26f22d2efd710a', 'UNUSED'),
  ('WALNUT-003', 'WALNUT', 1000, 'ddffc2cc7d0506341303b1b53941dacf', 'UNUSED'),
  ('WALNUT-004', 'WALNUT', 1000, '8ef3c270262d3a18c74bf00156a048e6', 'UNUSED'),
  ('WALNUT-005', 'WALNUT', 1000, 'd7988b049b6c5c6a73f9c1d33d6ff0d3', 'UNUSED'),
  ('WALNUT-006', 'WALNUT', 1000, 'c7ecaa53637052ab6510474f5ead4775', 'UNUSED'),
  ('WALNUT-007', 'WALNUT', 1000, '3a3219c224b808c490e22a2446bbf629', 'UNUSED'),
  ('WALNUT-008', 'WALNUT', 1000, '8bb46bf4cbc03b124e1969b1d0002214', 'UNUSED'),
  ('WALNUT-009', 'WALNUT', 1000, 'f3561cfbe94f11b170994f4d23eae422', 'UNUSED'),
  ('WALNUT-010', 'WALNUT', 1000, '5b6cd7d03e2edd3cb4ce3d921159e2cd', 'UNUSED'),
  ('WALNUT-011', 'WALNUT', 1000, '71ceb72987300213c1168201a471f3fc', 'UNUSED'),
  ('WALNUT-012', 'WALNUT', 1000, '6f04330fb14936f151638ad4d7c50b32', 'UNUSED'),
  ('WALNUT-013', 'WALNUT', 1000, '433bb155eb1533e86c04aa8989f3f129', 'UNUSED'),
  ('WALNUT-014', 'WALNUT', 1000, 'e46648642c0ef5a658fcde90822fd1e0', 'UNUSED'),
  ('WALNUT-015', 'WALNUT', 1000, '8cf96e2b32e2553fb4224372f299bb66', 'UNUSED'),
  ('WALNUT-016', 'WALNUT', 1000, '128b36fd70a535846f5af042fd5b8673', 'UNUSED'),
  ('WALNUT-017', 'WALNUT', 1000, '0109c8daad283cddd3284639af76a851', 'UNUSED'),
  ('WALNUT-018', 'WALNUT', 1000, '9b105e1b1a67f653fd913d2aa11245bc', 'UNUSED'),
  ('WALNUT-019', 'WALNUT', 1000, '8986b3b7da867fb517dc3a38b7e6abff', 'UNUSED'),
  ('WALNUT-020', 'WALNUT', 1000, 'd686808ae000bb5738d76adb387bf91c', 'UNUSED'),
  ('MAHOGANY-001', 'MAHOGANY', 2500, 'cabbff3260b5a5da96336e1ecc58c9b6', 'UNUSED'),
  ('MAHOGANY-002', 'MAHOGANY', 2500, 'ece603ce8df16339368cc3813300cb95', 'UNUSED'),
  ('MAHOGANY-003', 'MAHOGANY', 2500, '96b30272cf9b386302a1f9431242d0d9', 'UNUSED'),
  ('MAHOGANY-004', 'MAHOGANY', 2500, 'fe1782cc53c111324d18d506e61439f1', 'UNUSED'),
  ('MAHOGANY-005', 'MAHOGANY', 2500, 'f28fb140d796ee8a940111f590f910d7', 'UNUSED'),
  ('MAHOGANY-006', 'MAHOGANY', 2500, '0fa061deb145fd5b7e84f3b251090741', 'UNUSED'),
  ('MAHOGANY-007', 'MAHOGANY', 2500, '694f55debd8e3747562d8c174bcecb40', 'UNUSED'),
  ('MAHOGANY-008', 'MAHOGANY', 2500, '5a648ff61eb2e156d56f5b09b7e95415', 'UNUSED'),
  ('MAHOGANY-009', 'MAHOGANY', 2500, 'c1507fef21d5bf4dd72f57b99dfa7c9a', 'UNUSED'),
  ('MAHOGANY-010', 'MAHOGANY', 2500, 'f5f2954662861425b8268bf51aa9ed8d', 'UNUSED'),
  ('MAHOGANY-011', 'MAHOGANY', 2500, '7dd88c04055d3c3f839d6a8bb9964def', 'UNUSED'),
  ('MAHOGANY-012', 'MAHOGANY', 2500, 'd781db4d3a1fcc0a65d2adb6d8fa0db7', 'UNUSED'),
  ('MAHOGANY-013', 'MAHOGANY', 2500, 'ce23a248788576e686cb05a0804ad1df', 'UNUSED'),
  ('MAHOGANY-014', 'MAHOGANY', 2500, '30d636311117cdd0665dc7d96ace3294', 'UNUSED'),
  ('MAHOGANY-015', 'MAHOGANY', 2500, '6912f651e7d684dae2bdc177082be0af', 'UNUSED'),
  ('MAHOGANY-016', 'MAHOGANY', 2500, 'b41554852c4526f8f00202b4a74ac565', 'UNUSED'),
  ('MAHOGANY-017', 'MAHOGANY', 2500, '7fbdb26462e913ea7c835f8985ffb188', 'UNUSED'),
  ('MAHOGANY-018', 'MAHOGANY', 2500, '5f4b448a1b94b3fa80097652d967a4b6', 'UNUSED'),
  ('MAHOGANY-019', 'MAHOGANY', 2500, '77e70a0496c51a2e2cc87363ff22c635', 'UNUSED'),
  ('MAHOGANY-020', 'MAHOGANY', 2500, 'c6ced39fcf56a7f025d0bb2a3e91aa2a', 'UNUSED'),
  ('MAHOGANY-021', 'MAHOGANY', 2500, 'cfd9924cfd1db099f41a55a3886b21aa', 'UNUSED'),
  ('MAHOGANY-022', 'MAHOGANY', 2500, 'a2d21ef3373c1189594cc6ae3eb3fee5', 'UNUSED'),
  ('MAHOGANY-023', 'MAHOGANY', 2500, 'd9dd5917bfa0c30faf97017c1553045f', 'UNUSED'),
  ('MAHOGANY-024', 'MAHOGANY', 2500, 'e0454ac52fc8224830d59bec398b170b', 'UNUSED'),
  ('MAHOGANY-025', 'MAHOGANY', 2500, 'e12b9b72b5dc44200a2015b190ad0298', 'UNUSED'),
  ('MAHOGANY-026', 'MAHOGANY', 2500, 'e50d0926ed4d1336d15eee08f048487b', 'UNUSED'),
  ('MAHOGANY-027', 'MAHOGANY', 2500, '694a7954a0aca89315ed6957884f8064', 'UNUSED'),
  ('MAHOGANY-028', 'MAHOGANY', 2500, 'ed3fa6004f9fb5473e1ecb448d0cc394', 'UNUSED'),
  ('MAHOGANY-029', 'MAHOGANY', 2500, 'b8db8d29eb219c91a5c6cc0ecc9ab641', 'UNUSED'),
  ('MAHOGANY-030', 'MAHOGANY', 2500, '9e2467ad185fe177f35eb384a47e22d7', 'UNUSED'),
  ('MAHOGANY-031', 'MAHOGANY', 2500, 'e607666f5d5306c0ecaa79b026721894', 'UNUSED'),
  ('MAHOGANY-032', 'MAHOGANY', 2500, '1a6a95df37a850a4c25c329637a0a982', 'UNUSED'),
  ('MAHOGANY-033', 'MAHOGANY', 2500, '8eb28bcc63fdcb6effc81d6ce1a2c48f', 'UNUSED'),
  ('MAHOGANY-034', 'MAHOGANY', 2500, 'e66840ef0769abbd14137bef2fc31862', 'UNUSED'),
  ('MAHOGANY-035', 'MAHOGANY', 2500, '1f39cf119b52174c51196e67d7faa7c8', 'UNUSED'),
  ('MAHOGANY-036', 'MAHOGANY', 2500, '7a7970e6acf2220241e7afbad81f7098', 'UNUSED'),
  ('MAHOGANY-037', 'MAHOGANY', 2500, 'b705f37f3db80e23ecb1efc30f9d2dae', 'UNUSED'),
  ('MAHOGANY-038', 'MAHOGANY', 2500, '0474856df3b2b98432e072c7c4f2b2a1', 'UNUSED'),
  ('MAHOGANY-039', 'MAHOGANY', 2500, '03d7c0f7925a1460ec2f7cabd7e49769', 'UNUSED'),
  ('MAHOGANY-040', 'MAHOGANY', 2500, '81d8b7c11bdc0e91a681aadb2eb4c51c', 'UNUSED'),
  ('MAHOGANY-041', 'MAHOGANY', 2500, '830b2663e09555e349f7f51d6750797e', 'UNUSED'),
  ('MAHOGANY-042', 'MAHOGANY', 2500, '84b64bc99a1842983623b0532cab781e', 'UNUSED'),
  ('MAHOGANY-043', 'MAHOGANY', 2500, '550685e75e8d075d01e8a57ff127cabe', 'UNUSED'),
  ('MAHOGANY-044', 'MAHOGANY', 2500, '60eb6523dc6a8ae94f7be313b693291f', 'UNUSED'),
  ('MAHOGANY-045', 'MAHOGANY', 2500, 'c08e6dc2d4329d9792d1f29d40ec6173', 'UNUSED'),
  ('MAHOGANY-046', 'MAHOGANY', 2500, 'eda7254751dcb7a7309061bb4b5d27eb', 'UNUSED'),
  ('MAHOGANY-047', 'MAHOGANY', 2500, 'f2c8120757a674739958dedf5f472281', 'UNUSED'),
  ('MAHOGANY-048', 'MAHOGANY', 2500, 'b47eeb9db854683dbdd68fd64f18f60e', 'UNUSED'),
  ('MAHOGANY-049', 'MAHOGANY', 2500, '1285e0320adb8a5c5dabad868be0b4b7', 'UNUSED'),
  ('MAHOGANY-050', 'MAHOGANY', 2500, '5f801a96207875184c784c9d5bbf8297', 'UNUSED');

alter table public.tickets enable row level security;
revoke all on table public.tickets from anon, authenticated;

create or replace function public.verify_and_use_ticket(p_ticket_id text, p_qr_token text, p_user uuid)
returns table(result text, ticket_id text, ticket_type text, price integer, used_at timestamptz)
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.tickets t
     set status='USED', used_at=now(), used_by=p_user
   where t.ticket_id=p_ticket_id
     and t.qr_token=p_qr_token
     and t.status='UNUSED';

  if found then
    return query select 'VALID', t.ticket_id, t.ticket_type, t.price, t.used_at
      from public.tickets t where t.ticket_id=p_ticket_id;
    return;
  end if;

  if exists (select 1 from public.tickets t where t.ticket_id=p_ticket_id and t.qr_token=p_qr_token and t.status='USED') then
    return query select 'ALREADY_USED', t.ticket_id, t.ticket_type, t.price, t.used_at
      from public.tickets t where t.ticket_id=p_ticket_id;
    return;
  end if;

  if exists (select 1 from public.tickets t where t.ticket_id=p_ticket_id and t.qr_token=p_qr_token and t.status='VOID') then
    return query select 'VOID', t.ticket_id, t.ticket_type, t.price, t.used_at
      from public.tickets t where t.ticket_id=p_ticket_id;
    return;
  end if;

  return query select 'INVALID', null::text, null::text, null::integer, null::timestamptz;
end;
$$;

revoke all on function public.verify_and_use_ticket(text,text,uuid) from public, anon, authenticated;
grant execute on function public.verify_and_use_ticket(text,text,uuid) to service_role;

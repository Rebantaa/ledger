-- Paycheck Ledger: database schema
-- Run once in Supabase: SQL Editor -> New query -> paste -> Run.
-- Every table is locked so a signed-in person only ever sees and changes their own rows.

create table if not exists public.config (
  user_id    uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.txns (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  date        date not null,
  description text not null check (char_length(description) between 1 and 200),
  amount      numeric(12,2) not null check (amount > 0),
  kind        text not null check (kind in ('spend','payment','income','save')),
  account     text not null check (account in ('flex','discover','amex','debit','savings','direct','cash')),
  category    text,
  pre         boolean not null default false,
  period      text not null,
  created_at  timestamptz not null default now()
);
create index if not exists txns_user_period_idx on public.txns (user_id, period);

create table if not exists public.periods (
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  id      text not null,
  data    jsonb not null,
  primary key (user_id, id)
);

alter table public.config  enable row level security;
alter table public.txns    enable row level security;
alter table public.periods enable row level security;

drop policy if exists "own config"  on public.config;
drop policy if exists "own txns"    on public.txns;
drop policy if exists "own periods" on public.periods;

create policy "own config"  on public.config  for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "own txns"    on public.txns    for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));
create policy "own periods" on public.periods for all to authenticated
  using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

-- Nobody who is signed out can touch these tables.
revoke all on public.config, public.txns, public.periods from anon;

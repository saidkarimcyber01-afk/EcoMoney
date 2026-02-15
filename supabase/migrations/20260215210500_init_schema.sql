create extension if not exists "pgcrypto";

create type public.container_status as enum ('active', 'maintenance', 'offline');
create type public.transaction_status as enum ('pending', 'verified', 'manual_review', 'rejected');
create type public.event_status as enum ('upcoming', 'ongoing', 'completed');
create type public.waste_type as enum ('plastic', 'paper', 'glass', 'metal', 'organic');

create table if not exists public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  first_name text,
  last_name text,
  age integer check (age >= 0),
  city text,
  total_coins integer not null default 0,
  total_waste_kg numeric(10, 2) not null default 0,
  level text not null default 'newbie',
  avatar text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.containers (
  container_id uuid primary key default gen_random_uuid(),
  lat numeric(9, 6) not null,
  lng numeric(9, 6) not null,
  address text not null,
  status public.container_status not null default 'active',
  fill_level integer not null default 0 check (fill_level between 0 and 100),
  accepted_types public.waste_type[] not null,
  last_emptied timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.transactions (
  transaction_id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(user_id) on delete cascade,
  container_id uuid not null references public.containers(container_id) on delete restrict,
  waste_type public.waste_type not null,
  weight_kg numeric(10, 2) not null check (weight_kg > 0),
  coins_earned integer not null check (coins_earned >= 0),
  image_url text,
  ai_verified boolean not null default false,
  ai_confidence numeric(5, 2),
  status public.transaction_status not null default 'pending',
  created_at timestamptz not null default now()
);

create table if not exists public.events (
  event_id uuid primary key default gen_random_uuid(),
  title text not null,
  description text not null,
  location text not null,
  event_date timestamptz not null,
  bonus_coins integer not null default 0,
  max_participants integer,
  status public.event_status not null default 'upcoming',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.event_registrations (
  user_id uuid not null references public.profiles(user_id) on delete cascade,
  event_id uuid not null references public.events(event_id) on delete cascade,
  registered_at timestamptz not null default now(),
  primary key (user_id, event_id)
);

create index if not exists idx_transactions_user_created_at on public.transactions (user_id, created_at desc);
create index if not exists idx_containers_status_fill on public.containers (status, fill_level);
create index if not exists idx_events_status_date on public.events (status, event_date);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (user_id)
  values (new.id)
  on conflict (user_id) do nothing;
  return new;
end;
$$;

create or replace function public.update_profile_totals()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  update public.profiles
  set
    total_coins = (
      select coalesce(sum(coins_earned), 0)
      from public.transactions
      where user_id = new.user_id
      and status in ('verified', 'manual_review')
    ),
    total_waste_kg = (
      select coalesce(sum(weight_kg), 0)
      from public.transactions
      where user_id = new.user_id
      and status in ('verified', 'manual_review')
    ),
    updated_at = now()
  where user_id = new.user_id;

  update public.profiles
  set level = case
    when total_waste_kg >= 200 then 'champion'
    when total_waste_kg >= 75 then 'pro'
    when total_waste_kg >= 25 then 'active'
    else 'newbie'
  end
  where user_id = new.user_id;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

drop trigger if exists on_transaction_change_update_profile on public.transactions;
create trigger on_transaction_change_update_profile
after insert or update of coins_earned, weight_kg, status on public.transactions
for each row execute function public.update_profile_totals();

alter table public.profiles enable row level security;
alter table public.containers enable row level security;
alter table public.transactions enable row level security;
alter table public.events enable row level security;
alter table public.event_registrations enable row level security;

create policy "profiles_select_own" on public.profiles
for select using (auth.uid() = user_id);

create policy "profiles_update_own" on public.profiles
for update using (auth.uid() = user_id)
with check (auth.uid() = user_id);

create policy "containers_read_all_authenticated" on public.containers
for select using (auth.role() = 'authenticated');

create policy "transactions_insert_own" on public.transactions
for insert with check (auth.uid() = user_id);

create policy "transactions_select_own" on public.transactions
for select using (auth.uid() = user_id);

create policy "events_read_all_authenticated" on public.events
for select using (auth.role() = 'authenticated');

create policy "event_registrations_insert_own" on public.event_registrations
for insert with check (auth.uid() = user_id);

create policy "event_registrations_select_own" on public.event_registrations
for select using (auth.uid() = user_id);

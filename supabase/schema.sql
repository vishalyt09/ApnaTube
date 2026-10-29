-- Digital V starter schema
-- Run in Supabase SQL Editor. Review and test before production use.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  display_name text,
  avatar_url text,
  created_at timestamptz not null default now()
);

create table if not exists public.posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  caption text not null default '',
  media_url text,
  media_type text not null default 'text' check (media_type in ('text','image','video')),
  created_at timestamptz not null default now()
);

create table if not exists public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references auth.users(id) on delete cascade,
  post_id uuid references public.posts(id) on delete set null,
  reason text not null,
  status text not null default 'open' check (status in ('open','reviewed','actioned')),
  created_at timestamptz not null default now()
);

create table if not exists public.admin_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('super_admin','moderator','analyst')),
  created_at timestamptz not null default now()
);

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.admin_profiles ap
    where ap.user_id = auth.uid()
  );
$$;

alter table public.profiles enable row level security;
alter table public.posts enable row level security;
alter table public.reports enable row level security;
alter table public.admin_profiles enable row level security;

drop policy if exists "profiles are readable" on public.profiles;
create policy "profiles are readable"
on public.profiles for select to authenticated
using (true);

drop policy if exists "users create own profile" on public.profiles;
create policy "users create own profile"
on public.profiles for insert to authenticated
with check (id = auth.uid());

drop policy if exists "users update own profile" on public.profiles;
create policy "users update own profile"
on public.profiles for update to authenticated
using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() or public.is_admin());

drop policy if exists "posts readable by everyone" on public.posts;
create policy "posts readable by everyone"
on public.posts for select to anon, authenticated
using (true);

drop policy if exists "users create own posts" on public.posts;
create policy "users create own posts"
on public.posts for insert to authenticated
with check (user_id = auth.uid());

drop policy if exists "users update own posts or admin" on public.posts;
create policy "users update own posts or admin"
on public.posts for update to authenticated
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

drop policy if exists "users delete own posts or admin" on public.posts;
create policy "users delete own posts or admin"
on public.posts for delete to authenticated
using (user_id = auth.uid() or public.is_admin());

drop policy if exists "users create own reports" on public.reports;
create policy "users create own reports"
on public.reports for insert to authenticated
with check (reporter_id = auth.uid());

drop policy if exists "users read own reports or admin" on public.reports;
create policy "users read own reports or admin"
on public.reports for select to authenticated
using (reporter_id = auth.uid() or public.is_admin());

drop policy if exists "admins update reports" on public.reports;
create policy "admins update reports"
on public.reports for update to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "admins can read admin profiles" on public.admin_profiles;
create policy "admins can read admin profiles"
on public.admin_profiles for select to authenticated
using (user_id = auth.uid() or public.is_admin());

-- A normal user cannot insert/update their own admin role because no such policy exists.
-- Grant admin roles only from the Supabase SQL editor or a trusted server-side process.

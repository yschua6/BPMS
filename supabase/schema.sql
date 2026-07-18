-- ===================================================================
--  BPMS Literature Synthesis Matrix — database schema
--  Run this once in your Supabase project:
--    Supabase dashboard → SQL Editor → New query → paste → Run
-- ===================================================================

create extension if not exists "pgcrypto";

create table if not exists public.papers (
  id          uuid primary key default gen_random_uuid(),
  source      text not null,
  argument    text,
  method      text,
  findings    text,
  gap         text,
  pillar      text,
  link        text,
  file_url    text,
  file_name   text,
  created_at  timestamptz not null default now()
);

-- Row Level Security ------------------------------------------------
alter table public.papers enable row level security;

-- ⚠️ SHARED-TEAM MODE (default):
-- Anyone who has your app link + anon key can read, add, and remove
-- papers. Simple, and fine for a small trusted research team.
-- To lock it down later, delete these three policies and add
-- Supabase Auth (see README → "Locking it down").

create policy "team can read"
  on public.papers for select
  using (true);

create policy "team can insert"
  on public.papers for insert
  with check (true);

create policy "team can delete"
  on public.papers for delete
  using (true);

-- Optional: seed one example row so the matrix isn't empty on day one.
insert into public.papers (source, argument, method, findings, gap, pillar, link)
values (
  'Ashby, Bryce & Ring (2018)',
  'Boards manage risk along a spectrum and mostly frame it as downside threat rather than strategic opportunity; effective leadership integrates strategy and risk to sustain performance.',
  'Qualitative — 30 director interviews + 2 focus groups',
  'Practice sits on a Principled–Prescriptive spectrum; boards struggle to link soft factors (culture, risk appetite) to performance; board diversity of risk skills aids detection.',
  '"Some way to go to integrating strategy and risk decisions effectively"; boards struggle to link risk to organisational performance.',
  'Risk-based thinking',
  'Reframes risk from compliance toward strategic value; links strategy–performance–risk — supports the integrated structure.'
);

-- File attachments -------------------------------------------------
-- Storage bucket to hold uploaded paper PDFs, plus shared-team policies.
insert into storage.buckets (id, name, public)
values ('paper-files', 'paper-files', true)
on conflict (id) do nothing;

create policy "team can upload files"
  on storage.objects for insert with check (bucket_id = 'paper-files');
create policy "anyone can read files"
  on storage.objects for select using (bucket_id = 'paper-files');
create policy "team can delete files"
  on storage.objects for delete using (bucket_id = 'paper-files');

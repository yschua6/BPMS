-- ===================================================================
--  MIGRATION: add file attachments to the synthesis matrix
--  Run this once in Supabase → SQL Editor → New query → Run.
--  (Safe to run even if you already created the table.)
-- ===================================================================

-- 1. Add the two file columns to the papers table
alter table public.papers add column if not exists file_url  text;
alter table public.papers add column if not exists file_name text;

-- 2. Create a public storage bucket to hold the uploaded files
insert into storage.buckets (id, name, public)
values ('paper-files', 'paper-files', true)
on conflict (id) do nothing;

-- 3. Storage access policies (shared-team mode — matches the rest of the app)
--    Anyone with the anon key can upload; anyone can read/open files.
drop policy if exists "team can upload files" on storage.objects;
create policy "team can upload files"
  on storage.objects for insert
  with check (bucket_id = 'paper-files');

drop policy if exists "anyone can read files" on storage.objects;
create policy "anyone can read files"
  on storage.objects for select
  using (bucket_id = 'paper-files');

drop policy if exists "team can delete files" on storage.objects;
create policy "team can delete files"
  on storage.objects for delete
  using (bucket_id = 'paper-files');

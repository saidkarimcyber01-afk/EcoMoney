insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public)
values ('waste-photos', 'waste-photos', false)
on conflict (id) do nothing;

create policy "avatar_public_read" on storage.objects
for select
using (bucket_id = 'avatars');

create policy "avatar_upload_own" on storage.objects
for insert
with check (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
);

create policy "avatar_update_own" on storage.objects
for update
using (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
)
with check (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
);

create policy "waste_photo_read_own" on storage.objects
for select
using (
  bucket_id = 'waste-photos'
  and auth.uid()::text = (storage.foldername(name))[1]
);

create policy "waste_photo_upload_own" on storage.objects
for insert
with check (
  bucket_id = 'waste-photos'
  and auth.uid()::text = (storage.foldername(name))[1]
);

# EcoMoney Connect — Cloud Enablement (Supabase / Lovable Cloud)

This repository now includes a backend-ready Supabase setup for the EcoMoney Connect MVP.

## What is enabled

- Auth (email/password)
- Database schema for:
  - `profiles`
  - `containers`
  - `transactions`
  - `events`
  - `event_registrations`
- RLS policies for user-scoped access
- Storage buckets:
  - `avatars` (public read, owner write)
  - `waste-photos` (owner read/write)
- Edge Function:
  - `ai-verify` (MVP verification endpoint + coin estimate)
- Seed data:
  - 20 mock containers in Tashkent
  - 2 upcoming events

## Prerequisites

1. Install Supabase CLI.
2. Create a Supabase project in Lovable Cloud.
3. Authenticate CLI:

```bash
supabase login
```

## Local development

```bash
supabase start
supabase db reset
```

This starts local services, applies migrations, and seeds data from `supabase/seed.sql`.

## Connect to cloud project

```bash
supabase link --project-ref <your-project-ref>
supabase db push
supabase functions deploy ai-verify
```

## Required frontend environment variables

```bash
VITE_SUPABASE_URL=<project-url>
VITE_SUPABASE_ANON_KEY=<anon-key>
```

## Suggested next steps for full MVP

1. Build React PWA shell with auth-gated routes.
2. Connect scan/deposit flow to `containers`, `transactions`, and `ai-verify`.
3. Add realtime subscription on `profiles.total_coins` + `transactions`.
4. Implement admin route with service-role secured API endpoints.

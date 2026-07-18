# BPMS — Literature Synthesis Matrix

A shared, team-facing web app for a BPMS research project. Every paper the
team reads is logged against the framework — **process approach** and
**risk-based thinking** — including the *gap the authors admit*, which is where
the research contribution lives.

Built as a single static page (`index.html`) backed by **Supabase** for shared
storage, deployable free on **Vercel**.

---

## What you get

- A form to add papers: source, argument, method, findings, **gap**, framework
  pillar, and link-to-framework.
- A live matrix everyone on the team sees (shared database — not just your
  browser).
- **Export CSV** to drop straight into your literature review.

---

## Setup — about 15 minutes, one time

### 1. Create the Supabase database
1. Go to [supabase.com](https://supabase.com) → sign in → **New project**.
2. Give it a name (e.g. `bpms`), set a database password, pick a region, create.
3. When it's ready, open **SQL Editor → New query**.
4. Paste the whole contents of [`supabase/schema.sql`](supabase/schema.sql) →
   **Run**. This creates the `papers` table and its access policies, and seeds
   one example row.

### 2. Get your two keys
1. In Supabase: **Project Settings → API**.
2. Copy the **Project URL** and the **anon public** key.
3. Open [`config.js`](config.js) and paste them in, replacing the two
   `YOUR_...` placeholders. Save.

> The anon key is meant to be public and is safe in this repo — access is
> controlled by the Row Level Security policies in `schema.sql`.

### 3. Test locally (optional but smart)
Just open `index.html` in your browser. The status dot should go **green —
"Connected"** and you should see the seeded example paper. Add one to confirm it
saves.

### 4. Push to GitHub
From this folder, in your terminal:

```bash
git add .
git commit -m "BPMS synthesis matrix app"
git push
```

(The repo is already wired to `github.com/yschua6/BPMS`.)

### 5. Deploy on Vercel
1. Go to [vercel.com](https://vercel.com) → sign in **with GitHub**.
2. **Add New → Project → Import** the `BPMS` repo.
3. Framework preset: **Other**. No build command, no root changes needed —
   it's a static site.
4. **Deploy.** In ~30 seconds you get a link like
   `https://bpms-xxxx.vercel.app`.

**That link is what you share with your team.** Everyone who opens it reads and
writes the same matrix.

---

## Locking it down (later)

Right now, anyone with the link can read and edit — fine for a small trusted
team, not for public sharing. To require login:

1. In Supabase → **Authentication**, enable Email (or Google) sign-in.
2. In `schema.sql`, delete the three `team can ...` policies and replace the
   `using (true)` / `with check (true)` conditions with
   `using (auth.role() = 'authenticated')`.
3. Add a Supabase Auth login step to `index.html` (ask Claude Code to do this —
   *"add Supabase email login before showing the matrix"*).

---

## Files

| File | What it is |
|------|------------|
| `index.html` | The whole app — UI + logic |
| `config.js` | Your Supabase URL + anon key (you fill this in) |
| `supabase/schema.sql` | Database table + access policies |
| `README.md` | This file |

Built at the AI Accelerator Founder Club · Bukit Mertajam · 18 July 2026.

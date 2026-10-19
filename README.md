# Paycheck Ledger: setup

Your own copy of the ledger: hosted free on GitHub Pages, data stored in your own Supabase database, locked to your login. Takes about 20 minutes, once.

## What's in this folder

| File | What it is | Goes on GitHub? |
|---|---|---|
| `index.html` | The ledger app | Yes |
| `schema.sql` | Creates the database tables and locks them to your login | Yes (no personal data) |
| `seed.sql` | Your current balances, budgets and 7 entries | **No.** Run it in Supabase, then keep it on your Mac only |
| `.gitignore` | Stops `seed.sql` from being uploaded by accident | Yes |

## 1. Create the database (Supabase)

1. Go to supabase.com, sign up (GitHub login is fine), and click **New project**. Name it `ledger`, set a strong database password (save it in your password manager), and pick the **East US** region.
2. When it finishes, open **SQL Editor → New query**, paste all of `schema.sql`, and click **Run**. You should see "Success. No rows returned."

## 2. Create your login, then close sign-ups

1. **Authentication → Users → Add user → Create new user.** Enter your email and a strong password, and tick **Auto Confirm User**.
2. **Authentication → Sign In / Providers** (may be under Settings): turn **off** "Allow new users to sign up". Now nobody else can make an account on your database.

## 3. Load your starting data

1. Open `seed.sql` on your Mac, replace both `YOUR_EMAIL_HERE` with the email from step 2.
2. **SQL Editor → New query**, paste it, **Run**. Run it only once.
3. Check: **Table Editor → txns** should show 7 rows.

## 4. Connect the app to your database

1. **Project Settings → API** (or **Data API**). Copy the **Project URL** and the **anon public** key.
2. Open `index.html` in a text editor (TextEdit in plain-text mode, or VS Code). Near the bottom, replace:
   - `https://YOUR-PROJECT-REF.supabase.co` with your Project URL
   - `YOUR-ANON-PUBLIC-KEY` with the anon key

Never use the **service_role** key here. The anon key is meant to be public; the row-level security from `schema.sql` is what protects your data.

## 5. Publish on GitHub Pages

1. On github.com, click **New repository**. Name it `ledger`, set it to **Public** (free Pages needs a public repo; your numbers live in Supabase, not in the repo), and create it.
2. Click **uploading an existing file**, drag in `index.html`, `schema.sql`, `README.md` and `.gitignore`. **Do not upload `seed.sql`.** Commit.
3. **Settings → Pages → Build and deployment → Source: Deploy from a branch**, branch `main`, folder `/ (root)`, **Save**.
4. After a minute your app is live at `https://YOUR-GITHUB-USERNAME.github.io/ledger/`.
5. Back in Supabase, **Authentication → URL Configuration**: set **Site URL** to that address.

## 6. Put it on your phone

Open the address in Safari, sign in, then **Share → Add to Home Screen**. It opens like an app and stays signed in. Do the same on your Mac (bookmark it).

## Things to know

- **Inactivity pause:** Supabase's free plan pauses a project after 7 days with no activity. Your data is kept; restore it with one click from the Supabase dashboard. If you log purchases every few days, this won't happen.
- **Backups:** the **Download all entries (CSV)** button saves everything to a file. Do it at the end of each month.
- **New month:** use **Close this period and start the next one** on each bills paycheck. Past months stay under **Past periods**.
- **Updating the app later:** edit `index.html` and upload it to the same repo; the site updates in about a minute.

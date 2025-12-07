# Verify Your Supabase Setup

## ✅ Step 1: Verify Storage Policies

1. Go to **Storage** → **images** bucket → **Policies** tab
2. You should see **4 policies**:
   - ✅ `Users can upload own images` (INSERT)
   - ✅ `Users can read images` (SELECT)
   - ✅ `Users can update own images` (UPDATE)
   - ✅ `Users can delete own images` (DELETE)

If you see all 4 policies, you're good to go! ✅

## ✅ Step 2: Verify Database Tables

1. Go to **Table Editor** in Supabase dashboard
2. You should see **3 tables**:
   - ✅ `coaches`
   - ✅ `clients`
   - ✅ `plans`

If you see all 3 tables, you're good to go! ✅

## ✅ Step 3: Verify RLS is Enabled

1. Go to **Table Editor**
2. Click on any table (e.g., `coaches`)
3. Check the **"RLS enabled"** badge at the top
4. All three tables should show RLS enabled

If RLS is enabled on all tables, you're good to go! ✅

## 🎉 All Set!

If everything above is checked, your database is ready! Proceed to testing the app.


# Supabase Database Setup Guide

This guide will walk you through setting up your Supabase database tables, RLS policies, and storage bucket.

## Prerequisites

- Access to your Supabase project: https://yqrcscudifobekkitfta.supabase.co
- Supabase dashboard access

## Step 1: Access Supabase SQL Editor

1. Go to your Supabase project dashboard: https://supabase.com/dashboard/project/yqrcscudifobekkitfta
2. Click on **"SQL Editor"** in the left sidebar
3. Click **"New query"** to create a new SQL query

## Step 2: Create Database Tables

Copy and paste the following SQL into the SQL Editor, then click **"Run"**:

```sql
-- ============================================
-- CREATE TABLES
-- ============================================

-- Coaches table
CREATE TABLE IF NOT EXISTS coaches (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  profile_photo_url TEXT,
  bio TEXT,
  certificates TEXT[],
  subscription_tier TEXT DEFAULT 'free',
  client_limit INTEGER DEFAULT 3,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_active TIMESTAMPTZ,
  settings JSONB DEFAULT '{}'
);

-- Clients table
CREATE TABLE IF NOT EXISTS clients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coach_id UUID NOT NULL REFERENCES coaches(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  profile_photo_url TEXT,
  status TEXT DEFAULT 'pending',
  subscription_progress DOUBLE PRECISION DEFAULT 0.0,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  last_session TIMESTAMPTZ,
  goals JSONB DEFAULT '{}',
  stats JSONB DEFAULT '{}',
  session_history JSONB DEFAULT '[]'
);

-- Plans table
CREATE TABLE IF NOT EXISTS plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  coach_id UUID NOT NULL REFERENCES coaches(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  duration INTEGER NOT NULL,
  price DOUBLE PRECISION NOT NULL,
  features TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ,
  status TEXT DEFAULT 'active',
  client_count INTEGER DEFAULT 0,
  success_rate DOUBLE PRECISION DEFAULT 0.0,
  revenue DOUBLE PRECISION DEFAULT 0.0
);

-- ============================================
-- CREATE INDEXES (for better performance)
-- ============================================

CREATE INDEX IF NOT EXISTS idx_clients_coach_id ON clients(coach_id);
CREATE INDEX IF NOT EXISTS idx_plans_coach_id ON plans(coach_id);
CREATE INDEX IF NOT EXISTS idx_clients_status ON clients(status);
CREATE INDEX IF NOT EXISTS idx_plans_status ON plans(status);
```

## Step 3: Enable Row Level Security (RLS)

Run this SQL to enable RLS and create security policies:

```sql
-- ============================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================

ALTER TABLE coaches ENABLE ROW LEVEL SECURITY;
ALTER TABLE clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE plans ENABLE ROW LEVEL SECURITY;

-- ============================================
-- CREATE RLS POLICIES
-- ============================================

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Coaches can view own profile" ON coaches;
DROP POLICY IF EXISTS "Coaches can update own profile" ON coaches;
DROP POLICY IF EXISTS "Coaches can insert own profile" ON coaches;
DROP POLICY IF EXISTS "Coaches can manage own clients" ON clients;
DROP POLICY IF EXISTS "Coaches can manage own plans" ON plans;

-- Coaches can view their own profile
CREATE POLICY "Coaches can view own profile" ON coaches
  FOR SELECT USING (auth.uid() = id);

-- Coaches can update their own profile
CREATE POLICY "Coaches can update own profile" ON coaches
  FOR UPDATE USING (auth.uid() = id);

-- Coaches can insert their own profile (for signup)
CREATE POLICY "Coaches can insert own profile" ON coaches
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Coaches can manage their own clients (all operations)
CREATE POLICY "Coaches can manage own clients" ON clients
  FOR ALL USING (auth.uid() = coach_id);

-- Coaches can manage their own plans (all operations)
CREATE POLICY "Coaches can manage own plans" ON plans
  FOR ALL USING (auth.uid() = coach_id);
```

## Step 4: Create Storage Bucket

1. In Supabase dashboard, go to **"Storage"** in the left sidebar
2. Click **"New bucket"**
3. Configure the bucket:
   - **Name**: `images`
   - **Public bucket**: ✅ **Enable this** (so images can be accessed via URL)
   - **File size limit**: 5 MB (or your preference)
   - **Allowed MIME types**: `image/jpeg, image/png, image/webp` (optional)
4. Click **"Create bucket"**

### Set Storage Policies (Important!)

After creating the bucket, you need to set up policies so users can upload their own images.

**⚠️ IMPORTANT: Create each policy separately! Don't paste all three at once.**

#### Method 1: Using Supabase UI (Recommended for beginners)

**Policy 1: Allow users to upload images**

1. Click on the `images` bucket
2. Go to **"Policies"** tab
3. Click **"New policy"**
4. Select **"For full customization"**
5. **Policy name**: `Users can upload own images`
6. **Allowed operation**: `INSERT`
7. **Target roles**: `authenticated`
8. **WITH CHECK expression**: 
   ```sql
   bucket_id = 'images' AND (storage.foldername(name))[1] = auth.uid()::text
   ```
9. Click **"Review"** → **"Save policy"**

**Policy 2: Allow users to read images**

1. Click **"New policy"** again
2. Select **"For full customization"**
3. **Policy name**: `Users can read images`
4. **Allowed operation**: `SELECT`
5. **Target roles**: `authenticated`
6. **USING expression**:
   ```sql
   bucket_id = 'images'
   ```
7. Click **"Review"** → **"Save policy"**

**Policy 3: Allow users to manage their own images**

1. Click **"New policy"** again
2. Select **"For full customization"**
3. **Policy name**: `Users can manage own images`
4. **Allowed operation**: `ALL` (or select UPDATE and DELETE separately)
5. **Target roles**: `authenticated`
6. **USING expression**:
   ```sql
   bucket_id = 'images' AND (storage.foldername(name))[1] = auth.uid()::text
   ```
7. Click **"Review"** → **"Save policy"**

#### Method 2: Using SQL Editor (Faster, for advanced users)

If the UI method doesn't work, use the SQL Editor instead:

1. Go to **"SQL Editor"** in Supabase dashboard
2. Click **"New query"**
3. Copy and paste this SQL (run all at once):

```sql
-- Allow authenticated users to upload their own images
CREATE POLICY "Users can upload own images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'images' AND (storage.foldername(name))[1] = auth.uid()::text);

-- Allow authenticated users to read all images
CREATE POLICY "Users can read images"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'images');

-- Allow users to update/delete their own images
CREATE POLICY "Users can manage own images"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'images' AND (storage.foldername(name))[1] = auth.uid()::text);

CREATE POLICY "Users can delete own images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'images' AND (storage.foldername(name))[1] = auth.uid()::text);
```

4. Click **"Run"**

## Step 5: Verify Setup

Run this query to verify all tables were created:

```sql
-- Verify tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name IN ('coaches', 'clients', 'plans')
ORDER BY table_name;
```

You should see all three tables listed.

## Step 6: Test Database Connection

You can test if the setup works by running this query (after signing up a user):

```sql
-- This will only work after a user signs up
SELECT * FROM coaches LIMIT 1;
```

## Troubleshooting

### Issue: "relation already exists"
- The tables already exist. This is fine - the `IF NOT EXISTS` clause prevents errors.

### Issue: "permission denied"
- Make sure you're running the SQL as a database admin/superuser
- Check that RLS policies are correctly set up

### Issue: "foreign key constraint"
- Make sure you create tables in order: `coaches` → `clients` → `plans`
- The `IF NOT EXISTS` clause should handle this, but if issues persist, drop tables and recreate

### Issue: Storage bucket not accessible
- Make sure the bucket is set to **Public**
- Verify storage policies are correctly applied
- Check that the bucket name is exactly `images` (case-sensitive)

## Next Steps

After completing the database setup:

1. ✅ Database tables created
2. ✅ RLS policies enabled
3. ✅ Storage bucket created
4. ➡️ **Test the app** (see TESTING_GUIDE.md)


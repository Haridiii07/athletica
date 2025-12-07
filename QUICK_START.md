# Quick Start Guide

## 🚀 Get Your App Running in 5 Steps

### Step 1: Set Up Supabase Database (5 minutes)

1. **Go to Supabase Dashboard**: https://supabase.com/dashboard/project/yqrcscudifobekkitfta
2. **Open SQL Editor** (left sidebar)
3. **Copy and paste** the entire contents of `supabase_setup.sql`
4. **Click "Run"** to execute
5. **Verify**: You should see "Success" message

### Step 2: Create Storage Bucket (2 minutes)

1. **Go to Storage** (left sidebar in Supabase)
2. **Click "New bucket"**
3. **Name**: `images`
4. **Enable**: Public bucket ✅
5. **Click "Create bucket"**

### Step 3: Set Storage Policies (5 minutes)

**⚠️ IMPORTANT: Create each policy separately!**

#### Option A: Using SQL Editor (Easiest)

1. **Go to "SQL Editor"** in Supabase dashboard
2. **Click "New query"**
3. **Copy and paste this entire SQL**:

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

-- Allow users to update their own images
CREATE POLICY "Users can update own images"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'images' AND (storage.foldername(name))[1] = auth.uid()::text);

-- Allow users to delete their own images
CREATE POLICY "Users can delete own images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'images' AND (storage.foldername(name))[1] = auth.uid()::text);
```

4. **Click "Run"**

#### Option B: Using Storage UI (Alternative)

Create each policy one at a time in the Storage → Policies tab. See `DATABASE_SETUP_GUIDE.md` for detailed UI instructions.

### Step 4: Run the App (1 minute)

```bash
flutter pub get
flutter run
```

### Step 5: Test It! (5 minutes)

1. **Sign Up** with a test account
2. **Add a client**
3. **Create a plan**
4. **Upload a profile photo**

✅ **You're done!** The app should be working.

---

## 📚 Need More Details?

- **Detailed Database Setup**: See `DATABASE_SETUP_GUIDE.md`
- **Comprehensive Testing**: See `TESTING_GUIDE.md`
- **Implementation Status**: See `IMPLEMENTATION_STATUS.md`

## ⚠️ Troubleshooting

**"Failed to sign up"**
→ Check that tables were created (Step 1)

**"Cannot load clients"**
→ Check RLS policies were created (Step 1)

**"Image upload fails"**
→ Check storage bucket exists and is public (Step 2)
→ Check storage policies (Step 3)

**"App crashes on startup"**
→ Run `flutter pub get`
→ Check Supabase URL and key in `lib/config/app_config.dart`


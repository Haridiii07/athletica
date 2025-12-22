'''
# Supabase Setup Guide for Athletica

## Step 1: Create Supabase Project

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Click "New project"
3. Enter project name: `athletica-app`
4. Generate a secure database password and store it safely.
5. Choose a region (choose closest to Egypt).
6. Click "Create new project"

## Step 2: Get API Keys and URL

1. In the Supabase Dashboard, go to **Project Settings** > **API**.
2. Copy the **Project URL** and the **`anon` public key**.
3. These will be used to initialize the Supabase client in the Flutter app.

## Step 3: Initialize Supabase in Flutter

In your `main.dart` file, initialize the Supabase client before running the app:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  runApp(const MyApp());
}

// Helper for easy access to the Supabase client
final supabase = Supabase.instance.client;
```

**Important**: Store your URL and anon key securely (e.g., using environment variables), do not hardcode them directly in the source code.

## Step 4: Enable Authentication Providers

1. In the Supabase Dashboard, go to **Authentication** > **Providers**.
2. Enable the providers you need:
   - **Email**: Enabled by default.
   - **Phone**: Enable Phone sign-ins.
   - **Google**: Follow the on-screen instructions to add your OAuth credentials.
   - **Facebook**: Follow the on-screen instructions to add your OAuth credentials.

## Step 5: Set Up Database Tables & RLS

1. Go to the **Table Editor** to create your database schema (e.g., `coaches`, `clients`, `plans`).
2. Go to **Authentication** > **Policies** to enable **Row Level Security (RLS)** on your tables.

### Example RLS Policies

For a `coaches` table, you might have a policy that only allows a coach to see and edit their own profile:

```sql
-- Enable RLS on the table
ALTER TABLE public.coaches ENABLE ROW LEVEL SECURITY;

-- Policy: Coaches can view their own profile.
CREATE POLICY "Coaches can view their own profile."
ON public.coaches FOR SELECT
USING (auth.uid() = id);

-- Policy: Coaches can update their own profile.
CREATE POLICY "Coaches can update their own profile."
ON public.coaches FOR UPDATE
USING (auth.uid() = id);
```

## Step 6: Set Up Supabase Storage

1. Go to **Storage** in the dashboard.
2. Create a new **Bucket** (e.g., `profile-photos`).
3. Set up **Storage Policies** to control access. For example, allow authenticated users to upload to their own folder:

```sql
-- Policy: Allow authenticated users to upload files.
CREATE POLICY "Authenticated users can upload files."
ON storage.objects FOR INSERT
WITH CHECK (auth.role() = 'authenticated');
```

## Step 7: Test the Setup

1. Run the app: `flutter run`
2. Try to sign up with a new account.
3. Check the **Authentication** > **Users** section in your Supabase Dashboard to see if the new user was created.
4. Check your database tables to see if data is being created correctly.

## Troubleshooting

### Common Issues:

1.  **"Invalid JWT" / "Unauthorized"**: Check that your Supabase URL and anon key are correct. Ensure RLS policies are not blocking access.
2.  **"Network error"**: Check your internet connection and verify the Supabase project status on the dashboard.
3.  **"Permission denied"**: Review your RLS policies and database permissions carefully.

## Security Notes

1.  **Never expose your `service_role` key** on the client-side.
2.  **Always enable RLS** on tables containing sensitive data.
3.  **Use database functions** for complex operations to avoid exposing sensitive logic to the client.
4.  **Monitor usage** in the Supabase Dashboard.

## Next Steps

1.  Set up **Supabase Analytics** for usage tracking.
2.  Configure **Supabase Realtime** for live data synchronization and notifications.
3.  Set up **Supabase Edge Functions** for server-side logic.
4.  Configure **Supabase Hosting** for the web version of your app.

## Support

If you encounter issues:
1.  Check the **Logs** in the Supabase Dashboard for errors.
2.  Verify all configuration variables are correct.
3.  Test with a simple Supabase example first.
4.  Check the official **Supabase documentation** for updates.
'''

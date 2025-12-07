# Testing Guide for Athletica App

This guide will help you test the app after setting up the Supabase database.

## Prerequisites

- ✅ Database tables created (see DATABASE_SETUP_GUIDE.md)
- ✅ Storage bucket `images` created
- ✅ RLS policies enabled
- ✅ Flutter app dependencies installed (`flutter pub get`)

## Step 1: Verify Environment Setup

1. Check that your `.env` file exists (or verify `app_config.dart` has correct values):
   ```dart
   // In lib/config/app_config.dart
   static const String supabaseUrl = 'https://yqrcscudifobekkitfta.supabase.co';
   static const String supabaseAnonKey = 'your-key-here';
   ```

2. Run `flutter pub get` to ensure all dependencies are installed:
   ```bash
   flutter pub get
   ```

## Step 2: Run the App

```bash
flutter run
```

Or use your IDE's run button.

## Step 3: Test Authentication Flow

### Test Sign Up

1. **Launch the app** - You should see the landing/splash screen
2. **Navigate to Sign Up** - Tap "Sign Up" or "Create Account"
3. **Fill in the form**:
   - Name: `Test Coach`
   - Email: `test@example.com` (use a real email for password reset testing)
   - Phone: `+1234567890`
   - Password: `TestPassword123!`
4. **Submit** - Tap "Sign Up" or "Create Account"
5. **Expected Result**:
   - ✅ Account created successfully
   - ✅ Navigates to profile photo screen
   - ✅ Coach record created in `coaches` table

### Test Sign In

1. **Sign out** if you're signed in
2. **Navigate to Sign In**
3. **Enter credentials**:
   - Email: `test@example.com`
   - Password: `TestPassword123!`
4. **Submit**
5. **Expected Result**:
   - ✅ Signs in successfully
   - ✅ Navigates to home/dashboard
   - ✅ Shows coach data

### Test Forgot Password

1. **On Sign In screen**, tap "Forgot Password?"
2. **Enter email**: `test@example.com`
3. **Submit**
4. **Expected Result**:
   - ✅ Shows success message
   - ✅ Email sent (check your inbox)

## Step 4: Test Client Management

### Test Adding a Client

1. **From Dashboard**, navigate to "Clients" or "Manage Clients"
2. **Tap the "+" button** (FloatingActionButton)
3. **Fill in client form**:
   - Name: `John Doe`
   - Email: `john@example.com`
   - Phone: `+1234567891`
   - Status: `Active`
4. **Save**
5. **Expected Result**:
   - ✅ Client added successfully
   - ✅ Appears in clients list
   - ✅ Record created in `clients` table

### Test Viewing Client Details

1. **From Clients list**, tap on a client
2. **Expected Result**:
   - ✅ Client details screen opens
   - ✅ Shows client information
   - ✅ Shows associated plans (if any)

### Test Editing a Client

1. **From Client Details**, tap edit (or navigate from clients list)
2. **Modify information** (e.g., change name)
3. **Save**
4. **Expected Result**:
   - ✅ Client updated successfully
   - ✅ Changes reflected in UI
   - ✅ Database updated

### Test Client Progress

1. **From Client Details**, navigate to "Progress"
2. **Expected Result**:
   - ✅ Progress screen loads
   - ✅ Shows charts/graphs (may be empty initially)

## Step 5: Test Plan Management

### Test Creating a Plan

1. **Navigate to "Plans"** from dashboard
2. **Tap "+" button** or "Create Plan"
3. **Fill in plan form**:
   - Name: `Beginner Workout Plan`
   - Description: `A 4-week plan for beginners`
   - Duration: `4` (weeks)
   - Price: `99.99`
   - Status: `Active`
4. **Save**
5. **Expected Result**:
   - ✅ Plan created successfully
   - ✅ Appears in plans list
   - ✅ Record created in `plans` table

### Test Viewing Plans

1. **From Plans screen**, view the list
2. **Expected Result**:
   - ✅ All plans displayed
   - ✅ Can filter by status
   - ✅ Can search plans

### Test Editing a Plan

1. **Tap on a plan** from the list
2. **Modify information**
3. **Save**
4. **Expected Result**:
   - ✅ Plan updated successfully
   - ✅ Changes reflected

## Step 6: Test Profile Photo Upload

1. **During signup** or from profile screen
2. **Select "Add Photo"**
3. **Choose image** from gallery or camera
4. **Upload**
5. **Expected Result**:
   - ✅ Photo uploaded successfully
   - ✅ URL stored in database
   - ✅ Image visible in Supabase Storage bucket `images`

## Step 7: Test Navigation

Test that all navigation works:

- ✅ Dashboard → Clients
- ✅ Dashboard → Plans
- ✅ Dashboard → Analytics
- ✅ Dashboard → Settings
- ✅ Clients → Client Details
- ✅ Client Details → Progress
- ✅ Plans → Plan Details
- ✅ Back navigation works

## Step 8: Test Error Handling

### Test Network Errors

1. **Turn off internet** (airplane mode)
2. **Try to sign in**
3. **Expected Result**:
   - ✅ Shows network error message
   - ✅ Retry option available

### Test Validation Errors

1. **Try to sign up** with invalid email
2. **Expected Result**:
   - ✅ Shows validation error
   - ✅ Form highlights invalid fields

### Test Unauthorized Access

1. **Sign out**
2. **Try to access protected routes**
3. **Expected Result**:
   - ✅ Redirects to landing/sign in
   - ✅ Cannot access dashboard

## Step 9: Verify Database Records

### Check Supabase Dashboard

1. **Go to Supabase Dashboard** → **Table Editor**
2. **Verify records**:
   - ✅ `coaches` table has your coach record
   - ✅ `clients` table has client records
   - ✅ `plans` table has plan records

### Check Storage

1. **Go to Storage** → **images bucket**
2. **Verify**:
   - ✅ Uploaded images appear
   - ✅ Images organized by user ID folders

## Step 10: Test Data Persistence

1. **Add some data** (clients, plans)
2. **Close the app completely**
3. **Reopen the app**
4. **Sign in again**
5. **Expected Result**:
   - ✅ All data persists
   - ✅ Clients and plans still visible

## Common Issues & Solutions

### Issue: "Failed to sign up"
- **Check**: Database tables exist
- **Check**: RLS policies allow INSERT on coaches table
- **Check**: Email is unique (not already registered)

### Issue: "Cannot load clients"
- **Check**: RLS policies allow SELECT on clients table
- **Check**: Coach is authenticated
- **Check**: `coach_id` matches authenticated user ID

### Issue: "Image upload fails"
- **Check**: Storage bucket `images` exists
- **Check**: Storage policies allow upload
- **Check**: Bucket is public
- **Check**: File size is under limit

### Issue: "Navigation errors"
- **Check**: Router configuration in `app_router.dart`
- **Check**: All routes are properly defined
- **Check**: Auth state is correctly managed

## Performance Testing

### Test with Multiple Records

1. **Add 10+ clients**
2. **Add 5+ plans**
3. **Expected Result**:
   - ✅ Lists load smoothly
   - ✅ No performance issues
   - ✅ Pagination works (if implemented)

## Next Steps

After successful testing:

1. ✅ **Fix any bugs** found during testing
2. ✅ **Optimize performance** if needed
3. ✅ **Add unit tests** (see Phase 7 in IMPLEMENTATION_STATUS.md)
4. ✅ **Add widget tests** for critical screens
5. ✅ **Add integration tests** for complete flows

## Testing Checklist

- [ ] Authentication (Sign Up, Sign In, Sign Out)
- [ ] Password Reset
- [ ] Client CRUD (Create, Read, Update, Delete)
- [ ] Plan CRUD
- [ ] Profile Photo Upload
- [ ] Navigation between screens
- [ ] Error handling (network, validation, auth)
- [ ] Data persistence
- [ ] RLS policies working correctly
- [ ] Storage bucket accessible

## Need Help?

If you encounter issues:

1. Check the **Supabase Dashboard** logs
2. Check **Flutter console** for errors
3. Verify **RLS policies** are correct
4. Check **network connectivity**
5. Review **error messages** in the app


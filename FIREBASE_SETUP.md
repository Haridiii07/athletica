# Firebase Setup Guide for Athletica

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `athletica-app`
4. Enable Google Analytics (optional but recommended)
5. Choose analytics account or create new one
6. Click "Create project"

## Step 2: Add Android App

1. In Firebase Console, click the Android icon (</>) to add Android app
2. Enter Android package name: `com.example.athletica`
3. Enter app nickname: `Athletica`
4. Enter SHA-1 certificate fingerprint (optional for now)
5. Click "Register app"

## Step 3: Download Configuration File

1. Download the `google-services.json` file
2. Replace the placeholder file in `android/app/google-services.json`
3. **Important**: Never commit this file to public repositories

## Step 4: Enable Authentication

1. In Firebase Console, go to "Authentication" → "Sign-in method"
2. Enable "Email/Password" authentication
3. Click "Save"

## Step 5: Set Up Firestore Database

1. Go to "Firestore Database" → "Create database"
2. Choose "Start in test mode" (for development)
3. Select a location (choose closest to Egypt)
4. Click "Done"

### Firestore Security Rules

Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Coaches can read/write their own data
    match /coaches/{coachId} {
      allow read, write: if request.auth != null && request.auth.uid == coachId;
    }
    
    // Coaches can read/write their clients
    match /clients/{clientId} {
      allow read, write: if request.auth != null && 
        resource.data.coachId == request.auth.uid;
    }
    
    // Coaches can read/write their plans
    match /plans/{planId} {
      allow read, write: if request.auth != null && 
        resource.data.coachId == request.auth.uid;
    }
  }
}
```

## Step 6: Enable Storage (Optional)

1. Go to "Storage" → "Get started"
2. Choose "Start in test mode"
3. Select a location
4. Click "Done"

### Storage Security Rules

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Step 7: Update App Configuration

### Update google-services.json

Replace the placeholder values in `android/app/google-services.json` with your actual Firebase configuration:

```json
{
  "project_info": {
    "project_number": "123456789012",
    "project_id": "athletica-app",
    "storage_bucket": "athletica-app.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789012:android:abcdef1234567890",
        "android_client_info": {
          "package_name": "com.example.athletica"
        }
      },
      "oauth_client": [
        {
          "client_id": "123456789012-abcdefghijklmnop.apps.googleusercontent.com",
          "client_type": 3
        }
      ],
      "api_key": [
        {
          "current_key": "AIzaSyC-Your-Actual-API-Key-Here"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": [
            {
              "client_id": "123456789012-abcdefghijklmnop.apps.googleusercontent.com",
              "client_type": 3
            }
          ]
        }
      }
    }
  ],
  "configuration_version": "1"
}
```

## Step 8: Test the Setup

1. Run the app: `flutter run`
2. Try to sign up with a new account
3. Check Firebase Console to see if data is being created

## Troubleshooting

### Common Issues:

1. **"google-services.json not found"**
   - Make sure the file is in `android/app/google-services.json`
   - Check file permissions

2. **"Firebase not initialized"**
   - Ensure `google-services.json` is properly configured
   - Check that Firebase plugins are added to build.gradle files

3. **"Permission denied"**
   - Check Firestore security rules
   - Ensure authentication is enabled

4. **"Network error"**
   - Check internet connection
   - Verify Firebase project is in the correct region

## Security Notes

1. **Never commit `google-services.json` to public repositories**
2. **Use proper security rules in production**
3. **Enable App Check for additional security**
4. **Monitor usage in Firebase Console**

## Next Steps

1. Set up Firebase Analytics (optional)
2. Configure Firebase Cloud Messaging for notifications
3. Set up Firebase Functions for backend logic
4. Configure Firebase Hosting for web version

## Support

If you encounter issues:
1. Check Firebase Console for error logs
2. Verify all configuration files are correct
3. Test with a simple Firebase example first
4. Check Firebase documentation for updates

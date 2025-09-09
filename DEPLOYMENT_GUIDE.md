# 🚀 Athletica Deployment Guide

## 📋 **Quick Deployment Options**

### **Option 1: Web Deployment (Recommended for Sharing)**

#### **1.1 GitHub Pages (Free)**
```bash
# Build for web
flutter clean
flutter pub get
flutter build web --release

# The built files will be in build/web/
# GitHub Pages will automatically deploy from your main branch
```

**Live URL**: `https://haridiii07.github.io/athletica/`

#### **1.2 Netlify (Free)**
1. Connect your GitHub repository
2. Set build command: `flutter build web`
3. Set publish directory: `build/web`
4. Deploy automatically

#### **1.3 Vercel (Free)**
1. Connect your GitHub repository
2. Set build command: `flutter build web`
3. Set output directory: `build/web`
4. Deploy automatically

### **Option 2: Mobile App Distribution**

#### **2.1 Android APK**
```bash
# Build Android APK
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
```

**Share via:**
- Google Drive
- WhatsApp
- Email attachment
- Firebase App Distribution

#### **2.2 iOS App (Requires Mac)**
```bash
# Build iOS app
flutter build ios --release

# Upload to App Store Connect or TestFlight
```

### **Option 3: Desktop Apps**

#### **3.1 Windows**
```bash
flutter build windows --release
# Executable: build/windows/runner/Release/athletica.exe
```

#### **3.2 macOS**
```bash
flutter build macos --release
# App: build/macos/Build/Products/Release/athletica.app
```

#### **3.3 Linux**
```bash
flutter build linux --release
# Executable: build/linux/x64/release/bundle/athletica
```

## 🔧 **Backend Integration Setup**

### **Step 1: Switch to Real API**
In `lib/config/app_config.dart`:
```dart
// Change this line:
static const bool useMockApi = true;

// To:
static const bool useMockApi = false;
```

### **Step 2: Update Backend URL**
In `lib/config/app_config.dart`:
```dart
// For development:
static const String baseUrl = 'http://localhost:3000/api';

// For production:
static const String baseUrl = 'https://your-backend-domain.com/api';
```

### **Step 3: Backend API Endpoints Required**

Your backend needs to implement these endpoints:

#### **Authentication Endpoints**
```
POST /api/auth/signup
POST /api/auth/signin
POST /api/auth/signout
POST /api/auth/forgot-password
POST /api/auth/google-signin
POST /api/auth/facebook-signin
POST /api/auth/apple-signin
```

#### **Coach Endpoints**
```
GET /api/coaches/profile
PUT /api/coaches/profile
```

#### **Client Management**
```
GET /api/clients
POST /api/clients
PUT /api/clients/:id
DELETE /api/clients/:id
```

#### **Plan Management**
```
GET /api/plans
POST /api/plans
PUT /api/plans/:id
DELETE /api/plans/:id
```

#### **Analytics**
```
GET /api/analytics/dashboard
```

## 📱 **Testing Your App**

### **Local Testing**
```bash
# Run on Chrome
flutter run -d chrome

# Run on Android emulator
flutter run -d android

# Run on iOS simulator (Mac only)
flutter run -d ios
```

### **Production Testing**
1. Build the app for your target platform
2. Test all authentication flows
3. Test client and plan management
4. Verify error handling

## 🌐 **Sharing Your App**

### **For Investors/Demo**
1. **Web Demo**: Share GitHub Pages link
2. **Video Demo**: Record screen showing functionality
3. **APK File**: Send Android APK for testing

### **For Developers**
1. **GitHub Repository**: Already set up
2. **Documentation**: README.md with setup instructions
3. **API Documentation**: Backend integration guide

### **For Users**
1. **Web App**: Direct link to GitHub Pages
2. **Mobile App**: APK file or app store links
3. **Desktop App**: Downloadable executables

## 🔄 **Environment Management**

### **Development Environment**
- Uses Mock API Service
- Local development server
- Debug mode enabled

### **Staging Environment**
- Real API with test data
- Staging backend URL
- Production-like testing

### **Production Environment**
- Real API with live data
- Production backend URL
- Optimized builds

## 📊 **Monitoring and Analytics**

### **App Performance**
- Flutter performance monitoring
- Error tracking and reporting
- User analytics

### **Backend Monitoring**
- API response times
- Error rates
- Database performance

## 🚨 **Troubleshooting**

### **Common Issues**

#### **Build Errors**
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build web --release
```

#### **API Connection Issues**
1. Check backend URL in `app_config.dart`
2. Verify backend is running
3. Check network connectivity

#### **Authentication Issues**
1. Verify API endpoints
2. Check token handling
3. Test with mock API first

## 📈 **Next Steps After Deployment**

1. **Set up monitoring** for production
2. **Implement analytics** tracking
3. **Set up CI/CD** pipeline
4. **Create user documentation**
5. **Plan marketing strategy**

## 🎯 **Success Metrics**

- **Web App**: Page views, user engagement
- **Mobile App**: Downloads, active users
- **Backend**: API response times, uptime
- **Business**: User registrations, revenue

---

**Your Athletica app is ready for deployment! 🚀**

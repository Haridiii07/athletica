# 🏋️ Athletica - Fitness Trainer Platform

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-Private-red.svg?style=for-the-badge)]()

> **Private Flutter project** - Cross-platform fitness trainer management app

## 🎯 **Project Overview**

Athletica is a Flutter-based platform for fitness trainers with Arabic-first UI and comprehensive client management features.

### **Key Features**
- 🔐 **Multi-Platform Authentication** (Email/Password, Google, Facebook)
- 👥 **Client Management** with progress tracking
- 📅 **Smart Scheduling** system
- 💪 **Workout Templates** in Arabic
- 💬 **In-App Messaging** between trainers and clients
- 📊 **Business Analytics** and revenue tracking
- 🎨 **Arabic-First UI** with RTL support
- 📱 **Cross-Platform** (Android, iOS, Web, Windows, macOS, Linux)

## 🚀 **Quick Start**

### **Prerequisites**
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Git

### **Installation**

1. **Clone the repository**
   ```bash
   git clone https://github.com/Haridiii07/athletica.git
   cd athletica
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # Web (Chrome)
   flutter run -d chrome
   
   # Android
   flutter run -d android
   
   # iOS (Mac only)
   flutter run -d ios
   ```

### **🌐 Team Access**
**Web App**: [https://haridiii07.github.io/athletica/](https://haridiii07.github.io/athletica/)

### **📱 Mobile Testing**
- **Android**: Build APK locally or use `flutter run -d android`
- **iOS**: Use `flutter run -d ios` (Mac required)
- **Web**: Use `flutter run -d chrome`

## 🏗️ **Architecture**

### **Tech Stack**
- **Frontend**: Flutter 3.x with Dart
- **State Management**: Provider
- **HTTP Client**: Dio
- **Local Storage**: Hive
- **Authentication**: Firebase Auth + Custom Backend
- **UI Framework**: Material Design 3

### **Project Structure**
```
lib/
├── config/           # App configuration and API endpoints
├── models/           # Data models (Coach, Client, Plan, Message)
├── providers/        # State management (AuthProvider, CoachProvider)
├── screens/          # UI screens
│   ├── auth/        # Authentication screens
│   └── dashboard/   # Main app screens
├── services/         # API service and external integrations
└── utils/           # Utilities (theme, exceptions, helpers)
```

## 🔧 **Configuration**

### **Backend Setup**
1. Update `lib/config/app_config.dart` with your backend URL
2. Configure authentication endpoints
3. Set up your Node.js backend (see [Backend Integration Guide](BACKEND_INTEGRATION.md))

### **Firebase Setup**
1. Create a Firebase project
2. Add your `google-services.json` to `android/app/`
3. Configure authentication providers
4. See [Firebase Setup Guide](FIREBASE_SETUP.md) for detailed instructions

## 📋 **Features Implemented**

### ✅ **Authentication System**
- [x] Email/Password authentication
- [x] Google Sign-In integration
- [x] Facebook Sign-In integration
- [x] Forgot Password functionality
- [x] Custom exception handling with user-friendly error messages

### ✅ **API Service**
- [x] Dio HTTP client integration
- [x] Comprehensive error handling
- [x] Automatic authentication headers
- [x] 20+ API endpoints implemented

### ✅ **UI/UX**
- [x] Arabic-first design with RTL support
- [x] Smart error display system
- [x] Color-coded error messages
- [x] Retry functionality for network errors
- [x] Professional user experience

### 🔄 **In Progress**
- [ ] Apple Sign-In integration
- [ ] Dashboard screens implementation
- [ ] Client management features
- [ ] Plan management features
- [ ] Analytics dashboard

## 🎨 **Design System**

### **Color Palette**
- **Primary**: Deep Blue (#1E3A8A)
- **Secondary**: Orange (#F59E0B)
- **Success**: Green (#10B981)
- **Error**: Red (#EF4444)
- **Warning**: Orange (#F59E0B)

### **Typography**
- **Arabic Font**: Cairo (Google Fonts)
- **English Font**: Inter (Google Fonts)

## 🔧 **Development Setup**

### **Environment Configuration**
- Update `lib/config/app_config.dart` with your backend URL
- Set `useMockApi = true` for frontend testing without backend
- Configure authentication endpoints as needed

## 🧪 **Testing**

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

## 📦 **Building for Production**

### **Web Deployment**
```bash
flutter build web --release
# Deploy build/web/ to GitHub Pages, Netlify, or Vercel
```

### **Android APK**
```bash
flutter build apk --release
# APK: build/app/outputs/flutter-apk/app-release.apk
```

### **iOS App**
```bash
flutter build ios --release
# Upload to App Store Connect
```

### **Desktop Apps**
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 🚀 **Deployment**

### **Web Deployment**
- **GitHub Pages**: Automatic deployment from main branch
- **Manual**: Run `flutter build web --release` and deploy `build/web/`

### **Mobile Builds**
- **Android**: `flutter build apk --release`
- **iOS**: `flutter build ios --release` (Mac required)

**📖 Detailed deployment guide**: [docs/deployment/DEPLOYMENT_GUIDE.md](deployment/DEPLOYMENT_GUIDE.md)

## 📄 **Documentation**

- [Backend Integration Guide](api/BACKEND_INTEGRATION.md)
- [Deployment Guide](deployment/DEPLOYMENT_GUIDE.md)
- [Development Setup](development/)
- [Project Structure](../PROJECT_STRUCTURE.md)

## 🐛 **Known Issues**

- Apple Sign-In not yet implemented
- Some dashboard screens are placeholder
- Offline mode needs enhancement

## 📞 **Team Support**

- **Issues**: [GitHub Issues](https://github.com/Haridiii07/athletica/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Haridiii07/athletica/discussions)

---

**Private Flutter Project - Team Development**
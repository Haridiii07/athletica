# 🏋️ Athletica - Fitness Trainer Platform

## 📱 **Overview**

Athletica is a comprehensive fitness trainer platform designed for trainers to manage their clients, create workout plans, and track progress. Built with Flutter for cross-platform compatibility.

## 🎯 **Key Features**

### ✅ **Authentication System**
- Email/Password authentication
- Google Sign-In integration
- Facebook Sign-In integration
- Forgot Password functionality
- Custom exception handling

### ✅ **Client Management**
- Add, edit, and manage clients
- Track client progress and analytics
- Client communication and messaging
- Progress visualization with charts

### ✅ **Workout Planning**
- Create custom workout plans
- Exercise library and templates
- Plan sharing and distribution
- Progress tracking

### ✅ **Analytics Dashboard**
- Revenue analytics
- Client performance metrics
- Subscription tracking
- KPI monitoring

### ✅ **Modern Design**
- Clean and intuitive interface
- Professional typography
- Responsive design
- User-friendly experience

## 🛠️ **Tech Stack**

- **Frontend**: Flutter 3.x with Dart
- **State Management**: Provider
- **HTTP Client**: Dio
- **Local Storage**: Hive
- **Authentication**: Firebase Auth + Custom Backend
- **UI Framework**: Material Design 3

## 📁 **Project Structure**

```
lib/
├── main.dart                    # App entry point
├── config/                      # App configuration
│   ├── app_config.dart
│   └── app_router.dart
├── features/                    # Feature-based organization
│   ├── auth/                    # Authentication feature
│   │   └── screens/
│   ├── dashboard/               # Dashboard features
│   │   ├── home/
│   │   ├── clients/
│   │   ├── plans/
│   │   ├── analytics/
│   │   └── settings/
│   └── shared/                  # Shared components
│       └── widgets/
├── core/                        # Core functionality
│   ├── models/                  # Data models
│   ├── services/                # API services
│   ├── providers/               # State management
│   └── utils/                   # Utilities
└── app/                         # App-level files
    ├── theme.dart
    └── constants.dart
```

## 🚀 **Quick Start**

### **Prerequisites**
- Flutter SDK 3.x
- Dart SDK 3.x
- Android Studio / VS Code
- Git

### **Installation**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd athletica
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run -d chrome
   ```

### **Configuration**

1. **Backend Setup**
   - Update `lib/config/app_config.dart` with your backend URL
   - Configure authentication endpoints
   - Set `useMockApi = false` for production

2. **Firebase Setup**
   - Create a Firebase project
   - Add `google-services.json` to `android/app/`
   - Configure authentication providers

## 📱 **Platform Support**

- ✅ **Web** - Flutter web build
- ✅ **Android** - APK build ready
- ✅ **iOS** - iOS build ready (with Mac)
- ✅ **Desktop** - Windows, macOS, Linux

## 🔧 **Development**

### **Running Tests**
```bash
flutter test
```

### **Building for Production**
```bash
# Web
flutter build web --release

# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### **Code Analysis**
```bash
flutter analyze
```

## 📚 **Documentation**

- [Setup Guide](SETUP.md) - Detailed setup instructions
- [Deployment Guide](DEPLOYMENT.md) - Production deployment
- [API Documentation](API.md) - Backend integration
- [Business Documentation](business/) - Business requirements

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 **License**

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 **Support**

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

---

**Built with ❤️ for fitness trainers worldwide**
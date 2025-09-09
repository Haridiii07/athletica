# 🏋️ Athletica - Arabic-First Fitness Trainer SaaS Platform

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)

> **Arabic-first SaaS platform for independent fitness trainers in Egypt** - Manage clients, schedules, and workouts with 100% earnings (no commissions)

## 🎯 **Project Overview**

Athletica is a comprehensive Flutter-based SaaS platform designed specifically for fitness trainers in Egypt. The platform provides Arabic-first tools for client management, workout planning, and business analytics, helping trainers transition from manual WhatsApp/Excel methods to a professional digital solution.

### **Key Features**
- 🔐 **Multi-Platform Authentication** (Email/Password, Google, Facebook, Apple)
- 👥 **Client Management** with progress tracking and analytics
- 📅 **Smart Scheduling** with Ramadan-adjusted time slots
- 💪 **Workout Templates** in Arabic (10+ templates included)
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
   flutter run
   ```

## 📱 **Screenshots**

*Screenshots will be added soon*

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

## 📊 **Business Model**

### **Target Market**
- Independent fitness trainers in Egypt
- 10-50 clients per trainer
- 10,000-50,000 EGP/month income
- ~70% uncertified trainers

### **Revenue Model**
- **Free Tier**: 3 clients, basic features
- **Premium Tiers**: 500/750/1,000 EGP/month
- **No Commission Model**: 100% earnings for trainers

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

### **Android**
```bash
flutter build apk --release
flutter build appbundle --release
```

### **iOS**
```bash
flutter build ios --release
```

### **Web**
```bash
flutter build web --release
```

### **Desktop**
```bash
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### **Development Workflow**
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 **Documentation**

- [Backend Integration Guide](BACKEND_INTEGRATION.md)
- [Firebase Setup Guide](FIREBASE_SETUP.md)
- [Custom Exception Handling](CUSTOM_EXCEPTION_HANDLING_DOCUMENTATION.md)
- [Dio HTTP Client Refactoring](DIO_REFACTORING_DOCUMENTATION.md)
- [Google Sign-In Integration](GOOGLE_SIGNIN_INTEGRATION.md)
- [Facebook Sign-In Integration](FACEBOOK_SIGNIN_INTEGRATION.md)

## 📈 **Roadmap**

### **Phase 1: MVP (Current)**
- [x] Authentication system
- [x] Basic UI framework
- [x] API integration
- [ ] Core dashboard features

### **Phase 2: Core Features**
- [ ] Client management
- [ ] Workout planning
- [ ] Scheduling system
- [ ] Messaging platform

### **Phase 3: Advanced Features**
- [ ] Analytics dashboard
- [ ] Payment integration
- [ ] Mobile app stores
- [ ] Multi-language support

## 🐛 **Known Issues**

- Apple Sign-In not yet implemented
- Some dashboard screens are placeholder
- Offline mode needs enhancement

## 📞 **Support**

- **Email**: support@athletica.app
- **Issues**: [GitHub Issues](https://github.com/Haridiii07/athletica/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Haridiii07/athletica/discussions)

## 📜 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- Flutter team for the amazing framework
- Firebase for backend services
- Google Fonts for Arabic typography
- Open source community for inspiration

---

**Made with ❤️ for Egyptian fitness trainers**

*Building the future of fitness training in Egypt, one trainer at a time.*
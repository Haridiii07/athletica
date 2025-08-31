# Athletica - Fitness Trainer SaaS Platform

A Flutter-based SaaS platform designed for fitness trainers in Egypt to manage clients, schedules, and workout plans with an Arabic-first approach.

## 🏋️ Features

### For Coaches/Trainers
- **Client Management**: Track client progress, subscriptions, and session history
- **Plan Creation**: Create and manage workout plans with pricing tiers
- **Dashboard Analytics**: Monitor business metrics and client engagement
- **Messaging System**: In-app communication with clients
- **Profile Management**: Professional coach profiles with certifications

### Business Model
- **Freemium Model**: Free tier (3 clients), Premium tiers (500-1000 EGP/month)
- **Arabic-First Design**: RTL support and localized content
- **Ismailia Pilot**: 3-month pilot targeting 50 trainers
- **Revenue Target**: 60,000-300,000 EGP/year

## 🚀 Quick Start

### Prerequisites
- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Firebase account
- Android device/emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd athletica
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   - Follow the [Firebase Setup Guide](FIREBASE_SETUP.md)
   - Replace `android/app/google-services.json` with your configuration

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── coach.dart           # Coach model
│   ├── client.dart          # Client model
│   └── plan.dart            # Plan model
├── providers/               # State management
│   ├── auth_provider.dart   # Authentication
│   └── coach_provider.dart  # Coach data
├── screens/                 # UI screens
│   ├── splash_screen.dart   # Loading screen
│   ├── landing_screen.dart  # Onboarding
│   ├── auth/               # Authentication screens
│   ├── dashboard/          # Main app screens
│   └── profile/            # Profile management
├── utils/                   # Utilities
│   └── theme.dart          # App theme
└── widgets/                 # Reusable components
```

## 🎨 Design System

### Colors
- **Primary Blue**: `#4A67FF`
- **Dark Background**: `#121212`
- **Card Background**: `#1E1E1E`
- **Success Green**: `#4CAF50`
- **Error Red**: `#F44336`

### Typography
- **Font Family**: Cairo (Google Fonts)
- **RTL Support**: Full Arabic text direction support

## 🔧 Configuration

### Firebase Services
- **Authentication**: Email/password signup/login
- **Firestore**: Database for coaches, clients, and plans
- **Storage**: Profile photos and plan images
- **Analytics**: Usage tracking and insights

### Environment Setup
```bash
# Development
flutter run --debug

# Production build
flutter build apk --release
```

## 📊 Business Metrics

### Pilot Targets (Ismailia, 3 months)
- **Acquisition**: 50 trainers (worst-case: 20)
- **Retention**: <20% churn rate
- **Conversion**: 10-20% premium (5-10 trainers)
- **Revenue**: 60,000-300,000 EGP/year

### Subscription Tiers
- **Free**: 3 clients, basic features
- **Basic (500 EGP/month)**: Analytics, branding
- **Pro (750 EGP/month)**: Advanced features, group scheduling
- **Elite (1000 EGP/month)**: API access, unlimited clients

## 🛠️ Development

### Code Style
- Follow Flutter/Dart conventions
- Use Provider for state management
- Implement proper error handling
- Write clean, documented code

### Testing
```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

### Building
```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS (requires macOS)
flutter build ios
```

## 📈 Roadmap

### Phase 1: MVP (Current)
- [x] Project setup and Firebase configuration
- [x] Authentication system
- [x] Basic UI components
- [ ] Landing and onboarding screens
- [ ] Dashboard implementation
- [ ] Client management

### Phase 2: Core Features
- [ ] Plan management system
- [ ] Messaging functionality
- [ ] Analytics dashboard
- [ ] Profile management
- [ ] Payment integration

### Phase 3: Advanced Features
- [ ] Push notifications
- [ ] Offline support
- [ ] Advanced analytics
- [ ] Multi-language support
- [ ] Web platform

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is proprietary software. All rights reserved.

## 📞 Support

For support and questions:
- Email: [support@athletica.com]
- Documentation: [docs.athletica.com]
- Issues: GitHub Issues

## 🔒 Security

- Firebase security rules implemented
- Authentication required for all operations
- Data encryption in transit and at rest
- Regular security audits

---

**Built with ❤️ for fitness trainers in Egypt**

# 🏋️ Athletica - Fitness Trainer Platform

> **Private Flutter project** - Cross-platform fitness trainer management app

## 🚧 **Project Status: Active Development**
**Current Focus:** Migration to Riverpod & Supabase Integration
- ✅ **State Management**: Migrated from Provider to Riverpod
- ✅ **Backend**: Integrated Supabase for Auth & Database
- ✅ **Compilation**: Resolved all static analysis errors

## 🛑 **Current Critical Issue**
**The application is currently in a broken state.**
- **Problem**: Infinite loading on Splash Screen.
- **Symptoms**: App launches, shows logo and spinner, but never navigates to the Landing Screen.
- **Investigation**: `main()` executes correctly, but navigation logic in `SplashScreen` or `GoRouter` configuration appears to be failing.
- **Report**: See [docs/DEBUGGING_REPORT.md](docs/DEBUGGING_REPORT.md) for full investigation details.

## 🚀 **Quick Start**

### **Team Access**
- **Web App**: [https://haridiii07.github.io/athletica/](https://haridiii07.github.io/athletica/)
- **Local Development**: See [docs/README.md](docs/README.md) for full setup

### **Run Locally**
```bash
git clone https://github.com/Haridiii07/athletica.git
cd athletica
flutter pub get
flutter run -d chrome
```

## 📚 **Documentation**

- **[Full Documentation](docs/README.md)** - Complete setup and development guide
- **[Project Structure](PROJECT_STRUCTURE.md)** - File organization overview
- **[Deployment Guide](docs/deployment/DEPLOYMENT_GUIDE.md)** - How to deploy
- **[API Integration](docs/api/BACKEND_INTEGRATION.md)** - Backend setup

## 🏗️ **Tech Stack**

- **Frontend**: Flutter 3.x with Dart
- **State Management**: **Riverpod** (previously Provider)
- **Backend**: **Supabase** (Auth, Database, Storage)
- **Routing**: GoRouter
- **UI**: Arabic-first design with RTL support

## 📱 **Platforms**

- ✅ **Web** (Chrome, Firefox, Safari)
- ✅ **Android** (APK)
- ✅ **iOS** (Mac required)
- ✅ **Desktop** (Windows, macOS, Linux)

---

**Private Project - Team Development Only**

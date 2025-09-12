# Development Environment Setup Guide

## Flutter Doctor Status Check

Run `flutter doctor` to check your development environment:

```bash
flutter doctor
```

### Expected Output for Windows Development:
- ✅ Flutter (Channel stable, version 3.x.x)
- ✅ Android toolchain (Android SDK, Android Studio)
- ⚠️ iOS toolchain (requires macOS with Xcode)
- ✅ VS Code or Android Studio
- ✅ Connected device (Android device or emulator)

## iOS Build Environment Setup

### For Windows Developers:

Since you're on Windows, you have several options for iOS development:

#### Option 1: Cloud CI/CD Services (Recommended)
- **Codemagic**: Excellent Flutter support, free tier available
- **Bitrise**: Good Flutter integration
- **GitHub Actions**: Free for public repos, supports macOS runners
- **AppCenter**: Microsoft's CI/CD service

#### Option 2: macOS Virtual Machine
- Use VMware or VirtualBox to run macOS
- Install Xcode and iOS Simulator
- Note: Apple's licensing may restrict this approach

#### Option 3: Remote macOS Access
- Use services like MacStadium or MacinCloud
- Access macOS machines remotely for iOS builds

## iOS Project Configuration

### Bundle Identifier Setup
The iOS bundle identifier should be configured in:
- `ios/Runner.xcodeproj/project.pbxproj`
- `ios/Runner/Info.plist`

### Current Configuration:
```xml
<key>CFBundleIdentifier</key>
<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
```

### Recommended Bundle ID:
```
com.athletica.app
```

## Android Configuration

### Current Android Configuration:
- **Package Name**: `io.flutter.plugins`
- **Target SDK**: Latest stable
- **Min SDK**: 21 (Android 5.0)

### Recommended Android Configuration:
```gradle
android {
    compileSdkVersion 34
    defaultConfig {
        applicationId "com.athletica.app"
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

## Development Workflow

### 1. Local Development (Windows)
- Use Android emulator or physical Android device
- Test Flutter web version in browser
- Use `flutter run -d chrome` for web testing

### 2. iOS Testing
- Use cloud CI/CD services for iOS builds
- Test on iOS Simulator through cloud services
- Deploy to TestFlight for iOS testing

### 3. Code Quality
- Use `flutter analyze` for static analysis
- Run `flutter test` for unit and widget tests
- Use `flutter build` commands for release builds

## Environment Variables

Create a `.env` file for environment-specific configurations:

```env
# API Configuration
API_BASE_URL=https://api.athletica.app
API_VERSION=v1

# Firebase Configuration
FIREBASE_PROJECT_ID=athletica-app
FIREBASE_API_KEY=your_api_key_here

# Deep Linking
DEEP_LINK_SCHEME=athletica
UNIVERSAL_LINK_DOMAIN=athletica.app

# Analytics
ANALYTICS_ENABLED=true
CRASH_REPORTING_ENABLED=true
```

## Build Commands

### Android Builds:
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# App bundle for Play Store
flutter build appbundle --release
```

### Web Builds:
```bash
# Debug build
flutter build web --debug

# Release build
flutter build web --release
```

### iOS Builds (requires macOS):
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release

# Archive for App Store
flutter build ipa --release
```

## Troubleshooting

### Common Issues:

1. **Flutter Doctor Issues**:
   - Update Flutter: `flutter upgrade`
   - Accept Android licenses: `flutter doctor --android-licenses`

2. **Build Issues**:
   - Clean build: `flutter clean && flutter pub get`
   - Check dependencies: `flutter pub deps`

3. **iOS Build Issues**:
   - Use cloud CI/CD services
   - Ensure proper code signing
   - Check Xcode version compatibility

## Performance Optimization

### Build Performance:
- Use `--split-debug-info` for smaller builds
- Enable `--obfuscate` for release builds
- Use `--tree-shake-icons` to reduce bundle size

### Development Performance:
- Use `flutter run --hot` for hot reload
- Enable `--enable-software-rendering` for web
- Use `--dart-define` for environment variables

## Security Considerations

### API Keys:
- Never commit API keys to version control
- Use environment variables or secure storage
- Implement proper API key rotation

### Code Signing:
- Use proper certificates for iOS
- Implement automated signing in CI/CD
- Store certificates securely

## Monitoring and Analytics

### Crash Reporting:
- Integrate Firebase Crashlytics
- Set up error tracking
- Monitor app performance

### Analytics:
- Implement Firebase Analytics
- Track user engagement
- Monitor feature usage

## Documentation

### Code Documentation:
- Use Dart doc comments
- Document public APIs
- Maintain README files

### API Documentation:
- Document all API endpoints
- Include request/response examples
- Maintain API versioning

## Next Steps

1. Set up cloud CI/CD service
2. Configure iOS project settings
3. Implement automated testing
4. Set up monitoring and analytics
5. Create deployment pipeline

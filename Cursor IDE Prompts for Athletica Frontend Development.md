# Cursor IDE Prompts for Athletica Frontend Development

This document provides detailed, actionable prompts for use in Cursor IDE to address the findings from the Athletica Frontend Review Report. Each prompt is designed to guide you through specific tasks, from fixing identified errors to implementing missing features and optimizing the tech stack.

## 1. Outline of Prompt Categories

To ensure a structured approach, the prompts are categorized as follows:

* **2. Prompts for Identified Errors and Potential Issues**: Focuses on rectifying existing problems and addressing inconsistencies.
* **3. Prompts for Missing Components and Features**: Guides the implementation of functionalities identified as absent from the current codebase but present in the UI/UX design.
* **4. Prompts for Tech Stack Optimization and Recommendations**: Provides guidance on refining the current technology stack for better performance, maintainability, and adherence to platform-specific requirements.
* **5. Prompts for Development Environment Considerations**: Offers suggestions and steps to optimize your development workflow within Windows and Cursor IDE.

## 2. Prompts for Identified Errors and Potential Issues

### 2.1. Implement Missing Authentication Features (TODOs)

**Context**: The `SignInScreen` (`lib/screens/auth/signin_screen.dart`) contains placeholder comments (`// TODO: Implement...`) for crucial authentication functionalities such as "Forgot Password", "Google sign in", and "Facebook sign in". These features are essential for a complete and user-friendly authentication experience.

**Prompt for Cursor IDE**:

```texttext
As a Flutter developer, I need to implement the 'Forgot Password' functionality in `lib/screens/auth/signin_screen.dart`. When the 'Forgot Password?' text button is pressed, the user should be navigated to a new screen where they can enter their email to receive a password reset link. This new screen should include:

1.  A clear title (e.g., "Forgot Password?").
2.  An email input field with appropriate validation.
3.  A button to submit the email (e.g., "Send Reset Link").
4.  A back button to return to the sign-in screen.
5.  Integrate with the `AuthProvider` to call a new `forgotPassword` method in `ApiService` that sends a password reset email. Display success or error messages to the user using a `SnackBar`.

After implementing the UI, create the `forgotPassword` method in `lib/providers/auth_provider.dart` and `lib/services/api_service.dart`. The `api_service.dart` method should send a POST request to a new backend endpoint (e.g., `/auth/forgot-password`) with the user's email.
```text

```text
As a Flutter developer, I need to implement the 'Google Sign-In' functionality in `lib/screens/auth/signin_screen.dart`. When the 'Google' `OutlinedButton.icon` is pressed, the user should be able to sign in using their Google account. This requires:

1.  Integrating a Flutter package for Google Sign-In (e.g., `google_sign_in`).
2.  Handling the Google Sign-In flow, including obtaining user credentials.
3.  Integrating with the `AuthProvider` to call a new `signInWithGoogle` method in `ApiService` that sends the Google token to the backend for authentication. Display success or error messages to the user using a `SnackBar`.

After implementing the UI, create the `signInWithGoogle` method in `lib/providers/auth_provider.dart` and `lib/services/api_service.dart`. The `api_service.dart` method should send a POST request to a new backend endpoint (e.g., `/auth/google-signin`) with the Google access token.
```text

```text
As a Flutter developer, I need to implement the 'Facebook Sign-In' functionality in `lib/screens/auth/signin_screen.dart`. When the 'Facebook' `OutlinedButton.icon` is pressed, the user should be able to sign in using their Facebook account. This requires:

1.  Integrating a Flutter package for Facebook Sign-In (e.g., `flutter_facebook_auth`).
2.  Handling the Facebook Sign-In flow, including obtaining user credentials.
3.  Integrating with the `AuthProvider` to call a new `signInWithFacebook` method in `ApiService` that sends the Facebook token to the backend for authentication. Display success or error messages to the user using a `SnackBar`.

After implementing the UI, create the `signInWithFacebook` method in `lib/providers/auth_provider.dart` and `lib/services/api_service.dart`. The `api_service.dart` method should send a POST request to a new backend endpoint (e.g., `/auth/facebook-signin`) with the Facebook access token.
```text

### 2.2. Standardize HTTP Client to `dio`

**Context**: The `pubspec.yaml` lists both `http` and `dio` as dependencies, but only `http` is currently used in `lib/services/api_service.dart`. Standardizing on `dio` offers benefits like interceptors, global configurations, and better error handling.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to refactor `lib/services/api_service.dart` to exclusively use the `dio` package for all HTTP requests, replacing all instances of `package:http/http.dart`. This involves:

1.  Removing the `import 'package:http/http.dart' as http;` statement.
2.  Initializing `Dio` as the HTTP client.
3.  Converting all `http.get`, `http.post`, `http.put`, and `http.delete` calls to their equivalent `dio` methods (e.g., `_dio.get`, `_dio.post`).
4.  Adjusting request headers and body serialization to match `dio`'s API.
5.  Updating error handling to work with `DioError`.
6.  After refactoring, remove the `http` package from `pubspec.yaml` and run `flutter pub get`.
```text

### 2.3. Improve Error Handling Granularity

**Context**: The `AuthProvider` and `ApiService` currently throw generic `Exception` objects. More granular error handling would allow for better user feedback and easier debugging.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to improve the error handling in `lib/providers/auth_provider.dart` and `lib/services/api_service.dart` by introducing custom exception types. This involves:

1.  Define custom exception classes (e.g., `AuthException`, `NetworkException`, `ValidationException`) in a new file like `lib/utils/exceptions.dart`.
2.  Modify `ApiService` methods to throw these specific custom exceptions based on HTTP status codes or known error conditions (e.g., 401 for `AuthException`, 400 for `ValidationException`, network issues for `NetworkException`).
3.  Update `AuthProvider` to catch these specific exceptions and set more descriptive error messages in the `_error` variable, or expose the specific exception type.
4.  Modify the UI (e.g., `SignInScreen`, `SignUpScreen`) to display more user-friendly messages based on the type of error received from the `AuthProvider`.
```text

### 2.4. Implement Apple Sign-In for iOS

**Context**: For an iOS-first release, Apple mandates that if an app offers third-party sign-in options, it must also offer Apple Sign-In. The current codebase lacks this implementation.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to implement 'Apple Sign-In' functionality, which is mandatory for iOS apps offering other third-party logins. This involves:

1.  Integrating the `sign_in_with_apple` Flutter package.
2.  Adding an 'Apple Sign-In' button to `lib/screens/auth/signin_screen.dart` alongside Google and Facebook buttons.
3.  Handling the Apple Sign-In flow, obtaining the authorization code or identity token.
4.  Integrating with the `AuthProvider` to call a new `signInWithApple` method in `ApiService` that sends the Apple token to the backend for authentication. Display success or error messages to the user using a `SnackBar`.

After implementing the UI, create the `signInWithApple` method in `lib/providers/auth_provider.dart` and `lib/services/api_service.dart`. The `api_service.dart` method should send a POST request to a new backend endpoint (e.g., `/auth/apple-signin`) with the Apple identity token.
```text

## 3. Prompts for Missing Components and Features

### 3.1. Implement Profile Photo Upload Screen

**Context**: The UI/UX design includes a screen for uploading a profile photo, and the `AuthProvider` has an `updateProfile` method that accepts `profilePhotoUrl`. However, the corresponding frontend screen is missing.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to create a new `ProfilePhotoScreen` in `lib/screens/auth/profile_photo_screen.dart` that allows users to upload a profile picture. This screen should:

1.  Display a placeholder for the profile picture.
2.  Provide options to select an image from the gallery or take a new photo using the camera (utilize `image_picker`).
3.  Allow users to crop or edit the selected image if necessary.
4.  Include a "Skip" button for users who wish to set a profile photo later.
5.  Include a "Save" or "Continue" button to upload the selected image.
6.  Integrate with `AuthProvider` to call the `updateProfile` method, which will send the image to the backend. This will require a new method in `ApiService` for image upload that returns a URL.
7.  Handle loading states and display success/error messages.
```text

### 3.2. Implement Detailed Client Management UI

**Context**: The UI/UX shows detailed screens for client management, including a Client Details/Profile screen and a Client Progress/Analytics screen. The current codebase likely has basic list views but lacks the detailed UI.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to implement the detailed `ClientDetailsScreen` and `ClientProgressScreen` based on the UI/UX designs. For `ClientDetailsScreen` (likely in `lib/screens/dashboard/client_details_screen.dart`):

1.  Display the client's name, profile picture, and contact information.
2.  Show an overview of their current plan and progress.
3.  Include buttons/sections to:
    *   View/Edit Plan
    *   View Progress/Analytics (navigate to `ClientProgressScreen`)
    *   Send Message (navigate to `ChatConversationScreen`)
    *   Edit Client Profile (e.g., update personal details).

For `ClientProgressScreen` (likely in `lib/screens/dashboard/client_progress_screen.dart`):

1.  Display various charts and graphs (using `fl_chart`) to visualize client progress over time (e.g., weight, body fat, strength metrics).
2.  Include a date range selector to filter the data displayed.
3.  Ensure data is fetched from the `CoachProvider` and `ApiService` (may require new API endpoints for specific client analytics data).
```text

### 3.3. Implement Comprehensive Plan Creation and Exercise Management

**Context**: The UI/UX outlines a comprehensive flow for creating workout plans, including selecting exercises and defining their details. The current codebase has `addPlan` and `updatePlan` methods but the rich UI for this is missing.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to implement the comprehensive `CreatePlanScreen` and related exercise management screens based on the UI/UX designs. For `CreatePlanScreen` (likely in `lib/screens/dashboard/create_plan_screen.dart`):

1.  Allow coaches to input plan name, description, and duration.
2.  Provide an interface to add exercises to the plan.
3.  When adding exercises, navigate to an `ExerciseSelectionScreen` (new screen) that:
    *   Lists available exercises (fetch from backend via `ApiService`).
    *   Allows searching and filtering exercises.
    *   Enables multi-selection of exercises.
4.  After selecting exercises, navigate to an `ExerciseDetailsScreen` (new screen) for each selected exercise where coaches can:
    *   Define sets, repetitions, weight, and rest time for each exercise.
    *   Add notes or instructions.
5.  Allow reordering and editing of exercises within the plan.
6.  Include a "Save Plan" or "Publish Plan" button that integrates with `CoachProvider` and `ApiService` to persist the plan data.
```text

### 3.4. Implement Real-time Messaging Functionality

**Context**: The UI/UX includes detailed chat screens, and a `message.dart` model exists, but the `ApiService` lacks messaging endpoints and real-time integration.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to implement the real-time messaging functionality, including `MessagingScreen` (list of conversations) and `ChatConversationScreen` (individual chat). This is a complex feature that will require:

1.  **Backend Integration**: Work with the backend team to establish real-time communication (e.g., WebSockets, Firebase Realtime Database, or a dedicated chat service). This will involve new API endpoints for sending/receiving messages, fetching chat history, and managing conversations.
2.  **`ApiService` Extension**: Add new methods to `lib/services/api_service.dart` for:
    *   `getConversations()`: Fetch a list of all chat conversations.
    *   `getMessages(conversationId)`: Fetch messages for a specific conversation.
    *   `sendMessage(conversationId, messageContent)`: Send a new message.
    *   Potentially `startNewConversation(clientId)`.
3.  **`CoachProvider` Updates**: Add methods to `lib/providers/coach_provider.dart` to manage chat state, including:
    *   Loading conversations and messages.
    *   Handling real-time message updates (e.g., using `StreamController` or similar for reactive UI).
4.  **UI Implementation**: Develop `MessagingScreen` to display a list of active conversations with clients (e.g., showing last message and timestamp). Develop `ChatConversationScreen` with:
    *   A message list that displays sent and received messages.
    *   An input field for typing messages.
    *   A send button.
    *   Options to attach media (images, videos) or files.
5.  **Push Notifications**: Integrate push notifications for new messages to ensure coaches are alerted in real-time.
```text

### 3.5. Implement Subscription Management UI

**Context**: The UI/UX includes a Subscription Details screen, indicating that subscription management is a planned feature.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to implement the `SubscriptionScreen` (likely in `lib/screens/dashboard/subscription_screen.dart`) based on the UI/UX design. This screen should:

1.  Display the user's current subscription plan details (name, expiry date, features).
2.  Provide options to:
    *   View subscription history.
    *   Upgrade or downgrade the subscription plan.
    *   Manage payment methods.
3.  Integrate with `ApiService` to fetch subscription information and handle subscription changes (requires new backend API endpoints).
4.  Handle different subscription states (e.g., active, expired, trial).
```text

### 3.6. Implement Comprehensive Settings Screens

**Context**: The UI/UX shows various settings screens (Notifications, Privacy, Security, Language, Help/Support, About Us, Contact Us). These need to be fully implemented.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to implement the various settings screens as per the UI/UX designs. This includes:

1.  **`SettingsScreen`**: The main entry point for all settings, listing categories like Account, Notifications, Privacy, Security, Language, Help & Support, About Us.
2.  **`NotificationSettingsScreen`**: Allow users to toggle different types of notifications (e.g., new messages, client progress updates).
3.  **`PrivacySettingsScreen`**: Provide options related to data privacy and sharing.
4.  **`SecuritySettingsScreen`**: Include options for password change, two-factor authentication (if supported by backend), and session management.
5.  **`LanguageSelectionScreen`**: Allow users to select their preferred language for the app (requires `intl` package for localization).
6.  **`HelpSupportScreen`**: Provide links to FAQ, Contact Us, and About Us.
7.  **`AboutUsScreen`**: Display information about the app, version, terms of service, and privacy policy.
8.  **`ContactUsScreen`**: Provide a contact form or display contact information.

Ensure all these screens are properly navigable from the main `SettingsScreen` and integrate with `ApiService` and `AuthProvider` where necessary for data persistence (e.g., saving notification preferences, changing passwords).
```text

### 3.7. Implement Robust Error and Empty States

**Context**: While some error handling exists, a comprehensive approach to displaying error states and empty states will significantly improve user experience.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to implement robust error states and empty states across the application. This involves:

1.  **Global Error Handling**: Implement a global error handling mechanism (e.g., using `ErrorWidget.builder` or a custom error reporting service) to gracefully handle unhandled exceptions.
2.  **Specific Error Widgets**: For each screen or major component that fetches data, design and implement custom error widgets that display user-friendly messages when data loading fails (e.g., network error, server error).
3.  **Empty State Widgets**: For lists or sections that might be empty (e.g., no clients added yet, no plans created, no messages), design and implement visually appealing empty state widgets that provide context and guide the user on how to populate the section (e.g., "No clients yet. Tap here to add your first client!").
4.  **Loading Indicators**: Ensure consistent and clear loading indicators are displayed while data is being fetched or operations are in progress.
```text

## 4. Prompts for Tech Stack Optimization and Recommendations

### 4.1. Standardize HTTP Client to `dio` (Reiteration)

**Context**: As identified, both `http` and `dio` are present, but only `http` is used. Standardizing on `dio` is recommended for its advanced features and consistency.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to ensure that `lib/services/api_service.dart` exclusively uses the `dio` package for all HTTP requests. This involves:

1.  Verifying that all `http` calls have been successfully migrated to `dio`.
2.  Removing the `http` package from `pubspec.yaml`.
3.  Running `flutter pub get` to update dependencies.
4.  Confirming that the application builds and runs without network-related errors.
```text

### 4.2. Ensure iOS Human Interface Guidelines (HIG) Adherence

**Context**: While Flutter provides cross-platform UI, ensuring adherence to iOS HIG can significantly improve the user experience for iOS users.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to review the existing UI components and navigation patterns in the Athletica app, particularly in `lib/screens/`, to ensure they align with iOS Human Interface Guidelines (HIG). This involves:

1.  Identifying areas where Material Design widgets might clash with iOS aesthetics (e.g., navigation bars, dialogs, switches).
2.  Replacing or adapting these components to use Flutter's `Cupertino` widgets where appropriate (e.g., `CupertinoNavigationBar`, `CupertinoAlertDialog`, `CupertinoSwitch`).
3.  Adjusting typography and spacing to match iOS conventions.
4.  Paying special attention to the overall navigation flow to ensure it feels natural on iOS.
```text

### 4.3. Implement Performance Optimization Best Practices

**Context**: As the app grows, performance can become a concern. Implementing best practices can prevent jank and ensure a smooth user experience.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to optimize the performance of the Athletica app. This involves:

1.  Reviewing `lib/screens/` and other UI-heavy files for opportunities to use `const` constructors for stateless widgets and widget properties where possible.
2.  Ensuring that all `ListView` and `GridView` widgets that display a large number of items use `ListView.builder` or `GridView.builder` for efficient rendering.
3.  Identifying and optimizing complex animations or frequently rebuilding widgets using `RepaintBoundary` or `AnimatedBuilder` with specific `child` widgets to prevent unnecessary rebuilds.
4.  Using Flutter DevTools to profile the application and identify performance bottlenecks.
```text

### 4.4. Implement Deep Linking and Universal Links

**Context**: Deep linking is crucial for a seamless user experience, allowing specific content to be opened directly from URLs.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to implement deep linking and universal links in the Athletica app. This involves:

1.  Adding the `uni_links` package to `pubspec.yaml`.
2.  Configuring the iOS project to handle universal links (e.g., setting up Associated Domains in Xcode).
3.  Implementing logic in `main.dart` or a dedicated routing file to handle incoming deep links and navigate to the appropriate screen (e.g., a specific client's profile, a workout plan).
4.  Testing deep links thoroughly on both iOS and Android devices.
```text

### 4.5. Integrate Push Notifications (FCM)

**Context**: Push notifications are critical for real-time updates in a coach app.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to integrate Firebase Cloud Messaging (FCM) for push notifications in the Athletica app. This involves:

1.  Setting up Firebase in the Flutter project and configuring it for iOS.
2.  Adding the `firebase_messaging` package to `pubspec.yaml`.
3.  Implementing code to:
    *   Request notification permissions from the user.
    *   Receive and handle incoming push notifications (foreground and background).
    *   Display notifications to the user.
    *   Navigate to specific screens when a notification is tapped (e.g., open a chat conversation when a new message notification is received).
4.  Ensuring that the backend is configured to send FCM notifications.
```text

### 4.6. Enhance Offline Capabilities

**Context**: Robust offline capabilities are important for coaches in areas with limited internet connectivity.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to enhance the offline capabilities of the Athletica app using `hive` (already in use). This involves:

1.  Identifying critical data (e.g., client profiles, workout plans, past messages) that should be available offline.
2.  Implementing data caching strategies using Hive to store this data locally.
3.  Modifying `ApiService` and `CoachProvider` to first attempt to load data from Hive when offline or when network requests fail.
4.  Implementing data synchronization mechanisms to update local Hive data with the latest from the backend when connectivity is restored.
5.  Designing UI elements to indicate offline mode or data synchronization status.
```text

## 5. Prompts for Development Environment Considerations

### 5.1. Ensure Proper SDK Setup and iOS Build Environment

**Context**: You are working on Windows with Cursor IDE. While Flutter supports Windows development, building for iOS still requires specific setup.

**Prompt for Cursor IDE**:

```text
As a Flutter developer working on Windows, I need to ensure my development environment is correctly set up for building and deploying to iOS. This involves:

1.  **Verifying Flutter Doctor**: Run `flutter doctor` in your terminal and address any reported issues, especially those related to iOS development (e.g., Xcode, CocoaPods).
2.  **Understanding iOS Build Requirements**: Acknowledge that a macOS machine with Xcode is required for building and signing iOS applications. If you don't have one, research and set up a cloud-based CI/CD service (e.g., Codemagic, Bitrise, GitHub Actions) that supports Flutter iOS builds from a Windows environment.
3.  **Configuring iOS Project**: Ensure that the iOS project settings (e.g., bundle identifier, signing certificates, provisioning profiles) are correctly configured for your application.
```text

### 5.2. Leverage Cursor IDE Features for Enhanced Productivity

**Context**: Cursor IDE offers AI-powered features that can significantly boost your productivity.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I want to maximize my productivity using Cursor IDE's AI features. This involves:

1.  **Code Generation**: Utilize Cursor's AI to generate boilerplate code for new widgets, screens, or data models based on comments or partial code.
2.  **Code Refactoring**: Ask Cursor to refactor existing code for better readability, performance, or adherence to best practices (e.g., converting `StatefulWidget` to `StatelessWidget` where appropriate, extracting widgets).
3.  **Debugging Assistance**: Use Cursor's AI chat to get explanations for errors, suggest fixes, or understand complex code sections during debugging sessions.
4.  **Test Generation**: Prompt Cursor to generate unit, widget, or integration tests for new or existing code.
5.  **Documentation Generation**: Ask Cursor to generate comments or documentation for functions, classes, or complex logic.
```text

### 5.3. Implement Automated Testing

**Context**: Automated testing is crucial for maintaining code quality and ensuring application stability.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to implement automated tests for the Athletica app. This involves:

1.  **Unit Tests**: Write unit tests for business logic, utility functions, and provider methods (e.g., in `lib/providers/`). Focus on testing individual functions or classes in isolation.
2.  **Widget Tests**: Write widget tests for UI components and screens (e.g., in `lib/screens/`). Verify that widgets render correctly and respond to user interactions as expected.
3.  **Integration Tests**: Write integration tests to verify the end-to-end flow of critical features (e.g., sign-in, client creation, plan assignment). These tests simulate user interactions across multiple screens and interact with the backend (or mocked backend).
4.  **Test Coverage**: Aim for good test coverage to ensure that most of the codebase is covered by tests.
5.  **Running Tests**: Configure your Cursor IDE to easily run Flutter tests and interpret test results.
```text

### 5.4. Set Up a CI/CD Pipeline (for iOS Deployment)

**Context**: For an iOS-first release, an automated CI/CD pipeline is highly recommended to streamline the build and deployment process.

**Prompt for Cursor IDE**:

```text
As a Flutter developer, I need to set up a Continuous Integration/Continuous Deployment (CI/CD) pipeline for the Athletica app, especially for iOS deployment. This involves:

1.  **Choosing a CI/CD Service**: Research and select a suitable CI/CD service that supports Flutter (e.g., Codemagic, Bitrise, GitHub Actions).
2.  **Configuring Build Steps**: Define build steps in the CI/CD configuration to:
    *   Fetch the latest code from GitHub.
    *   Install Flutter dependencies (`flutter pub get`).
    *   Run tests (`flutter test`).
    *   Build the iOS application (e.g., `flutter build ios --release`).
    *   Sign the iOS application with appropriate certificates and provisioning profiles.
3.  **Automating Deployment**: Configure the pipeline to automatically deploy the built iOS app to TestFlight or the App Store upon successful builds.
4.  **Notifications**: Set up notifications for build status (success/failure) to keep the team informed.
```text

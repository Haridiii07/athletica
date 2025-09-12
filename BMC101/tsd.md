# Athletica SaaS Technical Specification Document (TSD)

## 1. Overview

- **Purpose**: Build an Arabic-first Android MVP for trainers to manage clients, schedules, and workouts, with a web app for team management (KPIs, support).
- **Scope**: Android MVP (launch October 23, 2025), iOS/web post-pilot (November 2025–January 2026).
- **Team**: 1 backend developer, 1 frontend developer, 1 UI/UX designer, 1 PM, 2 trainers, 1 IT manager (voluntary).

## 2. Architecture

- **Frontend**:
- Framework: Flutter (open-source, single codebase for Android, iOS, web).
- Components: Reusable UI (buttons, forms), RTL support, offline caching.
- Status: In frontend development (profiles, scheduling prioritized).
- **Backend**:
- Platform: Firebase (free tier) for database, authentication, hosting.
- Data: Store trainer/client profiles, schedules, templates, messages.
- Scalability: Supports 50 trainers without cost escalation.
- **Web App**: Flutter web for PM/IT manager dashboard (sign-ups, churn, support tickets).

## 3. Features Implementation

- **Free Tier**:
- Profiles: Firebase Firestore for data storage, Flutter forms for input.
- Client Management: Firestore for progress/notes, Flutter charts for visualization.
- Scheduling: Flutter calendar widget, Firebase Cloud Messaging for notifications.
- Templates: Firestore for 10 templates, searchable via tags.
- Messaging: Firebase Realtime Database for chats.
- Community: Firestore for forum posts, Flutter for badge UI.
- **Premium Tiers**:
- Basic: Firestore queries for analytics, logo upload via Flutter.
- Pro: PDF generation (Flutter plugin), group scheduling logic.
- Elite: REST API (Firebase Functions), unlimited client storage.
- **UX**: Arabic RTL via Flutter’s Directionality, offline mode via Hive, accessibility via Flutter’s semantics.

## 4. Tools & Integrations

- **Development**: Flutter, Dart, VS Code, Firebase (Firestore, Authentication, Cloud Messaging, Functions).
- **Support**:Yan**:
- Google Forms for feedback.
- WhatsApp for support (no cost).
- **Payments**: Manual bank transfers (Fawry/Vodafone post-pilot).
- **Analytics**: Firebase Analytics for usage tracking.

## 5. Development Plan

- **Timeline**:
  - August–September 2025: Complete frontend (profiles, scheduling), beta test with 10 trainers.
  - October 2025: Finalize MVP, launch on Google Play Store.
- **Tasks**:
  - Backend Developer: Firebase setup (database, authentication).
  - Frontend Developer: Flutter UI (profiles, calendar, messaging).
  - UI/UX Designer: Arabic-first design, high-contrast UI.
  - PM/IT Manager: Web dashboard, support coordination.
  - Trainers: Create 10 templates.

## 6. Constraints

- **Zero Budget**: Use free tools (Flutter, Firebase free tier).
- **Team Size**: 7 members, voluntary, no blockers confirmed.
- **Fallback**: No-code platform (Adalo) if delays occur.

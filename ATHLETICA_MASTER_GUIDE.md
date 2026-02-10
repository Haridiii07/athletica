# 🏋️ Athletica Project Master Guide

> **Version:** 1.0  
> **Last Updated:** December 22, 2025  
> **Status:** MVP / Active Development

This document serves as the **Single Source of Truth** for the Athletica project. It consolidates technical architecture, development status, business vision, and recruitment strategies into one comprehensive guide.

---

## 📖 Table of Contents

1.  [Project Vision & Business Model](#1-project-vision--business-model)
2.  [Technical Architecture](#2-technical-architecture)
3.  [Getting Started & Setup](#3-getting-started--setup)
4.  [Current Implementation Status](#4-current-implementation-status)
5.  [Backend & Database Architecture](#5-backend--database-architecture)
6.  [Authentication & Security](#6-authentication--security)
7.  [Recruitment & Compensation Strategy](#7-recruitment--compensation-strategy)
8.  [Roadmap & Next Steps](#8-roadmap--next-steps)

---

## 1. Project Vision & Business Model

**Athletica** is a cross-platform fitness trainer management application designed to bridge the gap between coaches and their clients. It features two distinct interfaces:
*   **Coach Dashboard:** For managing clients, creating diet/workout plans, and tracking analytics.
*   **Client App:** For receiving plans, logging progress, and communicating with the coach.

### Revenue Model
*   **Subscription-Based:** Coaches pay a monthly/yearly fee to use the platform (SaaS).
*   **Tiered Access:** Free tier (limited clients) vs. Premium tier (unlimited, advanced analytics).
*   **In-App Purchases:** Potential for marketplace features (templates, nutrition guides).

---

## 2. Technical Architecture

The project follows **Clean Architecture** principles to ensuring scalability and testability.

### 🛠 Tech Stack
*   **Frontend:** Flutter 3.x (Dart)
*   **State Management:** **Riverpod** (successfully migrated from Provider)
*   **Backend:** **Supabase** (Auth, PostgreSQL Database, Storage, Realtime)
*   **Routing:** `GoRouter`
*   **HTTP Client:** `Dio` (migrated from `http`)
*   **Local Storage:** `Hive` (for offline capabilities - *in progress*)

### 📂 Directory Structure (`lib/`)
*   `config/`: App-wide configuration (Env vars, Router, Theme).
*   `data/`: Data layer (Repositories implementations, Datasources/Services, Models).
*   `domain/`: Business logic layer (Use Cases, Repository Interfaces, Entities).
*   `presentation/`: UI layer (Riverpod Providers, Screens, Widgets).
*   `utils/`: Helper functions and constants.

---

## 3. Getting Started & Setup

### Prerequisites
*   Flutter SDK (Latest Stable)
*   Git
*   VS Code (recommended) or Android Studio

### Installation
```bash
# 1. Clone the repository
git clone https://github.com/Haridiii07/athletica.git
cd athletica

# 2. Install dependencies
flutter pub get

# 3. run the app
flutter run -d chrome
```

### ⚠️ Current Critical Issue
**Infinite Loading on Splash Screen:**
*   **Symptoms:** App launches but hangs on the logo.
*   **Workaround:** Manually change the URL from `/splash` to `/landing` if stuck, or check console logs for navigation errors.
*   **Fix Status:** See `docs/DEBUGGING_REPORT.md` for investigation details.

---

## 4. Current Implementation Status

### ✅ Fully Implemented
*   **Authentication:** Sign Up, Sign In, Forgot Password (Email/Pass).
*   **Social Auth:** Google & Facebook integration structure.
*   **Core UI:** Dark Theme (Arabic-First), Responsive Design.
*   **Data Models:** Coach, Client, Plan models.
*   **State Management:** Complete migration to Riverpod.

### 🚧 In Progress / Partially Implemented
*   **Messaging System:** UI exists, but Realtime backend integration is pending.
*   **Detailed Analytics:** Basic stats implemented; advanced charts pending.
*   **Offline Mode:** `Hive` integration for caching is ongoing.
*   **Settings Screens:** Placeholders exist for granular notification/privacy settings.

### ❌ Missing
*   **Subscription Management:** UI and payment gateway integration.
*   **Apple Sign-In:** Mandatory for iOS release, currently missing.

---

## 5. Backend & Database Architecture

The backend is powered by **Supabase**. You must execute the SQL setup scripts to make the app functional.

### 🗄️ Database Schema (PostgreSQL)

**1. `coaches` Table**
*   Stores coach profiles. linked to `auth.users`.
*   Fields: `id`, `name`, `email`, `subscription_tier`, `client_limit`.

**2. `clients` Table**
*   Stores client data managed by coaches.
*   Fields: `id`, `coach_id` (FK), `goals` (JSON), `stats` (JSON), `status`.

**3. `plans` Table**
*   Stores workout/diet plans.
*   Fields: `id`, `coach_id` (FK), `features` (JSON), `duration`, `price`.

> **Action Required:** Run the SQL commands found in `IMPLEMENTATION_STATUS.md` in your Supabase SQL Editor to create these tables and set up Row Level Security (RLS) policies.

---

## 6. Authentication & Security

### 🔐 Auth Flow
1.  **Sign Up:** User provides Name, Email, Phone, Password.
2.  **Identity Verification:**
    *   System sends OTP to Email/Phone (Choice).
    *   User enters 6-digit OTP.
3.  **Profile Setup:** User uploads profile photo (optional) and bio.
4.  **Login:** Standard Email/Password or Social Providers.

### Security Measures
*   **RLS Policies:** Strict database policies ensure coaches can ONLY see their own clients and plans.
*   **Password Rules:** Min 8 chars, 1 uppercase, 1 number, 1 special char.
*   **Input Validation:** enforced on both client (Flutter) and server (Postgres constraints).

---

## 7. Recruitment & Compensation Strategy

This section outlines the strategy for hiring a **Flutter Developer** to assist with the MVP.

### 💼 The Offer: Revenue Share (NOT Equity)
Since the project is in the MVP stage and legally unstructured, we offer a **Revenue Share Agreement**.
*   **Role:** Early Contributor / Contract Developer.
*   **Compensation:** **1% - 3% of Net Revenue** (after app store fees/taxes).
*   **Duration:** Fixed term (e.g., 18 months from first revenue).
*   **Why?** Low risk for the founder, high upside for the developer if the product succeeds.

### 🗣️ Interview Strategy
**Goal:** Sell the *Vision* and *Professionalism*. You are not "looking for help"; you are "selecting a partner".

**Key Script Points:**
*   **"Is there a salary?"** -> "Currently, we operate on a deferred compensation model via Revenue Share. You get paid when we succeed."
*   **"What is the equity?"** -> "We are offering Revenue Share (1-3%) rather than Equity at this stage to avoid legal complexity. This guarantees you cash flow from day 1 of profitability."
*   **"Team Structure?"** -> "We have a dedicated Product Owner (Me) and are hiring a lead Flutter Dev. We treat this as a lean startup."

**Ideal Candidate:**
*   Mid-Level (1.5 - 2 years experience).
*   Avoid eager freshers (lack of discipline) or high-level seniors (too expensive/demanding).

---

## 8. Roadmap & Next Steps

### 📅 Immediate Priorities (Week 1)
1.  **Fix Critical Bugs:** Resolve the "Infinite Loading" splash screen issue.
2.  **Database Sync:** Ensure local Supabase setup matches the production schema.
3.  **Testing:** Run end-to-end tests for the Auth flow.

### 📅 Short Term (Month 1)
1.  **Messaging:** Implement real-time chat using Supabase Realtime.
2.  **Plan Creator:** Finish the UI for creating complex workout plans.
3.  **Apple Sign-In:** Implement `sign_in_with_apple` for iOS compliance.

### 📅 Long Term (Quarter 1)
1.  **Payment Integration:** Stripe/RevenueCat for subscriptions.
2.  **App Store Launch:** Deploy to TestFlight and Google Play Console.
3.  **Marketing:** Begin coach onboarding campaign.

---
*Created by Antigravity Assistant from project documentation.*

# Athletica SaaS Product Requirements Document (PRD)

## 1. Purpose

- **Objective**: Deliver an Arabic-first SaaS platform for independent fitness trainers in Ismailia (Cairo opportunistic) to manage clients, schedules, and workouts, replacing WhatsApp/Excel.
- **Business Goals**:
  - Onboard 50 trainers (worst-case: 20).
  - Achieve <20% churn via intuitive UX and community features.
  - Convert 5–10 trainers to premium (10–20%, worst-case: 4).
  - Generate 60,000–300,000 EGP/year (worst-case: 24,000 EGP).
  - Expand to Cairo (150 trainers, Months 4–6).

## 2. Target Audience

- **Independent Trainers**:
  - Ismailia (primary), Cairo (via organic marketing).
  - 10–50 clients, 10,000–50,000 EGP/month (500–2,000 EGP/client).
  - ~70% uncertified, using WhatsApp/Excel.
- **Team**: PM/IT manager for web app management (sign-ups, support, KPIs).

## 3. Features

### Free Tier (3-Client Limit)

- **Trainer Profiles**: Bio, specialties, photo, client list (3 max).
- **Client Management**: Track progress (weight, reps), add notes.
- **Scheduling**: Calendar with Ramadan-adjusted evening slots, push notifications.
- **Workout Templates**: 10 Arabic templates (5 bodyweight, 5 gym-based), searchable by type/duration.
- **Messaging**: In-app trainer-client chat.
- **Community**: Forum for trainer tips, badges (e.g., 10 clients).

### Premium Tiers

- **Basic (500 EGP/month)**: Basic analytics (retention rates, dashboards), branding (logo on plans), 12-hour WhatsApp support.
- **Pro (750 EGP/month)**: Advanced analytics (reports, PDF exports), group scheduling, retention alerts (missed sessions).
- **Elite (1,000 EGP/month)**: API access (e.g., wearables), unlimited clients, premium branding (custom templates).

### UX Requirements

- Arabic-first, RTL support, offline mode (cache schedules/templates).
- High-contrast UI, scalable fonts, screen reader support (VoiceOver/TalkBack).
- 5-minute onboarding video (Arabic, Supabase-hosted).

## 4. Success Metrics

- **Acquisition**: 50 trainers (worst-case: 20).
- **Retention**: <20% churn after 3 months.
- **Conversion**: 10–20% premium (5–10 trainers, worst-case: 4).
- **Revenue**: 60,000–300,000 EGP/year (worst-case: 24,000 EGP).

## 5. Constraints

- **Zero Budget**: Voluntary team, free tools (Flutter, Supabase).
- **Timeline**: Android MVP launch by October 23, 2025.
- **Scope**: Android only for pilot; iOS/web post-pilot.

## 6. Assumptions

- Trainers need Arabic-first tools for client management.
- 500–1,000 EGP/month is viable for premium tiers (validation in process).
- Organic marketing (Instagram, referrals) can reach 50 trainers.

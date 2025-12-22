# Athletica Authentication Flow Documentation

This document details the multi-step user authentication and identity verification process as implemented in the Athletica UI/UX design. Developers must ensure the implementation strictly follows this flow.

## 1. Sign Up Screen

The initial sign-up screen captures the user's core identity information.

| Field | Requirement | Notes |
| :--- | :--- | :--- |
| **Name** | Required | Full name of the trainer. |
| **Email** | Required | Primary contact and login identifier. |
| **Phone** | Required | Used for identity verification and account recovery. Must include country code (e.g., +20). |
| **Password** | Required | Must meet all strength requirements listed below. |
| **Confirm Password** | Required | Must match the Password field. |

### Password Strength Requirements

The system enforces the following minimum password requirements, which must be visually indicated to the user during input:

1.  At least **8 characters** long.
2.  Include at least one **uppercase letter**.
3.  Include at least one **number**.
4.  Include at least one **special character** (e.g., !, @, #, $).

## 2. Identity Verification

After initial sign-up, the user is directed to a screen to verify their identity before proceeding. This step is crucial for security and account integrity.

**Process:**

1.  The user is presented with their masked **Email** and **Phone Number**.
2.  The user must select **one** method (Email or Phone) to receive a verification code.
3.  The selection is made via a radio button.
4.  Clicking "Continue" triggers the sending of the One-Time Password (OTP) to the selected channel.

## 3. OTP Code Verification

This screen is used to confirm the user's ownership of the selected contact method (Email or Phone).

**Process:**

1.  The user is prompted to enter the 6-digit OTP sent to their selected email or phone number.
2.  The input field is designed as six separate boxes for easy entry.
3.  A **resend timer** is displayed (e.g., "resend in 20 s") to prevent spamming and indicate when the user can request a new code.
4.  A "Send the code another way" option is available to return to the Identity Verification screen.
5.  Clicking "Continue" verifies the code and completes the sign-up process, leading to the main application.

## 4. Login Flow

The login flow is a standard Email/Password or Social Sign-in process.

*   **Social Sign-in:** Google and Facebook sign-in options are available.
*   **Forgot Password:** Triggers a flow that requires the user to verify their identity (similar to the Sign Up flow) before allowing a password reset.

---

## Technical Implementation Notes (Supabase)

The entire authentication flow is managed by **Supabase Auth**.

*   **Email/Password:** Standard Supabase `signUp` and `signInWithPassword` methods.
*   **Phone Number:** Requires enabling **Phone Sign-ins** in the Supabase Auth settings. The OTP verification step corresponds to the `signInWithOtp` or `verifyOtp` functions.
*   **Social Sign-in:** Handled via Supabase's built-in providers (Google, Facebook).
*   **Password Strength:** Must be enforced on the client-side (Flutter) for immediate feedback and on the server-side (Supabase/Edge Functions) for final validation.

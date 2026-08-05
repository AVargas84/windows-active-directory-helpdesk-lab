# Account Lockout Troubleshooting

## Overview

This exercise demonstrates how to identify, troubleshoot, and resolve an Active Directory account lockout. The objective was to configure an account lockout policy, intentionally lock a user account, restore access, and verify successful domain authentication.

---

## Objective

Configure an Active Directory account lockout policy and restore access for a locked user account without resetting the user's password.

---

## Lab Environment

| Component | Configuration |
|-----------|---------------|
| Domain Controller | DC01 |
| Client Workstation | CLIENT01 |
| Domain | adrianlab.local |
| User Account | Mike Chen |
| Management Tool | Active Directory Users and Computers |

---

## Configuration

The Default Domain Policy was configured with the following account lockout settings:

| Policy Setting | Value |
|---------------|-------|
| Account Lockout Threshold | 5 Invalid Logon Attempts |
| Reset Account Lockout Counter | Default |
| Lockout Duration | Default |

The updated policy was applied to the environment using:

```cmd
gpupdate /force
```

The account was intentionally locked by entering an incorrect password multiple times from CLIENT01.

---

## Troubleshooting

The account was investigated using **Active Directory Users and Computers**.

The following message appeared on the **Account** tab of the user account:

```text
This account is currently locked out on this Active Directory Domain Controller.
```

Because the user still knew the correct password, the account was unlocked without performing a password reset.

This approach restored access while allowing the user to continue using their existing credentials.

---

## Verification

The repair was verified by successfully signing back into CLIENT01 using the original password.

| Verification Test | Result |
|-------------------|--------|
| Account Lockout Triggered | ✅ Pass |
| Locked Account Identified | ✅ Pass |
| Account Successfully Unlocked | ✅ Pass |
| User Authentication Restored | ✅ Pass |

---

## Commands Used

```cmd
gpupdate /force
```

---

## Technologies Used

- Windows Server
- Active Directory Domain Services
- Group Policy
- Active Directory Users and Computers
- Windows Authentication

---

## Skills Demonstrated

- Account Lockout Troubleshooting
- Active Directory User Administration
- Group Policy Management
- Windows Authentication
- Help Desk Troubleshooting
- Verification and Testing

---

## Screenshots

### Locked User Account

The following screenshot shows the Active Directory account indicating that the user was locked out after exceeding the configured account lockout threshold.

![Locked User Account](../screenshots/troubleshooting/account-lockout.png)

---

## Lessons Learned

This exercise demonstrated how Active Directory account lockout policies protect domain accounts from repeated failed authentication attempts.

It also reinforced the importance of verifying the root cause before resetting passwords. When a user still knows the correct password, unlocking the account is often the quickest and least disruptive solution.

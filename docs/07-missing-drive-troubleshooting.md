# Missing Mapped Drive Troubleshooting

## Overview

This exercise demonstrates how to troubleshoot a departmental network drive that is missing from a user's Windows workstation.

An HR user reported that the HR H: drive was no longer available on CLIENT01. Because the drive was deployed through Group Policy Preferences using Active Directory security-group targeting, troubleshooting focused on the user's current network connections, security-group membership, and Group Policy processing.

---

## Objective

Identify why an authorized HR employee was missing the H: drive, correct the underlying Active Directory configuration, and verify that the mapped drive and HR files became available again.

---

## Lab Environment

| Component | Configuration |
|-----------|---------------|
| Domain Controller | DC01 |
| Client Workstation | CLIENT01 |
| Domain | adrianlab.local |
| Department | HR |
| Security Group | ADRIANLAB\HR_Users |
| HR Share | \\DC01\HR |
| Mapped Drive | H: |
| Drive Deployment | Group Policy Preferences |
| Targeting Method | Security Group Membership |

---

## Reported Issue

The HR user signed into CLIENT01 but the expected departmental drive:

```text
HR (H:)
```

did not appear in File Explorer.

The HR share and Group Policy configuration had previously worked, so the problem required troubleshooting rather than rebuilding the environment.

---

## Troubleshooting Approach

The investigation followed a layered process:

```text
Missing H: Drive
      |
      v
Check mapped drives
      |
      v
Check user identity and group membership
      |
      v
Verify Active Directory membership
      |
      v
Correct configuration
      |
      v
Refresh authentication and Group Policy
      |
      v
Verify H: drive and file access
```

This approach avoided immediately modifying the GPO or file-share permissions before identifying the actual cause.

---

## Step 1: Check Current Network Connections

On CLIENT01, the following command was used:

```cmd
net use
```

This displays the network connections and mapped drives recognized by the current Windows session.

The expected H: drive was not present.

This confirmed that the issue was not simply a File Explorer display problem; the drive mapping itself was missing from the current session.

---

## Step 2: Verify User Identity

The logged-in domain identity can be confirmed using:

```cmd
whoami
```

This helps ensure troubleshooting is being performed under the correct domain account.

---

## Step 3: Check Security Group Membership

Because the HR drive mapping used security-group-based item-level targeting, the user's current group memberships were checked using:

```cmd
whoami /groups
```

The expected group was:

```text
ADRIANLAB\HR_Users
```

However, `HR_Users` did not appear in the user's current security-group list.

This was an important finding because the HR Group Policy Preference depended on membership in this group.

---

## Root Cause

The investigation identified the root cause:

> The affected user was no longer a member of the `HR_Users` Active Directory security group.

The HR drive mapping was configured with item-level targeting similar to:

```text
User is a member of:
ADRIANLAB\HR_Users
```

Without that membership, the user did not satisfy the Group Policy targeting condition.

As a result, Windows did not provide the H: drive mapping.

---

## Corrective Action

On DC01, **Active Directory Users and Computers** was opened.

The affected user account was located and the missing security-group membership was restored:

```text
ADRIANLAB\HR_Users
```

The membership was verified through the user's:

```text
Properties
→ Member Of
```

tab.

---

## Refreshing the User Security Token

After the Active Directory membership was corrected, the user signed completely out of CLIENT01 and signed back in.

This step was necessary because Windows creates a security token when the user authenticates.

The token contains information including:

- User identity
- Security-group memberships
- Security identifiers
- Authorization information

Adding the user back to `HR_Users` in Active Directory does not necessarily update an already authenticated session.

Signing out and back in generated a new security token containing the restored HR membership.

---

## Verify Restored Group Membership

After signing back into CLIENT01, the following command was run again:

```cmd
whoami /groups
```

This time the output contained:

```text
ADRIANLAB\HR_Users
```

**Security Group Verification: ✅ PASS**

This confirmed that the user's current Windows session recognized the corrected Active Directory membership.

---

## Group Policy Refresh

The latest Group Policy configuration was then processed using:

```cmd
gpupdate /force
```

Because the user now satisfied the `HR_Users` item-level targeting condition, the HR drive mapping could be applied.

---

## Verify the Mapped Drive

The current network connections were checked again:

```cmd
net use
```

The HR mapping returned:

```text
H:    \\DC01\HR
```

File Explorer also displayed:

```text
HR (H:)
```

**Mapped Drive Verification: ✅ PASS**

---

## Verify File Access

The H: drive was opened and the HR departmental files were available.

The user successfully accessed:

```text
HR-Test.txt
```

This confirmed that both the mapped drive and the underlying HR share permissions were functioning.

**HR File Access: ✅ PASS**

---

## Verification Summary

| Test | Expected Result | Actual Result |
|------|-----------------|---------------|
| Initial `net use` | H: missing | ✅ Confirmed |
| Initial `whoami /groups` | HR_Users missing | ✅ Confirmed |
| AD membership corrected | HR_Users restored | ✅ Pass |
| New login session | Updated token | ✅ Pass |
| `whoami /groups` | HR_Users appears | ✅ Pass |
| `gpupdate /force` | Policy refreshes | ✅ Pass |
| Final `net use` | H: mapped | ✅ Pass |
| HR H: drive | Available | ✅ Pass |
| HR-Test.txt | Accessible | ✅ Pass |

---

## Why the GPO Was Not the Root Cause

A missing mapped drive does not automatically mean the Group Policy Object is broken.

The GPO was configured to provide the H: drive only when this condition was true:

```text
User ∈ HR_Users
```

The GPO was therefore behaving correctly.

The actual problem was that the user no longer met the targeting condition.

This distinction prevented unnecessary changes to a working Group Policy configuration.

---

## Troubleshooting Commands Used

```cmd
whoami
whoami /groups
net use
gpupdate /force
```

### `whoami`

Confirms the identity of the currently authenticated user.

### `whoami /groups`

Displays the security groups contained in the current user's Windows security token.

### `net use`

Displays current network connections and mapped network drives.

### `gpupdate /force`

Forces Windows to process the latest Group Policy settings.

---

## Technologies Used

- Windows Server
- Active Directory Domain Services
- Active Directory Users and Computers
- Active Directory Security Groups
- Group Policy Preferences
- Item-Level Targeting
- SMB File Sharing
- Windows 11
- Oracle VirtualBox

---

## Skills Demonstrated

- Help Desk Troubleshooting
- Active Directory Administration
- Security Group Troubleshooting
- Group Policy Troubleshooting
- Mapped Network Drive Troubleshooting
- Windows Security Tokens
- Command-Line Diagnostics
- Root-Cause Analysis
- Verification and Testing
- Least-Privilege Access Management

---

## Screenshots

### Restored HR Drive

The following screenshot shows the HR H: drive available on CLIENT01 after the user's `HR_Users` membership and Windows session were corrected.

![HR Mapped Drive](../screenshots/group-policy/hr-mapped-drive.png)

*Figure 1. HR H: drive successfully restored on CLIENT01.*

### HR Share Verification

The HR departmental share was successfully accessible after the drive mapping was restored.

![HR Shared Folder](../screenshots/file-sharing/hr-share-files.png)

*Figure 2. HR files accessible through the restored H: drive.*

---

## Lessons Learned

This exercise demonstrated the importance of troubleshooting mapped-drive problems systematically rather than immediately changing Group Policy.

The H: drive was missing because the user no longer satisfied the security-group condition used by Group Policy item-level targeting. The GPO itself was functioning correctly.

Commands such as `net use` and `whoami /groups` helped narrow the problem from a general "missing drive" complaint to a specific Active Directory membership issue.

The exercise also reinforced the importance of Windows security tokens. Restoring group membership in Active Directory did not by itself guarantee that an existing Windows session would recognize the change. Signing out and back in generated a new token containing the corrected membership.

Most importantly, the troubleshooting process followed a repeatable sequence:

```text
Observe → Verify → Isolate → Correct → Retest
```

Using this process reduces unnecessary configuration changes and helps identify the actual root cause of a user's problem.

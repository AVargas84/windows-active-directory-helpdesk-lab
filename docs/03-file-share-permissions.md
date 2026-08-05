# Secure Finance File Share

## Overview

This exercise demonstrates how to create and secure a departmental network file share using Active Directory security groups, SMB share permissions, and NTFS permissions.

The Finance department required a shared folder that authorized Finance employees could modify while users outside the department were denied access.

---

## Objective

Configure a secure Finance departmental share that provides authorized users with the access required to perform their work while following the principle of least privilege.

---

## Lab Environment

| Component | Configuration |
|-----------|---------------|
| Domain Controller | DC01 |
| Client Workstation | CLIENT01 |
| Domain | adrianlab.local |
| Local Folder | C:\Shares\Finance |
| Network Share | \\DC01\Finance |
| Security Group | ADRIANLAB\Finance_Users |
| Authorized Test User | Mike Chen |
| Unauthorized Test User | Sarah Johnson |

---

## Finance Share Configuration

The Finance departmental folder was created on DC01 at:

```text
C:\Shares\Finance
```

The folder was published as an SMB network share:

```text
\\DC01\Finance
```

Access was assigned to the Active Directory security group:

```text
ADRIANLAB\Finance_Users
```

Using a security group instead of assigning permissions directly to individual employees makes the environment easier to administer and scale.

---

## Share Permissions

The default broad `Everyone` permission was removed.

The Finance security group received:

| Security Principal | Share Permission |
|--------------------|------------------|
| Finance_Users | Change |
| Finance_Users | Read |

Full Control was not granted to standard Finance users.

This configuration allows authorized employees to work with departmental files without giving them unnecessary administrative control over the share.

---

## NTFS Permissions

The Finance folder was also secured using NTFS permissions.

`ADRIANLAB\Finance_Users` received:

- Modify
- Read & execute
- List folder contents
- Read
- Write

Permission inheritance was disabled and the inherited permissions were converted into explicit permissions.

Broad `ADRIANLAB\Users` entries were removed while necessary administrative and system entries were retained.

---

## Permission Model

Users accessing the Finance folder over the network are subject to both SMB share permissions and NTFS permissions.

The configuration used in this lab was:

```text
Finance_Users
      |
      +---- SMB Share Permissions: Change + Read
      |
      +---- NTFS Permissions: Modify
      |
      +---- Effective Finance File Access
```

This follows the principle of least privilege by providing the access Finance employees need without granting Full Control.

---

## Troubleshooting

During initial testing, the Finance folder could not be accessed even though the NTFS permissions appeared to be configured correctly.

The following commands were used during the investigation:

```cmd
net view \\10.0.2.10
whoami /groups
```

`net view` confirmed that CLIENT01 could communicate with DC01 and query its available network shares.

`whoami /groups` confirmed that the authorized Finance user was a member of:

```text
ADRIANLAB\Finance_Users
```

Because network connectivity and group membership were working, troubleshooting shifted to the server-side share configuration.

The investigation revealed that the Finance folder had appropriate NTFS permissions but had not actually been published as an SMB share.

The issue was resolved by enabling **Advanced Sharing** for the Finance folder and applying the appropriate share permissions.

---

## Verification

Access was tested using both an authorized Finance employee and an unauthorized HR employee.

### Authorized User Test

Mike Chen, a member of `Finance_Users`, successfully:

- Opened `\\DC01\Finance`
- Opened `Finance-Test.txt`
- Created `Mike-Test.txt`
- Saved the new file to the Finance share

**Result: ✅ PASS**

### Unauthorized User Test

Sarah Johnson was not a member of `Finance_Users`.

Sarah attempted to access:

```text
\\DC01\Finance
```

Windows denied access to the Finance share.

**Result: ✅ PASS**

---

## Verification Summary

| Test | Expected Result | Actual Result |
|------|-----------------|---------------|
| Mike opens Finance share | Access granted | ✅ Pass |
| Mike opens Finance-Test.txt | File opens | ✅ Pass |
| Mike creates Mike-Test.txt | File saves | ✅ Pass |
| Sarah opens Finance share | Access denied | ✅ Pass |

Testing both an authorized and unauthorized user confirmed that the access-control configuration was functioning as intended.

---

## Commands Used

```cmd
net view \\10.0.2.10
whoami /groups
```

---

## Technologies Used

- Windows Server
- Active Directory Domain Services
- Active Directory Security Groups
- SMB File Sharing
- NTFS Permissions
- Windows 11
- Oracle VirtualBox

---

## Skills Demonstrated

- SMB File Share Administration
- NTFS Permission Management
- Active Directory Security Groups
- Role-Based Access Control
- Least Privilege
- Permission Inheritance
- Windows Network Troubleshooting
- Positive and Negative Access Testing
- Root-Cause Analysis

---

## Screenshots

### Finance Users and Security Group

The following screenshot shows the Active Directory users and security-group structure used to manage Finance department access.

![Finance Users and Security Group](../screenshots/active-directory/finance-users-group.png)

*Figure 1. Active Directory structure used to manage Finance department access.*

---

## Lessons Learned

This exercise demonstrated that Windows network file access depends on multiple layers of authorization.

NTFS permissions control access to the underlying files and folders, while SMB share permissions control access when the resource is reached over the network. Both must be configured correctly for network access to function as intended.

The troubleshooting process also reinforced the importance of testing one layer at a time. Verifying connectivity and security-group membership before modifying permissions helped isolate the actual problem: the folder had not been published as an SMB share.

Using the `Finance_Users` security group instead of assigning permissions directly to individual employees also demonstrated how role-based access control makes user administration more scalable and easier to maintain.

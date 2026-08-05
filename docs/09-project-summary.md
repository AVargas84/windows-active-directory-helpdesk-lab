# Windows Active Directory Help Desk Lab — Project Summary

## Project Overview

This project is a hands-on Windows Active Directory home lab designed to simulate common Help Desk and junior Windows system administration responsibilities.

The environment was built using Windows Server, Windows 11 Enterprise, and Oracle VirtualBox. It includes a functioning Active Directory domain, departmental security groups, SMB file shares, NTFS permissions, Group Policy drive mappings, employee lifecycle management, and troubleshooting scenarios.

Rather than focusing only on initial configuration, the project also includes intentionally created problems that were diagnosed and resolved using Active Directory management tools and Windows command-line utilities.

---

## Project Objectives

The primary objectives of this project were to:

- Build and administer a Windows Active Directory domain
- Manage domain users and departmental security groups
- Apply role-based access control to network resources
- Configure secure SMB file shares
- Manage NTFS and share permissions
- Deploy mapped drives using Group Policy Preferences
- Use item-level targeting for department-based resources
- Practice employee onboarding and department transfers
- Troubleshoot account, permissions, mapped-drive, and SMB issues
- Verify both authorized and unauthorized access
- Document technical work using Markdown, Git, and GitHub

---

## Lab Architecture

The lab was built around the following environment:

| Component | Configuration |
|-----------|---------------|
| Domain | adrianlab.local |
| Domain Controller | DC01 |
| Client Workstation | CLIENT01 |
| Server Platform | Windows Server |
| Client Platform | Windows 11 Enterprise |
| Virtualization | Oracle VirtualBox |
| Finance Share | \\DC01\Finance |
| HR Share | \\DC01\HR |
| Finance Drive | F: |
| HR Drive | H: |

The basic architecture is:

```text
                adrianlab.local
                       |
                 +-----+-----+
                 |           |
                DC01      CLIENT01
                 |
        +--------+---------+
        |                  |
 Active Directory      File Services
        |                  |
   +----+----+        +----+----+
   |         |        |         |
Finance     HR      Finance     HR
Users      Users     Share     Share
   |         |        |         |
   +----+----+        +----+----+
        |                  |
        +--------+---------+
                 |
          Group Policy
                 |
          +------+------+
          |             |
       Finance F:      HR H:
```

---

## Active Directory Design

The domain was organized using Organizational Units and security groups.

Departmental OUs were used to organize user accounts, while security groups were used to assign access to resources.

Examples include:

```text
Finance OU
HR OU

Finance_Users
HR_Users
```

This separates **where users are organized** from **how permissions are assigned**.

Security groups were used instead of assigning permissions directly to individual users whenever possible.

---

## Access Control Model

Departmental access followed a role-based model.

For example:

```text
Finance Employee
      |
      v
Finance_Users
      |
 +----+-------------------+
 |                        |
 v                        v
SMB + NTFS             Group Policy
Permissions             Targeting
 |                        |
 v                        v
Finance Share          Finance F:
```

The same model was used for HR resources.

This allows access to be changed primarily through Active Directory group membership.

---

## File Share Security

Departmental folders were created on DC01 and published using SMB.

Examples:

```text
C:\Shares\Finance
C:\Shares\HR
```

Network users accessed these resources through:

```text
\\DC01\Finance
\\DC01\HR
```

Access was controlled using both:

- SMB share permissions
- NTFS permissions

Departmental security groups received the permissions required to perform normal work without granting unnecessary Full Control.

This demonstrated the principle of least privilege.

---

## Group Policy Drive Mapping

Group Policy Preferences were used to automatically provide departmental network drives.

Finance employees received:

```text
F: → \\DC01\Finance
```

HR employees received:

```text
H: → \\DC01\HR
```

Item-level targeting restricted each mapping according to Active Directory security-group membership.

For example:

```text
Finance_Users → Finance F:
HR_Users      → HR H:
```

This allowed drive mappings to follow the user's role rather than requiring manual configuration on CLIENT01.

---

## Employee Lifecycle Management

The project included both employee onboarding and department-transfer scenarios.

### New Employee Onboarding

A new Finance employee was provisioned by:

1. Creating an Active Directory account
2. Assigning an initial password
3. Requiring a password change at first login
4. Adding the employee to `Finance_Users`
5. Verifying domain authentication
6. Verifying the Finance F: drive
7. Testing Finance file access

### Department Transfer

An employee moving from Finance to HR required:

1. Moving the account to the HR OU
2. Removing `Finance_Users`
3. Adding `HR_Users`
4. Establishing a new Windows login session
5. Verifying the HR H: drive
6. Verifying HR file access
7. Confirming Finance access was removed

This demonstrated both **access provisioning** and **access revocation**.

---

## Troubleshooting Methodology

Several problems were intentionally introduced into the environment.

Troubleshooting followed a consistent process:

```text
Observe
   |
   v
Verify
   |
   v
Isolate
   |
   v
Correct
   |
   v
Retest
```

Rather than immediately changing configurations, diagnostic commands and management tools were used to narrow the issue to the appropriate layer.

---

## Commands Used

Common troubleshooting commands included:

```cmd
whoami
whoami /groups
net use
net view \\DC01
gpupdate /force
```

### `whoami`

Verified the identity of the currently authenticated domain user.

### `whoami /groups`

Displayed security-group memberships contained in the user's current Windows security token.

### `net use`

Displayed current mapped drives and network connections.

### `net view \\DC01`

Displayed SMB shares currently advertised by the domain controller.

### `gpupdate /force`

Forced CLIENT01 to process current Group Policy settings.

---

## Troubleshooting Scenarios

### Account Lockout

An account was intentionally locked after repeated incorrect password attempts.

The locked account was identified in Active Directory Users and Computers, unlocked, and successfully tested using the original password.

---

### Missing Security Group Membership

A user lost a departmental mapped drive after the required Active Directory security-group membership was removed.

`whoami /groups` helped identify that the expected group was missing from the user's current security token.

Restoring the group membership and establishing a new login session restored the mapped drive.

---

### Missing SMB Share

An HR folder still existed and had correct NTFS permissions, but users could not access it over the network.

The command:

```cmd
net view \\DC01
```

showed that the HR resource was not being advertised as an SMB share.

Restoring Advanced Sharing corrected the issue.

---

## Lab Documentation

The project is divided into individual technical documents:

| Document | Scenario |
|----------|----------|
| 01 | Active Directory Environment Setup |
| 02 | Account Lockout Troubleshooting |
| 03 | Secure Finance File Share |
| 04 | Group Policy Drive Mapping |
| 05 | New Employee Onboarding |
| 06 | Employee Department Transfer |
| 07 | Missing Mapped Drive Troubleshooting |
| 08 | SMB Share Troubleshooting |
| 09 | Project Summary |

Together, the documents show the progression from infrastructure setup through administration and troubleshooting.

---

## Verification Strategy

Configurations were not considered complete until they were tested.

The project used both **positive testing** and **negative testing**.

Positive testing verified that authorized users could access required resources.

Examples:

```text
Finance user → Finance share → Access granted
HR user      → HR share      → Access granted
```

Negative testing verified that unauthorized users were denied access.

Examples:

```text
HR user      → Finance share → Access denied
Former Finance employee → Finance share → Access denied
```

Testing both conditions provided stronger evidence that the access controls were functioning as intended.

---

## Technologies Used

- Windows Server
- Windows 11 Enterprise
- Active Directory Domain Services
- Active Directory Users and Computers
- DNS
- Group Policy Management
- Group Policy Preferences
- Active Directory Security Groups
- SMB File Sharing
- NTFS Permissions
- Windows Command Line
- Oracle VirtualBox
- Git
- GitHub
- Markdown

---

## Skills Demonstrated

### Windows Administration

- Active Directory Administration
- Domain User Management
- Organizational Unit Management
- Windows Authentication
- Client Workstation Administration

### Identity and Access Management

- Security Group Administration
- Role-Based Access Control
- Least-Privilege Access
- Employee Onboarding
- Department Transfers
- Access Provisioning
- Access Revocation

### Group Policy

- Group Policy Management
- Group Policy Preferences
- Mapped Network Drives
- Item-Level Targeting
- Policy Refresh and Verification

### File Services

- SMB File Sharing
- Share Permissions
- NTFS Permissions
- Permission Inheritance
- UNC Path Testing

### Troubleshooting

- Account Lockouts
- Missing Group Membership
- Missing Mapped Drives
- SMB Share Failures
- Windows Security Tokens
- Command-Line Diagnostics
- Root-Cause Analysis
- Positive and Negative Testing

### Documentation and Version Control

- Technical Documentation
- Markdown
- Git
- GitHub
- Screenshot-Based Verification

---

## Project Evidence

The repository includes screenshots demonstrating several completed configurations and verification tests.

### Active Directory Environment

![Active Directory Domain Structure](../screenshots/active-directory/aduc-domain-structure.png)

*Figure 1. Active Directory Users and Computers for the adrianlab.local domain.*

### Finance Security Structure

![Finance Users and Security Group](../screenshots/active-directory/finance-users-group.png)

*Figure 2. Finance users and departmental security-group configuration.*

### Finance Group Policy

![Finance Drive Mapping GPO](../screenshots/group-policy/finance-drive-mapping-gpo.png)

*Figure 3. Finance F: drive deployment through Group Policy Preferences.*

### HR Mapped Drive

![HR Mapped Drive](../screenshots/group-policy/hr-mapped-drive.png)

*Figure 4. HR H: drive successfully mapped on CLIENT01.*

### HR File Access

![HR Shared Folder](../screenshots/file-sharing/hr-share-files.png)

*Figure 5. HR departmental files accessible through the mapped network drive.*

### Account Lockout

![Account Lockout](../screenshots/troubleshooting/account-lockout.png)

*Figure 6. Active Directory account lockout troubleshooting scenario.*

---

## Key Takeaways

This project demonstrated that Windows domain administration requires understanding how multiple technologies work together.

A mapped departmental drive may involve:

```text
Active Directory User
        |
Security Group
        |
Windows Security Token
        |
Group Policy Preference
        |
SMB Share Permissions
        |
NTFS Permissions
        |
Departmental Files
```

A failure at any layer can produce a similar user-facing symptom.

The troubleshooting exercises reinforced the importance of identifying which layer is failing before changing the configuration.

The project also demonstrated why group-based access control is more scalable than assigning permissions directly to individual users. Security groups allowed onboarding, department transfers, resource deployment, and access revocation to be managed through a consistent administrative model.

---

## Future Improvements

Potential future enhancements to the lab include:

- PowerShell-based Active Directory user provisioning
- Bulk user creation from CSV files
- Automated security-group assignment
- Password reset and account-unlock scripts
- Additional Group Policy security settings
- Windows Server DHCP configuration
- Additional DNS administration
- Centralized logging and event monitoring
- Additional Help Desk troubleshooting scenarios

---

## Conclusion

This project provided hands-on experience administering and troubleshooting a Windows Active Directory environment.

The lab progressed beyond initial domain configuration by incorporating realistic Help Desk scenarios involving user accounts, security groups, file permissions, Group Policy, mapped drives, employee lifecycle management, and network file-sharing failures.

Documenting each scenario in GitHub also provided experience translating technical work into clear, repeatable documentation that can be reviewed alongside the completed lab environment.

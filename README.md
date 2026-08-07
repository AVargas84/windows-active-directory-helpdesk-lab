# 🖥️ Windows Active Directory Help Desk & PowerShell Automation Lab

Hands-on Windows Active Directory home lab simulating common **Help Desk, IT Support, and junior Windows system administration tasks**, including user administration, Group Policy, network file sharing, access control, employee lifecycle management, troubleshooting, and PowerShell automation.

The environment was built using **Windows Server, Windows 11 Enterprise, Active Directory, PowerShell, and Oracle VirtualBox** and documented using **Git, GitHub, Markdown, and screenshot-based verification**.

---

## 🎯 Project Overview

This project was designed to provide practical experience administering, troubleshooting, and automating a Windows domain environment.

The project is divided into two major phases:

### Part 1 — Active Directory Help Desk Administration

The first phase focused on manually configuring and troubleshooting:

- Active Directory Domain Services
- Domain users and Organizational Units
- Security groups
- Account lockouts
- SMB network shares
- NTFS permissions
- Group Policy Preferences
- Mapped network drives
- Employee onboarding
- Department transfers
- Access provisioning and revocation
- Missing drive troubleshooting
- SMB share troubleshooting

### Part 2 — PowerShell Automation

After completing the administration tasks manually, PowerShell was used to automate repetitive Active Directory operations including:

- User creation
- OU placement
- Security-group assignment
- Password resets
- Account unlocking
- Multi-department provisioning
- Duplicate-user detection
- Error handling
- CSV bulk onboarding
- Automated temporary-password generation
- Provisioning logs
- Employee offboarding
- Group-access removal
- Moving disabled users to a dedicated OU

This progression demonstrates both an understanding of the underlying Windows administration process and the ability to automate it.

---

## 🏗️ Lab Architecture

| Component | Configuration |
|-----------|---------------|
| Domain | `adrianlab.local` |
| Domain Controller | `DC01` |
| Client Workstation | `CLIENT01` |
| Server Platform | Windows Server |
| Client Platform | Windows 11 Enterprise |
| Virtualization | Oracle VirtualBox |
| Finance Share | `\\DC01\Finance` |
| HR Share | `\\DC01\HR` |
| Finance Drive | `F:` |
| HR Drive | `H:` |
| PowerShell Module | `ActiveDirectory` |

### Environment Flow

```text
                 adrianlab.local
                        |
                 +------+------+
                 |             |
                DC01        CLIENT01
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
                 |
                 v
        PowerShell Automation
```

---

## 🧰 Technologies Used

![Windows Server](https://img.shields.io/badge/Windows%20Server-Active%20Directory-0078D4?style=flat-square)
![Windows 11](https://img.shields.io/badge/Windows%2011-Client-0078D4?style=flat-square)
![Active Directory](https://img.shields.io/badge/Active%20Directory-AD%20DS-0078D4?style=flat-square)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-5391FE?style=flat-square)
![Group Policy](https://img.shields.io/badge/Group%20Policy-GPO-0078D4?style=flat-square)
![VirtualBox](https://img.shields.io/badge/VirtualBox-Lab-183A61?style=flat-square)
![Git](https://img.shields.io/badge/Git-Version%20Control-F05032?style=flat-square)
![GitHub](https://img.shields.io/badge/GitHub-Portfolio-181717?style=flat-square)

- Windows Server
- Windows 11 Enterprise
- Active Directory Domain Services
- Active Directory Users and Computers
- PowerShell
- Active Directory PowerShell Module
- DNS
- Group Policy Management
- Group Policy Preferences
- SMB File Sharing
- NTFS Permissions
- Windows Command Line
- Oracle VirtualBox
- Git
- GitHub
- Markdown

---

## 🔐 Access Control Design

Departmental access is based on **Active Directory security-group membership** rather than permissions assigned directly to individual employees.

```text
Employee
   |
   v
Department Security Group
   |
   +----------+----------+
   |                     |
   v                     v
SMB + NTFS          Group Policy
Permissions           Targeting
   |                     |
   v                     v
Department Share     Mapped Drive
```

Examples:

```text
Finance_Users → Finance Share → F:
HR_Users      → HR Share      → H:
```

This model supports **Role-Based Access Control (RBAC)** and the **principle of least privilege**.

---

# 📚 Part 1 — Active Directory Help Desk Administration

## Lab Documentation

| # | Scenario | Documentation |
|---|----------|---------------|
| 01 | Active Directory Environment Setup | [View Lab](docs/01-active-directory-setup.md) |
| 02 | Account Lockout Troubleshooting | [View Lab](docs/02-account-lockout.md) |
| 03 | Secure Finance File Share | [View Lab](docs/03-file-share-permissions.md) |
| 04 | Group Policy Drive Mapping | [View Lab](docs/04-group-policy-drive-mapping.md) |
| 05 | New Employee Onboarding | [View Lab](docs/05-user-onboarding.md) |
| 06 | Employee Department Transfer | [View Lab](docs/06-department-transfer.md) |
| 07 | Missing Mapped Drive Troubleshooting | [View Lab](docs/07-missing-drive-troubleshooting.md) |
| 08 | SMB Share Troubleshooting | [View Lab](docs/08-smb-share-troubleshooting.md) |
| 09 | Complete Project Summary | [View Summary](docs/09-project-summary.md) |
| 10 | PowerShell Automation | [View Automation Documentation](docs/10-powershell-automation.md) |

> **Start here:** [Read the complete project summary](docs/09-project-summary.md) for an overview of the Active Directory architecture, access-control model, troubleshooting scenarios, and lessons learned.

---

## 📸 Project Evidence

### Active Directory Environment

The `adrianlab.local` Active Directory environment used throughout the lab.

[![Active Directory Domain Structure](screenshots/active-directory/aduc-domain-structure.png)](screenshots/active-directory/aduc-domain-structure.png)

*Active Directory Users and Computers showing the lab domain structure.*

---

### Finance Users and Security Group

Active Directory security groups were used to provide department-based resource access.

[![Finance Users and Security Group](screenshots/active-directory/finance-users-group.png)](screenshots/active-directory/finance-users-group.png)

*Finance users and departmental security-group configuration.*

---

### Finance Group Policy Drive Mapping

Group Policy Preferences automatically deployed the Finance F: drive to authorized users.

[![Finance Drive Mapping GPO](screenshots/group-policy/finance-drive-mapping-gpo.png)](screenshots/group-policy/finance-drive-mapping-gpo.png)

*Finance drive mapping configured through Group Policy Preferences.*

---

### HR Drive Verification

After the appropriate Active Directory and Group Policy configuration was applied, CLIENT01 received the HR H: drive.

[![HR Mapped Drive](screenshots/group-policy/hr-mapped-drive.png)](screenshots/group-policy/hr-mapped-drive.png)

*HR H: drive successfully mapped on CLIENT01.*

---

### HR File Share Verification

The mapped H: drive successfully provided access to the HR departmental files.

[![HR Shared Folder](screenshots/file-sharing/hr-share-files.png)](screenshots/file-sharing/hr-share-files.png)

*HR departmental files accessible through the mapped network drive.*

---

### Account Lockout Troubleshooting

Active Directory Users and Computers was used to identify and resolve an intentionally locked domain account.

[![Account Lockout](screenshots/troubleshooting/account-lockout.png)](screenshots/troubleshooting/account-lockout.png)

*Account lockout scenario used to practice domain-user troubleshooting.*

---

# ⚡ Part 2 — PowerShell Automation

## Automation Objective

The PowerShell phase builds on the manual Active Directory administration completed in Part 1.

The goal was to replace repetitive administrative work with reusable scripts while maintaining the same Active Directory design and security controls.

The progression was:

```text
Manual Administration
        ↓
Single PowerShell Commands
        ↓
Reusable User Provisioning
        ↓
Multi-Department Automation
        ↓
Validation and Error Handling
        ↓
CSV Bulk Provisioning
        ↓
Automated Passwords and Logs
        ↓
Employee Offboarding
```

---

## 🛠️ PowerShell Tasks Completed

| Task | Automation |
|------|------------|
| 01 | Create and provision a single Active Directory user |
| 02 | Reset password and unlock an AD account |
| 03 | Build a reusable Finance onboarding script |
| 04 | Build multi-department provisioning logic |
| 05 | Add duplicate detection and error handling |
| 06 | Bulk provision users from CSV |
| 07 | Generate temporary passwords and provisioning logs |
| 08 | Automate employee offboarding |

Detailed documentation:

➡️ [PowerShell Automation Documentation](docs/10-powershell-automation.md)

---

## 📜 PowerShell Scripts

### `New-FinanceUser.ps1`

Creates a new Finance employee by:

- Collecting first and last name
- Generating a username
- Prompting securely for a temporary password
- Creating the Active Directory user
- Placing the account in the Finance OU
- Adding `Finance_Users`
- Requiring a password change at first login

[View Script](scripts/New-FinanceUser.ps1)

---

### `New-DepartmentUser.ps1`

Expands onboarding to multiple departments.

Supported departments:

```text
Finance
HR
IT
Sales
```

A PowerShell `switch` statement automatically selects the correct:

- Department value
- Organizational Unit
- Security group

[View Script](scripts/New-DepartmentUser.ps1)

---

### `Bulk-NewUsers.ps1`

Processes multiple employees from a CSV file using:

```powershell
Import-Csv
foreach
```

The script automatically:

- Generates usernames
- Checks for duplicates
- Selects departmental OUs
- Creates AD accounts
- Assigns departmental security groups

[View Script](scripts/Bulk-NewUsers.ps1)

---

### `Bulk-NewUsers-Logged.ps1`

Extends bulk provisioning with:

- Automatic temporary-password generation
- Duplicate detection
- Department validation
- `try` / `catch` error handling
- Provisioning status logs
- Separate temporary credential output

[View Script](scripts/Bulk-NewUsers-Logged.ps1)

---

### `Disable-ADUser.ps1`

Automates employee offboarding.

The script:

```text
Finds user
   ↓
Disables account
   ↓
Removes department groups
   ↓
Moves account to Disabled Users OU
   ↓
Preserves account for auditing
```

[View Script](scripts/Disable-ADUser.ps1)

---

## 📄 Sample CSV Input

Safe sample CSV files are included in:

```text
samples/
```

Example:

```csv
FirstName,LastName,Department
Amanda,Reed,Finance
Marcus,Lee,HR
Jessica,Carter,IT
Brian,Foster,Sales
```

Files:

- [NewUsers.csv](samples/NewUsers.csv)
- [NewUsers-Task7.csv](samples/NewUsers-Task7.csv)

No real passwords or live credentials are included.

---

## 🔒 Credential Security

The logged bulk-provisioning script creates a temporary credential file during execution.

Credential files are intentionally excluded from GitHub using `.gitignore`.

Protected examples include:

```gitignore
TemporaryPasswords.csv
TemporaryPassword.csv
**/Output/TemporaryPasswords.csv
**/Output/TemporaryPassword.csv
.env
*.key
*.secret
```

This keeps sensitive temporary credentials separate from public source control.

---

## ⌨️ Active Directory PowerShell Cmdlets

PowerShell commands used throughout Part 2 include:

```powershell
Get-ADUser
New-ADUser
Set-ADUser
Set-ADAccountPassword
Unlock-ADAccount
Disable-ADAccount
Add-ADGroupMember
Remove-ADGroupMember
Get-ADPrincipalGroupMembership
Get-ADGroupMember
Get-ADOrganizationalUnit
Move-ADObject
```

---

## 🧠 PowerShell Concepts Practiced

- Cmdlets
- Variables
- SecureString
- Functions
- Arrays
- `[PSCustomObject]`
- `Read-Host`
- `if`
- `switch`
- `foreach`
- `continue`
- `try`
- `catch`
- `-ErrorAction`
- String concatenation
- `.Substring()`
- `.ToLower()`
- `Import-Csv`
- `Export-Csv`
- Input validation
- Duplicate detection
- Logging
- Reusable `.ps1` scripts

---

## 🔎 Troubleshooting Methodology

A consistent troubleshooting process was used throughout both phases of the project:

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

Examples included:

- Identifying missing security-group membership
- Troubleshooting missing mapped drives
- Verifying Windows security tokens
- Distinguishing Group Policy issues from permission issues
- Identifying missing SMB shares
- Troubleshooting PowerShell syntax errors
- Correcting password-generation logic
- Identifying partial script execution
- Verifying automation output instead of trusting success messages

---

## ⌨️ Windows Diagnostic Commands

Common Windows commands used during troubleshooting:

```cmd
whoami
whoami /groups
net use
net view \\DC01
gpupdate /force
```

| Command | Purpose |
|---------|---------|
| `whoami` | Verify the currently authenticated user |
| `whoami /groups` | Inspect security groups in the current Windows token |
| `net use` | Review mapped drives and network connections |
| `net view \\DC01` | Review SMB shares advertised by DC01 |
| `gpupdate /force` | Force Group Policy processing |

---

## 💼 Skills Demonstrated

### Active Directory & Identity

- Active Directory administration
- User account provisioning
- Organizational Unit management
- Security group administration
- Account lockout resolution
- Employee onboarding
- Department transfers
- Access provisioning and revocation
- Employee offboarding
- Identity lifecycle management

### PowerShell Automation

- PowerShell scripting
- Active Directory cmdlets
- Reusable `.ps1` scripts
- Multi-department provisioning
- CSV bulk user creation
- Functions
- Conditional logic
- Loops
- Error handling
- Input validation
- Logging
- Automated account lifecycle management

### Windows Administration

- Windows Server administration
- Windows 11 domain clients
- Domain authentication
- Windows security tokens
- DNS-based domain communication
- Command-line diagnostics

### Group Policy & File Services

- Group Policy Management
- Group Policy Preferences
- Item-level targeting
- Mapped network drives
- SMB shares
- NTFS permissions
- Permission inheritance
- UNC path testing

### Troubleshooting

- Root-cause analysis
- Layered troubleshooting
- Authentication troubleshooting
- Permission troubleshooting
- Mapped-drive troubleshooting
- SMB troubleshooting
- PowerShell debugging
- Positive and negative testing

### Documentation & Version Control

- Technical documentation
- Markdown
- Git
- GitHub
- `.gitignore`
- Credential protection
- Version control
- Screenshot-based verification

---

## 🧪 Example Help Desk Scenario

**Issue:** An HR employee reports that the H: drive is missing.

**Investigation:**

```cmd
net use
whoami /groups
```

`net use` confirmed that H: was not mapped.

`whoami /groups` showed that the user's Windows security token did not contain `HR_Users`.

**Root Cause:** The employee was missing the required Active Directory security-group membership.

**Resolution:**

1. Restored `HR_Users` membership.
2. Signed the user completely out of CLIENT01.
3. Signed the user back in to generate a fresh security token.
4. Refreshed Group Policy.
5. Verified H: returned.
6. Verified HR file access.

**Result:** ✅ Resolved

See [Lab 07](docs/07-missing-drive-troubleshooting.md) for the complete troubleshooting walkthrough.

---

## 🧪 Example Automation Scenario

**Request:** Provision several new employees across different departments.

**Input:**

```csv
FirstName,LastName,Department
Amanda,Reed,Finance
Marcus,Lee,HR
Jessica,Carter,IT
Brian,Foster,Sales
```

**Automation:**

```text
Import CSV
     ↓
Process each employee
     ↓
Generate username
     ↓
Check for duplicates
     ↓
Determine department OU
     ↓
Create account
     ↓
Assign security group
     ↓
Log result
```

**Result:** ✅ Multiple Active Directory accounts provisioned automatically.

See [PowerShell Automation](docs/10-powershell-automation.md) for the complete automation progression.

---

## 🧠 Key Takeaways

This project demonstrated how several Windows technologies work together to provide identity, authorization, resource access, and automation.

A user's access to departmental files may involve:

```text
Active Directory Account
          |
          v
    Security Group
          |
          v
 Windows Security Token
          |
          v
 Group Policy Preference
          |
          v
   SMB Share Permission
          |
          v
    NTFS Permission
          |
          v
   Departmental Files
```

PowerShell adds another layer:

```text
CSV / Technician Input
          |
          v
    PowerShell Script
          |
          v
 Active Directory Cmdlets
          |
          v
 Automated User Lifecycle
```

The project reinforced the importance of understanding a manual process before automating it.

Automation does not remove the need for troubleshooting. Scripts must still validate inputs, handle failures, protect credentials, and verify that the intended changes actually occurred.

---

## 🚀 Future Improvements

Potential future enhancements include:

- Advanced PowerShell functions with parameters
- Script logging with timestamps
- Automated username collision resolution
- PowerShell transcript logging
- Home-directory creation
- User expiration handling
- Additional Active Directory security automation
- Windows Server DHCP
- Expanded DNS administration
- Event Viewer troubleshooting
- Centralized logging and monitoring
- Additional Help Desk ticket simulations
- Microsoft Entra ID / Microsoft 365 administration

---

## 📁 Repository Structure

```text
windows-active-directory-helpdesk-lab/
│
├── README.md
├── .gitignore
│
├── docs/
│   ├── 01-active-directory-setup.md
│   ├── 02-account-lockout.md
│   ├── 03-file-share-permissions.md
│   ├── 04-group-policy-drive-mapping.md
│   ├── 05-user-onboarding.md
│   ├── 06-department-transfer.md
│   ├── 07-missing-drive-troubleshooting.md
│   ├── 08-smb-share-troubleshooting.md
│   ├── 09-project-summary.md
│   └── 10-powershell-automation.md
│
├── scripts/
│   ├── New-FinanceUser.ps1
│   ├── New-DepartmentUser.ps1
│   ├── Bulk-NewUsers.ps1
│   ├── Bulk-NewUsers-Logged.ps1
│   └── Disable-ADUser.ps1
│
├── samples/
│   ├── NewUsers.csv
│   └── NewUsers-Task7.csv
│
└── screenshots/
    ├── active-directory/
    ├── file-sharing/
    ├── group-policy/
    └── troubleshooting/
```

---

## 📌 Project Status

### Part 1 — Active Directory Help Desk Lab
**Status:** ✅ Complete

### Part 2 — PowerShell Active Directory Automation
**Status:** ✅ Complete

The environment remains available for additional Windows administration, networking, security, and automation exercises.

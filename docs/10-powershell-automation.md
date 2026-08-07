# PowerShell Automation

## Overview

This section extends the Active Directory Help Desk lab by automating common user administration tasks with PowerShell.

The goal was to first understand the manual Active Directory workflow and then replace repetitive administrative steps with reusable scripts.

The automation work progressed from single-user commands to multi-department provisioning, CSV-based bulk onboarding, error handling, logging, and employee offboarding.

---

## Objectives

The PowerShell portion of the lab was designed to automate common Active Directory tasks including:

- Creating domain users
- Assigning Organizational Units
- Adding departmental security groups
- Resetting passwords
- Unlocking accounts
- Validating duplicate usernames
- Provisioning multiple users from CSV
- Generating temporary passwords
- Creating provisioning logs
- Disabling departing employees
- Removing departmental access
- Moving disabled users to a dedicated OU

---

## PowerShell Environment

| Component | Configuration |
|-----------|---------------|
| Domain Controller | DC01 |
| Domain | adrianlab.local |
| PowerShell Module | ActiveDirectory |
| Script Directory | C:\Scripts |
| Client Workstation | CLIENT01 |
| Repository Script Folder | scripts/ |

The Active Directory PowerShell module was verified using:

```powershell
Get-Module -ListAvailable ActiveDirectory
```

---

## Task 1 — Single User Provisioning

A Finance user was created using PowerShell instead of Active Directory Users and Computers.

The process included:

- Creating the AD account
- Setting the first and last name
- Creating a username
- Setting the User Principal Name
- Assigning the Finance department
- Placing the account in the Finance OU
- Assigning a temporary password
- Enabling the account
- Requiring a password change at first logon
- Adding the user to `Finance_Users`

Example commands included:

```powershell
New-ADUser
Add-ADGroupMember
Get-ADUser
Get-ADPrincipalGroupMembership
```

The account was then tested from CLIENT01 to verify domain authentication, Finance group membership, mapped-drive access, and file creation.

---

## Task 2 — Password Reset and Account Unlock

A locked Finance account was diagnosed and repaired entirely through PowerShell.

The account state was checked using:

```powershell
Get-ADUser -Identity dbrooks -Properties LockedOut,Enabled
```

The password was reset using:

```powershell
Set-ADAccountPassword
```

The account was unlocked using:

```powershell
Unlock-ADAccount
```

The user was then required to change the temporary password at the next logon using:

```powershell
Set-ADUser -ChangePasswordAtLogon $true
```

The repair was verified from CLIENT01.

---

## Task 3 — Reusable Finance Provisioning Script

The first reusable script was created:

```text
New-FinanceUser.ps1
```

The script prompted the technician for:

- First name
- Last name
- Temporary password

It automatically generated the username using:

```powershell
$username = ($firstName.Substring(0,1) + $lastName).ToLower()
```

The script then created the AD account, placed the user in the Finance OU, and assigned `Finance_Users`.

---

## Task 4 — Multi-Department Provisioning

The Finance-only script was expanded into:

```text
New-DepartmentUser.ps1
```

A `switch` statement allowed the technician to select:

```text
1. Finance
2. HR
3. IT
4. Sales
```

The script then automatically selected the correct:

- Department
- Organizational Unit
- Security group

Example logic:

```powershell
switch ($departmentChoice) {

    "1" {
        $department = "Finance"
        $ouPath = "OU=Finance,DC=adrianlab,DC=local"
        $groupName = "Finance_Users"
    }

    "2" {
        $department = "HR"
        $ouPath = "OU=HR,DC=adrianlab,DC=local"
        $groupName = "HR_Users"
    }
}
```

---

## Task 5 — Duplicate Detection and Error Handling

The provisioning script was improved with validation.

Duplicate usernames were checked using:

```powershell
Get-ADUser -Filter "SamAccountName -eq '$username'"
```

If an account already existed, the script stopped before attempting creation.

Additional error handling included:

```powershell
if
switch
try
catch
-ErrorAction Stop
```

This improved the script by preventing duplicate objects and handling invalid department selections.

---

## Task 6 — CSV Bulk Provisioning

A CSV-driven onboarding process was created using:

```powershell
Import-Csv
```

Sample input:

```csv
FirstName,LastName,Department
Amanda,Reed,Finance
Marcus,Lee,HR
Jessica,Carter,IT
Brian,Foster,Sales
```

The script processed each row using:

```powershell
foreach ($user in $users)
```

For each employee, the script:

1. Generated a username
2. Checked for duplicates
3. Selected the correct OU
4. Selected the correct department group
5. Created the AD account
6. Added group membership
7. Continued processing remaining employees

---

## Task 7 — Automated Passwords and Provisioning Logs

The bulk onboarding process was expanded to generate temporary passwords automatically.

A reusable PowerShell function was created:

```powershell
function New-TemporaryPassword
```

The script also used:

```powershell
[PSCustomObject]
```

to create structured provisioning results.

Two output files were generated:

```text
ProvisioningResults.csv
TemporaryPasswords.csv
```

The provisioning report recorded:

- Name
- Username
- Department
- Status
- Result message

Possible statuses included:

```text
SUCCESS
SKIPPED
ERROR
```

---

## Credential Security

The temporary-password output contains sensitive credentials and is not intended for public source control.

The repository uses `.gitignore` rules to prevent credential files from being committed.

Examples:

```gitignore
TemporaryPasswords.csv
TemporaryPassword.csv
**/Output/TemporaryPasswords.csv
**/Output/TemporaryPassword.csv
.env
*.key
*.secret
```

The public repository contains scripts and safe sample CSV files, but not live temporary credentials.

---

## Task 8 — Employee Offboarding

A reusable offboarding script was created:

```text
Disable-ADUser.ps1
```

The script performs the following actions:

```text
Find user
   ↓
Disable account
   ↓
Remove department-group memberships
   ↓
Move account to Disabled Users OU
   ↓
Verify account state
```

The account is not deleted.

Instead, the user remains in Active Directory for auditing or future recovery while authentication and departmental access are removed.

---

## Scripts Included

| Script | Purpose |
|--------|---------|
| `New-FinanceUser.ps1` | Creates a Finance employee |
| `New-DepartmentUser.ps1` | Creates employees for Finance, HR, IT, or Sales |
| `Bulk-NewUsers.ps1` | Creates multiple employees from CSV |
| `Bulk-NewUsers-Logged.ps1` | Bulk provisioning with automated passwords and result logging |
| `Disable-ADUser.ps1` | Disables and offboards an employee |

---

## Sample Files

The `samples/` directory includes safe example CSV files used by the bulk provisioning scripts.

Examples:

```text
NewUsers.csv
NewUsers-Task7.csv
```

No real credentials are included in these files.

---

## PowerShell Concepts Practiced

- Cmdlets
- Variables
- SecureString
- String concatenation
- `.Substring()`
- `.ToLower()`
- `Read-Host`
- `if`
- `switch`
- `foreach`
- `continue`
- `try`
- `catch`
- Functions
- Arrays
- `[PSCustomObject]`
- `Import-Csv`
- `Export-Csv`
- Error handling
- File output
- Reusable `.ps1` scripts

---

## Active Directory Cmdlets Used

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

## Skills Demonstrated

- PowerShell scripting
- Active Directory automation
- User provisioning
- Bulk onboarding
- Role-based access control
- Password administration
- Account lockout troubleshooting
- Security group administration
- Error handling
- Input validation
- CSV automation
- Logging
- Credential handling
- Employee offboarding
- Identity lifecycle management
- Git and GitHub security practices

---

## Automation Progression

The PowerShell section progressed through increasingly advanced automation:

```text
Manual AD Administration
        ↓
Single PowerShell Commands
        ↓
Reusable User Script
        ↓
Multi-Department Logic
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

## Lessons Learned

This phase of the lab demonstrated why learning the manual administration process first is useful before introducing automation.

Understanding how Active Directory users, OUs, security groups, passwords, and resource permissions work manually made it easier to understand what each PowerShell cmdlet was automating.

The project also reinforced the importance of validating input, handling errors, protecting credentials, and verifying automation results instead of assuming that a successful script message guarantees the entire workflow completed correctly.

PowerShell significantly reduces repetitive administrative work while providing a repeatable and scalable approach to Active Directory user lifecycle management.

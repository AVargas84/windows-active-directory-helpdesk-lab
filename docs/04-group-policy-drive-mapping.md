# Group Policy Drive Mapping

## Overview

This exercise demonstrates how Group Policy Preferences can automatically deploy departmental network drives based on Active Directory security-group membership.

Finance employees needed convenient access to the Finance shared folder without manually entering the UNC path each time they signed in.

The solution automatically mapped the Finance share as the F: drive for authorized Finance users while preventing users outside the department from receiving the mapping.

---

## Objective

Configure a Group Policy Preference that automatically maps the Finance departmental share to the F: drive for members of the `Finance_Users` security group.

---

## Lab Environment

| Component | Configuration |
|-----------|---------------|
| Domain Controller | DC01 |
| Client Workstation | CLIENT01 |
| Domain | adrianlab.local |
| GPO | Finance Drive Mapping |
| Network Share | \\DC01\Finance |
| Drive Letter | F: |
| Security Group | ADRIANLAB\Finance_Users |
| Authorized Test User | Mike Chen |
| Unauthorized Test User | Sarah Johnson |

---

## Group Policy Configuration

A Group Policy Object was created named:

```text
Finance Drive Mapping
```

The GPO was linked to the `adrianlab.local` domain.

The drive mapping was configured under:

```text
User Configuration
→ Preferences
→ Windows Settings
→ Drive Maps
```

This location uses **Group Policy Preferences**, which allows administrators to centrally deploy settings such as mapped network drives to domain users.

---

## Drive Mapping Configuration

The Finance mapped drive was configured with the following settings:

| Setting | Value |
|---------|-------|
| Action | Update |
| Location | \\DC01\Finance |
| Label | Finance |
| Drive Letter | F: |
| Hide/Show Drive | No change |

The **Update** action allows Group Policy to create the drive mapping when it does not exist and update the configuration when necessary.

The resulting mapping was:

```text
F: → \\DC01\Finance
```

---

## Item-Level Targeting

The Finance drive should only be presented to authorized Finance employees.

Under the **Common** tab, **Item-level targeting** was enabled.

The targeting condition was configured as:

```text
User is a member of:
ADRIANLAB\Finance_Users
```

This created the following deployment logic:

```text
User signs into CLIENT01
        |
        v
Is the user a member of Finance_Users?
        |
   +----+----+
   |         |
  Yes        No
   |         |
   v         v
Apply F:    Do not apply
mapping     F: mapping
```

This allows the GPO to be linked broadly while restricting the actual drive-mapping preference to the appropriate department.

---

## Policy Refresh

After configuring the GPO, Group Policy was manually refreshed on CLIENT01 using:

```cmd
gpupdate /force
```

This forced Windows to process the latest domain Group Policy settings.

---

## Security Group Verification

Before troubleshooting the mapped drive, the user's current security-group membership could be verified using:

```cmd
whoami /groups
```

For the authorized Finance user, the expected group was:

```text
ADRIANLAB\Finance_Users
```

This command is useful because Group Policy item-level targeting depends on the group memberships recognized in the user's current Windows security token.

---

## Verification

The configuration was tested using both an authorized Finance employee and an unauthorized HR employee.

### Authorized Finance User

Mike Chen was a member of:

```text
ADRIANLAB\Finance_Users
```

After signing into CLIENT01 and processing Group Policy, File Explorer displayed:

```text
Finance (F:)
```

The drive successfully opened:

```text
\\DC01\Finance
```

**Result: ✅ PASS**

### Unauthorized User

Sarah Johnson was not a member of:

```text
ADRIANLAB\Finance_Users
```

After Sarah signed into CLIENT01 and Group Policy was processed, the Finance F: drive did not appear.

**Result: ✅ PASS**

---

## Verification Summary

| Test | Expected Result | Actual Result |
|------|-----------------|---------------|
| Mike belongs to Finance_Users | Membership present | ✅ Pass |
| Finance GPO processes | Policy applies | ✅ Pass |
| Mike receives F: drive | F: appears | ✅ Pass |
| Mike opens Finance share | Access granted | ✅ Pass |
| Sarah receives F: drive | F: does not appear | ✅ Pass |

The positive and negative tests confirmed that the drive mapping was being deployed according to security-group membership.

---

## Group Policy vs. File Permissions

The mapped drive itself does not grant access to Finance data.

Group Policy determines whether the convenient F: drive mapping is presented to the user:

```text
Group Policy
     |
     v
F: → \\DC01\Finance
```

Actual authorization to the Finance files is controlled separately:

```text
Finance_Users
     |
     +---- SMB Share Permissions
     |
     +---- NTFS Permissions
     |
     v
Finance File Access
```

Therefore, removing or hiding a mapped drive is not a substitute for properly securing the underlying network share.

---

## Why Security-Group Targeting Was Used

The drive mapping targeted:

```text
ADRIANLAB\Finance_Users
```

rather than individual employee accounts.

This provides a scalable administration model.

When a new employee joins Finance, the administrator can add that employee to `Finance_Users`. The existing Group Policy configuration can then automatically provide the Finance drive without creating an employee-specific drive mapping.

---

## Commands Used

```cmd
gpupdate /force
whoami /groups
```

---

## Technologies Used

- Windows Server
- Active Directory Domain Services
- Group Policy Management
- Group Policy Preferences
- Active Directory Security Groups
- SMB File Sharing
- Windows 11
- Oracle VirtualBox

---

## Skills Demonstrated

- Group Policy Administration
- Group Policy Preferences
- Mapped Network Drive Deployment
- Item-Level Targeting
- Active Directory Security Groups
- Role-Based Resource Deployment
- Windows Security Tokens
- Centralized Windows Administration
- Positive and Negative Testing

---

## Screenshots

### Finance Drive Mapping Group Policy

The following screenshot shows the Group Policy Preferences configuration used to deploy the Finance F: drive to authorized Finance users.

![Finance Drive Mapping GPO](../screenshots/group-policy/finance-drive-mapping-gpo.png)

*Figure 1. Finance drive mapping configured through Group Policy Preferences.*

---

## Lessons Learned

This exercise demonstrated how Group Policy Preferences can automate resource deployment across a Windows domain.

Item-level targeting allows administrators to deploy a GPO broadly while controlling which users receive a specific preference based on security-group membership.

The exercise also reinforced an important distinction between **resource presentation and resource authorization**. Group Policy provides the F: drive mapping, while Active Directory security groups, SMB share permissions, and NTFS permissions determine whether the user can actually access the Finance data.

Using security groups for both permissions and Group Policy targeting creates a scalable model in which access can be managed primarily through Active Directory membership rather than individual workstation configuration.

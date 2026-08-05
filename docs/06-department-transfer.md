# Employee Department Transfer

## Overview

This exercise demonstrates how to update an employee's Active Directory access when the employee transfers from one department to another.

Emily Rodriguez was originally provisioned as a Finance employee. After transferring to HR, her Finance access needed to be removed and HR access granted without creating a new user account.

The exercise demonstrates how Active Directory security-group membership can be used to manage access throughout the employee lifecycle.

---

## Objective

Transfer Emily Rodriguez from Finance to HR by updating her Active Directory placement and security-group memberships, then verify that her mapped drives and file-share permissions reflect her new role.

---

## Lab Environment

| Component | Configuration |
|-----------|---------------|
| Domain Controller | DC01 |
| Client Workstation | CLIENT01 |
| Domain | adrianlab.local |
| Employee | Emily Rodriguez |
| Username | erodriguez |
| Previous Department | Finance |
| New Department | HR |
| Previous Security Group | ADRIANLAB\Finance_Users |
| New Security Group | ADRIANLAB\HR_Users |
| Finance Share | \\DC01\Finance |
| HR Share | \\DC01\HR |
| Finance Drive | F: |
| HR Drive | H: |

---

## Transfer Requirements

Emily's department transfer required several access changes.

The intended result was:

| Resource | Before Transfer | After Transfer |
|----------|-----------------|----------------|
| Finance_Users | Member | Removed |
| HR_Users | Not a member | Added |
| Finance F: drive | Available | Removed |
| HR H: drive | Unavailable | Available |
| Finance share | Access granted | Access denied |
| HR share | Access denied | Access granted |

The goal was not simply to grant HR access. Finance access also needed to be removed to maintain least privilege.

---

## Active Directory Organizational Unit Change

Emily's user account was moved from the Finance Organizational Unit to the HR Organizational Unit.

The move reflected her new departmental placement within Active Directory.

Her existing domain account remained:

```text
ADRIANLAB\erodriguez
```

A new account was not required.

This preserved the employee's identity while allowing administrative organization and access assignments to be updated.

---

## Security Group Changes

Emily's departmental security-group memberships were changed from:

```text
ADRIANLAB\Finance_Users
```

to:

```text
ADRIANLAB\HR_Users
```

The completed access change followed this model:

```text
Emily Rodriguez
        |
        +---- Remove Finance_Users
        |
        +---- Add HR_Users
```

Removing the previous departmental group was just as important as adding the new group.

If Emily remained a member of `Finance_Users`, she could retain access to Finance resources even though those resources were no longer required for her job.

---

## HR Resource Access

The HR environment was configured to use:

```text
ADRIANLAB\HR_Users
```

for departmental resource access.

Emily's new membership provided the authorization required for HR resources.

The access model was:

```text
Emily Rodriguez
        |
        v
     HR_Users
        |
   +----+------------------+
   |                       |
   v                       v
SMB + NTFS             GPO Item-Level
Permissions              Targeting
   |                       |
   v                       v
HR Share Access          HR H: Drive
```

This allowed the existing HR configuration to be reused without assigning permissions directly to Emily's account.

---

## Windows Security Token

After the Active Directory group changes were made, Emily's existing CLIENT01 login session could still contain her previous group memberships.

Windows generates a security token when a user authenticates. That token contains information such as:

- User identity
- Security-group memberships
- Security identifiers
- Authorization information

Changing group membership in Active Directory does not necessarily rebuild an already authenticated user's token.

Emily therefore signed completely out of CLIENT01 and signed back in.

This created a new Windows security token containing her updated departmental memberships.

---

## Group Membership Verification

After signing back into CLIENT01, Emily's current security groups were checked using:

```cmd
whoami /groups
```

The expected result was:

```text
ADRIANLAB\HR_Users
```

The previous Finance membership should no longer appear:

```text
ADRIANLAB\Finance_Users
```

This confirmed that the current Windows session recognized the department transfer.

---

## Group Policy Processing

Departmental drive mappings were deployed through Group Policy Preferences using security-group-based item-level targeting.

Group Policy could be refreshed using:

```cmd
gpupdate /force
```

The expected targeting logic after Emily's transfer was:

```text
Finance Drive Mapping
Finance_Users membership?
        |
        v
       No
        |
        v
Do not provide F:


HR Drive Mapping
HR_Users membership?
        |
        v
       Yes
        |
        v
Provide H:
```

This allowed the workstation configuration to adjust according to Emily's new Active Directory role.

---

## Mapped Drive Verification

File Explorer was opened on CLIENT01 after Emily signed back into the domain.

The expected departmental drive was:

```text
HR (H:)
```

The previous Finance drive:

```text
Finance (F:)
```

was no longer available.

This demonstrated that Group Policy drive deployment reflected Emily's current security-group membership.

---

## HR Share Verification

Emily opened:

```text
HR (H:)
```

which mapped to:

```text
\\DC01\HR
```

The HR share opened successfully and the departmental test file was available.

**HR Access Result: ✅ PASS**

---

## Finance Access Removal

The transfer also required verification that Emily could no longer access her previous department's data.

The Finance mapped drive was no longer presented to Emily after the updated Group Policy configuration was processed.

Direct access to the Finance share was also tested using:

```text
\\DC01\Finance
```

Because Emily was no longer a member of:

```text
ADRIANLAB\Finance_Users
```

access to the Finance share was denied.

**Finance Access Removal: ✅ PASS**

This negative test was important because successful HR access alone would not prove that the transfer had been completed securely.

---

## Verification Summary

| Test | Expected Result | Actual Result |
|------|-----------------|---------------|
| Emily moved to HR OU | HR placement | ✅ Pass |
| Finance_Users membership | Removed | ✅ Pass |
| HR_Users membership | Added | ✅ Pass |
| `whoami /groups` shows HR_Users | Present | ✅ Pass |
| `whoami /groups` shows Finance_Users | Absent | ✅ Pass |
| HR H: drive | Available | ✅ Pass |
| HR share | Access granted | ✅ Pass |
| Finance F: drive | Removed | ✅ Pass |
| Finance share | Access denied | ✅ Pass |

---

## Principle of Least Privilege

This scenario demonstrates an important part of access management:

> When an employee changes roles, obsolete access should be removed as well as new access being granted.

Simply adding Emily to `HR_Users` would have provided HR access but could have left her with unnecessary Finance permissions.

Removing `Finance_Users` reduced her permissions to the resources required for her current role.

---

## Why Security Groups Simplify Transfers

Because departmental permissions and drive mappings were assigned through security groups, the transfer did not require manually changing permissions on every individual resource.

The administrative workflow was primarily:

```text
Remove old departmental group
            |
            v
Add new departmental group
            |
            v
Refresh user authentication
            |
            v
Existing permissions and GPOs adjust access
```

This is more scalable than assigning file and workstation permissions directly to individual employees.

---

## Commands Used

```cmd
whoami /groups
gpupdate /force
net use
```

`net use` can also be used to review the network-drive connections recognized by the client workstation.

---

## Technologies Used

- Windows Server
- Active Directory Domain Services
- Active Directory Users and Computers
- Active Directory Security Groups
- Organizational Units
- Group Policy Preferences
- SMB File Sharing
- NTFS Permissions
- Windows 11
- Oracle VirtualBox

---

## Skills Demonstrated

- Active Directory User Administration
- Employee Access Lifecycle Management
- Department Transfers
- Security Group Administration
- Organizational Unit Management
- Group Policy Preferences
- Item-Level Targeting
- SMB and NTFS Permissions
- Windows Security Tokens
- Least-Privilege Access Control
- Access Revocation
- Positive and Negative Testing

---

## Screenshots

### HR Drive Verification

The following screenshot shows the HR H: drive successfully mapped on CLIENT01 after Emily's department and security-group assignments were updated.

![HR Mapped Drive](../screenshots/group-policy/hr-mapped-drive.png)

*Figure 1. HR H: drive available on CLIENT01 after the department transfer.*

### HR Shared Folder

The following screenshot shows the HR departmental share successfully opening through the mapped H: drive.

![HR Shared Folder](../screenshots/file-sharing/hr-share-files.png)

*Figure 2. HR departmental files accessible through the mapped H: drive.*

---

## Lessons Learned

This exercise demonstrated that employee access management continues throughout the user's employment lifecycle. Provisioning new access is only part of a department transfer; access associated with the employee's previous role must also be removed.

The exercise also reinforced the relationship between Active Directory security groups, Windows security tokens, Group Policy Preferences, SMB permissions, and NTFS permissions. A change made in Active Directory may require the user to establish a new login session before the updated authorization information is reflected on the workstation.

Using departmental security groups made the transfer significantly easier. Instead of modifying individual file permissions and workstation settings, the employee's group memberships were changed and the existing access-control infrastructure handled the corresponding resource changes.

Finally, testing both sides of the transfer was essential: successful access to HR resources demonstrated that the new permissions worked, while denied access to Finance resources demonstrated that obsolete permissions had been successfully revoked.

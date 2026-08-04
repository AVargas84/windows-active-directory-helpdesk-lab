# Employee Department Transfer and Access Deprovisioning

## Scenario

Emily Rodriguez transferred from the Finance department to the HR department.

Because her job responsibilities changed, IT needed to remove her previous Finance access and provide the appropriate HR resources.

The goal was to demonstrate both resource provisioning and deprovisioning using Active Directory security groups, Organizational Units, SMB and NTFS permissions, and Group Policy Preferences.

## Objective

Complete an employee department transfer by:

- Removing obsolete Finance security-group membership
- Adding the employee to the HR security group
- Moving the employee account to the appropriate Organizational Unit
- Creating and securing an HR departmental share
- Automatically mapping the HR network drive
- Removing the obsolete Finance drive
- Verifying that Finance access was completely revoked
- Confirming that HR access was successfully granted

## Employee Information

The employee being transferred was:

```text
Name: Emily Rodriguez
Username: erodriguez
Previous Department: Finance
New Department: HR
Domain: ADRIANLAB
```

Before the transfer, Emily was a member of:

```text
ADRIANLAB\Finance_Users
```

and received the Finance mapped drive:

```text
F: → \\DC01\Finance
```

## HR Security Group

The following Active Directory security group already existed:

```text
ADRIANLAB\HR_Users
```

This group was used to control access to HR resources.

## HR Shared Folder Creation

A new departmental folder was created on DC01:

```text
C:\Shares\HR
```

A test file was created inside the folder:

```text
HR-Test.txt
```

The folder was then published as an SMB network share:

```text
\\DC01\HR
```

## HR Share Permissions

The default broad `Everyone` permission was removed from the HR share.

The following Active Directory security group was added:

```text
ADRIANLAB\HR_Users
```

The group received:

```text
Change
Read
```

Full Control was not granted.

This allowed HR employees to work with departmental files without giving them unnecessary administrative control over the share.

## HR NTFS Permissions

The HR folder was configured with NTFS permissions for:

```text
ADRIANLAB\HR_Users
```

The group received:

```text
Modify
Read & execute
List folder contents
Read
Write
```

Inheritance was disabled and inherited permissions were converted into explicit permissions.

The broad:

```text
Users (ADRIANLAB\Users)
```

entries were removed.

Administrative and system entries were retained, including:

```text
Administrators
SYSTEM
CREATOR OWNER
HR_Users
```

## HR Permission Model

The final HR permission structure was:

```text
Share permissions:
HR_Users → Change + Read

NTFS permissions:
HR_Users → Modify
```

This followed the same least-privilege model previously implemented for the Finance department.

## Active Directory Department Transfer

Emily's Active Directory account was updated to reflect her new job assignment.

The following changes were made:

```text
Removed from: Finance_Users
Added to: HR_Users
```

Her account was also moved from the Finance Organizational Unit to the HR Organizational Unit.

The final Active Directory configuration was:

```text
Emily Rodriguez
        ↓
HR OU
        ↓
Member of HR_Users
        ↓
Not a member of Finance_Users
```

## Organizational Units vs. Security Groups

The department transfer demonstrated an important difference between Organizational Units and security groups.

The HR Organizational Unit was used to organize Emily's Active Directory account and could be used to determine which OU-linked policies apply.

The `HR_Users` security group was used to grant access to departmental resources.

Moving Emily into the HR OU by itself did not provide access to the HR share.

Her membership in:

```text
ADRIANLAB\HR_Users
```

provided the authorization required for the HR resources.

## HR Drive Mapping Group Policy

A new Group Policy Object was created:

```text
HR Drive Mapping
```

The drive mapping was configured under:

```text
User Configuration
→ Preferences
→ Windows Settings
→ Drive Maps
```

The mapped drive was configured as:

```text
Action: Update
Location: \\DC01\HR
Label: HR
Drive Letter: H:
```

## HR Item-Level Targeting

The HR drive needed to apply only to authorized HR employees.

Item-level targeting was enabled under the Common tab.

The targeting condition was:

```text
The user is a member of:
ADRIANLAB\HR_Users
```

This created the following deployment model:

```text
HR_Users
    ↓
Item-level targeting
    ↓
HR Drive Mapping GPO
    ↓
H: → \\DC01\HR
```

## Initial Transfer Verification

Emily completely signed out of CLIENT01 and signed back in after the security-group changes.

A full sign-out was important because Windows needed to create a new security token containing the updated group memberships.

The following command was used:

```cmd
whoami /groups
```

The results confirmed:

```text
ADRIANLAB\HR_Users       → Present
ADRIANLAB\Finance_Users  → Not Present
```

This verified that Emily's current authentication session recognized her new department membership.

## Group Policy Refresh

The following command was used to refresh Group Policy:

```cmd
gpupdate /force
```

After the policy refresh, File Explorer was opened to:

```text
This PC
```

The new HR drive appeared:

```text
HR (H:)
```

The drive mapped to:

```text
\\DC01\HR
```

Emily successfully opened the HR share and accessed the HR files.

## HR File Access Test

Emily verified her Modify-level access by creating:

```text
Emily-HR-Test.txt
```

inside the HR shared folder.

The file was successfully saved.

**Result: PASS**

## Finance Access Removal Test

After the department transfer, Emily was no longer a member of:

```text
ADRIANLAB\Finance_Users
```

However, the old Finance F: drive was still displayed on CLIENT01.

The drive was disabled or inaccessible, but the stale mapping remained visible.

This demonstrated that removing authorization to a resource and removing a mapped-drive object are separate processes.

## Troubleshooting the Stale Finance Drive

The following command was used to inspect Emily's active network-drive mappings:

```cmd
net use
```

The Finance drive still appeared as:

```text
F: → \\DC01\Finance
```

The following command was also used to inspect the Group Policy Objects being processed for Emily:

```cmd
gpresult /r
```

Both the Finance and HR Drive Mapping GPOs appeared in the Group Policy results.

This was expected because the GPOs were linked to the domain.

Item-level targeting determined whether the individual drive-mapping preference applied to the user.

## Automatic Drive Cleanup Configuration

The Finance Drive Mapping GPO was edited.

Under the Common tab, the following option was enabled:

```text
Remove this item when it is no longer applied
```

The existing item-level targeting condition remained:

```text
ADRIANLAB\Finance_Users
```

The HR Drive Mapping GPO was also configured with:

```text
Remove this item when it is no longer applied
```

while retaining its targeting condition:

```text
ADRIANLAB\HR_Users
```

This configuration was intended to support both resource provisioning and resource removal.

The desired behavior was:

```text
Join Finance_Users
        ↓
F: appears

Leave Finance_Users
        ↓
F: removed
```

and:

```text
Join HR_Users
        ↓
H: appears

Leave HR_Users
        ↓
H: removed
```

## Existing Stale Mapping

The existing F: mapping had been created before the automatic removal behavior was configured.

Because the stale mapping remained, it was manually removed from Emily's workstation using:

```cmd
net use F: /delete
```

Windows confirmed that the F: mapping was deleted successfully.

The current network mappings were then checked again using:

```cmd
net use
```

The Finance F: mapping was no longer present.

## Final Group Policy Refresh

Group Policy was refreshed again using:

```cmd
gpupdate /force
```

Emily then completely signed out and signed back into CLIENT01.

This provided a clean test of the final access configuration.

## Final Drive Verification

File Explorer was opened to:

```text
This PC
```

The final drive state was:

```text
HR (H:)       → Present
Finance (F:)  → Gone
```

The HR drive remained accessible.

**HR Drive Result: PASS**

**Finance Drive Removal Result: PASS**

## Direct Finance Access Test

Removing the F: drive only removed the convenient mapped-drive representation.

A separate test was performed to verify that Emily's actual authorization to Finance data had also been revoked.

The following UNC path was manually entered:

```text
\\DC01\Finance
```

Windows denied Emily access to the Finance share.

**Result: PASS**

This confirmed that removing Emily from:

```text
Finance_Users
```

had revoked her actual Finance permissions.

## Mapped Drive vs. Authorization

This task demonstrated an important security distinction.

A mapped drive is primarily a convenient way to present a network resource to a user.

For example:

```text
F: → \\DC01\Finance
```

Removing F: from File Explorer does not by itself secure the Finance folder.

The actual authorization was controlled by:

```text
Active Directory security-group membership
        ↓
SMB share permissions
        ↓
NTFS permissions
```

Therefore:

```text
Removing F:
```

cleaned up the user's interface, while:

```text
Removing Emily from Finance_Users
```

actually revoked access to Finance data.

## Deprovisioning

The department transfer demonstrated deprovisioning.

When an employee changes jobs, IT should remove permissions that are no longer required rather than simply adding new access.

Emily's transfer required both:

```text
Provision new HR access
```

and:

```text
Remove obsolete Finance access
```

This supports the principle of least privilege by ensuring employees retain only the access required for their current responsibilities.

## Troubleshooting Commands Used

The following commands were used during the transfer and troubleshooting process:

```cmd
whoami /groups
gpupdate /force
gpresult /r
net use
net use F: /delete
```

## Final Verification Summary

The completed department transfer was verified as follows:

```text
Emily moved to HR OU: PASS
HR_Users membership: PASS
Finance_Users membership removed: PASS
HR H: drive mapped: PASS
HR share accessible: PASS
HR file creation: PASS
Finance F: drive removed: PASS
Direct Finance UNC access denied: PASS
```

## Security Concepts

This task demonstrated:

- Least privilege
- Role-based access control
- Access provisioning
- Access deprovisioning
- Security-group-based authorization
- Organizational Unit management
- Separation of mapped drives and resource permissions
- Positive and negative access testing
- Authentication security tokens
- Centralized Group Policy administration

## Troubleshooting Methodology

The troubleshooting process followed a layered approach:

```text
Verify group membership
        ↓
Verify new resource access
        ↓
Identify stale resource
        ↓
Inspect network mappings
        ↓
Inspect Group Policy processing
        ↓
Correct drive cleanup configuration
        ↓
Remove existing stale mapping
        ↓
Refresh policy
        ↓
Verify new access
        ↓
Verify old access is denied
```

## Ticket Resolution

Emily Rodriguez was successfully transferred from Finance to HR.

Her Active Directory Organizational Unit and security-group memberships were updated, the HR departmental share and mapped drive were provisioned, and her previous Finance permissions were revoked.

A stale Finance drive mapping was identified using `net use` and Group Policy was inspected using `gpresult /r`.

The drive-mapping policies were updated to remove mappings when they no longer apply, and the existing stale Finance mapping was removed.

Final testing confirmed that Emily could access HR resources while direct access to the Finance share was denied.

## Concepts Practiced

- Active Directory user administration
- Organizational Units
- Active Directory security groups
- Employee department transfers
- Role-based access control
- SMB share permissions
- NTFS permissions
- Group Policy Management
- Group Policy Preferences
- Drive Maps
- Item-level targeting
- Mapped network drives
- Access provisioning
- Access deprovisioning
- Windows security tokens
- `whoami /groups`
- `gpupdate /force`
- `gpresult /r`
- `net use`
- UNC paths
- Least privilege
- Troubleshooting
- Positive and negative verification

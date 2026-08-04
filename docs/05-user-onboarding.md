# New Employee Onboarding

## Scenario

A new employee, Emily Rodriguez, joined the Finance department and needed an Active Directory account with access to the same departmental resources as existing Finance employees.

The goal was to provision the employee using the existing Active Directory security-group structure instead of assigning permissions directly to the individual user.

## Objective

Create a new Active Directory user account, configure first-login password requirements, assign the appropriate departmental security group, and verify that existing permissions and Group Policy automatically provide the required Finance resources.

## New Employee Information

The following user account was created:

```text
Name: Emily Rodriguez
Username: erodriguez
Department: Finance
Domain: ADRIANLAB
```

The account was created inside the Finance Organizational Unit in Active Directory.

## Active Directory Account Creation

The account was created using:

```text
Active Directory Users and Computers
→ Finance OU
→ New
→ User
```

The user logon name was configured as:

```text
erodriguez
```

The domain account could be used to authenticate as:

```text
ADRIANLAB\erodriguez
```

## Initial Password Configuration

A temporary password was assigned during account creation.

The following option was enabled:

```text
User must change password at next logon
```

The following options remained disabled:

```text
User cannot change password
Password never expires
Account is disabled
```

This required the employee to replace the temporary password during the first successful domain login.

## Finance Security Group

The new employee needed the same departmental access as other Finance employees.

Emily was added to:

```text
ADRIANLAB\Finance_Users
```

The group membership was configured through:

```text
Emily Rodriguez
→ Properties
→ Member Of
→ Add
→ Finance_Users
```

Using a security group allowed the existing Finance permissions and Group Policy configuration to provide resources automatically.

No direct permissions were assigned to Emily's individual account.

## Client Login

Emily signed into the domain-joined CLIENT01 workstation using:

```text
ADRIANLAB\erodriguez
```

During the first login, Windows required the temporary password to be changed.

After authentication, the logged-in identity was verified using:

```cmd
whoami
```

The expected identity was:

```text
adrianlab\erodriguez
```

## Group Membership Verification

The following command was used to inspect the security groups contained in Emily's current Windows security token:

```cmd
whoami /groups
```

The expected Finance group was:

```text
ADRIANLAB\Finance_Users
```

## Troubleshooting

During the initial test, `Finance_Users` did not appear in the output of:

```cmd
whoami /groups
```

Because the required security group was missing, troubleshooting focused on Active Directory group membership rather than immediately changing the Finance share, NTFS permissions, or Group Policy.

Emily's account was checked in:

```text
Active Directory Users and Computers
→ Emily Rodriguez
→ Properties
→ Member Of
```

The issue was traced to the Finance group membership/current authentication state.

The appropriate membership was corrected so that Emily belonged to:

```text
ADRIANLAB\Finance_Users
```

Emily then completely signed out of CLIENT01 and signed back in.

A new login session was important because Windows creates a security token during authentication that contains the user's security-group memberships.

## Troubleshooting Verification

After signing back in, the following command was run again:

```cmd
whoami /groups
```

This time the output contained:

```text
ADRIANLAB\Finance_Users
```

This confirmed that Emily's current Windows session recognized the correct Finance group membership.

## Automatic Resource Provisioning

The Finance infrastructure had already been configured during previous tasks.

The existing configuration included:

```text
Finance_Users
        ↓
SMB and NTFS permissions
        ↓
Access to \\DC01\Finance
```

The Finance Drive Mapping Group Policy also used:

```text
Finance_Users
        ↓
Item-level targeting
        ↓
F: → \\DC01\Finance
```

Because Emily was added to `Finance_Users`, no additional Finance folder permissions or employee-specific drive mapping needed to be created.

## Group Policy Refresh

If necessary, Group Policy could be manually refreshed using:

```cmd
gpupdate /force
```

This forces Windows to process the latest user and computer Group Policy settings.

## Finance Drive Verification

After Emily had the correct group membership, File Explorer was opened to:

```text
This PC
```

The Finance drive appeared as:

```text
Finance (F:)
```

The drive mapped to:

```text
\\DC01\Finance
```

Emily successfully opened the Finance drive and accessed the existing departmental files.

## File Access Test

Emily verified that she had Modify-level access to the Finance share by creating:

```text
Emily-Test.txt
```

The file was successfully saved inside the Finance shared folder.

This confirmed that Emily had both:

- Access to the Finance share
- Permission to create and modify files

**Result: PASS**

## Provisioning Model

The onboarding process demonstrated the following access model:

```text
Emily Rodriguez
        ↓
Finance_Users
        ↓
 ┌──────────────────────────┐
 ↓                          ↓
SMB/NTFS permissions        GPO item-level targeting
 ↓                          ↓
Finance folder access       Finance F: drive
```

The employee received departmental resources primarily because of the assigned security-group membership.

## Why Group-Based Access Was Used

Permissions were not assigned directly to:

```text
erodriguez
```

Instead, access was assigned to:

```text
Finance_Users
```

This makes administration more scalable.

When another employee joins Finance, IT can add the employee to the same security group rather than modifying the Finance folder permissions and Group Policy for every individual user.

## Security Token Concept

Windows creates a security token when a user authenticates.

The token contains information such as:

- User identity
- Security-group memberships
- Security identifiers
- Authorization information

This explains why signing completely out and back in may be required after changing a user's Active Directory security-group membership.

The command:

```cmd
whoami /groups
```

was used to verify which group memberships Windows recognized in the current session.

## Security Concepts

This task demonstrated:

- Role-based access control
- Security-group-based provisioning
- Least privilege
- Centralized identity management
- First-login password security
- Separation of users and permissions
- Verification of user authorization

## Commands Used

```cmd
whoami
whoami /groups
gpupdate /force
```

## Verification Summary

The completed onboarding was verified as follows:

```text
Domain account created: PASS
Temporary password configured: PASS
Password change at first login: PASS
Finance_Users membership: PASS
Domain authentication: PASS
Finance F: drive mapping: PASS
Finance share access: PASS
File creation test: PASS
```

## Ticket Resolution

The new Finance employee was successfully provisioned with an Active Directory domain account and assigned to the appropriate Finance security group.

Existing SMB permissions, NTFS permissions, and Group Policy Preferences automatically provided the employee with the required departmental resources.

A missing group-membership issue encountered during testing was identified using `whoami /groups`, corrected in Active Directory, and verified after establishing a fresh login session.

## Concepts Practiced

- Active Directory user creation
- Organizational Units
- User account administration
- Temporary passwords
- First-login password changes
- Active Directory security groups
- Role-based access control
- Windows security tokens
- `whoami`
- `whoami /groups`
- `gpupdate /force`
- Group Policy Preferences
- Mapped network drives
- SMB and NTFS permissions
- Employee onboarding
- Resource provisioning
- Troubleshooting
- Verification after remediation

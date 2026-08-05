# Secure Department File Share

## Scenario

The Finance department needed a shared network folder that Finance employees could modify while users outside Finance were denied access.

## Objective

Create and secure an SMB network share for the Finance department using Active Directory security groups, share permissions, and NTFS permissions.

## Share Configuration

The Finance folder was created on DC01 at:

C:\Shares\Finance

The folder was published as the following network share:

\\DC01\Finance

## Share Permissions

The default `Everyone` permission was removed.

The following Active Directory security group was added:

ADRIANLAB\Finance_Users

The group received:

- Change
- Read

Full Control was not granted.

## NTFS Permissions

The Finance folder was configured so that:

ADRIANLAB\Finance_Users

received the following NTFS permissions:

- Modify
- Read & execute
- List folder contents
- Read
- Write

Inheritance was disabled and the inherited permissions were converted into explicit permissions.

The broad `ADRIANLAB\Users` entries were removed.

Administrative and system entries such as the following were retained:

- SYSTEM
- Administrators
- CREATOR OWNER

## Troubleshooting

The first network access attempt failed even though the NTFS permissions appeared to be configured correctly.

The following commands were used during troubleshooting:

```cmd
net view \\10.0.2.10
whoami /groups
```

```markdown
`net view` confirmed that CLIENT01 could communicate with DC01 and that SMB services were responding.

`whoami /groups` confirmed that the Finance user was a member of:

ADRIANLAB\Finance_Users

Further investigation showed that the Finance folder had the appropriate NTFS permissions but had not actually been published as an SMB share.

The issue was resolved by enabling Advanced Sharing for the Finance folder and configuring the appropriate share permissions.

## Verification

Access was tested using both an authorized and unauthorized user.

### Finance User Test

Mike Chen, a member of `Finance_Users`, successfully:

- Opened `\\DC01\Finance`
- Opened `Finance-Test.txt`
- Created `Mike-Test.txt`
- Saved changes to the Finance share

Result: PASS

### Unauthorized User Test

Sarah Johnson, an HR user who was not a member of `Finance_Users`, attempted to access:

\\DC01\Finance

Windows denied access.

Result: PASS

## Share Permissions vs. NTFS Permissions

The Finance share uses two permission layers.

Share permissions:

Finance_Users → Change + Read

NTFS permissions:

Finance_Users → Modify

When a user accesses the folder over the network, Windows evaluates both permission layers.

This configuration allows Finance employees to create, modify, and delete files without granting them Full Control over the folder.

## Security Group-Based Access

Permissions were assigned to the `Finance_Users` security group rather than directly to individual employees.

This makes access easier to administer because new Finance employees can receive the appropriate permissions simply by being added to the Finance security group.

## Security Concepts

This task demonstrated:

- Least privilege
- Role-based access control
- Security-group-based permissions
- Separation of SMB and NTFS permissions
- Positive access testing
- Negative access testing

## Concepts Practiced

- SMB file sharing
- NTFS permissions
- Share permissions
- Active Directory security groups
- Permission inheritance
- Advanced Sharing
- Least privilege
- `net view`
- `whoami /groups`
- Access-control troubleshooting
- Positive and negative verification

## Screenshots

### Finance Users and Security Group

The following screenshot shows the Active Directory users and security-group structure used to manage Finance department access.

![Finance Users and Security Group](../screenshots/active-directory/finance-users-group.png)

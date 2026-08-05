# Group Policy Drive Mapping

## Scenario

Finance employees needed automatic access to the Finance department shared folder without manually entering the network path each time they logged in.

The goal was to automatically map the Finance share as the F: drive for Finance employees while preventing users outside the Finance department from receiving the drive mapping.

## Objective

Use Group Policy Preferences and Active Directory security-group membership to automatically deploy a mapped network drive to authorized Finance users.

## Existing Finance Resource

The Finance department share was already available at:

\\DC01\Finance

Access to the share was controlled through the Active Directory security group:

ADRIANLAB\Finance_Users

## Group Policy Configuration

A new Group Policy Object was created:

Finance Drive Mapping

The GPO was linked to the `adrianlab.local` domain.

The drive mapping was configured under:

User Configuration  
→ Preferenes  
→ Windows Settings  
→ Drive Maps

## Drive Mapping Configuration

A new mapped drive was configured with the following settings:

Action: Update

Location:

\\DC01\Finance

Label:

Finance

Drive Letter:

F:

The Update action was used so that Group Policy could create the mapping when it was missing and update the existing configuration when necessary.

## Item-Level Targeting

The drive mapping needed to apply only to Finance employees.

Under the Common tab, Item-level targeting was enabled.

The targeting condition was configured as:

User is a member of:

ADRIANLAB\Finance_Users

This allowed the GPO to be linked broadly while restricting the Finance drive mapping to users who were members of the Finance security group.

## Policy Refresh

Group Policy was manually refreshed from CLIENT01 using:

```cmd
gpupdate /force
```
## Finance User Verification

Mike Chen was used as the authorized Finance user.

After signing into CLIENT01, the following command was used to verify group membership:
whoami /groups

Mike's security token contained:

ADRIANLAB\Finance_Users

File Explorer was then opened to:

This PC

The following mapped drive appeared automatically:

Finance (F:)

The F: drive successfully opened the Finance department share.

Result: PASS

## Unauthorized User Verification

Sarah Johnson was used as the negative test.

Sarah was not a member of:

ADRIANLAB\Finance_Users

After Sarah signed into CLIENT01 and Group Policy was processed, the Finance F: drive did not appear.

Result: PASS

## How the Configuration Works

The configuration follows this access path:

Finance employee
→ Member of Finance_Users
→ Item-level targeting condition matches
→ Finance Drive Mapping preference applies
→ F: maps to \\DC01\Finance

A user outside Finance follows a different path:

Non-Finance employee
→ Not a member of Finance_Users
→ Item-level targeting condition does not match
→ Finance drive mapping is not applied
## Group Policy vs. File Permissions

The mapped drive does not provide the actual authorization to Finance data.

Group Policy determines whether the convenient F: drive mapping is presented to the user.

Access to the files themselves is controlled separately through SMB share permissions and NTFS permissions assigned to Finance_Users.

This means that hiding or removing a mapped drive is not a substitute for properly securing the underlying shared folder.
## Security Concepts
This task demonstrated:

Role-based resource deployment
Security-group-based targeting
Least privilege
Separation of resource presentation and resource authorization
Centralized Windows configuration
Positive and negative access testing

## Concepts Practiced
Group Policy Management
Group Policy Objects
Group Policy Preferences
User Configuration
Drive Maps
Mapped network drives
Item-level targeting
Active Directory security groups
gpupdate /force
whoami /groups
Centralized resource deployment
Positive and negative testing

## Screenshots

### Finance Drive Mapping Group Policy

The following screenshot shows the Group Policy Preferences configuration used to deploy the Finance F: drive to authorized Finance users.

![Finance Drive Mapping GPO](../screenshots/group-policy/finance-drive-mapping-gpo.png)

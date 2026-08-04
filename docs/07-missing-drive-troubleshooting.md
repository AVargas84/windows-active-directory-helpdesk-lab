# Missing Department Drive Troubleshooting

## Scenario

Sarah Johnson, an employee in the HR department, reported that her HR network drive was no longer available.

The user reported:

> "My HR drive was working yesterday, but today it's missing. I need access to my department files."

The expected HR resource was:

```text
H: → \\DC01\HR
```

The HR drive had previously worked correctly, so the goal was to troubleshoot the problem systematically rather than immediately recreating the drive mapping or changing permissions.

## Objective

Diagnose and resolve a missing departmental network drive by:

- Verifying the user's current security-group memberships
- Checking existing network-drive mappings
- Identifying whether the issue involved Active Directory, Group Policy, networking, or permissions
- Correcting only the affected component
- Refreshing the user's authentication session
- Verifying that the original problem was resolved

## User Information

The affected user was:

```text
Name: Sarah Johnson
Department: HR
Computer: CLIENT01
Domain: ADRIANLAB
```

Sarah was expected to be a member of:

```text
ADRIANLAB\HR_Users
```

Members of this group were expected to receive:

```text
H: → \\DC01\HR
```

through Group Policy Preferences.

## Expected Access Model

The existing HR configuration followed this model:

```text
Sarah Johnson
        ↓
HR_Users
        ↓
 ┌────────────────────────────┐
 ↓                            ↓
SMB/NTFS authorization        GPO item-level targeting
 ↓                            ↓
Access to \\DC01\HR           H: drive mapping
```

Because both resource authorization and drive deployment depended on `HR_Users`, group membership was an important troubleshooting point.

## Known-Good Baseline

Before the troubleshooting scenario was introduced, Sarah's HR access was verified.

Sarah successfully:

```text
Logged into CLIENT01
Was recognized as a member of HR_Users
Received the H: drive
Opened HR-Test.txt
```

This established that the HR infrastructure, share, permissions, and Group Policy configuration were working before the incident.

## Initial Troubleshooting Decision

The first troubleshooting commands selected were:

```cmd
whoami /groups
net use
```

These commands were chosen because they answer two different questions.

`whoami /groups` determines which Active Directory security groups are recognized in the user's current Windows security token.

`net use` displays the user's current network-drive mappings and their connection status.

This allowed the investigation to begin with the user's current authorization and mapped-drive state rather than immediately changing server configuration.

## Security Group Investigation

The following command was run on CLIENT01 while logged in as Sarah:

```cmd
whoami /groups
```

The expected group was:

```text
ADRIANLAB\HR_Users
```

After the user's authentication session was refreshed, `HR_Users` was missing from the output.

This was a major troubleshooting clue.

Because the required HR security group was absent from Sarah's current security token, the investigation shifted toward Active Directory group membership.

## Why the Missing Group Was Important

The HR environment used `HR_Users` for two purposes.

First, the group was used for authorization to the HR shared folder.

Second, the HR Drive Mapping Group Policy used item-level targeting based on membership in the same group.

The configuration was:

```text
HR_Users
    ↓
SMB/NTFS permissions
    ↓
HR folder access
```

and:

```text
HR_Users
    ↓
GPO item-level targeting
    ↓
H: drive mapping
```

Therefore, a missing `HR_Users` membership could affect both the user's actual HR permissions and the automatic H: drive mapping.

## Active Directory Investigation

Because `whoami /groups` showed that the required security group was missing, Sarah's account was investigated on DC01.

The following location was checked:

```text
Active Directory Users and Computers
→ Sarah Johnson
→ Properties
→ Member Of
```

The investigation confirmed that Sarah was not currently a member of:

```text
HR_Users
```

## Root Cause

The root cause of the incident was:

```text
Sarah Johnson was missing membership in the HR_Users Active Directory security group.
```

Because the environment used security-group-based access control, losing this membership prevented Sarah from receiving the expected HR resources.

The problem was not caused by:

```text
DNS
Network connectivity
The HR SMB share
NTFS permissions
The HR Drive Mapping GPO configuration
CLIENT01 network settings
```

The troubleshooting evidence pointed directly to the user's Active Directory authorization.

## Resolution

Sarah's account was repaired through:

```text
Active Directory Users and Computers
→ Sarah Johnson
→ Properties
→ Member Of
→ Add
```

The following group was entered:

```text
HR_Users
```

The group name was validated using:

```text
Check Names
```

After the name resolved successfully, the membership change was applied.

Sarah was once again a member of:

```text
ADRIANLAB\HR_Users
```

## Security Token Refresh

Changing Active Directory group membership does not necessarily update an already authenticated Windows session immediately.

Windows creates a security token when a user authenticates.

The token contains information such as:

```text
User identity
Security-group memberships
Security identifiers
Authorization information
```

Because Sarah's group membership had changed, she completely signed out of CLIENT01 and signed back in.

This caused Windows to generate a fresh security token containing the restored `HR_Users` membership.

## Group Membership Verification

After Sarah signed back into CLIENT01, the following command was run again:

```cmd
whoami /groups
```

The output now contained:

```text
ADRIANLAB\HR_Users
```

**Group Membership Result: PASS**

This confirmed that Sarah's current Windows session recognized the corrected Active Directory membership.

## Drive Mapping Verification

File Explorer was opened to:

```text
This PC
```

The HR mapped drive returned:

```text
HR (H:)
```

The drive pointed to:

```text
\\DC01\HR
```

**Drive Mapping Result: PASS**

## File Access Verification

Sarah opened the H: drive and successfully accessed:

```text
HR-Test.txt
```

This confirmed that the repair restored actual access to the HR departmental resource.

**File Access Result: PASS**

## Troubleshooting Sequence

The incident was resolved using the following process:

```text
User reports missing H: drive
        ↓
Check current group membership
        ↓
whoami /groups
        ↓
HR_Users missing
        ↓
Check Active Directory account
        ↓
HR_Users membership missing
        ↓
Restore group membership
        ↓
Sign user out and back in
        ↓
Generate fresh security token
        ↓
Verify HR_Users membership
        ↓
Verify H: drive
        ↓
Verify HR file access
```

## Troubleshooting Methodology

This ticket followed the troubleshooting model:

```text
Identify
    ↓
Test
    ↓
Isolate
    ↓
Correct
    ↓
Verify
```

### Identify

The user's reported symptom was a missing HR mapped drive.

### Test

The user's current security groups and network-drive state were investigated.

### Isolate

`whoami /groups` showed that the required `HR_Users` group was missing.

Active Directory Users and Computers confirmed that the user's account was missing the required group membership.

### Correct

Sarah was added back to `HR_Users`.

### Verify

Sarah signed out and back in.

The group membership returned, the H: drive appeared, and `HR-Test.txt` opened successfully.

## Why Unrelated Settings Were Not Changed

The troubleshooting process avoided immediately modifying:

```text
The HR GPO
The H: drive configuration
NTFS permissions
SMB share permissions
DNS
CLIENT01 networking
DC01 networking
```

Changing several components simultaneously could have made it difficult to determine which change actually resolved the incident.

Instead, troubleshooting followed the available evidence and corrected only the component that was actually misconfigured.

## Group Policy and Authorization

This incident also demonstrated the difference between Group Policy deployment and resource authorization.

The HR Drive Mapping GPO used:

```text
ADRIANLAB\HR_Users
```

for item-level targeting.

The HR folder permissions also relied on:

```text
ADRIANLAB\HR_Users
```

Therefore, the same Active Directory security group supported two different functions:

```text
HR_Users
    ↓
GPO targeting
    ↓
H: appears
```

and:

```text
HR_Users
    ↓
SMB + NTFS permissions
    ↓
HR data is accessible
```

The mapped drive itself did not create authorization.

The security group and underlying file permissions controlled access to the HR data.

## Commands Used

The primary troubleshooting commands used during this incident were:

```cmd
whoami /groups
net use
```

Group Policy could also be manually refreshed when necessary using:

```cmd
gpupdate /force
```

## Verification Summary

The completed repair was verified as follows:

```text
Sarah authenticated to ADRIANLAB: PASS
HR_Users membership restored: PASS
HR_Users visible in whoami /groups: PASS
H: drive returned: PASS
HR share accessible: PASS
HR-Test.txt accessible: PASS
```

## Root Cause Summary

```text
Problem:
HR mapped drive unavailable

Root Cause:
User missing from HR_Users security group

Resolution:
Restored HR_Users membership

Session Requirement:
User signed out and back in to obtain a fresh security token

Verification:
HR_Users returned, H: mapped, and HR files were accessible
```

## Security Concepts

This task demonstrated:

- Role-based access control
- Active Directory security groups
- Security-group-based authorization
- Windows security tokens
- Least privilege
- Group Policy item-level targeting
- Positive access verification
- Root-cause troubleshooting

## Help Desk Skills Demonstrated

This incident required:

- Gathering information from the user's workstation
- Selecting appropriate diagnostic commands
- Interpreting command output
- Isolating the failing layer
- Investigating Active Directory
- Correcting account authorization
- Refreshing the authentication session
- Verifying the user's original problem was resolved
- Avoiding unnecessary configuration changes

## Ticket Resolution

Sarah Johnson's missing HR network drive was traced to missing membership in the `HR_Users` Active Directory security group.

The problem was identified using `whoami /groups`, confirmed in Active Directory Users and Computers, and corrected by restoring Sarah's `HR_Users` membership.

Sarah then signed out and back into CLIENT01 to obtain a fresh security token.

Final testing confirmed that `HR_Users` was recognized by the workstation, the H: drive returned, and Sarah successfully accessed `HR-Test.txt`.

## Concepts Practiced

- Active Directory Users and Computers
- Active Directory security groups
- Group membership troubleshooting
- Windows security tokens
- `whoami /groups`
- `net use`
- `gpupdate /force`
- Group Policy Preferences
- Item-level targeting
- Mapped network drives
- Role-based access control
- Help Desk troubleshooting
- Root-cause analysis
- Authentication troubleshooting
- Verification after remediation

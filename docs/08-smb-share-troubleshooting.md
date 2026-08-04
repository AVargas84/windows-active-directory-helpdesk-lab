# SMB Share and Disconnected Drive Troubleshooting

## Scenario

Sarah Johnson, an employee in the HR department, reported that her HR mapped drive was unavailable.

The user reported:

> "My H: drive disappeared again. I restarted my computer, but I still can't access the HR folder."

Sarah's Active Directory group membership had already been repaired during a previous incident, so the troubleshooting process did not assume that the same problem had occurred again.

The expected HR resource was:

```text
H: → \\DC01\HR
```

The goal was to determine whether the failure involved the user's account, Group Policy, DNS, network connectivity, the mapped drive, the SMB share, or file permissions.

## Objective

Diagnose and resolve an unavailable departmental network drive by:

- Checking the current network-drive status
- Testing connectivity to the domain controller
- Verifying DNS name resolution
- Checking the SMB shares published by the server
- Isolating the failure to the appropriate infrastructure layer
- Restoring the affected service
- Verifying the repair from the user's workstation

## User Information

The affected user was:

```text
Name: Sarah Johnson
Department: HR
Computer: CLIENT01
Domain: ADRIANLAB
```

Sarah was already expected to have the correct HR authorization through:

```text
ADRIANLAB\HR_Users
```

The HR drive was expected to map as:

```text
H: → \\DC01\HR
```

## Existing HR Infrastructure

The HR environment had already been configured with:

```text
HR_Users
    ↓
SMB + NTFS permissions
    ↓
\\DC01\HR
```

and:

```text
HR_Users
    ↓
Group Policy item-level targeting
    ↓
H: → \\DC01\HR
```

Because the environment had previously worked, troubleshooting focused on identifying which layer had failed.

## Troubleshooting Strategy

Rather than running every available command at once, the investigation was performed one step at a time.

Each result was used to determine the next troubleshooting action.

The investigation followed this general path:

```text
Mapped drive
    ↓
Network connectivity
    ↓
DNS resolution
    ↓
SMB service/share
    ↓
Share permissions
    ↓
NTFS permissions
```

This made it possible to isolate the failure without unnecessarily changing unrelated settings.

## Step 1 - Check the Network Drive

The first troubleshooting command selected was:

```cmd
net use
```

This command displays the user's current network connections and mapped drives.

The result for the HR drive was:

```text
Disconnected   H:   \\DC01\HR   Microsoft Windows Network
```

This was an important clue.

Windows still knew that H: should point to:

```text
\\DC01\HR
```

but the workstation could not currently connect to the resource.

## Interpretation of the Disconnected Drive

Because the H: mapping still existed, the investigation did not immediately recreate the Group Policy drive mapping.

The result suggested:

```text
Drive mapping exists
        ↓
Network resource cannot currently be reached
```

The next question was whether CLIENT01 could communicate with DC01 at all.

## Step 2 - Test Connectivity to DC01

The following command was run:

```cmd
ping DC01
```

The hostname successfully resolved to:

```text
dc01.adrianlab.local
```

with the IPv4 address:

```text
10.0.2.10
```

The ping results were:

```text
Packets: Sent = 4
Received = 4
Lost = 0
0% packet loss
```

The replies were received in less than 1 millisecond.

**Connectivity Result: PASS**

## DNS Verification

The successful command:

```cmd
ping DC01
```

also demonstrated that CLIENT01 could resolve the hostname `DC01` to the correct IP address.

The expected server address was:

```text
10.0.2.10
```

Because name resolution succeeded, basic DNS functionality between CLIENT01 and DC01 was working.

**DNS Result: PASS**

## Troubleshooting Decision

At this stage, the evidence showed:

```text
H: mapping exists
        ↓
H: is disconnected
        ↓
CLIENT01 can reach DC01
        ↓
DC01 hostname resolves correctly
```

This reduced the likelihood that the problem involved:

```text
Basic network connectivity
DNS resolution
Incorrect server IP address
Missing H: drive configuration
```

The next step was to determine whether DC01 was actually publishing the HR network share.

## Step 3 - Check Published SMB Shares

The following command was selected:

```cmd
net view \\DC01
```

This command requested a list of the shared resources currently published by DC01.

DC01 responded successfully.

However, the expected share:

```text
HR
```

did not appear in the list.

This was the critical troubleshooting clue.

## Interpretation of net view

The successful response from:

```cmd
net view \\DC01
```

showed that CLIENT01 could communicate with the Windows server and request its available shared resources.

However:

```text
HR share → Missing
```

This indicated that the problem was likely located on DC01 at the SMB/share configuration layer.

The troubleshooting evidence now showed:

```text
H: mapping exists
        ↓
H: disconnected
        ↓
DC01 reachable
        ↓
DNS working
        ↓
DC01 responds to net view
        ↓
HR share not published
        ↓
Investigate server-side SMB share
```

## Server-Side Investigation

The investigation moved to DC01.

The following management console was opened:

```text
Computer Management
→ System Tools
→ Shared Folders
→ Shares
```

The list of currently published SMB shares was reviewed.

The expected:

```text
HR
```

share was missing.

This confirmed the client-side troubleshooting results.

## Root Cause

The root cause of the incident was:

```text
The HR folder still existed on DC01, but it was no longer published as an SMB network share.
```

The local folder:

```text
C:\Shares\HR
```

still existed.

The NTFS permissions also remained configured.

The failure occurred specifically at the SMB sharing layer.

## Why NTFS Permissions Were Not Rebuilt

Stopping or removing an SMB share does not automatically delete the underlying folder or its NTFS permissions.

Because:

```text
C:\Shares\HR
```

still existed with the previously configured NTFS access-control entries, there was no reason to rebuild those permissions.

The repair focused only on the component that had failed.

## Resolution

The HR share was restored on DC01 by navigating to:

```text
C:\Shares\HR
→ Properties
→ Sharing
→ Advanced Sharing
```

The following option was enabled:

```text
Share this folder
```

The share name was configured as:

```text
HR
```

This restored the network path:

```text
\\DC01\HR
```

## Share Permissions

The broad default:

```text
Everyone
```

permission was removed.

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

This restored the same least-privilege share configuration used before the incident.

## Share Verification on DC01

After Advanced Sharing was restored, the following location was checked again:

```text
Computer Management
→ System Tools
→ Shared Folders
→ Shares
```

The HR share now appeared in the list.

**Server-Side Share Result: PASS**

## Client-Side Verification

The repair was not considered complete simply because the share appeared in Computer Management.

The original problem was reported from CLIENT01, so the solution needed to be verified from the user's workstation.

Sarah remained the test user.

## Direct UNC Path Test

The first client-side verification used the direct UNC path:

```text
\\DC01\HR
```

The HR shared folder opened successfully.

**UNC Access Result: PASS**

This confirmed that CLIENT01 could once again access the SMB resource directly.

## Mapped Drive Verification

File Explorer was opened to:

```text
This PC
```

The HR H: drive was checked.

The drive reconnected to:

```text
\\DC01\HR
```

If Group Policy needed to be refreshed, the following command was available:

```cmd
gpupdate /force
```

The final mapped-drive state was:

```text
HR (H:) → Connected
```

**Mapped Drive Result: PASS**

## File Access Verification

The final test involved accessing an actual HR file.

Sarah successfully opened:

```text
HR-Test.txt
```

This confirmed that the user could access the contents of the departmental share after the SMB service was restored.

**File Access Result: PASS**

## Complete Troubleshooting Sequence

The incident was diagnosed using the following sequence:

```text
User reports disconnected HR drive
        ↓
net use
        ↓
H: exists but is disconnected
        ↓
ping DC01
        ↓
DC01 reachable and DNS resolves
        ↓
net view \\DC01
        ↓
Server responds but HR share is missing
        ↓
Check Computer Management on DC01
        ↓
HR missing from Shared Folders → Shares
        ↓
Restore Advanced Sharing
        ↓
Reapply HR_Users share permissions
        ↓
Test \\DC01\HR from CLIENT01
        ↓
Verify H: reconnects
        ↓
Open HR-Test.txt
        ↓
Ticket resolved
```

## Layered Troubleshooting Model

This ticket demonstrated how a network-resource problem can be investigated layer by layer.

### Layer 1 - Drive Mapping

Command:

```cmd
net use
```

Question answered:

```text
Does Windows still have the H: network-drive mapping?
```

Result:

```text
Yes, but it is disconnected.
```

### Layer 2 - Network Connectivity

Command:

```cmd
ping DC01
```

Question answered:

```text
Can CLIENT01 communicate with the server?
```

Result:

```text
Yes.
```

### Layer 3 - DNS Resolution

The same ping test showed:

```text
DC01 → 10.0.2.10
```

Question answered:

```text
Can CLIENT01 resolve the DC01 hostname?
```

Result:

```text
Yes.
```

### Layer 4 - SMB Share Availability

Command:

```cmd
net view \\DC01
```

Question answered:

```text
Is DC01 currently publishing the HR share?
```

Result:

```text
No.
```

This isolated the failure to the server-side SMB share configuration.

## Root Cause Analysis

The troubleshooting process ruled out several possible causes before making changes.

The following were working:

```text
Sarah's workstation
Basic network connectivity
DNS resolution
DC01 availability
The existing H: drive mapping
The underlying HR folder
Existing NTFS permissions
```

The failing component was:

```text
HR SMB share publication
```

This allowed the repair to focus specifically on Advanced Sharing.

## Why the GPO Was Not Recreated

The `net use` result showed:

```text
H: → \\DC01\HR
```

even though the status was disconnected.

This meant Windows already knew about the drive mapping.

Recreating the Group Policy Object would not have corrected the missing SMB share.

The GPO was therefore left unchanged.

## Why Network Settings Were Not Changed

The successful:

```cmd
ping DC01
```

test demonstrated that CLIENT01 could communicate with DC01.

The hostname also resolved correctly to:

```text
10.0.2.10
```

Therefore, changing CLIENT01's IP address, DNS settings, or virtual network configuration would have been unnecessary.

## Why Permissions Were Not Changed First

An access-denied problem and a missing-share problem are different.

If the HR share had appeared in:

```cmd
net view \\DC01
```

but Sarah received an access-denied message, the investigation would have shifted toward:

```text
Security-group membership
Share permissions
NTFS permissions
```

Instead, the HR share did not appear at all.

That evidence pointed toward the SMB share configuration before file permissions.

## Commands Used

The primary troubleshooting commands used during this incident were:

```cmd
net use
ping DC01
net view \\DC01
```

Group Policy could also be refreshed when necessary using:

```cmd
gpupdate /force
```

## Command Purpose Summary

```text
net use
→ Check network-drive mapping and connection status

ping DC01
→ Check server connectivity and basic DNS resolution

net view \\DC01
→ Check SMB resources currently published by DC01

gpupdate /force
→ Refresh Group Policy when necessary
```

## Verification Summary

The completed repair was verified as follows:

```text
H: mapping exists: PASS
DC01 reachable: PASS
DC01 resolves to 10.0.2.10: PASS
HR SMB share restored: PASS
\\DC01\HR accessible: PASS
H: reconnected: PASS
HR-Test.txt accessible: PASS
```

## Root Cause Summary

```text
Problem:
HR mapped drive disconnected

Initial Observation:
H: still mapped to \\DC01\HR but disconnected

Network Test:
DC01 reachable

DNS Test:
DC01 resolved to 10.0.2.10

SMB Test:
HR missing from net view \\DC01

Root Cause:
HR folder was no longer published as an SMB share

Resolution:
Restored Advanced Sharing and HR_Users share permissions

Verification:
UNC path opened, H: reconnected, and HR-Test.txt was accessible
```

## Troubleshooting Methodology

This incident followed the troubleshooting process:

```text
Identify
    ↓
Test
    ↓
Interpret
    ↓
Isolate
    ↓
Correct
    ↓
Verify
```

The key principle was to use the result of each test to determine the next action rather than making several unrelated changes simultaneously.

## Help Desk Skills Demonstrated

This incident required:

- Investigating a disconnected mapped drive
- Reading and interpreting `net use` output
- Testing server connectivity
- Verifying DNS name resolution
- Querying available SMB shares
- Using Computer Management
- Managing Windows shared folders
- Configuring Advanced Sharing
- Applying security-group-based share permissions
- Distinguishing SMB failures from NTFS permission failures
- Performing root-cause analysis
- Verifying the repair from the end user's workstation

## Security Concepts

This task reinforced:

- Least privilege
- Role-based access control
- Security-group-based share permissions
- Separation of SMB and NTFS permissions
- Layered access control
- Positive access verification

## Ticket Resolution

Sarah Johnson's disconnected HR network drive was diagnosed using a layered troubleshooting process.

`net use` confirmed that H: was still mapped but disconnected.

`ping DC01` confirmed network connectivity and successful DNS resolution to `10.0.2.10`.

`net view \\DC01` showed that the HR share was not being published by DC01.

Computer Management confirmed that HR was missing from the server's active shares.

The HR SMB share was restored using Advanced Sharing, and `HR_Users` received Change and Read share permissions.

Final testing from CLIENT01 confirmed that `\\DC01\HR` opened successfully, the H: drive reconnected, and Sarah could access `HR-Test.txt`.

## Concepts Practiced

- SMB file sharing
- Windows network shares
- Mapped network drives
- `net use`
- `ping`
- `net view`
- DNS troubleshooting
- Network connectivity troubleshooting
- Computer Management
- Shared Folders
- Advanced Sharing
- Active Directory security groups
- Share permissions
- NTFS permissions
- Least privilege
- Root-cause analysis
- Layered troubleshooting
- Help Desk troubleshooting
- Verification after remediation

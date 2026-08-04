# 🧑‍💻 Windows Active Directory Help Desk Lab

## Overview

This project documents a hands-on Windows Server and Active Directory lab designed to simulate common Help Desk and system administration tasks.

The lab uses a Windows Server domain controller and a domain-joined Windows 11 client to practice Active Directory administration, access control, Group Policy, network file sharing, employee onboarding, and troubleshooting.

Rather than completing isolated exercises, the lab uses ticket-based scenarios to troubleshoot and manage a simulated business environment.

## Lab Environment

| System | Purpose |
|---|---|
| DC01 | Windows Server Domain Controller |
| CLIENT01 | Windows 11 Enterprise workstation |
| adrianlab.local | Active Directory domain |

### Network Configuration

- Domain Controller: `10.0.2.10`
- Client Workstation: `10.0.2.15`
- Active Directory-integrated DNS
- Virtualized lab environment

## Technologies and Tools

- Windows Server
- Windows 11 Enterprise
- Active Directory Domain Services (AD DS)
- Active Directory Users and Computers (ADUC)
- Group Policy Management
- Group Policy Preferences
- DNS
- SMB File Sharing
- NTFS Permissions
- Security Groups
- Command Prompt
- Virtualization

## Skills Demonstrated

- Active Directory user and group administration
- Organizational Unit (OU) management
- Domain joining Windows workstations
- Password resets and account lockout troubleshooting
- Role-based access control using security groups
- NTFS and SMB share permissions
- Least-privilege access
- Group Policy creation and management
- Group Policy Preferences
- Automated mapped network drives
- Item-level targeting
- Employee onboarding
- Employee department transfers
- Access provisioning and deprovisioning
- DNS and network connectivity troubleshooting
- SMB share troubleshooting

## Help Desk Scenarios

### Active Directory Environment Setup
Configured a Windows Server domain controller, created the `adrianlab.local` domain, organized Active Directory using Organizational Units, created users and security groups, and joined a Windows 11 workstation to the domain.

### Account Lockout Troubleshooting
Configured an account lockout policy and tested failed authentication attempts. Used Active Directory Users and Computers to identify a locked account, unlock the user, reset credentials, and verify successful authentication.

### Secure Department File Share
Created a Finance department SMB share and configured separate share and NTFS permissions using the `Finance_Users` security group. Applied least-privilege access and verified authorized and unauthorized access.

### Group Policy Drive Mapping
Created a Group Policy Preference to automatically map the Finance share as the `F:` drive for members of `Finance_Users`. Used item-level targeting to prevent unauthorized users from receiving the mapping.

### New Employee Onboarding
Created a new Finance employee account, configured first-login password requirements, assigned role-based group membership, and verified automatic access to Finance resources.

### Employee Department Transfer
Transferred an employee from Finance to HR by modifying OU placement and security-group membership. Provisioned HR resources, revoked Finance access, and removed obsolete network-drive mappings.

### Missing Network Drive Troubleshooting
Diagnosed an HR employee's missing mapped drive using `whoami /groups` and `net use`. Identified missing Active Directory security-group membership, restored the appropriate group, refreshed the user's authentication session, and verified access.

### SMB Share Troubleshooting
Diagnosed a disconnected HR network drive using `net use`, `ping`, and `net view`. Determined that the server was reachable but the HR SMB share was no longer being published. Restored the share and verified access from the client workstation.

## Troubleshooting Commands

```cmd
whoami
whoami /groups
ipconfig /all
ping DC01
net use
net view \\DC01
gpupdate /force
gpresult /r

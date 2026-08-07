# 🖥️ Windows Active Directory Help Desk Lab Portfolio

> A hands-on Windows Server Active Directory home lab demonstrating real-world Help Desk and Junior Systems Administrator tasks including Active Directory administration, Group Policy, DNS, SMB file sharing, NTFS permissions, PowerShell automation, user provisioning, troubleshooting, and security best practices.

---

## 📑 Table of Contents

- 📖 Project Overview
- ⭐ Project Highlights
- 🛠️ Skills Demonstrated
- 🏗️ Lab Environment
- 💻 Technologies Used
- 🌐 Lab Architecture
- 📋 Help Desk Scenarios
- ⚡ PowerShell Administration & Automation
- 🌍 DNS Administration & Troubleshooting
- 📸 Screenshot Evidence
- 🔒 Security Concepts
- 🎓 Lessons Learned
- 🚀 Future Improvements
- 📊 Repository Statistics
- 👨‍💻 About the Author
- ⭐ Repository Status

---

# 📖 Project Overview

This project documents the design, implementation, administration, automation, and troubleshooting of a Windows Active Directory home lab built using Oracle VirtualBox, Windows Server 2022, Windows 10, and Ubuntu Linux.

The environment simulates common Help Desk and Junior Systems Administrator responsibilities, including:

- Active Directory administration
- User provisioning and deprovisioning
- Organizational Unit (OU) management
- Security group administration
- SMB file sharing
- NTFS permissions
- Share permissions
- Group Policy configuration
- Drive mapping
- DNS administration
- Forward and reverse DNS
- PowerShell administration
- Bulk user provisioning
- Account lockout troubleshooting
- User offboarding
- Help Desk troubleshooting
- Root cause analysis
- Verification testing
- Technical documentation

Each scenario includes the objective, implementation steps, troubleshooting process, verification, and supporting evidence.

---

# ⭐ Project Highlights

- 🏢 Built and administered a Windows Active Directory domain.
- 👥 Created and managed Organizational Units and security groups.
- 🔐 Implemented Role-Based Access Control (RBAC).
- 💽 Configured SMB file shares with NTFS permissions.
- ⚙️ Automated drive mappings using Group Policy Preferences.
- 👤 Provisioned, transferred, and deprovisioned domain users.
- 🔒 Diagnosed and resolved account lockouts.
- ⚡ Created PowerShell scripts for Active Directory administration.
- 👥 Automated bulk user provisioning from CSV data.
- 📝 Added provisioning results and temporary-credential logging.
- 🌍 Administered Active Directory-integrated DNS.
- 🔎 Worked with A, PTR, and SRV DNS records.
- 🧭 Configured forward and reverse DNS resolution.
- 🛠️ Diagnosed incorrect client DNS configuration.
- 🛠️ Diagnosed incorrect DNS A records.
- 🌐 Tested SMB connectivity using TCP port 445.
- 📊 Audited DNS records with PowerShell.
- 🧹 Performed DNS record cleanup.
- 📸 Documented configuration, failures, repairs, and verification.
- 📚 Published the project using Git and GitHub.

---

# 🛠️ Skills Demonstrated

| Windows Administration | Networking & DNS | Security | Automation & Professional Skills |
|---|---|---|---|
| Active Directory Users and Computers | DNS Administration | NTFS Permissions | PowerShell |
| Organizational Units | Forward Lookup Zones | Share Permissions | Active Directory Cmdlets |
| User & Group Management | Reverse Lookup Zones | Least Privilege | Bulk User Provisioning |
| Group Policy Management | A Records | Role-Based Access Control | CSV Processing |
| Group Policy Preferences | PTR Records | Authentication | Error Handling |
| Account Lockout Management | SRV Records | Security Groups | Logging |
| User Provisioning | DNS Cache | User Deprovisioning | Technical Documentation |
| User Offboarding | Domain Controller Discovery | Access Validation | Root Cause Analysis |
| SMB Administration | SMB / TCP 445 | Positive & Negative Testing | Troubleshooting |
| Windows Server Administration | Name Resolution | Secure Credential Handling | Git & GitHub |

---

# 🏗️ Lab Environment

| Component | Configuration |
|---|---|
| Hypervisor | Oracle VirtualBox |
| Domain Controller | DC01 |
| Server OS | Windows Server 2022 |
| Domain | adrianlab.local |
| DC01 IPv4 | 10.0.2.10 |
| Client Workstation | CLIENT01 |
| Client OS | Windows 10 |
| CLIENT01 IPv4 | 10.0.2.3 |
| DNS Server | DC01 / 10.0.2.10 |
| Documentation Workstation | Ubuntu Linux |
| Version Control | Git |
| Repository Hosting | GitHub |

---

# 💻 Technologies Used

- Windows Server 2022
- Windows 10
- Ubuntu Desktop
- Oracle VirtualBox
- Active Directory Domain Services (AD DS)
- Active Directory Users and Computers
- Group Policy Management
- Windows DNS Server
- PowerShell
- SMB File Sharing
- NTFS Permissions
- Git
- GitHub

---

# 🌐 Lab Architecture

```text
                         🌐 Home Lab
                              |
                       Oracle VirtualBox
                              |
          +-------------------+-------------------+
          |                   |                   |
          v                   v                   v
   +-------------+      +-------------+      +-------------+
   |    DC01     |      |  CLIENT01   |      |   Ubuntu    |
   | Win Server  |      | Windows 10  |      | Git/GitHub  |
   | 10.0.2.10   |      | 10.0.2.3    |      |   Docs      |
   +------+------+      +------+------+      +-------------+
          |                    |
          |                    |
          +---------+----------+
                    |
                    v
            adrianlab.local
                    |
          +---------+---------+
          |                   |
          v                   v
      Finance OU            HR OU
          |                   |
          v                   v
    Finance_Users          HR_Users
          |                   |
          v                   v
    Finance Share          HR Share
```

DC01 provides:

```text
Active Directory Domain Services
            +
          DNS
            +
      SMB File Shares
            +
      Group Policy
```

CLIENT01 is domain joined and uses DC01 as its Active Directory DNS server.

---

# 📋 Help Desk Scenarios

| # | Scenario | Documentation |
|---|---|---|
| 01 | 🏗️ Active Directory Setup | [01 - Active Directory Setup](docs/01-active-directory-setup.md) |
| 02 | 🔐 Account Lockout Troubleshooting | [02 - Account Lockout Troubleshooting](docs/02-account-lockout.md) |
| 03 | 📁 Secure Department File Share | [03 - File Share Permissions](docs/03-file-share-permissions.md) |
| 04 | 💽 Group Policy Drive Mapping | [04 - Group Policy Drive Mapping](docs/04-group-policy-drive-mapping.md) |
| 05 | 👤 User Onboarding | [05 - User Onboarding](docs/05-user-onboarding.md) |
| 06 | 🔄 Department Transfer | [06 - Department Transfer](docs/06-department-transfer.md) |
| 07 | 🔍 Missing Department Drive Troubleshooting | [07 - Missing Department Drive Troubleshooting](docs/07-missing-department-drive.md) |
| 08 | 🌐 SMB Share Troubleshooting | [08 - SMB Share Troubleshooting](docs/08-smb-share-troubleshooting.md) |
| 09 | ⚡ PowerShell Active Directory Administration | [09 - PowerShell AD Administration](docs/09-powershell-ad-administration.md) |
| 10 | 🤖 PowerShell Automation & Bulk Provisioning | [10 - PowerShell Automation](docs/10-powershell-automation.md) |
| 11 | 🌍 DNS Administration & Troubleshooting | [11 - DNS Administration & Troubleshooting](docs/11-dns-administration-troubleshooting.md) |

---

# ⚡ PowerShell Administration & Automation

The lab progressed from GUI-based Active Directory administration to command-line administration and automation with PowerShell.

Tasks included:

- Querying Active Directory users
- Creating users
- Creating department users
- Assigning security-group membership
- Resetting passwords
- Unlocking accounts
- Disabling accounts
- Moving users between Organizational Units
- Detecting duplicate usernames
- Bulk provisioning users from CSV files
- Generating temporary passwords
- Logging provisioning results
- Exporting temporary credentials
- Verifying created accounts

Example Active Directory query:

```powershell
Get-ADUser dbrooks -Properties Department,MemberOf,PasswordLastSet
```

Example group-membership verification:

```powershell
Get-ADPrincipalGroupMembership dbrooks |
Select-Object Name
```

Bulk provisioning expanded the lab from individual account administration into repeatable administrative automation.

---

# 🌍 DNS Administration & Troubleshooting

DNS administration was added to demonstrate the relationship between Active Directory, name resolution, and Windows network services.

The DNS module included:

- Active Directory-integrated DNS
- Forward lookup zones
- Reverse lookup zones
- A records
- PTR records
- SRV records
- LDAP service discovery
- Domain-controller discovery
- DNS client configuration
- DNS cache behavior
- PowerShell DNS administration
- DNS record auditing
- DNS cleanup

The primary DNS server for the environment is:

```text
DC01
10.0.2.10
```

CLIENT01 uses:

```text
DNS Server → 10.0.2.10
```

## Active Directory Service Discovery

LDAP SRV records were tested using:

```cmd
nslookup -type=SRV _ldap._tcp.dc._msdcs.adrianlab.local
```

The query returned:

```text
dc01.adrianlab.local
Port 389
```

Domain-controller discovery was verified using:

```cmd
nltest /dsgetdc:adrianlab.local
```

---

## DNS Troubleshooting Ticket #3002

### Problem

CLIENT01 could reach DC01 by IP address but could not access it by hostname.

### Evidence

```text
ping dc01.adrianlab.local
→ Could not find host

Resolve-DnsName dc01.adrianlab.local
→ DNS timeout

ping 10.0.2.10
→ Successful
```

### Root Cause

CLIENT01 was incorrectly configured to use:

```text
10.0.2.99
```

instead of:

```text
10.0.2.10
```

### Resolution

The correct DNS server was restored:

```powershell
Set-DnsClientServerAddress `
    -InterfaceAlias "Ethernet" `
    -ServerAddresses 10.0.2.10
```

The DNS cache was then cleared and resolution was verified.

---

## DNS Troubleshooting Ticket #3003

### Problem

CLIENT01 was configured with the correct DNS server, but DC01 resolved to the wrong IP address.

DNS returned:

```text
dc01.adrianlab.local → 10.0.2.20
```

while DC01 actually used:

```text
10.0.2.10
```

### Diagnosis

```powershell
Test-NetConnection dc01.adrianlab.local -Port 445
```

returned:

```text
RemoteAddress    : 10.0.2.20
TcpTestSucceeded : False
```

while:

```powershell
Test-NetConnection 10.0.2.10 -Port 445
```

returned:

```text
RemoteAddress    : 10.0.2.10
TcpTestSucceeded : True
```

### Root Cause

The DC01 A record contained the incorrect IP address.

### Resolution

The A record was corrected from:

```text
10.0.2.20
```

to:

```text
10.0.2.10
```

CLIENT01's DNS cache was cleared and SMB connectivity was verified again.

---

# 📸 DNS Screenshot Evidence

## Incorrect Client DNS Configuration

![DNS Client Misconfiguration](screenshots/dns/dns-client-misconfiguration-failure.png)

CLIENT01 could reach DC01 by IP address but DNS name resolution failed.

---

## DNS Configuration Restored

![DNS Troubleshooting Resolved](screenshots/dns/dns-troubleshooting-resolved.png)

CLIENT01 successfully resolved DC01 and reached SMB TCP port 445 after the correct DNS server was restored.

---

## Incorrect DNS A Record

![DNS Record Failure](screenshots/dns/dns-record-failure.png)

DNS resolved DC01 to the incorrect `10.0.2.20` address while direct communication with the actual `10.0.2.10` server succeeded.

---

## Corrected DNS A Record

![DNS Record Fixed](screenshots/dns/dns-record-fixed.png)

DC01 again resolved to `10.0.2.10` and TCP port 445 connectivity succeeded.

---

## PowerShell DNS Audit

![DNS Record Audit](screenshots/dns/dns-record-audit.png)

PowerShell was used to audit forward A records and reverse PTR records.

---

# 🔒 Security Concepts

Throughout this project, I implemented and verified Windows security concepts including:

- 🔐 Least Privilege
- 👥 Role-Based Access Control (RBAC)
- 🛡️ Security Group-Based Authorization
- 📁 NTFS Permissions
- 🌐 SMB Share Permissions
- 💽 Group Policy Preferences
- 👤 User Provisioning
- 🔄 Department Transfers
- 🚫 User Deprovisioning
- 🔒 Account Lockout Management
- 🔑 Temporary Credential Handling
- ✅ Positive and Negative Access Testing
- 🌍 Active Directory DNS
- 🧹 Administrative Cleanup

The lab emphasizes granting access through security groups rather than assigning permissions directly to individual users whenever possible.

---

# 🔧 Troubleshooting Methodology

The lab uses a repeatable troubleshooting process:

```text
Observe
   |
   v
Gather Evidence
   |
   v
Test
   |
   v
Compare
   |
   v
Isolate
   |
   v
Identify Root Cause
   |
   v
Correct
   |
   v
Verify
   |
   v
Document
```

An important lesson from the DNS module was that similar symptoms do not necessarily have the same root cause.

For example:

```text
Cannot access server by hostname
              |
      +-------+-------+
      |               |
      v               v
Wrong client       Wrong DNS
DNS server         A record
      |               |
      v               v
Ticket #3002       Ticket #3003
```

Testing both hostname resolution and direct IP connectivity helped isolate the correct layer before making changes.

---

# 🎓 Lessons Learned

Building this lab strengthened my understanding of:

- Active Directory administration
- Organizational Unit management
- Security group administration
- Group Policy deployment
- SMB file sharing
- NTFS and share permissions
- User provisioning and deprovisioning
- Windows authentication
- Account lockout troubleshooting
- PowerShell administration
- PowerShell automation
- Bulk user provisioning
- CSV-based automation
- DNS administration
- Forward and reverse DNS
- A, PTR, and SRV records
- DNS caching
- Domain-controller discovery
- TCP port testing
- Help Desk troubleshooting methodology
- Root cause analysis
- Verification testing
- Technical documentation
- Git and GitHub portfolio management

One of the most important lessons from this project is that troubleshooting should focus on **isolating the failing layer before changing the environment**.

For example, successful communication with an IP address but failure using the hostname suggests investigating name resolution before assuming that the server or network is unavailable.

The project also reinforced the importance of documenting failures as well as successful configurations. Showing the original symptom, diagnostic evidence, root cause, repair, and verification provides a much stronger demonstration of troubleshooting ability than showing only the finished configuration.

---

# 🚀 Future Improvements

Planned additions include:

- 🔐 Password Policies
- 🛡️ Fine-Grained Password Policies
- 🌐 DHCP Administration
- 📂 Folder Redirection
- 🖨️ Print Server Administration
- 🔍 Event Viewer Investigations
- 📜 PowerShell Login Scripts
- 🔑 Windows LAPS
- 🖥️ WSUS
- 📊 Group Policy Security Hardening
- 🛡️ Windows Defender / Endpoint Security
- 📋 Additional PowerShell Automation
- 📈 Administrative Reporting
- 🔎 Additional Help Desk Troubleshooting Scenarios
- ☁️ Hybrid Microsoft Entra ID Integration

---

# 📊 Repository Statistics

| Category | Count |
|---|---:|
| Documented Modules / Scenarios | 11 |
| DNS Troubleshooting Tickets | 2 |
| Domain Controllers | 1 |
| Windows Clients | 1 |
| Linux Documentation Systems | 1 |
| DNS Servers | 1 |
| PowerShell Automation Projects | Multiple |
| Screenshots | Growing |
| Technologies Used | 10+ |

---

# 👨‍💻 About the Author

I created this project to strengthen my Windows Server, Active Directory, networking, PowerShell, Group Policy, and Help Desk troubleshooting skills while building a professional portfolio that demonstrates practical systems administration experience.

Every lab in this repository was completed in a virtualized environment using Oracle VirtualBox and documented with configuration details, troubleshooting procedures, verification steps, and supporting screenshots.

My goal is to continue expanding this repository as I develop additional Windows Server, networking, scripting, automation, and cybersecurity skills.

---

# ⭐ Repository Status

**Current Status: ✅ Active Development**

Completed areas include:

- ✅ Active Directory Setup
- ✅ Account Lockout Troubleshooting
- ✅ Secure Department File Sharing
- ✅ Group Policy Drive Mapping
- ✅ User Onboarding
- ✅ Department Transfer
- ✅ Missing Department Drive Troubleshooting
- ✅ SMB Share Troubleshooting
- ✅ PowerShell Active Directory Administration
- ✅ PowerShell Automation
- ✅ Bulk User Provisioning
- ✅ User Offboarding
- ✅ DNS Administration
- ✅ Forward and Reverse DNS
- ✅ DNS PowerShell Administration
- ✅ DNS Record Auditing
- ✅ DNS Troubleshooting — Client Misconfiguration
- ✅ DNS Troubleshooting — Incorrect A Record

Additional Windows Server, networking, PowerShell, and security projects will be added as the lab continues to expand.

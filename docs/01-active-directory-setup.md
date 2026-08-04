# Active Directory Environment Setup

## Objective

Build a virtual Windows domain environment that can be used to practice common Help Desk and Windows system administration tasks.

## Environment

| System | Configuration |
|---|---|
| DC01 | Windows Server Domain Controller |
| CLIENT01 | Windows 11 Enterprise workstation |
| Domain | adrianlab.local |
| DC01 IPv4 | 10.0.2.10 |
| CLIENT01 IPv4 | 10.0.2.15 |

## Configuration

Windows Server was configured as the domain controller for the `adrianlab.local` Active Directory domain.

The environment included:

- Active Directory Domain Services
- DNS
- Organizational Units
- Domain users
- Security groups
- Domain-joined Windows 11 workstation

Departmental Organizational Units were created to organize users according to business function.

Security groups were created separately from the OUs so that access to resources could be assigned based on job responsibilities.

## Client Configuration

CLIENT01 was configured to use the domain controller for DNS resolution.

The workstation was then joined to:

`adrianlab.local`

Domain authentication was verified by signing into CLIENT01 using an Active Directory user account.

## Verification

The logged-in identity was verified from CLIENT01 using:

```cmd
whoami

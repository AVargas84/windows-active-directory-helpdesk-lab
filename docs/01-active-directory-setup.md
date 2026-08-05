# Active Directory Environment Setup

## Overview

This project establishes the Windows Active Directory environment used throughout the Help Desk lab. The environment provides a domain controller, a Windows 11 client workstation, and the Active Directory infrastructure required for user management, Group Policy, file sharing, and authentication.

---

## Objective

Build a Windows Active Directory domain that can be used to practice common Help Desk and Windows system administration tasks.

---

## Lab Environment

| Component | Configuration |
|-----------|---------------|
| Domain Controller | DC01 |
| Client Workstation | CLIENT01 |
| Operating System | Windows Server / Windows 11 Enterprise |
| Domain Name | adrianlab.local |
| DC01 IPv4 | 10.0.2.10 |
| CLIENT01 IPv4 | 10.0.2.15 |
| Virtualization Platform | Oracle VirtualBox |

---

## Active Directory Configuration

The Active Directory environment was configured with the following core services:

- Active Directory Domain Services (AD DS)
- DNS
- Organizational Units (OUs)
- Domain Users
- Security Groups
- Domain-joined Windows 11 workstation

Departmental Organizational Units were created to separate users according to business function.

Security Groups were created independently from Organizational Units so permissions could be assigned using Role-Based Access Control (RBAC).

---

## Organizational Units

The following Organizational Units were created:

- HR
- Finance
- IT
- Sales
- Employees
- Servers
- Workstations

These Organizational Units provide logical organization while allowing Group Policy and administrative delegation to be managed efficiently.

---

## Client Configuration

CLIENT01 was configured to:

- Use DC01 for DNS resolution
- Join the `adrianlab.local` domain
- Authenticate using Active Directory user accounts
- Receive Group Policy settings from the domain controller

Domain authentication was verified by successfully signing into CLIENT01 using a domain account.

---

## Verification

The environment was validated by confirming:

| Verification Test | Result |
|-------------------|--------|
| Active Directory installed | ✅ Pass |
| DNS operational | ✅ Pass |
| Domain created | ✅ Pass |
| CLIENT01 joined domain | ✅ Pass |
| Domain user authentication | ✅ Pass |

The logged-in identity was confirmed using:

```cmd
whoami
```

---

## Technologies Used

- Windows Server
- Windows 11 Enterprise
- Active Directory Domain Services
- DNS
- Oracle VirtualBox
- Git
- GitHub

---

## Skills Demonstrated

- Active Directory Administration
- Organizational Unit Management
- Domain Administration
- Windows Authentication
- DNS Configuration
- Windows Client Management
- Virtual Machine Administration

---

## Screenshots

### Active Directory Domain Structure

The Active Directory Users and Computers console showing the completed `adrianlab.local` environment.

![Active Directory Domain Structure](../screenshots/active-directory/aduc-domain-structure.png)

---

## Lessons Learned

This exercise established the Active Directory environment that supports every subsequent Help Desk scenario in this project.

Separating Organizational Units from Security Groups provides a scalable design that simplifies administration while allowing permissions to be assigned according to job responsibilities rather than individual users.

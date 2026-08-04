# Account Lockout Troubleshooting

## Scenario

A user reported being unable to sign in after several failed password attempts.

## Objective

Configure and test an Active Directory account lockout policy, identify the locked account, unlock it, and verify successful authentication.

## Configuration

The Default Domain Policy was updated with an account lockout threshold of:

```text
5 invalid logon attempts

The policy was refreshed using:

```cmd
gpupdate /force

## Troubleshooting

In Active Directory Users and Computers, the user's Account tab displayed:

```text
This account is currently locked out on this Active Directory Domain Controller.

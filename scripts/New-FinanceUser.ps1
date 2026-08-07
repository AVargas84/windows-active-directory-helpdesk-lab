Import-Module ActiveDirectory

$firstName = Read-Host "Enter first name"
$lastName = Read-Host "Enter last name"

$username = ($firstName.Substring(0,1) + $lastname).ToLower()
$fullName = "$firstName $lastName"

$password = Read-Host "Enter temporary password" -AsSecureString

$ouPath = "OU=Finance,DC=adrianlab,DC=local"
$groupName = "Finance_Users"

New-ADUser `
    -Name $fullName `
    -GivenName $fristName `
    -Surname $lastName `
    -SamAccountName $username `
    -UserPrincipalName "$username@adrianlab.local" `
    -Department "Finance" `
    -Path $ouPath `
    -AccountPassword $password `
    -Enable $true `
    -ChangePasswordAtLogon $true

Add-ADGroupMember `
    -Identity $groupName `
    -Members $username

Write-Host ""
Write-Host "User created successfully."
Write-Host "Name: $fullName"
Write-Host "Username: $username"
Write-Host "Department: Finance"
Write-Host "Group: $groupName"
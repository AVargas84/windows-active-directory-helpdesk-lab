Import-Module ActiveDirectory

$firstName = Read-Host "Enter first name"
$lastName = Read-Host "Enter last name"

$username = ($firstName.Substring(0,1) + $lastName).ToLower()
$fullName = "$firstName $lastName"

Write-Host ""
Write-Host "Generated username: $username"

$existingUser = Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue

if ($existingUser) {
    Write-Host ""
    Write-Host "ERROR: Username $username already exisit."
    Write-Host "No account was created."
    exit
}

Write-Host ""
Write-Host "Select a department:"
Write-Host "1. Finance"
Write-Host "2. HR"
Write-Host "3. IT"
Write-Host "4. Sales"

$departmentChoice = Read-Host "Enter choice (1-4)"

switch ($departmentChoice) {

    "1" {
    	$department = "Finance"
    	$ouPath = "OU=Finance,DC=adrianlab,DC=local"
    	$groupName = "Finance_Users"
    }

    "2" {
	$department = "HR"
    	$ouPath = "OU=HR,DC=adrianlab,DC=local"
    	$groupName = "HR_Users"
    }

    "3" {
	$department = "IT"
    	$ouPath = "OU=IT,DC=adrianlab,DC=local"
    	$groupName = "IT_Users"
    }

    "4" {
	$department = "Sales"
    	$ouPath = "OU=Sales,DC=adrianlab,DC=local"
    	$groupName = "Sales_Users"
    }

    default {
	Write-Host ""
	Write-Host "ERROR: Invlid department selection."
	Write-Host "Please run the script again and select 1 through 4."
	exit
    }
}

$password = Read-Host "Enter temporary password" -AsSecureString

try {

    New-ADUser `
        -Name $fullName `
        -GivenName $firstName `
        -Surname $lastName `
        -SamAccountName $username `
        -UserPrincipalName "$username@adrianlab.local" `
        -Department $department `
        -Path $ouPath `
        -AccountPassword $password `
        -Enabled $true `
        -ChangePasswordAtLogon $true `
	-ErrorAction Stop

    Add-ADGroupMember `
        -Identity $groupName `
        -Members $username `
        -ErrorAction Stop

    Write-Host ""
    Write-Host "SUCCESS: User created and provisioned."
    Write-Host "Name: $fullName"
    Write-Host "Username: $username"
    Write-Host "Department: $department"
    Write-Host "Group: $groupName"

}

catch {

    Write-Host ""
    Write-Host "ERROR: User provisioning failed."
    Write-Host $_.Exception.Message
}
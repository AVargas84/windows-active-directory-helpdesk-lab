Import-Module ActiveDirectory

$users = Import-Csv "C:\Scripts\NewUsers.csv"

foreach ($user in $users) {

    $firstName = $user.FirstName
    $lastName = $user.LastName
    $department = $user.Department

    $username = ($firstName.Substring(0,1) + $lastName).ToLower()
    $fullName = "$firstName $lastName"

    Write-Host ""
    Write-Host "Processing: $fullName"
    Write-Host "Generated username: $username"

    $existingUser = Get-ADUser `
	-Filter "SamAccountName -eq '$username'" `
	-ErrorAction SilentlyContinue

    if ($existingUser) {
        Write-Host "SKIPPED: Username $username already exists."
	continue
    }

    switch ($department) {

	"Finance" {
    	    $ouPath = "OU=Finance,DC=adrianlab,DC=local"
    	    $groupName = "Finance_Users"
        }

        "HR" {
    	    $ouPath = "OU=HR,DC=adrianlab,DC=local"
    	    $groupName = "HR_Users"
        }

        "IT" {
    	    $ouPath = "OU=IT,DC=adrianlab,DC=local"
    	    $groupName = "IT_Users"
        }

        "Sales" {
    	    $ouPath = "OU=Sales,DC=adrianlab,DC=local"
    	    $groupName = "Sales_Users"
        }

        default {
	    Write-Host "SKIPPED: Invlid department '$department'."
	    continue
	    
        }
    }

    $password = Read-Host `
    "Enter temporary password for $fullname" `
    -AsSecureString

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

        Write-Host "SUCCESS: User created."
        Write-Host "Username: $username"
        Write-Host "Department: $department"
        Write-Host "Group: $groupName"

    }

    catch {

        Write-Host "ERROR: Failed to provision $fullName."
        Write-Host $_.Exception.Message
    }
}
Import-Module ActiveDirectory

$users = Import-Csv "C:\Scripts\NewUsers-Task7.csv"

$results = @()
$credentials = @()

function New-TemporaryPassword {

    $characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz23456789!@#$%"

    $password = -join (1..14 | ForEach-Object {
	 $characters[(Get-Random -Minimum 0 -Maximum $characters.Length)]
    })

    return $password
}

foreach ($user in $users) {

    $firstName = $user.FirstName
    $lastName = $user.LastName
    $department = $user.Department

    $username = ($firstName.Substring(0,1) + $lastName).ToLower()
    $fullName = "$firstName $lastName"

    Write-Host ""
    Write-Host "Processing: $fullName"
    Write-Host "username: $username"

    $existingUser = Get-ADUser `
	-Filter "SamAccountName -eq '$username'" `
	-ErrorAction SilentlyContinue

    if ($existingUser) {

        Write-Host "SKIPPED: Username $username already exists."

	$results += [PSCustomObject]@{
	    Name	= $fullName
	    Username	= $username
	    Department	= $department
	    Status	= "SKIPPED"
	    Message	= "Username already exists"
	}
	
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

	    Write-Host "SKIPPED: Invalid department."

	    $results += [PSCustomObject]@{
		Name	    = $fullName
		Username    = $username
		Department  = $department
		Status	    = "SKIPPED"
		Message	    = "Invalid department"
	    }

	    continue
	    
        }
    }


    try {
	
	$plainPassword = New-TemporaryPassword

	if ([string]::IsNullOrWhiteSpace($plainPassword)) {
	    throw "Temporary password generation failed."
	}

        $securePassword = ConvertTo-SecureString `
	    $plainPassword `
	    -AsPlainText `
	    -Force

        New-ADUser `
            -Name $fullName `
            -GivenName $firstName `
            -Surname $lastName `
            -SamAccountName $username `
            -UserPrincipalName "$username@adrianlab.local" `
            -Department $department `
            -Path $ouPath `
            -AccountPassword $securePassword `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
	    -ErrorAction Stop

        Add-ADGroupMember `
            -Identity $groupName `
            -Members $username `
            -ErrorAction Stop

        Write-Host "SUCCESS: $fullName provisioned."

	$results += [PSCustomObject]@{
	    Name	= $fullName
	    Username	= $username
	    Department	= $department
	    Status	= "SUCCESS"
	    Message	= "User created and added to $groupName"
	}

	$credentials += [PSCustomObject]@{
	    Name	= $fullName
	    Username	= $username
	    TemporaryPassword = $plainPassword
	}
    }
    
    catch {

        Write-Host "ERROR: Failed to provision $fullName."
        Write-Host $_.Exception.Message

	$results += [PSCustomObject]@{
	    Name	= $fullName
	    Username	= $username
	    Department	= $department
	    Status	= "ERROR"
	    Message	= $._Exception.Message
        }
    }
}

$results |
    Export-Csv `
	"C:\Scripts\Output\ProvisioningResults.csv" `
	-NoTypeInformation

$credentials |
    Export-Csv `
	"C:\Scripts\Output\TemporaryPasswords.csv" `
	-NoTypeInformation

Write-Host ""
Write-Host "Provisioning complete."
Write-Host "Results:"
Write-Host "C:\Scripts\Output\ProvisioningResults.cvs"
Write-Host ""
Write-Host "Temporary credentials:"
Write-Host "C:\Scripts\Output\TemporaryPasswords.csv"
Import-Module ActiveDirectory

$username = Read-Host "Enter username to offboard"

$user = Get-ADUser `
    -Identity $username `
    -Properties Department,MemberOf `
    -ErrorAction SilentlyContinue

if (-not $user) {
    Write-Host ""
    Write-Host "ERROR: User $username was not found."
    exit
}

Write-Host ""
Write-Host "User found:"
Write-Host "Name: $($user.Name)"
Write-Host "Username: $($user.SamAccountName)"
Write-Host "Department: $($user.Department)"

$disabledOU = "OU=Disabled Users,DC=adrianlab,DC=local"

try {
    
    Disable-ADAccount `
	-Identity $username `
	-ErrorAction Stop

    Write-Host ""
    Write-Host "Account disabled."

    $departmentGroups = @(
	"Finance_Users",
	"HR_Users",
	"IT_Users",
	"Sales_Users"
    )

    foreach ($group in $departmentGroups) {

	$isMember = Get-ADGroupMember `
	    -Identity $group `
	    -ErrorAction Stop |
	    Where-Object {
	        $_.SamAccountName -eq $username
	    }

	if ($isMember) {

	    Remove-ADGroupMember `
		-Identity $group `
		-Members $username `
		-Confirm:$false `
		-ErrorAction Stop

	    Write-Host "Removed from group: $group"
	}
    }

    $user = Get-ADUser -Identity $username

    Move-ADObject `
	-Identity $user.DistinguishedName `
	-TargetPath $disabledOU `
	-ErrorAction Stop

    Write-Host "Moved to Disabled Users OU."

    Write-Host ""
    Write-Host "SUCCESS: offboarding completed for $username."
}

catch {
    
    Write-Host ""
    Write-Host "ERROR: offboarding failed."
    Write-Host $_.Exception.Message
}
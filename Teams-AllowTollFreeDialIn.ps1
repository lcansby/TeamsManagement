<#
    .SYNOPSIS
    Disables or Enables Toll Free numbers for Teams users with a csv as input.
    
    .DESCRIPTION
    This script will disable or enable Toll Free numbers for users from a csv file. The csv file should only contain the header 'UserPrincipalName' and one UPN per row.
    ex:
    UserPrincipalName
    adele@contoso.com

    Prior to running the script connect to Teams Powershell with admin credentials.

    .INPUTS
    -Users <PathToCSV>
    -AllowTollFreeDialIn $true/$false

    .EXAMPLE
    .\Teams-AllowTollFreeDialIn.ps1 -Users C:\Temp\Users.csv -AllowTollFreeDialIn $false
    This will DISABLE Toll Free for all users in CSV

    .EXAMPLE
    .\Teams-AllowTollFreeDialIn.ps1 -Users C:\Temp\Users.csv -AllowTollFreeDialIn $true
    This will ENABLE Toll Free for all users in CSV

    .NOTES
    Author        Linus Cansby, lync.se, Twitter: @lcansby
    
    Change Log    V1.00, 07-Apr-2021 - Initial version

#>

param (
    [Parameter(Mandatory=$true)][string]$Users,
    [Parameter(Mandatory=$true)][string]$AllowTollFreeDialIn
 )

#Open CSV File
$UsersCSV = Import-Csv -Path $Users

#Reset Counter
$counter = 0

#Count users in CSV
$UsersCount = ($UsersCSV | Measure-Object).count
Write-Host $UsersCount

foreach($User in $UsersCSV)
    {
    Write-Progress -Activity 'Updating' -Status 'Toll Free Number' -PercentComplete ((($counter++) / $UsersCount) * 100) -CurrentOperation "$counter of $itemsFilteredcount Users"

    $UserPrincipalName = $User.UserPrincipalName

    if($AllowTollFreeDialIn -eq $false)
        {
        Set-CsOnlineDialInConferencingUser -Identity $UserPrincipalName –AllowTollFreeDialIn $false
        }
    if($AllowTollFreeDialIn -eq $true)
        {
        Set-CsOnlineDialInConferencingUser -Identity $UserPrincipalName –AllowTollFreeDialIn $true
        }
    }

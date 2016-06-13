$ErrorActionPreference = "SilentlyContinue"

Write-Host "*****Getting Domains, RID Masters, and Domain Admin Account Information*****" -Verbose -foregroundcolor DarkGreen -BackgroundColor White

$RID = Get-ADForest | Select Domains | foreach{$_.domains | Get-ADDomain | Select RIDMaster}

(Get-ADForest | Select Domains).domains | Out-File -FilePath "$PSScriptRoot\Domains.txt" 

$RID | Out-File -FilePath "$PSScriptRoot\RIDMasters.txt" 

$RID | foreach {
     Get-ADGroupMember "Domain Admins" -Server $_.RIDMaster -Recursive -OutVariable DomainAdmin | Out-Null
    $DomainAdmin | Get-ADUser -Properties * | Select Name,SamAccountName,PasswordLastSet,Enabled,LastLogonDate,PasswordNeverExpires,AccountExpirationDate,DistinguishedName | Sort LastLogonDate |  Export-Csv -Append -Path "$PSScriptRoot\DomainAdminAccounts.csv" -NoTypeInformation
    }

Write-Host "*****COMPLETE!!!*****" -Verbose -foregroundcolor DarkRed -BackgroundColor White

Write-Host "Getting Forest Name, RID Master, and Enterprise Admin Account Information" -Verbose -foregroundcolor DarkGreen -BackgroundColor White

$ForestRID = Get-ADForest | Select Name | foreach{$_.Name | Get-ADDomain | Select RIDMaster}

Get-ADForest | Select Name | Out-File -FilePath "$PSScriptRoot\ForestName.txt"

$ForestRID | Out-File -FilePath "$PSScriptRoot\ForestRIDMaster.txt" 

$ForestRID | foreach {
    Get-ADGroupMember "Enterprise Admins" -Server $_.RIDMaster -Recursive -OutVariable EnterpriseAdmin | Out-Null
    $EnterpriseAdmin | Get-ADUser -Properties * | Select Name,SamAccountName,PasswordLastSet,Enabled,LastLogonDate,PasswordNeverExpires,AccountExpirationDate,DistinguishedName | Sort LastLogonDate | Export-Csv -Append -Path "$PSScriptRoot\EnterpriseAdminAccounts.csv" -NoTypeInformation
    }

Write-Host "*****COMPLETE!!!*****" -Verbose -foregroundcolor DarkRed -BackgroundColor White

Write-Host "*****Getting List of all Replica Servers in the Forest*****" -Verbose -ForegroundColor DarkGreen -BackgroundColor White

$DomainControllers = (Get-ADForest | Select Domains | foreach{$_.domains | Get-ADDomain | Sort | Select ReplicaDirectoryServers}).replicaDirectoryServers

$DomainControllers | Out-File -FilePath "$PSScriptRoot\ReplicaServer.txt" 

Write-Host "*****COMPLETE!!!*****" -Verbose -foregroundcolor DarkRed -BackgroundColor White
   
Import-module activedirectory
$domain = (Get-ADDomain | Select Name).name
$DaysInactive = 30
$time = (Get-Date).Adddays(-($DaysInactive))
$SearchBase = $null

Get-ADUser -Filter {passwordlastset -lt $time -and whencreated -lt $time -and enabled -eq $false} -Properties description,passwordlastset,passwordexpired,whencreated,whenchanged  | select-object samaccountname,description,passwordlastset,passwordexpired,whencreated,whenchanged | export-csv $PSScriptRoot\DisabledUserAccounts.csv –NoTypeInformation -Force
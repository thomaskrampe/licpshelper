$Name = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
Set-Content -Path C:\temp\test.txt -Value $Name

$Trigger = New-ScheduledTaskTrigger -AtLogon
$User = "NT AUTHORITY\SYSTEM" 
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "C:\temp\test.ps1" 
Register-ScheduledTask -TaskName "JustMyTest" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force

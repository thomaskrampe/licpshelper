$Name = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
Set-Content -Path C:\test.txt -Value $Name


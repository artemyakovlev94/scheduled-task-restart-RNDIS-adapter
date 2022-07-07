$PathFolderScripts = 'C:\Shtrih\scripts'
$NameFileScript = 'RNDISAdapterRestart.ps1'
$PathScript = "$PathFolderScripts\$NameFileScript"

Set-ExecutionPolicy Unrestricted -Scope Process

If(!(Test-Path $PathFolderScripts))
{
      New-Item -ItemType Directory -Force -Path $PathFolderScripts
}

'Get-NetAdapter -InterfaceDescription "Remote NDIS based Internet Sharing Device"| Disable-NetAdapter -Confirm:$False
Enable-NetAdapter -InterfaceDescription "Remote NDIS based Internet Sharing Device"' > $PathScript

If(Test-Path $PathScript)
{
    $Trigger= New-ScheduledTaskTrigger -AtLogOn
    $User= "NT AUTHORITY\SYSTEM"
    $Action= New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NonInteractive -WindowStyle Hidden -File $PathScript"
    Register-ScheduledTask -TaskName "Restart RNDIS Adapter" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force
}
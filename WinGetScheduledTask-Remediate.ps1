#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	WinGetScheduledTask-Remediate.ps1
#	https://github.com/Headbolt/WinGet
#
#   This Script is designed check the status of a Winget Update Scheduled Task
#	and create it if it does not exist.
#
#	Intended use is in Microsoft Endpoint Manager, as the "Remediate" half of a Proactive Remediation Script
#	The "Check" half is found here https://github.com/Headbolt/WinGet
#
###############################################################################################################################################
#
# HISTORY
#
#   Version: 1.0 - 09/04/2025
#
#	09/04/2025 - V1.0 - Created by Headbolt
#
###############################################################################################################################################
#
$global:LocalLogFilePath="$Env:WinDir\temp\WinGetScheduledTask-Remediate.log" # Set LogFile
$global:ScriptName="Windows | WinGet Scheduled Task"
#
###############################################################################################################################################
#
#   Functions Definition
#
###############################################################################################################################################
#
#   Logging Function
#
function Logging
{
#	
Start-Transcript $global:LocalLogFilePath # Start the logging
Clear-Host # Clear Screen
SectionEnd
Write-Host "Logging to $global:LocalLogFilePath"
#
}     
#
###############################################################################################################################################
#
# Section End Function
#
function SectionEnd
{
#
Write-Host '' # Outputting a Blank Line for Reporting Purposes
Write-Host  '-----------------------------------------------' # Outputting a Dotted Line for Reporting Purposes
Write-Host '' # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Script End Function
#
Function ScriptEnd
{
#
Write-Host Ending Script $global:ScriptName
Write-Host '' # Outputting a Blank Line for Reporting Purposes
Write-Host  '-----------------------------------------------' # Outputting a Dotted Line for Reporting Purposes
Write-Host ''# Outputting a Blank Line for Reporting Purposes
#
Stop-Transcript # Stop Logging
#
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
# 
# Begin Processing
#
###############################################################################################################################################
#
SectionEnd
Logging
#
$ScheduledTaskName = "WinGet Scheduled Update"
$ScheduledTaskStatus = Get-ScheduledTask | Where-object {$_.taskName -eq "$ScheduledTaskName"}
#
if (!$ScheduledTaskStatus)
{
	try{
		Write-Host "$ScheduledTaskName task does not exist. Creating Task."
		$TaskAction  = New-ScheduledTaskAction -Execute 'powershell -executionpolicy bypass -command "winget upgrade --all --silent"'
		$TaskTrigger = New-ScheduledTaskTrigger -Daily -At 3am
		$TaskSet     = New-ScheduledTaskSettingsSet
		$TaskUser    = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
		Register-ScheduledTask -TaskName $ScheduledTaskName -TaskPath "\"  -Action $TaskAction -Settings $TaskSet -Trigger $TaskTrigger -Principal $TaskUser
		Exit 0
	} Catch {
		Write-Host "Error in Creating scheduled task"
		Write-error $_
		Exit 1
	}
} else {
		Write-Host "Task already Exists. No Action Needed."
}
#
SectionEnd
ScriptEnd

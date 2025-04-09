#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	WinGetScheduledTask-Check.ps1
#	https://github.com/Headbolt/WinGet
#
#   This Script is designed check the status of a Winget Update Scheduled Task
#	and then exit with an appropriate Exit code.
#
#	Intended use is in Microsoft Endpoint Manager, as the "Check" half of a Proactive Remediation Script
#	The "Remediate" half is found here https://github.com/Headbolt/WinGet
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
# Begin Processing
#
###############################################################################################################################################
#
$ExitCode=0 # Setting ExitCode Variable to an initial 0
#
$ScheduledTaskName = "WinGet Scheduled Update"
$ScheduledTaskStatus = Get-ScheduledTask | Where-object {$_.taskName -eq "$ScheduledTaskName"}
#
if ($ScheduledTaskStatus)
{
	Write-Host "Task already Exists. No Action Needed."
} else {
	Write-Host "Task does not exist, Remediation required"
	$ExitCode++
}
#
Write-Host Exiting with exit code $ExitCode
exit $ExitCode

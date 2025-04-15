#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	WinGet-Detection.ps1
#	https://github.com/Headbolt/WinGet
#
#   This Script is designed for use in Intunewin packages and was designed to detect if a package is installed
#
###############################################################################################################################################
#
# HISTORY
#
#   Version: 1.0 - 09/04/2025
#
#	09/04/2025 - V1.0 - Created by Headbolt
#
#
###############################################################################################################################################
#
#   DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
$global:PackageID="<Package-ID>" # Pull Package ID into a Global Variable
#
$global:ScriptVer="1.0" # Set ScriptVersion for logging
$global:ExitCode=2 # Setting Initial Exit Code 2
$global:LocalLogFilePath="$Env:WinDir\temp\" # Set LogFile Patch
$global:ScriptName="Windows | WinGet Detection" # Set ScriptName for logging
#
###############################################################################################################
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
$LocalLogFileType="_Detection.log" # Set ActionType for Log File Path
$global:LocalLogFilePath=$global:LocalLogFilePath+$global:PackageID+$LocalLogFileType # Construct Log File Path
#
Start-Transcript $global:LocalLogFilePath # Start the logging
Clear-Host # Clear Screen
SectionEnd
Write-Host "Logging to $global:LocalLogFilePath"
Write-Host ''# Outputting a Blank Line for Reporting Purposes
Write-Host "Script Version $global:ScriptVer"
Write-Host ''# Outputting a Blank Line for Reporting Purposes
Write-Host 'Install Switch is'$Install
Write-Host 'Uninstall Switch is'$Uninstall
If ( $global:PackageID )
{
	Write-Host 'PackageID is'$global:PackageID
}
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
Write-Host Exiting With Exit Code $global:ExitCode
Write-Host ''# Outputting a Blank Line for Reporting Purposes
Write-Host  '-----------------------------------------------' # Outputting a Dotted Line for Reporting Purposes
Write-Host ''# Outputting a Blank Line for Reporting Purposes
Stop-Transcript # Stop Logging

Exit $global:ExitCode

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
Logging
#
SectionEnd
#
Write-Host 'Finding Local WinGet Install'
#
$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe" # Search for winget
#
if ($ResolveWingetPath)
{
	$WingetPath = $ResolveWingetPath[-1].Path
}
#
$Winget = $WingetPath + "\winget.exe"
#
Write-Host "Winget path is"
Write-Host "$Winget"
#
SectionEnd  
#
If ( $global:PackageID ) # Check PackageID is set
{
	Write-Host 'Attempting Detection'
	SectionEnd
	$Check=(& $Winget list | Select-String $global:PackageID)
	#
	If ( $Check )
	{
		Write-Host Package ID $Check.Pattern Found
		$global:ExitCode=0
		SectionEnd
	}
	else
	{
		Write-Host Package ID $Check.Pattern NOT Found
		$global:ExitCode=1
		SectionEnd
	}
}
else
{
	Write-Host 'PackageID not set, Detection cannot continue'
	SectionEnd

}
#
ScriptEnd

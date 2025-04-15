#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	WinGet-Install_Uninstall.ps1
#	https://github.com/Headbolt/WinGet
#
#   This Script is designed for use in Intunewin packages and was designed to Install or Uninstall a Winget Package
#
# 		Note as IntuneWin are 32 Bit Apps, powershell in the App Command will need to be forced to Native
#			Otherwise Reg Searches for Uninstall commands in HKLM:\SOFTWARE\Microsoft
#			may get redirected to HKLM:\SOFTWARE\Wow6432Node\Microsoft, resulting in uninstallers not being found
#			so call powershell like this
#			%windir%\SysNative\WindowsPowershell\v1.0\PowerShell.exe -executionpolicy bypass -command ./WinGetInstall_Uninstall.ps1
#
###############################################################################################################################################
#
#	Usage
#		Down-And-Install.ps1 [-install | -uninstall] -PackageID <packageid>
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
param (
	[switch]$Install,
	[switch]$Uninstall,
 	[string]$PackageID
)
#
$global:ScriptVer="1.0" # Set ScriptVersion for logging
#
$global:LocalLogFilePath="$Env:WinDir\temp\" # Set LogFile Patch
$global:ScriptName="Windows | WinGet Install_Uninstall" # Set ScriptName for logging
$global:PackageID=$PackageID # Pull Package ID into a Global Variable
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
If ( $Install )
{
	$LocalLogFileType="_Install.log" # Set ActionType for Log File Path
	$global:LocalLogFilePath=$global:LocalLogFilePath+$global:PackageID+$LocalLogFileType # Construct Log File Path
}
#
If ( $Uninstall )
{
	$LocalLogFileType="_Uninstall.log" # Set ActionType for Log File Path
	$global:LocalLogFilePath=$global:LocalLogFilePath+$global:PackageID+$LocalLogFileType # Construct Log File Path
}
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
If ( $Install )
{
	Write-Host '"Install" action requested'
	SectionEnd
	If ( $global:PackageID ) # Check PackageID is set
	{
		Write-Host 'Attempting Install'
		SectionEnd
		Write-Host "Running Command $Winget install --id $global:PackageID --accept-source-agreements --accept-package-agreements --silent"
		$Command=(& $Winget install --id $global:PackageID --accept-source-agreements --accept-package-agreements --silent)
		Write-Host ''# Outputting a Blank Line for Reporting Purposes
		Write-Host $Command
		SectionEnd
	}
	else
	{
	Write-Host 'PackageID not set, Install cannot continue'
	SectionEnd
	}
}
#
If ( $Uninstall )
{
	Write-Host '"Uninstall" action requested'
	SectionEnd
	If ( $global:PackageID ) # Check PackageID is set
	{
		Write-Host 'Attempting Uninstall'
		SectionEnd
		Write-Host "Running Command $Winget uninstall --id $global:PackageID --force --silent"
		$Command=(& $Winget uninstall --id $global:PackageID --force --silent)
		Write-Host ''# Outputting a Blank Line for Reporting Purposes
		Write-Host $Command
		SectionEnd
	}
	else
	{
	Write-Host 'PackageID not set, uninstall cannot continue'
	SectionEnd
	}
}
#
ScriptEnd

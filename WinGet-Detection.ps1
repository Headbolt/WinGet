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
#   Version: 1.1 - 20/05/2025
#
#	09/04/2025 - V1.0 - Created by Headbolt
#
#	20/05/2025 - V1.1 - Updated by Headbolt
#							Updated to Include "--accept-source-agreements" during detection, so bypass agreements Y/N prompt
#
#	20/05/2025 - V1.2 - Updated by Headbolt
#							Updated to remove logging to screen, and only log to file
#
###############################################################################################################################################
#
#   DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
$global:PackageID="<Package-ID>" # Pull Package ID into a Global Variable
#
$global:ScriptVer="1.2" # Set ScriptVersion for logging
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
#Start-Transcript $global:LocalLogFilePath # Start the logging
#Clear-Host # Clear Screen
#
Write-Output '' >> $global:LocalLogFilePath # Outputting a Blank Line for Reporting Purposes
Write-Output  '-----------------------------------------------' >> $global:LocalLogFilePath # Outputting a Dotted Line for Reporting Purposes
Write-Output '' >> $global:LocalLogFilePath # Outputting a Blank Line for Reporting Purposes
#
Write-Output "Logging to $global:LocalLogFilePath" > $global:LocalLogFilePath
Write-Output '' >> $global:LocalLogFilePath # Outputting a Blank Line for Reporting Purposes
Write-Output "Script Version $global:ScriptVer" >> $global:LocalLogFilePath
Write-Output '' >> $global:LocalLogFilePath # Outputting a Blank Line for Reporting Purposes
If ( $global:PackageID )
{
	Write-Output "PackageID is $global:PackageID" >> $global:LocalLogFilePath
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
Write-Output '' >> $global:LocalLogFilePath # Outputting a Blank Line for Reporting Purposes
Write-Output  '-----------------------------------------------' >> $global:LocalLogFilePath # Outputting a Dotted Line for Reporting Purposes
Write-Output '' >> $global:LocalLogFilePath # Outputting a Blank Line for Reporting Purposes
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
Write-Output "Ending Script $global:ScriptName" >> $global:LocalLogFilePath
Write-Output '' >> $global:LocalLogFilePath # Outputting a Blank Line for Reporting Purposes
Write-Output "Exiting With Exit Code $global:ExitCode" >> $global:LocalLogFilePath
Write-Output '' >> $global:LocalLogFilePath # Outputting a Blank Line for Reporting Purposes
Write-Output  '-----------------------------------------------' >> $global:LocalLogFilePath # Outputting a Dotted Line for Reporting Purposes
Write-Output '' >> $global:LocalLogFilePath # Outputting a Blank Line for Reporting Purposes
#Stop-Transcript # Stop Logging
#
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
Write-Output 'Finding Local WinGet Install' >> $global:LocalLogFilePath
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
Write-Output "Winget path is" >> $global:LocalLogFilePath
Write-Output "$Winget" >> $global:LocalLogFilePath
#
SectionEnd  
#
If ( $global:PackageID ) # Check PackageID is set
{
	Write-Output 'Attempting Detection' >> $global:LocalLogFilePath
	SectionEnd
	$Check=(& $Winget list --accept-source-agreements | Select-String $global:PackageID)
	#
	If ( $Check )
	{
		Write-Output "Package ID $Check.Pattern Found" >> $global:LocalLogFilePath
		$global:ExitCode=0
		SectionEnd
	}
	else
	{
		Write-Output "Package ID $Check.Pattern NOT Found" >> $global:LocalLogFilePath
		$global:ExitCode=1
		SectionEnd
	}
}
else
{
	Write-Output 'PackageID not set, Detection cannot continue' >> $global:LocalLogFilePath
	$global:ExitCode=1
	SectionEnd
}
#
ScriptEnd

How to Use

Create an App in Intune as a Win32 App
Use the IntuneWin file as the package

Install Command should be.

%windir%\SysNative\WindowsPowershell\v1.0\PowerShell.exe -executionpolicy bypass -command ./WinGet-Install_Uninstall.ps1 -install -PackageID <PackageID>

eg.

%windir%\SysNative\WindowsPowershell\v1.0\PowerShell.exe -executionpolicy bypass -command ./WinGet-Install_Uninstall.ps1 -install -PackageID JAMSoftware.TreeSize.Free



UnInstall Command should be

%windir%\SysNative\WindowsPowershell\v1.0\PowerShell.exe -executionpolicy bypass -command ./WinGet-Install_Uninstall.ps1 -uninstall -PackageID <PackageID>

eg.

%windir%\SysNative\WindowsPowershell\v1.0\PowerShell.exe -executionpolicy bypass -command ./WinGet-Install_Uninstall.ps1 -uninstall -PackageID JAMSoftware.TreeSize.Free

Take a copy of WinGet-Detection.ps1
Edit the copy and set the package ID on the line
$global:PackageID=<PackageID>

eg.

$global:PackageID="JAMSoftware.TreeSize.Free"

Then Scope to Machines.
Use the Proactive Remediation Pair of scripts to Check for and Create if needed, a Scheduled Task on each machine that runs weekly and checks all Apps for updates and updates them


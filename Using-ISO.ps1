#!ps
#maxlength=50000000
#timeout=360000000

Mount-DiskImage -ImagePath "C:\windows\temp\Win11_25H2_English_x64_v2.iso" -NoDriveLetter -StorageType ISO

Get-WmiObject -Class Win32_volume -Filter 'DriveType=5' | Select-Object -First 1 | Set-WmiInstance -Arguments @{DriveLetter='W:'}




$env:SEE_MASK_NOZONECHECKS=1

$Arguments = "/Auto Upgrade /DynamicUpdate Disable /EULA Accept /Compat IgnoreWarning /Product Server /ShowOOBE Full /Uninstall Disable /copylogs C:\Windows\Temp\Windows11UpgradeLogs /DiagnosticPrompt Enable"

Start-Process -Verb RunAs -FilePath "W:\setup.exe" -ArgumentList "$Arguments" -PassThru -Wait



###$Arguments = "/Auto Upgrade /DynamicUpdate Disable /EULA Accept /Quiet /Compat IgnoreWarning /Product Server /ShowOOBE Full /Uninstall Disable /copylogs C:\Windows\Temp\Windows11UpgradeLogs /DiagnosticPrompt Enable"




DisMount-DiskImage -ImagePath "C:\windows\temp\Win11_25H2_English_x64_v2.iso"

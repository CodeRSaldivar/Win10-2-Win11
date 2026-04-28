function Set-RegistryValueForced {
    param (
        [string]$Path,
        [string]$Name,
        [string]$Type,
        [object]$Value
    )
    try {
        if (-not (Test-Path -Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force
    } catch {
        Write-Output "Failed to set $Name in ${Path}: $($_.Exception.Message)"
    }
}

Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\CompatMarkers" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Shared" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TargetVersionUpgradeExperienceIndicators" -Recurse -Force -ErrorAction SilentlyContinue

Set-RegistryValueForced -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\HwReqChk" -Name "HwReqChkVars" -Type MultiString -Value @(
    "SQ_SecureBootCapable=TRUE",
    "SQ_SecureBootEnabled=TRUE",
    "SQ_TpmVersion=2",
    "SQ_RamMB=8192"
)

Set-RegistryValueForced -Path "HKLM:\SYSTEM\Setup\MoSetup" -Name "AllowUpgradesWithUnsupportedTPMOrCPU" -Type DWord -Value 1

Set-RegistryValueForced -Path "HKCU:\Software\Microsoft\PCHC" -Name "UpgradeEligibility" -Type DWord -Value 1


#>>>>>>>>>>>>>>>>>>>>>>>


Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2171764" -OutFile "C:\Windows\Temp\Windows11InstallationAssistant.exe"

Start-Process "C:\Windows\Temp\Windows11InstallationAssistant.exe" -ArgumentList "/QuietInstall /SkipEULA /NoRestartUI /Auto Upgrade" -Wait

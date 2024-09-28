# Define the action functions
function Install-Chocolatey {

    Write-Host ""
    Write-Host "Installing Chocolatey package manager ..."
    Write-Host ""

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    Pause
}

function Show-All-File-Extensions {

    Write-Host ""
    Write-Host "Setting registry key to show all file extensions ..."
    Write-Host ""
    
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Type DWord -Force

    Pause
}

function Disable-Defender {

    Write-Host ""
    Write-Host "Disabling Defender anti virus ..."
    Write-Host ""
    
    Set-MpPreference -DisableRealtimeMonitoring $true
    Set-MpPreference -DisableIntrusionPreventionSystem $true
    Set-MpPreference -SubmitSamplesConsent NeverSend
    Set-MpPreference -MAPSReporting Disable

    Pause
}

function Restore-Classical-Context-Menu {

    Write-Host ""
    Write-Host "Restoring classical context menu ..."
    Write-Host ""

    New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InprocServer32" -Force
    Set-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(default)" -Value "" -Force

    Pause
}

function Disable-Windows-Updates {

    Write-Host ""
    Write-Host "Disabling Windows updates ..."
    Write-Host ""

    # Stop the Windows Update service
    Stop-Service -Name wuauserv -Force

    # Disable the Windows Update service startup
    Set-Service -Name wuauserv -StartupType Disabled

    Pause
}

function Execute-All {

    Install-Chocolatey
    Show-All-File-Extensions
    Disable-Defender
    Restore-Classical-Context-Menu
    Disable-Windows-Updates
}

# Define the menu function
function Show-Menu {

    Clear-Host

    Write-Host "======================================"
    Write-Host "             Tiny 11 Tuner            "
    Write-Host "======================================"
    Write-Host "0. Execute all actions"
    Write-Host "1. Install Chocolatey package manager"
    Write-Host "2. Show all file extensions"
    Write-Host "3. Disable Defender anti virus"
    Write-Host "4. Restore classical context menu"
    Write-Host "5. Disable Windows updates"
    Write-Host "6. Exit"
    Write-Host "======================================"
}

# Execute main program loop
do {
    
    Show-Menu

    $choice = Read-Host "Enter your choice (0-6)"

    switch ($choice) {

        0 { Execute-All }
        1 { Install-Chocolatey }
        2 { Show-All-File-Extensions }
        3 { Disable-Defender }
        4 { Restore-Classical-Context-Menu }
        5 { Disable-Windows-Updates }
        6 { Write-Host "Exiting ..." -ForegroundColor Yellow }
        
        default { 
            Write-Host "Invalid choice, please try again." -ForegroundColor Red
            Pause
        }
    }
} while ($choice -ne 6)

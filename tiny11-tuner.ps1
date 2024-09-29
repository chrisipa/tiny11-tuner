# Define the action functions

function Log-Action-Text {

    param (
        [string]$text,
        [string]$color
    )

    $separator = '=' * $text.Length

    Write-Host ""
    Write-Host $separator -ForegroundColor $color
    Write-Host $text -ForegroundColor $color
    Write-Host $separator -ForegroundColor $color
    Write-Host ""
}

function Install-Chocolatey {

    param (
        [bool]$doPause
    )

    Log-Action-Text "Install Chocolatey package manager" "Yellow"

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    if ($doPause) {
        Pause
    }
}

function Show-All-File-Extensions {

    param (
        [bool]$doPause
    )

    Log-Action-Text "Set registry key to show all file extensions" "Yellow"

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Type DWord -Force

    if ($doPause) {
        Pause
    }
}

function Disable-Gaming-Overlay-Links-Popup {

    param (
        [bool]$doPause
    )

    Log-Action-Text "Disable gaming overlay links popup" "Yellow"
    
    # Define the registry path
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR"

    # Create the registry key if it doesn't exist
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force
    }

    # Set registry values
    Set-ItemProperty -Path $regPath -Name "AppCaptureEnabled" -Value 0 -Type DWord
    Set-ItemProperty -Path $regPath -Name "AudioCaptureEnabled" -Value 0 -Type DWord
    Set-ItemProperty -Path $regPath -Name "CursorCaptureEnabled" -Value 0 -Type DWord
    Set-ItemProperty -Path $regPath -Name "HistoricalCaptureEnabled" -Value 0 -Type DWord

    if ($doPause) {
        Pause
    }
}

function Restore-Classical-Context-Menu {

    param (
        [bool]$doPause
    )

    Log-Action-Text "Restore classical context menu" "Yellow"

    New-Item -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "InprocServer32" -Force
    Set-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" -Name "(default)" -Value "" -Force

    if ($doPause) {
        Pause
    }
}

function Restore-Classical-Start-Menu {

    param (
        [bool]$doPause
    )

    Log-Action-Text "Restore classical start menu" "Yellow"

    C:\ProgramData\chocolatey\bin\choco.exe install --force -y open-shell --params="'/StartMenu:true /ClassicExplorer:false /ClassicIE:false'"

    if ($doPause) {
        Pause
    }
}

function Disable-Windows-Updates {

    param (
        [bool]$doPause
    )

    Log-Action-Text "Disabe Windows updates" "Yellow"

    # Stop the Windows Update service
    Stop-Service -Name wuauserv -Force

    # Disable the Windows Update service startup
    Set-Service -Name wuauserv -StartupType Disabled

    if ($doPause) {
        Pause
    }
}

function Disable-System-Sounds {

    param (
        [bool]$doPause
    )

    Log-Action-Text "Disable system sounds" "Yellow"

    $path = "HKCU:\AppEvents\Schemes" 
    $keyName = "(Default)" 
    $setValue = ".None" 

    $TestPath = Test-Path $path
    if (-Not($TestPath -eq $True)) {
        Write-Host "Creating folder ..." 
        New-item $path -force
    } 

    if (Get-ItemProperty -path $path -name $keyName -EA SilentlyContinue) {

        $Keyvalue = (Get-ItemProperty -path $path).$keyName  

        if ($KeyValue -eq $setValue) {
            Write-Host "The registry key already exists." 
        }
        else {

            Write-Host " Changing Key Value ..."

            New-itemProperty -path $path -Name $keyName -value $setValue -force 
            Get-ChildItem -Path "HKCU:\AppEvents\Schemes\Apps" | 
            Get-ChildItem | 
            Get-ChildItem | 
            Where-Object { $_.PSChildName -eq ".Current" } | 
            Set-ItemProperty -Name "(Default)" -Value "" 

            Write-Host " The registry key value changed sucessfully." 
        }
    }

    if ($doPause) {
        Pause
    }
}

function Execute-All {

    param (
        [bool]$doPause
    )

    Install-Chocolatey $doPause
    Show-All-File-Extensions $doPause
    Disable-Gaming-Overlay-Links-Popup $doPause
    Restore-Classical-Context-Menu $doPause
    Restore-Classical-Start-Menu $doPause
    Disable-Windows-Updates $doPause
    Disable-System-Sounds $doPause

    Pause
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
    Write-Host "3. Disable gaming overlay links popup"
    Write-Host "4. Restore classical context menu"
    Write-Host "5. Restore classical start menu"
    Write-Host "6. Disable Windows updates"
    Write-Host "7. Disable system sounds"
    Write-Host "8. Exit"
    Write-Host "======================================"
}

# Execute main program loop
do {
    
    Show-Menu

    $choice = Read-Host "Enter your choice (0-8)"

    switch ($choice) {

        0 { Execute-All $false }
        1 { Install-Chocolatey $true }
        2 { Show-All-File-Extensions $true }
        3 { Disable-Gaming-Overlay-Links-Popup $true }
        4 { Restore-Classical-Context-Menu $true }
        5 { Restore-Classical-Start-Menu $true }
        6 { Disable-Windows-Updates $true }
        7 { Disable-System-Sounds $true }
        8 { 
            Write-Host ""
            Write-Host "Please restart your computer now to ensure that all settings are applied correctly!" -ForegroundColor Red 
            Write-Host ""
        }
        default {
            Write-Host "Invalid choice, please try again." -ForegroundColor Red
            Pause
        }
    }
} while ($choice -ne 8)

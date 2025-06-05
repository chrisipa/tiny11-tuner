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

function Create-Registry-Path-If-Not-Exists {

    param (
        [string]$registryPath
    )

    if (-not (Test-Path $registryPath)) {
        New-Item -Path $registryPath -Force | Out-Null
        Write-Host "Registry path created: $registryPath"
    } 
    else {
        Write-Host "Registry path already exists: $registryPath"
    }
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

    # Define the registry path
    $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    # Create the registry path if it doesn't exist
    Create-Registry-Path-If-Not-Exists $registryPath
    
    # Set registry value
    Set-ItemProperty -Path $registryPath -Name "HideFileExt" -Value 0 -Type DWord -Force

    if ($doPause) {
        Pause
    }
}

function Disable-Gamebar-Popups {

    param (
        [bool]$doPause
    )

    Log-Action-Text "Disable gamebar popups" "Yellow"
    
    # Define the registry path
    $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR"

    # Create the registry path if it doesn't exist
    Create-Registry-Path-If-Not-Exists $registryPath

    # Set registry values
    Set-ItemProperty -Path $registryPath -Name "AppCaptureEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $registryPath -Name "AudioCaptureEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $registryPath -Name "CursorCaptureEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty -Path $registryPath -Name "HistoricalCaptureEnabled" -Value 0 -Type DWord -Force

    # Define the registry path    
    $registryPath = "HKCU:\System\GameConfigStore"
    
    # Create the registry path if it doesn't exist
    Create-Registry-Path-If-Not-Exists $registryPath
    
    # Set registry values
    Set-ItemProperty -Path $registryPath -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force

    # Define the registry path
    $registryPath = "HKCU:\SOFTWARE\Classes\ms-gamebar"

    # Create the registry path if it doesn't exist
    Create-Registry-Path-If-Not-Exists $registryPath

    # Set registry values
    Set-ItemProperty -Path $registryPath -Name "(Default)" -Value "URL:ms-gamebar" -Type String -Force
    Set-ItemProperty -Path $registryPath -Name "URL Protocol" -Value "" -Type String -Force

    # Define the registry path    
    $registryPath = "HKCU:\SOFTWARE\Classes\ms-gamebar\shell\open\command"
    
    # Create the registry path if it doesn't exist
    Create-Registry-Path-If-Not-Exists $registryPath

    # Set registry values
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Classes\ms-gamebar\shell\open\command" -Name "(Default)" -Value "C:\Windows\System32\cmd.exe /c exit" -Type String -Force

    if ($doPause) {
        Pause
    }
}

function Restore-Classical-Context-Menu {

    param (
        [bool]$doPause
    )

    Log-Action-Text "Restore classical context menu" "Yellow"

    # Define the registry path
    $registryPath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"

    # Create the registry path if it doesn't exist
    Create-Registry-Path-If-Not-Exists $registryPath

    # Set registry value
    Set-ItemProperty -Path $registryPath -Name "(default)" -Value "" -Force

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

    Log-Action-Text "Disable Windows updates" "Yellow"

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

function Fix-Taskbar-Settings {

    param (
        [bool]$doPause
    )

    Log-Action-Text "Fix taskbar settings" "Yellow"

    # Define the registry path
    $taskbarRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $searchRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"

    # Create the registry paths if they do not exist
    Create-Registry-Path-If-Not-Exists $taskbarRegistryPath
    Create-Registry-Path-If-Not-Exists $searchRegistryPath

    # Remove task view from taskbar
    Set-ItemProperty -Path $taskbarRegistryPath -Name "ShowTaskViewButton" -Value 0 -Type DWord -Force
    
    # Remove widgets from taskbar
    Set-ItemProperty -Path $taskbarRegistryPath -Name "TaskbarDa" -Value 0 -Type DWord -Force
    
    # Remove chat from taskbar
    Set-ItemProperty -Path $taskbarRegistryPath -Name "TaskbarMn" -Value 0 -Type DWord -Force
    
    # Set default start menu alignment to left
    Set-ItemProperty -Path $taskbarRegistryPath -Name "TaskbarAl" -Value 0 -Type DWord -Force
    
    # Remove search from taskbar
    Set-ItemProperty -Path $searchRegistryPath -Name "SearchboxTaskbarMode" -Value 0 -Type DWord -Force

    if ($doPause) {
        Pause
    }
}

function Disable-Startup-Ads-For-M365 {

    param (
        [bool]$doPause
    )

    Log-Action-Text "Disable startup ads for M365" "Yellow"

    Write-Host "Disable startup ad: Show me the Windows welcome experience after updates and occasionally when I sign in to highlight what's new and suggested"
    Create-Registry-Path-If-Not-Exists "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
                 -Name "SubscribedContent-310093Enabled" `
                 -Value 0 `
                 -Type DWord `
                 -Force

    Write-Host "Disable startup ad: Suggest ways to get the most out of Windows and finish setting up this device"
    Create-Registry-Path-If-Not-Exists "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
                 -Name "SubscribedContent-338389Enabled" `
                 -Value 0 `
                 -Type DWord `
                 -Force

    Write-Host "Disable startup ad: Get tips and suggestions when using Windows"
    Create-Registry-Path-If-Not-Exists "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement"
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" `
                 -Name "ScoobeSystemSettingEnabled" `
                 -Value 0 `
                 -Type DWord `
                 -Force

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
    Disable-Gamebar-Popups $doPause
    Restore-Classical-Context-Menu $doPause
    Restore-Classical-Start-Menu $doPause
    Disable-Windows-Updates $doPause
    Disable-System-Sounds $doPause
    Fix-Taskbar-Settings $doPause
    Disable-Startup-Ads-For-M365 $doPause

    Pause
}

function Restart-Machine {

    $choice = Read-Host "Your computer needs to be restarted to apply all settings correctly. Do you want to continue? (Y/N)"

    switch ($choice) {
        y { 
            Write-Host "Restarting computer now ..."
            Restart-Computer -Force
        }
        n { 
            Write-Host "Restart of computer was skipped." 
        }
        default { 
            Write-Host "Invalid choice, please try again." -ForegroundColor Red 
        }
    }
}

# Define the menu function
function Show-Menu {

    Clear-Host

    Write-Host "======================================"
    Write-Host "             Tiny 11 Tuner            "
    Write-Host "======================================"
    Write-Host " 0. Execute all actions"
    Write-Host " 1. Install Chocolatey package manager"
    Write-Host " 2. Show all file extensions"
    Write-Host " 3. Disable gamebar popups"
    Write-Host " 4. Restore classical context menu"
    Write-Host " 5. Restore classical start menu"
    Write-Host " 6. Disable Windows updates"
    Write-Host " 7. Disable system sounds"
    Write-Host " 8. Fix taskbar settings"
    Write-Host " 9. Disable startup ads for M365"
    Write-Host "10. Exit"
    Write-Host "======================================"
}

# Execute main program loop
do {
    
    Show-Menu

    $choice = Read-Host "Enter your choice (0-10)"

    switch ($choice) {

         0 { Execute-All $false }
         1 { Install-Chocolatey $true }
         2 { Show-All-File-Extensions $true }
         3 { Disable-Gamebar-Popups $true }
         4 { Restore-Classical-Context-Menu $true }
         5 { Restore-Classical-Start-Menu $true }
         6 { Disable-Windows-Updates $true }
         7 { Disable-System-Sounds $true }
         8 { Fix-Taskbar-Settings $true }
         9 { Disable-Startup-Ads-For-M365 $true }
        10 { Restart-Machine }
        default {
            Write-Host "Invalid choice, please try again." -ForegroundColor Red
            Pause
        }
    }
} while ($choice -ne 10)

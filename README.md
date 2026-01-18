# tiny11-tuner
A PowerShell script that makes Windows 11 (or Tiny11) far more usable. Once applied, the experience closely resembles Windows 7 — widely regarded as the last great Windows version. Tested on Windows 11 23H2.

## Functionalities

* The script provides these functionalities:
    ```
    ======================================
          Tiny 11 Tuner [ADMIN MODE]
    ======================================
     0. Execute all actions
     1. Show all file extensions
     2. Disable gamebar popups
     3. Restore classical context menu
     4. Disable system sounds
     5. Fix taskbar settings
     6. Disable startup ads for M365
     7. Disable power saving features
     8. Install Chocolatey package manager
     9. Restore classical start menu
    10. Disable Windows updates
    11. Exit
    ======================================
    Enter your choice (0-11):
    ```    

## How to execute?

* The script can be executed with or without adminisitrative privileges
* Please keep in mind that it will provide less functionalities if you execute it with a non admin user account

### How to execute locally?

* Clone repository to local machine
* Open a Powershell window
* Change to repository folder
* Execute Powershell script locally:
    ```
    Powershell -ExecutionPolicy Unrestricted -File tiny11-tuner.ps1
    ```

### How to execute script directly from Github?

* Open a Powershell window
* Execute Powershell script:
    ```
    Set-ExecutionPolicy Unrestricted; Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/chrisipa/tiny11-tuner/master/tiny11-tuner.ps1").Content
    ```
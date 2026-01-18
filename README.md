# tiny11-tuner
Powerscript to make Windows (or Tiny) 11 much more usable. The script has been tested with Windows 11 

## How to execute locally?

* Clone repository to local machine
* Open Powershell with administrative permissions
* Change to repository folder
* Execute Powershell script locally:
    ```
    Powershell -ExecutionPolicy Unrestricted -File tiny11-tuner.ps1
    ```

## How to execute script directly from Github?

* Open Powershell with administrative permissions
* Execute Powershell script:
    ```
    Set-ExecutionPolicy Unrestricted; Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/chrisipa/tiny11-tuner/master/tiny11-tuner.ps1").Content
    ```
echo .------..------..------..------..------..------..------..------..------..------.
echo |F.--. ||F.--. ||M.--. ||P.--. ||E.--. ||G.--. ||..--. ||B.--. ||A.--. ||T.--. |
echo | :(): || :(): || (\/) || :/\: || (\/) || :/\: || :(): || :(): || (\/) || :/\: |
echo | ()() || ()() || :\/: || (__) || :\/: || :\/: || ()() || ()() || :\/: || (__) |
echo | '--'F|| '--'F|| '--'M|| '--'P|| '--'E|| '--'G|| '--'.|| '--'B|| '--'A|| '--'T|
echo `------'`------'`------'`------'`------'`------'`------'`------'`------'`------'

@echo off
:: Check if running as administrator
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Check for Chocolatey installation
choco -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing Chocolatey...
    :: Install Chocolatey
    @powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    if %errorlevel% neq 0 (
        echo Failed to install Chocolatey. Exiting...
        exit /b %errorlevel%
    )
)

:: Install ffmpeg using Chocolatey
echo Installing ffmpeg...
choco install ffmpeg -y
if %errorlevel% neq 0 (
    echo Failed to install ffmpeg. Exiting...
    exit /b %errorlevel%
)

echo ffmpeg has been installed successfully.
pause

:: Exit the batch script and close the Command Prompt window
exit
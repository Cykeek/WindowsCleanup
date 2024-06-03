@echo off
setlocal enabledelayedexpansion

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
set "LOG_DIR=%SCRIPT_DIR%logging"

REM Delete previous logging folder if exists
if exist "%LOG_DIR%" (
    rmdir /q /s "%LOG_DIR%"
)

REM Create logging folder
mkdir "%LOG_DIR%"

REM Clean temporary folders
echo Cleaning temporary folders...
echo Cleaning temporary folders... >> "%LOG_DIR%\logs.txt"
echo %date% %time% >> "%LOG_DIR%\logs.txt"
echo.

REM Clean %temp% folder
echo Cleaning %temp% folder... >> "%LOG_DIR%\logs.txt"
del /q /f /s %temp%\*.* >> "%LOG_DIR%\logs.txt" 2>>&1
if %errorlevel% NEQ 0 echo The process cannot access the file because it is being used by another process. >> "%LOG_DIR%\logs.txt"

REM Clean prefetch folder
echo Cleaning prefetch folder... >> "%LOG_DIR%\logs.txt"
del /q /f /s %windir%\prefetch\*.* >> "%LOG_DIR%\logs.txt" 2>>&1
if %errorlevel% NEQ 0 echo The process cannot access the file because it is being used by another process. >> "%LOG_DIR%\logs.txt"

REM Check network connectivity
echo Checking network connectivity... >> "%LOG_DIR%\logs.txt"
echo %date% %time% >> "%LOG_DIR%\logs.txt"
echo.

REM Ping www.google.com four times
echo Pinging www.google.com... >> "%LOG_DIR%\logs.txt"
ping www.google.com -n 4 | findstr /C:"TTL=" > nul
if errorlevel 1 (
    echo Network is disconnected. >> "%LOG_DIR%\logs.txt"
) else (
    echo Network is connected. >> "%LOG_DIR%\logs.txt"
)

REM Check if Chrome is installed
if exist "%LocalAppData%\Google\Chrome\User Data\Default\Cache\" (
    echo Cleaning Chrome cache files... >> "%LOG_DIR%\logs.txt"
    del /q /f /s "%LocalAppData%\Google\Chrome\User Data\Default\Cache\*.*" >> "%LOG_DIR%\logs.txt" 2>>&1
    if %errorlevel% NEQ 0 echo The process cannot access the file because it is being used by another process. >> "%LOG_DIR%\logs.txt"
)

REM Check if Edge is installed
if exist "%LocalAppData%\Microsoft\Edge\User Data\" (
    echo Cleaning Edge cache files... >> "%LOG_DIR%\logs.txt"
    del /q /f /s "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache\*.*" >> "%LOG_DIR%\logs.txt" 2>>&1
    if %errorlevel% NEQ 0 echo The process cannot access the file because it is being used by another process. >> "%LOG_DIR%\logs.txt"
)

REM Check if Firefox is installed
if exist "%AppData%\Mozilla\Firefox\Profiles\" (
    echo Cleaning Firefox cache files... >> "%LOG_DIR%\logs.txt"
    del /q /f /s "%LocalAppData%\Mozilla\Firefox\Profiles\*\cache2\*.*" >> "%LOG_DIR%\logs.txt" 2>>&1
    if %errorlevel% NEQ 0 echo The process cannot access the file because it is being used by another process. >> "%LOG_DIR%\logs.txt"
)

echo Temporary files have been cleaned. Press any key to exit.

REM Run popup.vbs to show the message
wscript.exe "%SCRIPT_DIR%popup.vbs"

REM Run optimisation.ps1 PowerShell script
echo Running optimisation.ps1...
echo Running optimisation.ps1... >> "%LOG_DIR%\logs.txt"
powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_DIR%optimisation.ps1"

REM Close Command Prompt window
exit

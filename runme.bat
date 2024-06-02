@echo off
setlocal enabledelayedexpansion

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"

REM Delete previous logs.txt if exists
if exist "%SCRIPT_DIR%logs.txt" (
    del "%SCRIPT_DIR%logs.txt"
)

REM Check if script is running with admin privileges
NET FILE 1>NUL 2>NUL
if %errorlevel% == 0 (
    set "ADMIN_ACCESS=1"
) else (
    set "ADMIN_ACCESS=0"
)

REM If not running with admin privileges, prompt for admin rights
if %ADMIN_ACCESS% == 0 (
    echo Administrative privileges are required to clean temporary files and perform network checks.
    echo Please provide admin credentials if prompted.
    echo.
)

REM Change the working directory to the script directory
cd /d "%SCRIPT_DIR%"

REM Clean temporary folders
echo Cleaning temporary folders...
echo Cleaning temporary folders... >> logs.txt
echo %date% %time% >> logs.txt
echo.

REM Clean %temp% folder
echo Cleaning %temp% folder... >> logs.txt
del /q /f /s %temp%\*.* >> logs.txt 2>>&1
echo.

REM Clean prefetch folder
echo Cleaning prefetch folder... >> logs.txt
del /q /f /s %windir%\prefetch\*.* >> logs.txt 2>>&1
echo.

REM Check if Chrome is installed
if exist "%LocalAppData%\Google\Chrome\User Data\Default\Cache\" (
    REM Clean temp folder for Chrome
    echo Cleaning Chrome cache files... >> logs.txt
    del /q /f /s "%LocalAppData%\Google\Chrome\User Data\Default\Cache\*.*" >> logs.txt 2>>&1
    echo.
)

REM Check if Edge is installed
if exist "%LocalAppData%\Microsoft\Edge\User Data\" (
    REM Clean temp folder for Edge
    echo Cleaning Edge cache files... >> logs.txt
    del /q /f /s "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache\*.*" >> logs.txt 2>>&1
    echo.
)

REM Check if Firefox is installed
if exist "%AppData%\Mozilla\Firefox\Profiles\" (
    REM Clean temp folder for Firefox
    echo Cleaning Firefox cache files... >> logs.txt
    del /q /f /s "%LocalAppData%\Mozilla\Firefox\Profiles\*\cache2\*.*" >> logs.txt 2>>&1
    echo.
)

REM Check network connectivity
echo Checking network connectivity...
echo %date% %time% >> logs.txt
echo.

REM Ping www.google.com four times
echo Pinging www.google.com...
ping www.google.com -n 4 | findstr /C:"TTL=" > nul
if errorlevel 1 (
    echo Network is disconnected. >> logs.txt
) else (
    echo Network is connected. >> logs.txt
)

echo.

echo Temporary files have been cleaned and network connectivity has been checked. Press any key to exit.

REM Run popup.vbs to show the message
wscript.exe "%SCRIPT_DIR%popup.vbs"

REM Close Command Prompt window
exit

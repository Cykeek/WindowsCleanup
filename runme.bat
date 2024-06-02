@echo off
setlocal enabledelayedexpansion

REM Delete previous logs.txt if exists
if exist logs.txt (
    del logs.txt
)

REM Prompt for admin rights
echo Administrative privileges are required to clean temporary files and perform network checks.
echo Please provide admin credentials if prompted.
echo.

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

REM Clean temp folder
echo Cleaning temp folder... >> logs.txt
del /q /f /s %windir%\temp\*.* >> logs.txt 2>>&1
echo.

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
wscript.exe "popup.vbs"

REM Close Command Prompt window
exit

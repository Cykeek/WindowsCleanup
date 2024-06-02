@echo off

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"

REM Navigate to the processhack directory
cd "%SCRIPT_DIR%processhack"

REM Run the VBScript to start the main script in the background
start /min processhack.bat

REM Return to the original directory
cd "%SCRIPT_DIR%"

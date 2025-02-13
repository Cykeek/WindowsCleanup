@echo off

REM Set the interval (in seconds) for checking processes
set "CHECK_INTERVAL=1"

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"

REM Create the logging folder if it doesn't exist
if not exist "%SCRIPT_DIR%logging" (
    mkdir "%SCRIPT_DIR%logging"
)

REM Clean previous process logs
del /q "%SCRIPT_DIR%logging\process_logs.txt" > nul 2>&1

REM Define the array of target processes and desired priority levels
REM Real Time Priority [Values = 256]
REM High Priority [Values = 128]
REM Above Normal Priority [Values = 32768]
REM Normal Priority [Values = 32]
REM Below Normal Priority [Values = 16384]
REM Idle priority [Values = 64]

setlocal EnableDelayedExpansion
set "TARGET_PROCESSES[0]=chrome.exe"
set "TARGET_PROCESSES[1]=cs2.exe"
set "TARGET_PROCESSES[2]=cmd.exe"
set "TARGET_PROCESSES[3]=steam.exe"
set "TARGET_PROCESSES[4]=SteamService.exe"
set "TARGET_PROCESSES[5]=RiotClientServices.exe"
set "TARGET_PROCESSES[6]=RiotClientCrashHandler.exe"
set "TARGET_PROCESSES[7]=PhoneExperienceHost.exe"
set "TARGET_PROCESSES[8]=OfficeClickToRun.exe"
set "TARGET_PROCESSES[9]=msedgewebview2.exe"
set "TARGET_PROCESSES[10]=MicrosoftEdgeUpdate.exe"
set "TARGET_PROCESSES[11]=Discord.exe"
set "DESIRED_PRIORITIES[0]=16384"
set "DESIRED_PRIORITIES[1]=256"
set "DESIRED_PRIORITIES[2]=64"
set "DESIRED_PRIORITIES[3]=64"
set "DESIRED_PRIORITIES[4]=64"
set "DESIRED_PRIORITIES[5]=64"
set "DESIRED_PRIORITIES[6]=64"
set "DESIRED_PRIORITIES[7]=64"
set "DESIRED_PRIORITIES[8]=64"
set "DESIRED_PRIORITIES[9]=64"
set "DESIRED_PRIORITIES[10]=64"
set "DESIRED_PRIORITIES[11]=64"

REM Initialize process states
for /L %%i in (0,1,11) do (
    set "PROCESS_STATE[%%i]=not running"
)

:ProcessHack
REM Iterate through the array of target processes
for /L %%i in (0,1,11) do (
    set "TARGET_PROCESS=!TARGET_PROCESSES[%%i]!"
    set "DESIRED_PRIORITY=!DESIRED_PRIORITIES[%%i]!"

    REM Check if the target process is running
    tasklist /fi "imagename eq !TARGET_PROCESS!" | find /i "!TARGET_PROCESS!" > nul
    if !errorlevel! equ 0 (
        if "!PROCESS_STATE[%%i]!" neq "running" (
            REM Process started
            echo [!DATE! !TIME!] !TARGET_PROCESS! started. >> "%SCRIPT_DIR%logging\process_logs.txt"
            echo !TARGET_PROCESS! detected and running.
            wmic process where "name='!TARGET_PROCESS!'" CALL setpriority !DESIRED_PRIORITY! > nul
            if !errorlevel! equ 0 (
                echo [!DATE! !TIME!] Failed to set priority of process !TARGET_PROCESS!. >> "%SCRIPT_DIR%logging\process_logs.txt"
            ) else (
                echo [!DATE! !TIME!] Priority of process !TARGET_PROCESS! set to !DESIRED_PRIORITY!. >> "%SCRIPT_DIR%logging\process_logs.txt"
            )
            set "PROCESS_STATE[%%i]=running"
        )
    ) else (
        if "!PROCESS_STATE[%%i]!" neq "not running" (
            REM Process terminated
            echo [!DATE! !TIME!] !TARGET_PROCESS! terminated. >> "%SCRIPT_DIR%logging\process_logs.txt"
            set "PROCESS_STATE[%%i]=not running"
            echo !TARGET_PROCESS! got terminated!!
        )
    )
)

REM Wait for the next check interval
timeout /t %CHECK_INTERVAL% /nobreak > nul

REM Continue checking processes
goto :ProcessHack

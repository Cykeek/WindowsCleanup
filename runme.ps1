# Delete log file if exists
$logFile = Join-Path -Path $PSScriptRoot -ChildPath "cleanup_log.txt"
if (Test-Path -Path $logFile) {
    Remove-Item -Path $logFile -Force
}

# Function to log messages
function LogMessage {
    param (
        [string]$Message
    )
    $Message | Out-File -FilePath $logFile -Append
}

# Function to clean a specific folder
function CleanFolder {
    param (
        [string]$FolderPath
    )
    if (Test-Path -Path $FolderPath -PathType Container) {
        LogMessage "Deleting contents of the folder: $FolderPath"
        
        # Loop through each file in the folder
        Get-ChildItem -Path $FolderPath | ForEach-Object {
            $FilePath = $_.FullName
            if (-not (Test-Path -Path $FilePath -PathType Container)) {
                # Check if the file is in use by any process
                $inUse = $false
                $processes = Get-Process
                foreach ($process in $processes) {
                    try {
                        $process.Modules | Where-Object { $_.FileName -eq $FilePath } | Out-Null
                        $inUse = $true
                        break
                    } catch {
                        # Ignore errors accessing process modules
                    }
                }

                if (-not $inUse) {
                    # File is not in use, proceed to delete
                    Remove-Item -Path $FilePath -Force -ErrorAction SilentlyContinue
                    if ($?) {
                        LogMessage "Deleted file: $FilePath"
                    } else {
                        LogMessage "Failed to delete file: $FilePath"
                    }
                } else {
                    LogMessage "File is in use, skipping: $FilePath"
                }
            }
        }

        # Remove all subdirectories in the folder
        Get-ChildItem -Path $FolderPath -Directory | ForEach-Object {
            Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
            if ($?) {
                LogMessage "Deleted directory: $($_.FullName)"
            } else {
                LogMessage "Failed to delete directory: $($_.FullName)"
            }
        }

        LogMessage "Folder $FolderPath cleaned successfully."
    } else {
        LogMessage "Folder does not exist: $FolderPath"
    }
}

# Prompt user for admin privileges
Start-Process powershell.exe -Verb RunAs -ArgumentList "-File `"$PSCommandPath`""

# Define the log file path
$logFile = Join-Path -Path $PSScriptRoot -ChildPath "cleanup_log.txt"

# Clean user's temp folder
$TempFolder = [System.IO.Path]::GetTempPath()
CleanFolder -FolderPath $TempFolder

# Clean Windows temp folder
$WindowsTempFolder = "$env:SystemRoot\Temp"
CleanFolder -FolderPath $WindowsTempFolder

# Clean Prefetch folder
$PrefetchFolder = "$env:SystemRoot\Prefetch"
CleanFolder -FolderPath $PrefetchFolder

Write-Host "Cleanup completed. Log file: $logFile"

<#
.SYNOPSIS
Starts a server or worker using uvicorn or Celery based on the specified action.

.DESCRIPTION
This script activates a virtual environment and starts uvicorn server or Celery worker/beat based on the action provided.

.PARAMETER Action
Specifies the action to perform ('uvicorn', 'celery_worker', or 'celery_beat').

.EXAMPLE
.\start.ps1 -Action uvicorn
Starts the uvicorn server.

.EXAMPLE
.\start.ps1 -Action celery_worker
Starts the Celery worker.

.EXAMPLE
.\start.ps1 -Action celery_beat
Starts the Celery beat.

.NOTES
Author: Md Faruk
Date:   2024-05-28
#>

# Function to handle script execution based on Action
function Start-ServerOrWorker {
    param (
        [Parameter(Position=0, Mandatory=$true, HelpMessage="Specify the action ('uvicorn', 'celery_worker' or 'celery_beat').")]
        [ValidateSet('uvicorn', 'celery_worker', 'celery_beat')]
        [string]$Action
    )

    # If-Else Logic based on $Action parameter
    if ($Action -eq "uvicorn") {
        Write-Host "Starting uvicorn server...."
        Start-Sleep -Seconds 1
        uvicorn app.main:app --reload --port 80
    } elseif ($Action -eq "celery_worker") {
        Write-Host "Starting Celery worker...."
        celery -A app.celery worker -l info -P gevent -E
    } elseif ($Action -eq "celery_beat") {
        Write-Host "Starting Celery beat...."
        celery -A app.celery beat
    } else {
        Write-Host "Invalid action specified. Please use 'uvicorn', 'celery_worker', or 'celery_beat'."
    }
}

# Function to activate virtual environment if not activated
function Activate-VirtualEnvironment {
    # Set the path to the activation script
    $activationScript = "D:\work\Manna-insect\farmerenv\Scripts\Activate.ps1"

    # Check if the virtual environment is already activated
    if (-not $env:VIRTUAL_ENV) {
        # Check if the activation script exists
        if (Test-Path $activationScript) {
            # Invoke the activation script in the appropriate context
            & $activationScript
            Start-Sleep -Seconds 3
        } else {
            Write-Host "Error: Virtual environment activation script not found."
        }
    }
}

function Stop-Celery() {
    # Find the celery process
    $celeryProcess = Get-Process | Where-Object { $_.ProcessName -eq "celery" } # gps | ? { $_.ProcessName -eq "celery" }

    if ($celeryProcess) {
        $celeryProcessId = $celeryProcess.Id
        Write-Output "Celery process found with PID: $celeryProcessId"

        # Terminate the celery process
        Stop-Process -Id $celeryProcessId -Force
        Write-Output "Celery process with PID $celeryProcessId has been terminated."
    }
    else {
        Write-Output "No Celery process to terminate."
    }

}

function Print-MultilineMessage {
    param(
        [string]$message
    )

    $borderLength = 40
    $paddingLength = [Math]::Ceiling(($borderLength - $message.Length - 2) / 2)

    $border = '*' * $borderLength
    $padding = ' ' * $paddingLength

    $topBottomBorder = "/*$border*/"
    $middleLine = "/*$padding$message$padding*/"

    Write-Output $topBottomBorder
    Write-Output $middleLine
    Write-Output $topBottomBorder
}

# Check for --help or -h option
if ($args.Count -eq 0 -or $args -contains "--help" -or $args -contains "-h") {
@"
USAGE:

.\$($MyInvocation.MyCommand.Name) <Action>

Actions:
    uvicorn         - Start uvicorn server.
    celery_worker   - Start Celery worker.
    celery_beat     - Start Celery beat.
    start_redis     - Start Redis server.
    stop_redis      - Stop Redis server.
    stop_celery     - Stop All Celery Script.

"@
    exit
}

if ($args -contains "start_redis") {
    # Starting redis-server
    wsl -u root -e sudo service redis-server start
    exit
}

if ($args -contains "stop_redis") {
    wsl -u root -e sudo service redis-server stop
    exit
}

if ($args -contains "stop_celery") {
    Stop-Celery
    exit
}

# Example usage printing function:
$message = "REMEMBER TO START REDIS_SERVER"
Print-MultilineMessage -message $message

# Activate virtual environment
Activate-VirtualEnvironment

# Invoke the function with the provided action
if ($args[0]-in @('uvicorn', 'celery_worker', 'celery_beat')) {
    Start-ServerOrWorker -Action $args[0]
} else {
    Write-Host "Invalid argument found"
    exit
}

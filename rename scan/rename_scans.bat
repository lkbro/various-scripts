@echo off
setlocal enabledelayedexpansion

REM ============================================================================
REM Configuration - Update these values for your environment
REM ============================================================================
REM Path to your SSH private key (generate with ssh-keygen, see SSH_SETUP.md)
set "SSH_KEY=%USERPROFILE%\.ssh\nas_id_rsa"

REM NAS connection details
set "NAS_USER=nasusername"
set "NAS_HOST=nashost"
set "NAS_PORT=22"

REM Path mapping (Windows drive letter to NAS volume)
set "WIN_DRIVE=X:\"
set "NAS_VOLUME=/volume1/"

REM Remote Python script path
set "REMOTE_SCRIPT=/nasvolume/scriptfolder/scanrename.py"
REM ============================================================================

REM Validate SSH key exists
if not exist "%SSH_KEY%" (
    echo ERROR: SSH private key not found at: %SSH_KEY%
    echo.
    echo Please follow the setup instructions in SSH_SETUP.md to generate
    echo an SSH key pair and configure your NAS for key-based authentication.
    echo.
    pause
    exit /b 1
)

REM Convert Windows path to Unix path
set winpath=%1
set winpath=!winpath:%WIN_DRIVE%=%NAS_VOLUME%!
set unixpath=!winpath:\=/!

REM Execute remote command using SSH key authentication
plink -batch -ssh %NAS_USER%@%NAS_HOST% -P %NAS_PORT% -i "%SSH_KEY%" -t "/usr/local/bin/python3 %REMOTE_SCRIPT% '!unixpath!'"

echo.
echo Script execution complete. Press any key to close this window.
pause > nul
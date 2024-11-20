@echo off
setlocal enabledelayedexpansion
set winpath=%1
set winpath=!winpath:X:\=/volume1/!
set unixpath=!winpath:\=/!

REM Define username directly in the script
set USERNAME=nasusername

REM Use the hostname from the hosts file
plink -batch -ssh %USERNAME%@nashost -P 22 -pwfile supersecret.txt -t "/usr/local/bin/python3 /nasvolume/scriptfolder/scanrename.py '!unixpath!'"

echo.
echo Script execution complete. Press any key to close this window.
pause > nul
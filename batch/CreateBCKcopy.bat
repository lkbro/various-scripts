@echo off
setlocal enabledelayedexpansion

for %%a in (%*) do (
    for /f "tokens=2 delims==" %%i in ('wmic os get localdatetime /value') do set datetime=%%i
    set "year=!datetime:~0,4!"
    set "month=!datetime:~4,2!"
    set "day=!datetime:~6,2!"
    set "hour=!datetime:~8,2!"
    set "minute=!datetime:~10,2!"
    set "second=!datetime:~12,2!"

    set "filename=%%~na"
    set "newfolder=%%~dpa_bck"
    if not exist "!newfolder!" mkdir "!newfolder!"

    rem Correct handling of spaces in filenames and correct placement of timestamp
    set "newname=!filename!_!year!!month!!day!_!hour!!minute!!second!%%~xa"

    rem Remove double quotes from source path
    set "sourcepath=%%a"
    set "sourcepath=!sourcepath:"=!"

    rem Use quotes to correctly handle destination path
    copy "!sourcepath!" "!newfolder!\!newname!"
)

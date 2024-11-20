@echo off
REM Get current date and time in the desired format
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set "YYYY=%datetime:~0,4%"
set "MM=%datetime:~4,2%"
set "DD=%datetime:~6,2%"
set "HH=%datetime:~8,2%"
set "Min=%datetime:~10,2%"

REM Convert numeric month to three-letter abbreviation
set "MMM="
if "%MM%"=="01" set "MMM=Jan"
if "%MM%"=="02" set "MMM=Feb"
if "%MM%"=="03" set "MMM=Mar"
if "%MM%"=="04" set "MMM=Apr"
if "%MM%"=="05" set "MMM=May"
if "%MM%"=="06" set "MMM=Jun"
if "%MM%"=="07" set "MMM=Jul"
if "%MM%"=="08" set "MMM=Aug"
if "%MM%"=="09" set "MMM=Sep"
if "%MM%"=="10" set "MMM=Oct"
if "%MM%"=="11" set "MMM=Nov"
if "%MM%"=="12" set "MMM=Dec"

REM Construct timestamp
set "timestamp=%DD%-%MMM%-%YYYY% %HH%:%Min%"

REM Copy timestamp to clipboard
echo %timestamp% | clip
echo Timestamp copied to clipboard: %timestamp%


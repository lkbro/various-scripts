@echo off
REM Get current date and time in the desired format
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set "YYYY=%datetime:~0,4%"
set "MM=%datetime:~4,2%"
set "DD=%datetime:~6,2%"
set "HH=%datetime:~8,2%"
set "Min=%datetime:~10,2%"

REM Construct timestamp in the desired format (YYYYMMDD HHmm)
set "timestamp=%YYYY%%MM%%DD% %HH%%Min%"

REM Copy timestamp to clipboard
echo %timestamp% | clip
echo Timestamp copied to clipboard: %timestamp%

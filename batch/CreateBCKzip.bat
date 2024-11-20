@echo off
setlocal

:: Extract the directory, filename, and extension of the file
set "FilePath=%~1"
set "FileDir=%~dp1"
set "FileName=%~n1"
set "FileExt=%~x1"

:: Create backup directory path relative to the file
set "BackupDir=%FileDir%_bck"

:: Generate timestamp for the file name
for /f "tokens=2 delims==" %%A in ('wmic OS Get localdatetime /value') do set datetime=%%A
set "datetime=%datetime:~0,4%%datetime:~4,2%%datetime:~6,2%_%datetime:~8,2%%datetime:~10,2%%datetime:~12,2%"

:: Construct new file name with timestamp
set "NewFileName=%FileName%_%datetime%%FileExt%"

:: Ensure the backup directory exists
if not exist "%BackupDir%" mkdir "%BackupDir%"

:: Copy the file to the backup directory with the new name
copy "%FilePath%" "%BackupDir%\%NewFileName%" >nul

:: Add the copied file to the 7-Zip archive
"C:\Program Files\7-Zip\7z.exe" a "%BackupDir%\%FileName%.7z" "%BackupDir%\%NewFileName%" >nul

:: Check and compress old files before deleting them
for /f "tokens=*" %%A in ('dir "%BackupDir%\%FileName%_*%FileExt%" /b /a-d ^| findstr /v /i "%datetime%"') do (
    :: Check if the file is already in the archive
    "C:\Program Files\7-Zip\7z.exe" l "%BackupDir%\%FileName%.7z" | findstr /i "%%A" >nul
    if errorlevel 1 (
        :: If not found in the archive, add the file to the archive
        "C:\Program Files\7-Zip\7z.exe" a "%BackupDir%\%FileName%.7z" "%BackupDir%\%%A" >nul
    )
    
    :: Delete the old file
    del "%BackupDir%\%%A" >nul
)

endlocal

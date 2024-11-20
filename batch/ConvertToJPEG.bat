@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
FOR %%A IN (%*) DO (
    "C:\Program Files\IrfanView\i_view64.exe" "%%~fA" /convert="%%~dpnA.jpg"
)

@echo off 
(netsh wlan show autoconfig | find /i "enabled")>nul
if %errorlevel% equ 0 (
    echo Disable autoconfig ...
    netsh wlan set autoconfig enabled=no interface="WiFi"
) else (
    echo Enable autoconfig ...
    netsh wlan set autoconfig enabled=yes interface="WiFi"
)
pause
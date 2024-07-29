@echo off

:: Проверка, запущен ли скрипт с правами администратора
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Перезапуск с правами администратора...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~fnx0' -Verb runAs"
    exit /b
)

:: Установка системного прокси
set PROXY_SERVER=213.109.227.99
set PROXY_PORT=8080

:: Устанавливаем системный прокси через реестр
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "%PROXY_SERVER%:%PROXY_PORT%" /t REG_SZ /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f

:: Пауза на 5 секунд
timeout /t 5 /nobreak

:: Скачивание сертификата
powershell -Command "Invoke-WebRequest -Uri https://burp/cert -OutFile %TEMP%\cacert.der"


:: Установка сертификата
certutil -addstore -f "Root" "%TEMP%\cacert.der"


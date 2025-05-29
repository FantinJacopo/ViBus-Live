@echo off
echo ========================================
echo    ViBus Live - Setup ngrok
echo ========================================
echo.

REM Verifica se esiste il file .env
if not exist ".env" (
    echo Creando file .env...
    copy ".env.example" ".env"
    echo.
    echo IMPORTANTE: Modifica il file .env con il tuo ngrok authtoken!
    echo 1. Vai su https://dashboard.ngrok.com/get-started/your-authtoken
    echo 2. Copia il tuo authtoken
    echo 3. Incollalo nel file .env alla riga NGROK_AUTHTOKEN=
    echo.
    pause
    exit /b 1
)

echo Verificando configurazione ngrok...
echo.

REM Leggi authtoken dal file .env
for /f "tokens=2 delims==" %%i in ('findstr "NGROK_AUTHTOKEN" .env') do set NGROK_TOKEN=%%i

if "%NGROK_TOKEN%"=="your_ngrok_authtoken_here" (
    echo ERRORE: ngrok authtoken non configurato nel file .env
    echo Modifica il file .env con il tuo vero authtoken.
    pause
    exit /b 1
)

if "%NGROK_TOKEN%"=="" (
    echo ERRORE: ngrok authtoken vuoto nel file .env
    pause
    exit /b 1
)

echo ✓ ngrok authtoken configurato
echo ✓ URL statico: more-elk-slightly.ngrok-free.app
echo.

echo Avviando servizi Docker con ngrok...
docker-compose up -d

echo.
echo ========================================
echo    Servizi Avviati
echo ========================================
echo.
echo InfluxDB (locale):     http://localhost:8086
echo InfluxDB (pubblico):   https://more-elk-slightly.ngrok-free.app
echo Node-RED:              http://localhost:1880
echo Grafana:               http://localhost:3000
echo ngrok Dashboard:       http://localhost:4040
echo.
echo MQTT Broker:           localhost:1883
echo.
echo ========================================
echo    Credenziali
echo ========================================
echo.
echo InfluxDB: admin / svt-password-123
echo Grafana:  admin / svt-admin-123
echo.
echo InfluxDB Token: svt-super-secret-token-123456789
echo Organizzazione: SVT-Vicenza
echo Bucket:         bus-data
echo.

echo Testando connessione ngrok...
timeout /t 5 >nul
powershell -Command "try { $response = Invoke-WebRequest -Uri 'https://more-elk-slightly.ngrok-free.app/ping' -Method GET -TimeoutSec 10; Write-Host '✓ ngrok tunnel attivo' } catch { Write-Host '✗ ngrok tunnel non raggiungibile' }"

echo.
echo ========================================
echo    Per l'App Android
echo ========================================
echo.
echo L'app Android è configurata per usare:
echo https://more-elk-slightly.ngrok-free.app/
echo.
echo Questo permette di testare l'app su:
echo - Dispositivi fisici
echo - Reti diverse
echo - Connessioni remote
echo.
echo Se vuoi usare localhost invece, modifica
echo NetworkConfig.kt e cambia CURRENT_BASE_URL
echo.
pause
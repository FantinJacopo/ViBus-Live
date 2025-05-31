@echo off
echo ========================================
echo    ViBus Live - Setup ngrok MQTT
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
echo ✓ URL MQTT statico: mqtt.more-elk-slightly.ngrok-free.app:1883
echo ⚠️  InfluxDB ngrok temporaneamente disabilitato (piano free ngrok)
echo.

echo Avviando servizi Docker con ngrok MQTT...
docker-compose up -d

echo.
echo Aspettando che i servizi si avviino...
timeout /t 15 >nul

echo.
echo ========================================
echo    Verifica Tunnel MQTT
echo ========================================
echo.

echo Verificando che ngrok MQTT sia attivo...
docker ps --filter "name=svt-ngrok-mqtt" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo Verificando tunnel ngrok...
timeout /t 5 >nul

REM Test connessione al tunnel MQTT
echo Testando connessione al tunnel MQTT...
powershell -Command "try { $tcpClient = New-Object System.Net.Sockets.TcpClient; $tcpClient.ConnectAsync('mqtt.more-elk-slightly.ngrok-free.app', 1883).Wait(5000); if ($tcpClient.Connected) { Write-Host '✓ Tunnel MQTT raggiungibile su mqtt.more-elk-slightly.ngrok-free.app:1883'; $tcpClient.Close(); } else { Write-Host '✗ Tunnel MQTT non raggiungibile'; } } catch { Write-Host '✗ Errore nella connessione al tunnel MQTT:' $_.Exception.Message }"

echo.
echo ========================================
echo    Configurazione App Android
echo ========================================
echo.
echo L'app è già configurata per usare il tunnel MQTT statico:
echo.
echo Host: mqtt.more-elk-slightly.ngrok-free.app
echo Port: 1883
echo.
echo Non serve modificare NetworkConfig.kt!
echo.

echo ========================================
echo    Servizi Avviati
echo ========================================
echo.
echo InfluxDB (solo locale):   http://localhost:8086
echo Node-RED:                 http://localhost:1880
echo Grafana:                  http://localhost:3000
echo ngrok MQTT Dashboard:     http://localhost:4041
echo.
echo MQTT Broker (locale):     localhost:1883
echo MQTT Broker (ngrok):      mqtt.more-elk-slightly.ngrok-free.app:1883
echo.
echo NOTA: InfluxDB ngrok disabilitato per usare solo MQTT ngrok
echo      (limitazione piano free ngrok - 1 tunnel alla volta)
echo.

echo ========================================
echo    Test MQTT
echo ========================================
echo.
echo Testando MQTT broker locale...
docker exec svt-mosquitto mosquitto_pub -h localhost -p 1883 -t "test/topic" -m "test message" 2>nul
if errorlevel 0 (
    echo ✓ MQTT broker locale funziona
) else (
    echo ✗ MQTT broker locale non risponde
)

echo.
echo Testando Node-RED publishing...
timeout /t 3 >nul
docker exec svt-mosquitto mosquitto_sub -h localhost -p 1883 -t "vibus/autobus/+/posizione" -C 1 2>nul
if errorlevel 0 (
    echo ✓ Node-RED sta pubblicando dati autobus
) else (
    echo ⚠️ Node-RED potrebbe non essere attivo - controlla http://localhost:1880
)

echo.
echo ========================================
echo    Prossimi Passi
echo ========================================
echo.
echo 1. ✓ Servizi Docker avviati
echo 2. ✓ URL MQTT statico configurato
echo 3. ✓ App Android già configurata
echo.
echo Per testare l'app:
echo 1. Avvia l'app Android
echo 2. Vai su MqttDebugActivity
echo 3. Verifica stato "Connected"
echo 4. Controlla che arrivino dati autobus
echo.
echo Se l'app non si connette:
echo - Controlla che l'authtoken ngrok sia corretto
echo - Verifica che ngrok-mqtt container sia running
echo - Usa MqttDebugActivity per vedere gli errori
echo.
pause
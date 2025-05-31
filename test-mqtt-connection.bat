@echo off
echo ========================================
echo    Test Connessione MQTT ViBus
echo ========================================
echo.

echo Verificando che Docker sia avviato...
docker ps >nul 2>&1
if errorlevel 1 (
    echo ERRORE: Docker non avviato o non accessibile
    pause
    exit /b 1
)

echo ✓ Docker è in esecuzione
echo.

echo Controllando container Mosquitto...
docker ps --filter "name=svt-mosquitto" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
echo Testando connessione MQTT locale...
echo.

REM Test con mosquitto_pub/mosquitto_sub se disponibili
where mosquitto_pub >nul 2>&1
if not errorlevel 1 (
    echo Usando mosquitto_pub per test...
    start /B mosquitto_sub -h localhost -p 1883 -t "vibus/autobus/+/posizione" -v
    timeout /t 2 >nul
    mosquitto_pub -h localhost -p 1883 -t "vibus/autobus/TEST01/posizione" -m "{\"bus_id\":\"TEST01\",\"line\":\"1\",\"line_name\":\"Test Line\",\"position\":{\"lat\":45.5477,\"lon\":11.5458},\"speed\":25.0,\"bearing\":90,\"delay\":0.0,\"passengers\":10,\"status\":\"in_service\",\"timestamp\":\"2025-01-01T12:00:00Z\"}"
    echo Messaggio di test inviato
) else (
    echo mosquitto_pub non trovato, usando Docker...
    docker exec svt-mosquitto mosquitto_pub -h localhost -p 1883 -t "vibus/autobus/TEST01/posizione" -m "{\"bus_id\":\"TEST01\",\"line\":\"1\",\"line_name\":\"Test Line\",\"position\":{\"lat\":45.5477,\"lon\":11.5458},\"speed\":25.0,\"bearing\":90,\"delay\":0.0,\"passengers\":10,\"status\":\"in_service\",\"timestamp\":\"2025-01-01T12:00:00Z\"}"
    echo Messaggio di test inviato via Docker
)

echo.
echo ========================================
echo    Informazioni di Rete
echo ========================================
echo.

echo IP del PC su rete locale:
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /i "IPv4"') do echo %%a

echo.
echo Configurazioni per l'app Android:
echo.
echo Per EMULATORE Android:
echo   MQTT Host: 10.0.2.2
echo   MQTT Port: 1883
echo.
echo Per DISPOSITIVO FISICO:
echo   MQTT Host: [IP del PC mostrato sopra]
echo   MQTT Port: 1883
echo.
echo Verifica che il container mosquitto sia in ascolto su:
docker exec svt-mosquitto netstat -ln | findstr 1883

echo.
pause
@echo off
echo ========================================
echo    ViBus Live - Creazione Pacchetto Condivisione
echo ========================================
echo.

REM Crea cartella condivisione
if exist "ViBus-Live-Share" rmdir /s /q "ViBus-Live-Share"
mkdir "ViBus-Live-Share"

REM Copia file essenziali
echo Copiando file di configurazione...
copy "docker-compose.yml" "ViBus-Live-Share\"
xcopy "mosquitto" "ViBus-Live-Share\mosquitto\" /E /I /Q

REM Crea cartelle vuote necessarie
mkdir "ViBus-Live-Share\flows"
mkdir "ViBus-Live-Share\docs"
mkdir "ViBus-Live-Share\scripts"

REM Crea file README
echo Creando README...
echo # ViBus Live - Monitoring Autobus Vicenza > "ViBus-Live-Share\README.md"
echo. >> "ViBus-Live-Share\README.md"
echo ## Avvio Rapido >> "ViBus-Live-Share\README.md"
echo 1. Installa Docker Desktop >> "ViBus-Live-Share\README.md"
echo 2. Apri Command Prompt in questa cartella >> "ViBus-Live-Share\README.md"
echo 3. Esegui: docker-compose up -d >> "ViBus-Live-Share\README.md"
echo 4. Vai su http://localhost:1880 (Node-RED) >> "ViBus-Live-Share\README.md"
echo 5. Vai su http://localhost:3000 (Grafana, admin/admin) >> "ViBus-Live-Share\README.md"
echo. >> "ViBus-Live-Share\README.md"
echo ## Credenziali >> "ViBus-Live-Share\README.md"
echo - Grafana: admin / admin (cambia al primo accesso) >> "ViBus-Live-Share\README.md"
echo - InfluxDB: admin / vibus-admin-2025 >> "ViBus-Live-Share\README.md"

REM Crea script avvio
echo Creando script di avvio...
echo @echo off > "ViBus-Live-Share\avvia-vibus.bat"
echo echo Avviando ViBus Live... >> "ViBus-Live-Share\avvia-vibus.bat"
echo docker-compose up -d >> "ViBus-Live-Share\avvia-vibus.bat"
echo echo. >> "ViBus-Live-Share\avvia-vibus.bat"
echo echo ViBus Live avviato! >> "ViBus-Live-Share\avvia-vibus.bat"
echo echo Node-RED: http://localhost:1880 >> "ViBus-Live-Share\avvia-vibus.bat"
echo echo Grafana: http://localhost:3000 >> "ViBus-Live-Share\avvia-vibus.bat"
echo echo InfluxDB: http://localhost:8086 >> "ViBus-Live-Share\avvia-vibus.bat"
echo pause >> "ViBus-Live-Share\avvia-vibus.bat"

echo.
echo ========================================
echo    Pacchetto creato in: ViBus-Live-Share
echo ========================================
echo.
echo Prossimi passi:
echo 1. Comprimi la cartella ViBus-Live-Share in ZIP
echo 2. Condividi il file ZIP con il compagno
echo 3. Il compagno estrae e lancia avvia-vibus.bat
echo.
pause
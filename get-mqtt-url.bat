@echo off
echo ========================================
echo    Recupera URL ngrok MQTT
echo ========================================
echo.

echo Interrogando API ngrok per tunnel MQTT...
echo.

powershell -Command "try { $response = Invoke-RestMethod -Uri 'http://localhost:4041/api/tunnels' -Method GET -TimeoutSec 10; $mqttTunnel = $response.tunnels | Where-Object { $_.config.addr -like '*mosquitto:1883*' }; if ($mqttTunnel) { Write-Host '✓ Tunnel MQTT attivo!'; Write-Host ''; Write-Host 'URL completo:' $mqttTunnel.public_url; $url = $mqttTunnel.public_url; $parts = $url -replace 'tcp://', '' -split ':'; $host = $parts[0]; $port = $parts[1]; Write-Host 'Host:' $host; Write-Host 'Port:' $port; Write-Host ''; Write-Host '=============================='; Write-Host '  Aggiorna NetworkConfig.kt'; Write-Host '=============================='; Write-Host ''; Write-Host 'const val MQTT_BROKER_HOST_NGROK = \"' $host '\"'; Write-Host 'const val MQTT_BROKER_PORT_NGROK =' $port; Write-Host ''; Write-Host 'Oppure usa questi valori nell' + 'app Android.'; Write-Host ''; Write-Host 'Test connessione TCP...'; $tcpClient = New-Object System.Net.Sockets.TcpClient; try { $tcpClient.ConnectAsync($host, $port).Wait(5000) | Out-Null; if ($tcpClient.Connected) { Write-Host '✓ Connessione TCP riuscita!'; $tcpClient.Close(); } else { Write-Host '✗ Connessione TCP fallita'; } } catch { Write-Host '✗ Errore TCP:' $_.Exception.Message; } } else { Write-Host '✗ Nessun tunnel MQTT trovato.'; Write-Host 'Verifica che il container ngrok-mqtt sia running:'; Write-Host 'docker ps | findstr ngrok-mqtt'; } } catch { Write-Host '✗ Errore API ngrok:' $_.Exception.Message; Write-Host ''; Write-Host 'Verifica manualmente su: http://localhost:4041'; }"

echo.
echo ========================================
echo    Dashboard ngrok
echo ========================================
echo.
echo Apri nel browser: http://localhost:4041
echo Cerca il tunnel TCP per mosquitto:1883
echo.

echo ========================================
echo    Container Status
echo ========================================
echo.
docker ps --filter "name=ngrok" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo.
pause
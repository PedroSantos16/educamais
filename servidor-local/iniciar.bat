@echo off
chcp 65001 >nul
cd /d "%~dp0.."
echo === Educa+ : subindo banco e API (a primeira vez leva alguns minutos) ===
docker compose up -d --build
if errorlevel 1 (
  echo.
  echo Falhou. Verifique se o Docker Desktop esta aberto.
  pause
  exit /b 1
)
echo.
echo Aguardando a API responder...
:espera
powershell -NoProfile -Command "try { Invoke-WebRequest -UseBasicParsing http://localhost:8080/api/auth/contas-teste -TimeoutSec 3 | Out-Null; exit 0 } catch { exit 1 }"
if errorlevel 1 ( timeout /t 3 >nul & goto espera )
echo.
echo ===========================================================
echo  API no ar!
echo  Navegador (este PC):  http://localhost:8080
echo  Emulador Android:     http://10.0.2.2:8080
for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -and $_.NetAdapter.Status -eq 'Up' } | ForEach-Object { $_.IPv4Address.IPAddress }"`) do echo  Celular (mesma rede): http://%%i:8080
echo.
echo  Se o celular nao conectar: Configuracoes do Windows ^> Rede ^> marque a rede como PRIVADA
echo ===========================================================
start http://localhost:8080
pause

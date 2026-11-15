@echo off
cd /d "%~dp0.."
docker compose down
echo Servidor parado. (Os dados ficam salvos; para zerar o banco use: docker compose down -v)
pause

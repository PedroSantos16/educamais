#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."
echo "=== Educa+ : subindo banco e API (a primeira vez leva alguns minutos) ==="
docker compose up -d --build
echo "Aguardando a API responder..."
until curl -fs http://localhost:8080/api/auth/contas-teste >/dev/null; do sleep 3; done
IP=$( (ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}') )
echo
echo "API no ar!"
echo "  Navegador (este PC):  http://localhost:8080"
echo "  Emulador Android:     http://10.0.2.2:8080"
[ -n "$IP" ] && echo "  Celular (mesma Wi-Fi): http://$IP:8080"

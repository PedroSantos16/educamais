# Educa+ — servidor local

Sobe o banco MySQL (já com a escola de demonstração) e a API com um comando só.

## Pré-requisito
- **Docker Desktop** instalado e aberto: https://www.docker.com/products/docker-desktop/
  Não precisa instalar MySQL, Java nem Maven.

## Como rodar
- **Windows:** dê dois cliques em `servidor-local\iniciar.bat`
- **Linux/macOS:** `./servidor-local/iniciar.sh`
- **Manual:** na pasta do projeto, `docker compose up -d --build`

A primeira vez leva alguns minutos (baixa as imagens e compila a API). Depois sobe em segundos.

## Endereços da API
| Onde | Endereço |
|---|---|
| Navegador no computador | http://localhost:8080 |
| Emulador Android | http://10.0.2.2:8080 |
| Celular na mesma Wi-Fi | http://IP_DO_COMPUTADOR:8080 (o `iniciar.bat` mostra) |

No celular, toque em **Configurar servidor** no app e informe o endereço.
Se não conectar, libere o Docker/Java no Firewall do Windows em **Redes privadas**.

## Outros comandos
- Parar: `servidor-local\parar.bat` ou `docker compose down`
- Ver logs da API: `docker compose logs -f api`
- Zerar o banco e recarregar os dados demo: `docker compose down -v` e depois iniciar de novo
- Acessar o MySQL pelo Workbench: `localhost:3306`, usuário `root`, senha `1234`

> Se já houver um MySQL rodando na porta 3306 do seu PC, troque `"3306:3306"` por `"3307:3306"` no `docker-compose.yml`.

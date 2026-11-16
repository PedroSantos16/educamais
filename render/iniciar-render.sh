#!/usr/bin/env bash
# Sobe o MySQL local do container, carrega o banco de demonstração e inicia a API.
set -e
DATA=/var/lib/mysql
mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld

if [ ! -d "$DATA/educa_mais" ]; then
  echo ">> Inicializando MySQL"
  rm -rf "$DATA"/* 2>/dev/null || true
  mysqld --defaults-extra-file=/etc/mysql/conf.d/educa.cnf --initialize-insecure --user=mysql --datadir="$DATA"
fi

mysqld --defaults-extra-file=/etc/mysql/conf.d/educa.cnf --user=mysql --datadir="$DATA" &
for i in $(seq 1 60); do mysqladmin -uroot ping >/dev/null 2>&1 && break; mysqladmin -uroot -p"$DB_PASS" ping >/dev/null 2>&1 && break; sleep 1; done

if ! mysql -uroot -p"$DB_PASS" -e "SELECT 1 FROM educa_mais.usuario LIMIT 1" >/dev/null 2>&1; then
  echo ">> Carregando banco de demonstração"
  mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PASS'" 2>/dev/null || true
  for f in /app/banco/01_schema.sql /app/banco/02_dados_demo.sql; do
    mysql -uroot -p"$DB_PASS" --default-character-set=utf8mb4 < "$f"
  done
fi
echo ">> Banco pronto"

exec java -XX:+UseSerialGC -Xss512k -Xmx170m -XX:MaxMetaspaceSize=128m -XX:ReservedCodeCacheSize=40m \
  -XX:TieredStopAtLevel=1 -Dserver.port="${PORT:-8080}" -jar /app/app.jar

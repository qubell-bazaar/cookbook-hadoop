export PGPASSWORD=`cat /var/lib/cloudera-scm-server-db/data/generated_password.txt | awk '{ if (!RES) { RES = $1 } } END { print RES }'`

psql -h localhost -U cloudera-scm -p 7432 -c "CREATE DATABASE metastore" postgres
psql -h localhost -U cloudera-scm -p 7432 -c "CREATE USER hive WITH PASSWORD 'hive'" postgres
psql -h localhost -U cloudera-scm -p 7432 -c "GRANT ALL PRIVILEGES ON DATABASE metastore TO hive" postgres

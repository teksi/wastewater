
docker compose exec db dropdb -U postgres tww
docker compose exec db createdb -U postgres tww

docker compose exec db pum -vvv -s pg_tww -d datamodel install -p SRID 2056 --roles --grant

docker compose run qgis sh -c 'xvfb-run /usr/src/plugin/tww_cmd.py interlis_import --xtf_file /usr/src/plugin/teksi_wastewater/tests/data/test-dataset-organisations.xtf --pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432'
docker compose run qgis sh -c 'xvfb-run /usr/src/plugin/tww_cmd.py interlis_import --xtf_file /usr/src/plugin/teksi_wastewater/tests/data/test-dataset-DSS.xtf --pghost db --pgdatabase tww --pguser postgres --pgpass postgres --pgport 5432'

docker compose exec db pg_dump --inserts --data-only --no-owner --no-privileges --schema=tww_od -U postgres tww > demo_data.sql

# Remove select set_config
sed -i '/^SELECT pg_catalog\.set_config/d' demo_data.sql

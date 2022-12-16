# Restoring pg_dump and Debezium

In one of the projects at work, I had to automate the restoration of PostgreSQL DB from a dump. I chose a standard
`pg_dump/pg_restore` tooling so far it's very straightforward using them.

In this post, I will list the issues with [Debezium](https://debezium.io/)(a kafka-connector for CDC) I discovered in this project.

## Issue with Heartbeat

You can create a special table that Debezium will update periodically, and by doing it, Debezium will check if
the DB is available. That's what heartbeat means here.

So far, it takes time to restore the database; it can take longer than the heartbeat interval(can be 500ms). In that case
Debezium instance will panic and crash. But it should not be a problem so far k8s(in our case) will restart the crashed pod, and the error
will resolve, though it might raise an alert. So additional steps to disable Debezium temporarily can be necessary.

An error can look like this:
```text
io.debezium.DebeziumException: Could not execute heartbeat action (Error: 57P01)
```

## Issue "Publication does not exist"

It was discovered in one of the runs that Debezium could not use restored publication and fail with an error like:
```text
Caused by: org.postgresql.util.PSQLException: ERROR: publication "dbz_publication" does not exist
  Where: slot "debezium_NAME_slot", output plugin "pgoutput", in the change callback, associated LSN 1160/57399A78
```

To avoid it when using `pg_restore`, the script should use `--no-publications` and `--no-subscriptions` options
so existing publications and slots won't be affected.

It was tested in the following scenario:

```bash
docker-compose up -d
# create a connector
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-postgres.json
```
```bash
docker-compose exec postgres bash -c 'psql -U user my_db'
# ...and create a table with records
# create table t1 (c1 varchar not null unique, c2 integer default 0);
# insert into t1 (c1, c2) values ('apple', 1), ('potato', 2), ('banana', 3);
```
```bash
# pg_dump -d 'postgres://user:123456@localhost/my_db' --no-privileges --no-owner -Fc --clean --if-exists > local-dump.txt
pg_restore -d 'postgres://user:123456@localhost/my_db' --no-privileges --no-owner -Fc --clean --if-exists \
  --no-subscriptions --no-publications < local-dump.txt
# there should not be errors in the logs
docker-compose logs -f connect
```
```bash
# to check if debezium produced messages
docker-compose exec kafka /bin/kafka-console-consumer --bootstrap-server kafka:9092 --from-beginning --property print.key=true --topic md_debezium.public.t1
```

Additional materials are in [assets folder](./assets/debezium) folder.

## [Potential issue]Debezium produces messages from the restored dump

Despite saying that [Debezium captures row-level changes](https://debezium.io/documentation/reference/stable/connectors/postgresql.html), the connector
generates messages out of restored records by `COPY` command. It's also true that `COPY` command will add to WAL - [see](https://www.postgresql.org/docs/current/populate.html#POPULATE-COPY-FROM).

It can be an issue if we restore many records, so the restoration will probably create an unnecessary volume of messages in the staging cluster.
At the same time, the idea is to avoid copying so-called historical data, meaning that we should prepare thin dumps to restore only the relevant data.

## Addition links

- [Making Sense of Change Data Capture Pipelines for Postgres with Debezium Kafka Connector](https://web.archive.org/web/20220820044741/https://turkogluc.com/postgresql-capture-data-change-with-debezium/)
- [Setting up PostgreSQL for Debezium](https://elephanttamer.net/?p=50)

https://superset.incubator.apache.org/installation.html

|database|pypi package|SQLAlchemy URI prefix|
|----|----|----|
|Amazon Athena   |pip install "PyAthenaJDBC>1.0.9"     |awsathena+jdbc://         |
|Amazon Athena   |pip install "PyAthena>1.2.0"         |awsathena+rest://         |
|Amazon Redshift |pip install sqlalchemy-redshift      |redshift+psycopg2://      |
|Apache Drill    |pip install sqlalchemy-drill         |For the REST API:`` drill+sadrill:// For JDBC drill+jdbc://|
|Apache Druid    |pip install pyduid                   |druid://                  |
|Apache Hive     |pip install pyhive                   |hive://                   |
|Apache Impala   |pip install impyla                   |impala://                 |
|Apache Kylin    |pip install kylinpy                  |kylin://                  |
|Apache Pinot    |pip install pinotdb                  |pinot+http://CONTROLLER:5436/ query?server=http://CONTROLLER:5983/|
|Apache Spark SQL|pip install pyhive                   |jdbc+hive://              |
|BigQuery        |pip install pybigquery               |bigquery://               |
|ClickHouse      |pip install sqlalchemy-clickhouse    ||
|Google Sheets   |pip install gsheetsdb                |gsheets://                |
|IBM Db2         |pip install ibm_db_sa                |db2+ibm_db://             |
|MySQL           |pip install mysqlclient              |mysql://                  |
|Oracle          |pip install cx_Oracle                |oracle://                 |
|PostgreSQL      |pip install psycopg2                 |postgresql+psycopg2://    |
|Presto          |pip install pyhive                   |presto://                 |
|Snowflake       |pip install snowflake-sqlalchemy     |snowflake://              |
|SQLite          |                                     |sqlite://                 |
|SQL Server      |pip install pymssql                  |mssql://                  |
|Teradata        |pip install sqlalchemy-teradata      |teradata://               |
|Vertica         |pip install sqlalchemy-vertica-python|vertica+vertica_python:// |
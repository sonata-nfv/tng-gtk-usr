#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	CREATE USER tango;
	CREATE DATABASE tango;
	GRANT ALL PRIVILEGES ON DATABASE tango TO tango;
EOSQL


psql -U tango -d tango -c "CREATE TABLE USERS (NAME varchar(40), PASSWORD varchar(40), EMAIL varchar(40) PRIMARY KEY, ROLE varchar(40))"

psql  -U tango -c "INSERT INTO USERS (NAME, PASSWORD, EMAIL, ROLE) VALUES ('paco', 'paco', 'paco@paco', 'admin')"
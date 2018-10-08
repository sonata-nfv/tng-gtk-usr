#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	CREATE USER sonatatest;
	CREATE DATABASE gatekeeper;
	GRANT ALL PRIVILEGES ON DATABASE gatekeeper TO sonatatest;
EOSQL


psql -h 172.18.0.2 -U sonatatest -d gatekeeper -c "CREATE TABLE USERS (NAME varchar(40), PASSWORD varchar(40), EMAIL varchar(40) PRIMARY KEY, ROLE varchar(40), STATUS varchar(40))"

psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO USERS (NAME, PASSWORD, EMAIL, ROLE, STATUS) VALUES ('paco', 'paco', 'paco@paco', 'admin', 'active')"


psql -h 172.18.0.2 -U sonatatest -d gatekeeper -c "CREATE TABLE ROLES (ROLE varchar(40), ENDPOINT varchar(40))"

psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('admin', 'pings')"
psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('admin', 'packages')"
psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('admin', 'services')"
psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('admin', 'functions')"
psql -h 172.18.0.2  -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('admin', 'requests')"
psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('admin', 'records')"
psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('admin', 'slices')"
psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('admin', 'slice-instances')"
psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('admin', 'descriptors')"
psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('admin', 'policies')"
psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('admin', 'slas')"


psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('developer', 'pings')"
psql  -h 172.18.0.2 -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('developer', 'packages')"
psql  -h 172.18.0.2  -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('developer', 'services')"
psql  -h 172.18.0.2  -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('developer', 'functions')"
psql  -h 172.18.0.2  -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('developer', 'requests')"
psql  -h 172.18.0.2  -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('developer', 'records')"


psql  -h 172.18.0.2  -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('customer', 'pings')"
psql  -h 172.18.0.2  -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('customer', 'packages')"
psql  -h 172.18.0.2  -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('customer', 'services')"
psql  -h 172.18.0.2  -U sonatatest -d gatekeeper -c "INSERT INTO ROLES (ROLE, ENDPOINT) VALUES ('customer', 'functions')"

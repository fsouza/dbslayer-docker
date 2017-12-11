#!/bin/sh -e

if [ -z "$MYSQL_HOST" ]; then
	echo >&2 "missing env var MYSQL_HOST"
	exit 2
fi

if [ -z "$MYSQL_USER" ]; then
	echo >&2 "missing env var MYSQL_USER"
	exit 2
fi

if [ -z "$MYSQL_PASSWORD" ]; then
	echo >&2 "missing env var MYSQL_PASSWORD"
	exit 2
fi

if [ -z "$MYSQL_DATABASE" ]; then
	echo >&2 "missing env var MYSQL_DATABASE"
	exit 2
fi

sed "s/@@HOST@@/$MYSQL_HOST/" /etc/my.cnf.template | \
	sed "s/@@PORT@@/$MYSQL_PORT/" | \
	sed "s/@@USER@@/$MYSQL_USER/" | \
	sed "s/@@PASSWORD@@/$MYSQL_PASSWORD/" | \
	sed "s/@@DATABASE@@/$MYSQL_DATABASE/" > /etc/my.cnf
exec /usr/bin/dbslayer -s dbslayer -c /etc/my.cnf -d 1 "$@"

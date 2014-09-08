#! /bin/sh
. ../inc/config.sh
if [ "$DBNAME" = "" ]; then
    echo "ERR: DBNAME non défini dans inc/config.sh";
    exit;
fi
if [ "$DBPASS" = "" ]; then
    echo "ERR: DBPASS non défini dans inc/config.sh";
    exit;
fi
if [ "$DBUSER" = "" ]; then
    echo "ERR: DBUSER non défini dans inc/config.sh";
    exit;
fi
(echo "BEGIN TRANSACTION;"; cat *.sql; echo 'COMMIT;') |  PGPASSWORD=$DBPASS psql -h localhost -U $DBUSER $DBNAME

#!/bin/bash

echo "================================================================================"
# Please Confirm Backup Location(DIR) and Database Name (DBNAME). Don't add '/' slash at end for DIR.
# DBNAME (#1 stands for first argument while running this script (see in /etc/crontab)).
DBNAME=$1
DIR="/odoo/backups/$DBNAME"

MIN_BKP_SIZE=90
PGDUMP=`which pg_dump`

TIME=`date +%Y%m%d_%H%M`
YEAR=`date +%Y`
MONTH=`date +%m`
HOUR=`date +%H`
DAY=`date +%d`
MONTHNAME=`date +%b`

DB_DUMP_FILE="$DIR/$DBNAME-$TIME.dump"
echo "DB Backup Script Start: $DBNAME."

sudo -u postgres -H $PGDUMP --no-owner --format=c --file="$DB_DUMP_FILE" "$DBNAME"
echo " "

echo "Backup completed! Please Confirm Backup."
echo " "
ls -ltrh "$DB_DUMP_FILE"
echo " "
cat "$DB_DUMP_FILE" | tail -n10
echo " "

FILESIZE=$(du -k "$DB_DUMP_FILE" | cut -f 1)
if [ ! -f  "$DB_DUMP_FILE" ]; then
    echo "$DB_DUMP_FILE File not found!"
else
    echo "$DB_DUMP_FILE File found, Actual size after compression is $FILESIZE "
    if [ $MONTH -eq 1 ]; then
        if [ $DAY -eq 1 ]; then
            mv "$DB_DUMP_FILE" "$DIR/$YEAR-$MONTHNAME-$DBNAME-$TIME.dump"
        fi
    else
        if [ $DAY -eq 1 ]; then
            mv "$DB_DUMP_FILE" "$DIR/$MONTHNAME-$DBNAME-$TIME.dump"
        fi
    fi
fi
echo " "

if [ $FILESIZE -ge $MIN_BKP_SIZE ]; then
    if [ $(date +%u) -lt 7 ]; then
        BEFORE7DAYS=`date --date @$(($(date +%s) - 7 * 24 * 60 * 60)) +%Y%m%d`
        DELETEFILE=$(eval "ls $(echo $DIR/$DBNAME-$BEFORE7DAYS | sed 's/ /\\ /g')*.dump")
        if [ -f "$DELETEFILE" ]; then
            echo "Deleting $DELETEFILE."
            rm "$DELETEFILE"
        fi
    else
        BEFORE35DAYS=`date --date @$(($(date +%s) - 35 * 24 * 60 * 60)) +%Y%m%d`
        DELETEFILE=$(eval "ls $(echo $DIR/$DBNAME-$BEFORE35DAYS | sed 's/ /\\ /g')*.dump")
        if [ -f  "$DELETEFILE" ]; then
            echo "Deleting $DELETEFILE."
            rm "$DELETEFILE"
        fi
    fi
else
    echo "Backup File Size is empty!"
fi
echo ""

echo "DB Backup Script Completed: $TIME."
echo "================================================================================"

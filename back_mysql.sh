#!/bin/bash
NOW=$( date +%d-%m-%YT%H:%I:%S )
PAST_MONTH=$( date +%d-%m-%YT%H:%I:%S -d "-1 month")

MYSQL_USERNAME=username
MYSQL_HOST=host
MYSQL_PASSWD=passwd
MYSQL_DB=database

BKP_FILE=~/backup/$MYSQL_DB.$NOW.sql
BKP_FILE_GZ=$BKP_FILE.tar.gz

mysqldump -u $MYSQL_USERNAME --host=$MYSQL_HOST --password=$MYSQL_PASSWD $MYSQL_DB > $BKP_FILE
tar -czf $BKP_FILE_GZ $BKP_FILE

#delete files older than 30 days
for f in $( find ~/backup/* -mtime +30 ); do
    rm $f
done



===================
#!/bin/bash

# mysql setup
MYSQL_USER='db-username'
MYSQL_PASS='db-password'

DATE=`date +%Y%m%d`
DIR="/backup"

mkdir $DIR/$DATE
mkdir $DIR/$DATE/mysql

for i in `echo "show databases" | mysql -u$MYSQL_USER -p$MYSQL_PASS | grep -v Database` 
    do 
    mysqldump  -u$MYSQL_USER -p$MYSQL_PASS --database $i > $DIR/$DATE/mysql/$i 
    gzip $DIR/$DATE/mysql/$i
done
tar -czvf $DIR/$DATE/mysql.tar.gz $DIR/$DATE/mysql
rm -rf $DIR/$DATE/mysql

# clean files old more than 7 days
TODAY=`date +%s`
DAY=86400

ls $DIR | while read file
do
    MOD_DATE=`stat --format=%Y $DIR/${file}`
    DIFF=$(((TODAY-MOD_DATE)/DAT))
    if [ $DIFF -gt 7 ] ; then
        echo "File ${file} is older then 7 days - removeing..."
        rm -rf $DIR/${file}
    fi
done

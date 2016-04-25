#!/bin/bash
CURRENTDATETIME=`date +"%Y%m%d%H%M%S"`
DUMPDIR=/root/Scripts/backupfiles
LOGDIR=/root/Scripts/logs/
ERROR=0

exec > ${LOGDIR}/dbdumb-nas-${CURRENTDATETIME}.log 2>&1
set -x


/usr/bin/mysqldump -u takizo -p5N9jMPuS8jb2c --no-create-info --complete-insert takizo > $DUMPDIR/takizo-data-only-$CURRENTDATETIME.sql
STtakizoDUMP=$?

/bin/tar -zcf $DUMPDIR/takizo-data-only-$CURRENTDATETIME.tar.gz $DUMPDIR/takizo-data-only-$CURRENTDATETIME.sql
/bin/mv $DUMPDIR/takizo-data-only-$CURRENTDATETIME.tar.gz /mnt/nas_website_backup/mysql/
/bin/rm -rf $DUMPDIR/takizo-data-only-$CURRENTDATETIME.sql

/usr/bin/mysqldump -u takizo -p5N9jMPuS8jb2c takizo > $DUMPDIR/takizo-full-$CURRENTDATETIME.sql
STtakizoFULLDUMP=$?

/bin/tar -zcf $DUMPDIR/takizo-full-$CURRENTDATETIME.tar.gz $DUMPDIR/takizo-full-$CURRENTDATETIME.sql
/bin/mv $DUMPDIR/takizo-full-$CURRENTDATETIME.tar.gz /mnt/nas_website_backup/mysql/
/bin/rm -rf $DUMPDIR/takizo-full-$CURRENTDATETIME.sql

/usr/bin/mysqldump -u TAKIZOIXweb -pw3bb.com1x8#%% --no-create-info --complete-insert TAKIZOIXweb > $DUMPDIR/TAKIZOIXweb-data-only-$CURRENTDATETIME.sql
STTAKIZOIXWEBDATADUMP=$?

/bin/tar -zcf $DUMPDIR/TAKIZOIXweb-data-only-$CURRENTDATETIME.tar.gz $DUMPDIR/TAKIZOIXweb-data-only-$CURRENTDATETIME.sql
/bin/mv $DUMPDIR/TAKIZOIXweb-data-only-$CURRENTDATETIME.tar.gz /mnt/nas_website_backup/mysql/
/bin/rm -rf $DUMPDIR/TAKIZOIXweb-data-only-$CURRENTDATETIME.sql

/usr/bin/mysqldump -u TAKIZOIXweb -pw3bb.com1x8#%% TAKIZOIXweb > $DUMPDIR/TAKIZOIXweb-full-$CURRENTDATETIME.sql
STTAKIZOIXWEBFULLDUMP=$?

/bin/tar -zcf $DUMPDIR/TAKIZOIXweb-full-$CURRENTDATETIME.tar.gz $DUMPDIR/TAKIZOIXweb-full-$CURRENTDATETIME.sql
/bin/mv $DUMPDIR/TAKIZOIXweb-full-$CURRENTDATETIME.tar.gz /mnt/nas_website_backup/mysql/
/bin/rm -rf $DUMPDIR/TAKIZOIXweb-full-$CURRENTDATETIME.sql

if [ ${STtakizoDUMP} -eq 0 ] && [ ${STtakizoFULLDUMP} -eq 0 ] && [ ${STTAKIZOIXWEBDATADUMP} -eq 0 ] && [ ${STTAKIZOIXWEBFULLDUMP} -eq 0 ]; then
        ERROR=0
else
        ERROR=1
fi

if [ ${ERROR} -eq 1 ]
then
        echo "There were error during database backup at ${CURRENTDATETIME}" | /bin/mail -s 'Weekly Database backup error' email@null.com
fi

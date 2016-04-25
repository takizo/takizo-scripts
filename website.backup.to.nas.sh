#!/bin/bash
CURRENTDATETIME=`date +"%Y%m%d%H%M%S"`

DIRTAKIZOIXCP=/mnt/nas_website_backup/web/$CURRENTDATETIME/TAKIZOIXcp/
DIRTAKIZOIXWEB=/mnt/nas_website_backup/web/$CURRENTDATETIME/TAKIZOIXweb/
DIRTAKIZOIXINMON=/mnt/nas_website_backup/web/$CURRENTDATETIME/inmon/
LOGDIR=/root/Scripts/logs/
ERROR=0

exec > ${LOGDIR}/webbackup-nas-${CURRENTDATETIME}.log 2>&1
set -x


/bin/mkdir -p $DIRTAKIZOIXCP
STMKDIRTAKIZOIXCP=$?

/bin/mkdir -p $DIRTAKIZOIXWEB
STMKDIRTAKIZOIXWEB=$?

/bin/mkdir -p $DIRTAKIZOIXINMON
STMKDIRTAKIZOIXINMON=$?

/usr/bin/rsync -avz --progress --exclude 'logs' /opt/www/TAKIZOIXcp.takizo.com $DIRTAKIZOIXCP
STRSYNCTAKIZOIXCP=$?

/usr/bin/rsync -avz --progress --exclude 'logs' /opt/www/TAKIZOIXweb.takizo.com $DIRTAKIZOIXWEB
STRSYNCTAKIZOIXWEB=$?

/usr/bin/rsync -avz --progress --exclude 'logs' /opt/www/theportal.TAKIZOIX.com $DIRTAKIZOIXINMON
STRSYNCTAKIZOIXCPORT=$?

/usr/bin/rsync -avz --progress /etc/httpd/conf.d /mnt/nas_website_backup/web/$CURRENTDATETIME/
/usr/bin/rsync -avz --progress /etc/httpd/conf /mnt/nas_website_backup/web/$CURRENTDATETIME/
/usr/bin/rsync -avz --progress /etc/httpd/ssl /mnt/nas_website_backup/web/$CURRENTDATETIME/

/bin/tar -zcf /mnt/nas_website_backup/web/$CURRENTDATETIME.tar.gz /mnt/nas_website_backup/web/$CURRENTDATETIME
STTARFILE=$?

/bin/rm -rf /mnt/nas_website_backup/web/$CURRENTDATETIME

if [ ${STMKDIRTAKIZOIXCP} -eq 0 ] && [ ${STMKDIRTAKIZOIXWEB} -eq 0 ] && [ ${STMKDIRTAKIZOIXINMON} -eq 0 ] && [ ${STRSYNCTAKIZOIXCP} -eq 0 ] && [ ${STRSYNCTAKIZOIXWEB} -eq 0 ] && [ ${STRSYNCTAKIZOIXCPORT} -eq 0 ] && [ ${STTARFILE} -eq 0 ]
then
    ERROR=0
else
    ERROR=1
fi

if [ ${ERROR} -eq 1 ]
then
  echo "Error backup website file ${CURRENTDATETIME} " | /bin/mail -s 'Error backup website files' email@null.com
fi

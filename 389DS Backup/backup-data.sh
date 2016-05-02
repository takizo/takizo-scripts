#!/bin/bash

TODAY=`/bin/date +%Y%m%d%H%M`
DIRSERVICE=/etc/init.d/dirsrv
BKCMD=/usr/lib64/dirsrv/slapd-noreplied/db2bak
BKDIR=/var/lib/dirsrv/slapd-noreplied/bak/

# Stop the service
${DIRSERVICE} stop
${BKCMD} ${BKDIR}${TODAY}
${DIRSERVICE} start

## Backup another copy to remote server
/usr/bin/rsync -avz ${BKDIR}${TODAY} root@backup.noreplied.com.local:/opt/389DS-Backup/

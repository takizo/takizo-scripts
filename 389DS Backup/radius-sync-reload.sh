#!/bin/bash

SYNC=`/usr/bin/rsync -avz --exclude 'modules/ldap' /etc/raddb root@serv.noreplied.com.local:/etc/`
SYNCST=$?

TRACK=`echo ${SYNC} | /bin/awk '{print $5}'`

if [ ${TRACK} != 'sent' ]; then
        RELOADRADIUS=`ssh root@serv2.noreplied.com.local '/etc/init.d/radiusd reload'`
        ${RELOADRADIUS}
        echo 'RELOAD'
fi

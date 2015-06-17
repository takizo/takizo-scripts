#!/bin/bash


while read line   
do
	ISDN=`echo $line | cut -d , -f1`
	LOCATION=`echo $line | cut -d , -f2`
	ROUTER=`echo $line | cut -d , -f3`
	DESTINATION=`echo $line | cut -d , -f4`
	PHONE=`echo $line | cut -d , -f5`

	echo "INSERT INTO router_list (router_ip, destination_ip, location, circuit, cloginrc, groupname) VALUES ('${ROUTER}', '${DESTINATION}', '${LOCATION}', '${ISDN}', 'cloginrc.bnm', 'BNM-ISDN-PING-TEST');"
done <bnm-newfi.csv 

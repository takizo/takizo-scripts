#!/bin/bash

nsmaster=( `cat latestdns.log | tr '\n' ' '`)

hhh=0
ggg=${#nsmaster[@]}

while [ "$hhh" -lt "$ggg" ] 
do
	domain=`echo ${nsmaster[$hhh]} | cut -d : -f1`
	ipaddress=`echo ${nsmaster[$hhh]} | cut -d : -f2`	
	grepdomain=`grep -w $domain named.time.com.my | awk {'print $1'}`
	grepip=`grep -w $domain named.time.com.my | awk {'print $3'}`
	
	if [ "$grepdomain" != "" ]; then
		echo $hhh
		echo $domain - $ipaddress
		echo $grepdomain - $grepip
		echo -e
		echo -e
	fi
	((hhh++))
done
#!/bin/bash

LISTFILE=top10.list
thelist=( `cat $LISTFILE  | tr '\n' ' '` )

count=0
totalcount=${#thelist[@]}

while [ "$count" -lt "$totalcount" ]
do 
	title=`echo ${thelist[$count]} | cut -d: -f1`
	menu=`echo ${thelist[$count]} | cut -d: -f2`
	host=`echo ${thelist[$count]} | cut -d: -f3`

	cat top10-host-template.tpl | sed -e "s/###NAME###/${title}/g" -e "s/###TITLE###/${menu}/g" -e "s/###HOST###/${host}/g" 

	echo -e 
	((count++))
done

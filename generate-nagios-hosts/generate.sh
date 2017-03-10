#!/opt/local/bin/bash

IFS=$'\n'
SCORE=0
TODAY=`date +%Y-%m-%d`


for d in {201..220} ; do
	echo "define host {"
	echo -e "\tuse\t\tgeneric-host"
	echo -e "\thost_name\tkvm$d"
	echo -e "\talias\t\tkvm$d"
	echo -e "\taddress\t\tkvm$d.serverware.my"
	echo "}"
done

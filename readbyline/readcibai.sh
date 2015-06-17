#!/bin/bash

while read line; do 
	staffid=`echo $line | cut -d , -f1`
	username=`echo $line | cut -d , -f2`
	password=`echo $line | cut -d , -f3`
	email=`echo $line | cut -d , -f4`
	fullname=`echo $line | cut -d , -f5`
	department=`echo $line | cut -d , -f6`

    echo "INSERT INTO user_account (staff_id, username, password, email, fullname) VALUES ('$staffid', '$username', '$password', '$email', '$fullname');"


done < damnit.log

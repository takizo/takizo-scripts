#!/bin/bash

while read line; do 
	created_at=`echo $line | cut -d , -f1`
	distri_code=`echo $line | cut -d , -f2`
	distri_name=`echo $line | cut -d , -f3`
	dealer_code=`echo $line | cut -d , -f4`
	dealer_name=`echo $line | cut -d , -f5`
	dealer_kind=`echo $line | cut -d , -f6`

    echo "INSERT INTO mnp_dealer_code (dealer_name, dealer_code, distri_name, distri_code, dealer_type, status) VALUES ('$dealer_name', '$dealer_code', '$distri_name', '$distri_code', '$dealer_kind', 'ACTIVE');"


done < dealer2.csv

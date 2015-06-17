#!/bin/bash

while read line; do
    error_code=`echo $line | cut -d , -f1`
    the_error_message=`echo $line | cut -d , -f2`

    echo "INSERT INTO mnp_error_code (code, message, error_type) VALUES ('$error_code', '$the_error_message', 'RejectCode');"
    #echo "INSERT INTO mnp_error_code (code, message, error_type) VALUES ('$error_code', '$error_message', 'DataError');"


done < error-code-03.csv

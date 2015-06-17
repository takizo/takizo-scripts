#!/bin/bash


for (( i = 128; i <= 191; i++))
do

echo "\$TTL 612000

$i.74.110.IN-ADDR.ARPA. IN SOA        ns1.aims.my. sys.adm.aims.com.my. (
                        2009082400; serial
                        7200    ; Refresh
                        1800    ; Retry
                        612000  ; Expire
                        21600 ) ; Minimum

;   Name Servers

$i.223.203.IN-ADDR.ARPA.  IN  NS  ns1.aims.my.
$i.223.203.IN-ADDR.ARPA.  IN  NS  ns2.aims.my.

;1     IN      PTR     sample.globaltransit.net.

" > $i.rev
done

for ((d=8; d<=127; d++))
do
echo "zone \"$d.28.223.in-addr.arpa\" in {
        type master;
        file \"rev/223.28/named.7.28.223.conf\";
        allow-transfer {  \"AllowTransferBlock\"; };
};
"
done

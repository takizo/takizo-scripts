#!/opt/local/bin/bash

# Reboot TP Link router on modern firmware (tested only on WDR4300/N750)
# Author: Nicolai Spohrer <nicolai@xeve.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.

if [ "$#" -ne 3 ]; then
    echo "Illegal number of parameters";
    echo "Usage: $0 ROUTER_IP USERNAME PASSWORD";
    exit;
fi

IP=$1;
USERNAME=$2;
PASSWORD=$3;


MAX_TRIES=6; # maximum number of reboot attempts
SYSLOG_TAG="restart-wdr4300.sh"

# From https://stackoverflow.com/questions/296536/urlencode-from-a-bash-script/10660730#10660730
rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER)
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

PASSWORD_MD5=`echo -n $PASSWORD | md5 | cut -d " " -f 1`;
COOKIE_B64_PART=`echo -n $USERNAME":"$(echo -n $PASSWORD_MD5)|base64`;
COOKIEVAL_UNENCODED=`echo -n "Basic $COOKIE_B64_PART"`;
COOKIEVAL=`rawurlencode "$COOKIEVAL_UNENCODED"`

GET_KEY_URL=`echo "http://$IP/userRpm/LoginRpm.htm?Save=Save"`


# If the reboot sequence fails, try again $MAX_TRIES times
for i in $(seq 1 $MAX_TRIES)
do

  RESPONSE=`curl -s --cookie "Authorization=$COOKIEVAL" $GET_KEY_URL`;
  KEY=`echo $RESPONSE |  head -n 1 | cut -d '/' -f 4` # extract key from post-login-page
  echo $RESPONSE
  exit 0 
    sleep 1;

    REBOOT_URL="http://"$IP"/"$KEY"/userRpm/SysRebootRpm.htm?Reboot=Reboot";
    REBOOT_REFERER_URL="http://"$IP"/"$KEY"/userRpm/SysRebootRpm.htm";

    FINAL_RESPONSE=`curl -s --cookie "Authorization=$COOKIEVAL" --referer $REBOOT_REFERER_URL $REBOOT_URL`;

    MATCHES=`echo $FINAL_RESPONSE | grep -c "Restarting..."`
    if [ $MATCHES -gt 0 ]; then
      # Success!
      break
    else
      echo "Failed on try $i..."
      sleep 1;
    fi
  done

  if [ $MATCHES -gt 0 ]; then
    SUCCESS_TEXT="Successfully triggered reboot of $IP.";
    echo $SUCCESS_TEXT;
    logger -t $SYSLOG_TAG $SUCCESS_TEXT;
  else
    FAILURE_TEXT="Apparently failed to trigger reboot of $IP.";
    echo $FAILURE_TEXT;
    logger -t $SYSLOG_TAG $FAILURE_TEXT;

    # Log failure details
    MYRAND=$RANDOM;
    MYFILES="/tmp/reboot-failure-$MYRAND";
    echo $RESPONSE > "$MYFILES-response1"
    echo $FINAL_RESPONSE > "$MYFILES-finalresponse"

    exit 1;
  fi

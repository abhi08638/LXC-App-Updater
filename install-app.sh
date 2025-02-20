#!/bin/bash

#cleanup
adb disconnect
rm /root/downloads/ha.apk

#init
/root/scripts/download-apps.sh

#install
while read p; do
  adb connect "$p"
  sleep 2
  RESULT=$(adb install -r /root/downloads/ha.apk>NUL && echo success || echo failed)
  echo $RESULT
  if [ $RESULT = "success" ]; then
   mosquitto_pub -h ha.internal -u mqtt_example_user -P password1234 -m "$p update completed" -t lxc-mqtt/nsp-lxc/state>
   adb reboot  
  else
   mosquitto_pub -h ha29.internal -u mqtt_example_user -P password1234 -m "$p update failed" -t lxc-mqtt/nsp-lxc/state -i>
  fi
  sleep 5
  adb disconnect
  sleep 5
done </root/scripts/adb-ips.index

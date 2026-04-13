#!/bin/bash

#take input param
echo -n "Enter apk name without extention: "
read file

#validate if file exists
filename="/mnt/app-dir/$file.apk"
if test -f "$filename"; then
  echo "$filename found"
else 
  echo "$filename not found"
  exit 1
fi

#cleanup
adb disconnect

#install
while read p; do
  adb connect "$p"
  sleep 2
  #clean old file
  adb shell -n rm /data/local/tmp/$file.apk
  #push new file locally
  adb push -p $filename /data/local/tmp/
  #install file
  RESULT=$(adb shell -n pm install -r /data/local/tmp/$file.apk>NUL && echo success || echo failed)
  #remove installation file
  adb shell -n rm /data/local/tmp/$file.apk
 # RESULT=$(adb install -r $filename>NUL && echo success || echo failed)
  echo $RESULT
  if [ $RESULT = "success" ]; then
   mosquitto_pub -h ha29.internal -u mqtt_example_user -P password1234 -m "$p update completed for $file.apk" -t lxc-mqtt/nsp-lxc/state -i nsp-lxc
   adb reboot
  else
   mosquitto_pub -h ha29.internal -u mqtt_example_user -P password1234 -m "$p update failed for $file.apk" -t lxc-mqtt/nsp-lxc/state -i nsp-lxc
  fi
  sleep 5
  adb disconnect
  sleep 5
done </root/scripts/adb-ips.index

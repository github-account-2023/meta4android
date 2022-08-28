pid=$(cat ./clash.pid)
if [ $pid == 0 ]
then
   /data/adb/clash -d /data/adb/meta &
   echo $! > ./clash.pid
elif [ $pid -gt 0 ]
then
   kill $pid
   /data/adb/clash -d /data/adb/meta &
   echo $! > ./clash.pid
else
   echo 0 > ./clash.pid
fi

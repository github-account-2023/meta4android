pid=$(cat ./clash.pid)
if [ $pid == 0 ]
then
   echo "not running"
elif [ $pid -gt 0 ]
then
   kill $pid
   echo 0 > ./clash.pid
else
   echo "invaild pid"
fi

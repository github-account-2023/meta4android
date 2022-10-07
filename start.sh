pid=$(cat ./clash.pid)
if [ $pid -gt 0 ]
then
   kill $pid
fi
/data/adb/clash -d /data/adb/meta &
echo $! > ./clash.pid
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -F -t filter
iptables -P FORWARD ACCEPT

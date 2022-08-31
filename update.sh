url=""

server="https://sub.shellclash.cf"
config="https://raw.githubusercontent.com/Hailey2022/clash-config/main/clash.ini"

exclude=""
include=""

path_to_clash="/data/adb/clash"
path_to_config="/data/adb/meta"

path_to_tmp_file="tmp.yaml"

sub="$server/sub?target=clash&insert=true&new_name=true&scv=true&udp=true&exclude=$exclude&include=$include&url=$url&config=$config"
echo $sub
rm -f $path_to_tmp_file
if [ -x "$(command -v wget)" ]; then
    wget --user-agent="clash" -q --show-progress --timeout=5 -t 2 -O "$path_to_tmp_file" "$sub"
    [ "$?" = "0" ] && result="200"
elif [ -x "$(command -v curl)" ]; then
    result=$(curl -A "clash" -w %{http_code} --connect-timeout 5 -# -L -o "$path_to_tmp_file" "$sub" 2>/dev/null)
fi

[ "$result" != "200" ] && exit 1

cat >> $path_to_tmp_file <<EOF

tun:
  enable: true
  stack: system
  dns-hijack:
    - 'any:53'
  auto-route: true
  auto-detect-interface: true

dns:
  enable: true
  ipv6: true
  listen: 0.0.0.0:1053
  enhanced-mode: fake-ip
  use-hosts: true
  fake-ip-filter: ['connect.rom.miui.com', 'localhost.ptlogin2.qq.com', '+.stun.*.*', '+.stun.*.*.*', '+.stun.*.*.*.*', '+.stun.*.*.*.*.*', 'lens.l.google.com', '*.n.n.srv.nintendo.net', '+.stun.playstation.net', 'xbox.*.*.microsoft.com', '*.*.xboxlive.com', '*.msftncsi.com', '*.msftconnecttest.com', '*.mcdn.bilivideo.cn', 'WORKGROUP']
  proxy-server-nameserver:
    - 'https://223.5.5.5/dns-query'
    - 'https://1.12.12.12/dns-query'
  default-nameserver:
    - 'https://223.5.5.5/dns-query'
    - 'https://1.12.12.12/dns-query'
  nameserver:
    - 'https://223.5.5.5/dns-query' 
    - 'https://1.12.12.12/dns-query'

EOF

$path_to_clash -t -f $path_to_tmp_file -d $path_to_config
[ "$?" != "0" ] && exit 2 
mv -f $path_to_tmp_file $path_to_config

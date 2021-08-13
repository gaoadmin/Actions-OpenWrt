#!/bin/sh

uci set luci.main.lang=zh_cn
uci commit luci

uci set system.@system[0].timezone=CST-8
uci set system.@system[0].zonename=Asia/Shanghai
uci commit system

uci set fstab.@global[0].anon_mount=1
uci commit fstab


rm -f /usr/lib/lua/luci/view/admin_status/index/mwan.htm
rm -f /usr/lib/lua/luci/view/admin_status/index/upnp.htm
rm -f /usr/lib/lua/luci/view/admin_status/index/ddns.htm
rm -f /usr/lib/lua/luci/view/admin_status/index/minidlna.htm

sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/aria2.lua
sed -i 's/services/nas/g' /usr/lib/lua/luci/view/aria2/overview_status.htm
sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/hd_idle.lua
sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/samba.lua
sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/minidlna.lua
sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/transmission.lua
sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/mjpg-streamer.lua
sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/p910nd.lua
sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/usb_printer.lua
sed -i 's/\"services\"/\"nas\"/g' /usr/lib/lua/luci/controller/xunlei.lua
sed -i 's/services/nas/g'  /usr/lib/lua/luci/view/minidlna_status.htm

ln -sf /sbin/ip /usr/bin/ip

sed -i 's#http://downloads.openwrt.org#https://mirrors.cloud.tencent.com/lede#g' /etc/opkg/distfeeds.conf
sed -i 's/root::0:0:99999:7:::/root:$1$jfFhIs.K$FzAs40PXo6lC5zKXs3eu71.:0:0:99999:7:::/g' /etc/shadow

sed -i "s/# //g" /etc/opkg/distfeeds.conf
sed -i '/openwrt_luci/ { s/snapshots/releases\/18.06.8/g; }'  /etc/opkg/distfeeds.conf

sed -i '/REDIRECT --to-ports 53/d' /etc/firewall.user
echo "iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53" >> /etc/firewall.user
echo "iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53" >> /etc/firewall.user

sed -i '/option disabled/d' /etc/config/wireless
sed -i '/set wireless.radio${devidx}.disabled/d' /lib/wifi/mac80211.sh

sed -i '/DISTRIB_REVISION/d' /etc/openwrt_release
echo "DISTRIB_REVISION='Lede'" >> /etc/openwrt_release
sed -i '/DISTRIB_DESCRIPTION/d' /etc/openwrt_release
echo "DISTRIB_DESCRIPTION='Grover - '" >> /etc/openwrt_release

sed -i 's/LuCI Master/Grover/g' /usr/lib/lua/luci/version.lua
sed -i 's/LuCI openwrt-18.06 branch/Grover/g' /usr/lib/lua/luci/version.lua
sed -i 's/LuCI 17.01 Lienol/Grover/g' /usr/lib/lua/luci/version.lua
sed -i 's/LuCI openwrt-21.02 branch/Grover/g' /usr/lib/lua/luci/version.lua
sed -i '/luciversion/d' /usr/lib/lua/luci/version.lua
echo 'luciversion = "June"' >> /usr/lib/lua/luci/version.lua

sed -i '/log-facility/d' /etc/dnsmasq.conf
echo "log-facility=/dev/null" >> /etc/dnsmasq.conf

sed -i 's/cbi.submit\"] = true/cbi.submit\"] = \"1\"/g' /usr/lib/lua/luci/dispatcher.lua

echo 'hsts=0' > /root/.wgetrc

rm -rf /tmp/luci-modulecache/
rm -f /tmp/luci-indexcache
ifconfig eth1 down
sleep 1s
ifconfig eth1 hw ether C8:3A:35:25:0A:58

exit 0

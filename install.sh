#!/bin/sh
sudo su
yes | apt update
yes | apt upgrade 
pip install shadowsocks

json_content="{\n  \"server\":\"::\",\n  \"server_port\":10086,\n  \"password\":\"testpassword\",\n  \"timeout\":60,\n  \"method\":\"aes-256-cfb\",\n  \"fast_open\": true\n  \"workers\":1\n}"
echo -e ${json_content} >> /etc/shadowsocks.json


sed -i "s/exit 0//g" /etc/rc.local
echo "sudo /usr/local/bin/sslocal -c /etc/shadowsocks.json -d start" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local


echo "* soft nofile 51200" >> /etc/security/limit.conf
echo "* hard nofile 51200" >> /etc/security/limit.conf
ulimit -n 51200


echo "fs.file-max = 51200" >> /etc/sysctl.conf
echo "net.core.rmem_max = 67108864" >> /etc/sysctl.conf
echo "net.core.wmem_max = " >> /etc/sysctl.conf
echo "net.core.netdev_max_backlog = 250000" >> /etc/sysctl.conf
echo "net.core.somaxconn = " >> /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_recycle = 0" >> /etc/sysctl.conf
echo "net.ipv4.tcp_fin_timeout = 30" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time = 1200" >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 10000 65000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 8192" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_tw_buckets = 5000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_fastopen = 3" >> /etc/sysctl.conf
echo "net.ipv4.tcp_mem = 25600 51200 102400" >> /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 87380 67108864" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 65536 67108864" >> /etc/sysctl.conf
echo "net.ipv4.tcp_mtu_probing = 1" >> /etc/sysctl.conf
sysctl -p


wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
chmod +x bbr.sh
echo |./bbr.sh


reboot


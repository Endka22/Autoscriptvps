#!/bin/bash 
source /var/lib/premium-script/ipvps.conf
domain=$(cat /etc/v2ray/domain)
read -rp "User: " -e user
egrep -w "^### Vmess $user" /etc/nginx/conf.d/vps.conf >/dev/null
if [ $? -eq 0 ]; then
echo -e "Username Sudah Ada"
exit 0
fi
PORT=$((RANDOM + 10000))
read -p "Expired (days): " masaaktif
uuid=$(cat /proc/sys/kernel/random/uuid)
uid=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 14; echo;)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
cat> /etc/v2ray/vmess-$user.json<<END
{
  "log": {
        "access": "/var/log/v2ray/access.log",
        "error": "/var/log/v2ray/error.log",
        "loglevel": "warning"
    },
  "inbounds": [
    {
    "port":$PORT,
      "listen": "127.0.0.1",
      "tag": "vmess-in",
      "protocol": "vmess",
      "settings": {
        "clients": [
        {
            "id": "${uuid}",
            "alterId": 64
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path":"/endka-vpn?u=${user}&p=${uid}"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": { },
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": { },
      "tag": "blocked"
    }
  ],
  "dns": {
    "servers": [
      "https+local://1.1.1.1/dns-query",
          "1.1.1.1",
          "1.0.0.1",
          "8.8.8.8",
          "8.8.4.4",
          "localhost"
    ]
  },
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "type": "field",
        "inboundTag": [
          "vmess-in"
        ],
        "outboundTag": "direct"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  }
}
END
sed -i '$ i### Vmess '"$user"' '"$exp"'' /etc/nginx/conf.d/vps.conf
sed -i '$ ilocation /endka-vpn?u='"$user"'&p='"$uid"'' /etc/nginx/conf.d/vps.conf
sed -i '$ i{' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_pass http://127.0.0.1:'"$PORT"';' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/vps.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/vps.conf
sed -i '$ i}' /etc/nginx/conf.d/vps.conf
tls=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "64",
      "net": "ws",
      "path": "/endka-vpn?u=${user}&p=${uid}",
      "type": "none",
      "host": "",
      "tls": "tls"
}
EOF`
none=`cat<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "endka.edu-proxy.site",
      "port": "80",
      "id": "${uuid}",
      "aid": "64",
      "net": "ws",
      "path": "/endka-vpn?u=${user}&p=${uid}",
      "type": "none",
      "host": "${domain}",
      "tls": "none"
}
EOF`
vmesslink1="vmess://$(echo $tls | base64 -w 0)"
vmesslink2="vmess://$(echo $none | base64 -w 0)"
systemctl start v2ray@vmess-$user
systemctl enable v2ray@vmess-$user
systemctl reload nginx
clear
echo -e ""
echo -e "==========-V2RAY/VMESS-=========="
echo -e "Remarks        : ${user}"
echo -e "Domain         : ${domain}"
echo -e "port TLS       : 443"
echo -e "port none TLS  : 80"
echo -e "id             : ${uuid}"
echo -e "alterId        : 64"
echo -e "Security       : auto"
echo -e "network        : ws"
echo -e "path           : /endka-vpn?u=${user}&p=${uid}"
echo -e "================================="
echo -e "link TLS       : ${vmesslink1}"
echo -e "================================="
echo -e "link none TLS  : ${vmesslink2}"
echo -e "================================="
echo -e "Expired On     : $exp"

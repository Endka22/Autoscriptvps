#!/bin/bash
domain=$(cat /etc/v2ray/domain)
read -rp "User: " -e user
egrep -w "^### $user" /etc/trojan-go/akun.conf >/dev/null
if [ $? -eq 0 ]; then
echo -e "Username Sudah Ada"
exit 0
fi
read -p "Expired (days): " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
uuid=$(cat /etc/trojan-go/uuid.txt)
sed -i '/"'""$uuid""'"$/a\,"'""$user""'"' /etc/trojan-go/config.json
echo -e "### $user $exp" >> /etc/trojan-go/akun.conf
systemctl restart trojan-go.service
trojangolink="trojan-go://${user}@${domain}:443/?sni=${domain}&type=ws&host=${domain}&path=/Trojan-go&encryption=none#${user}"
clear
echo -e ""
echo -e "===========-Trojan-GO-==========="
echo -e "Remarks        : ${user}"
echo -e "Host/IP        : ${domain}"
echo -e "port           : 443"
echo -e "Key            : ${user}"
echo -e "Path           : /Trojan-go"
echo -e "================================="
echo -e "Trojan-go Link : ${trojangolink}"
echo -e "================================="
echo -e "Expired On     : $exp"

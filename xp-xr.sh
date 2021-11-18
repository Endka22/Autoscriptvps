#!/bin/bash
data=( `cat /etc/nginx/conf.d/vps.conf | grep '^### Vmess' | cut -d ' ' -f 3`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### Vmess $user" "/etc/nginx/conf.d/vps.conf" | cut -d ' ' -f 4)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### Vmess $user $exp/,/^}/d" /etc/nginx/conf.d/vps.conf
rm -f /usr/local/etc/xray/vmess-$user.json
systemctl stop xray@vmess-$user
systemctl disable xray@vmess-$user
fi
done
systemctl reload nginx

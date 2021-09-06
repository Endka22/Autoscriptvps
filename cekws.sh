#!/bin/bash
clear
data=( `cat /etc/nginx/conf.d/v2ray.conf | grep '^### Vmess' | cut -d ' ' -f 3`);
echo "-------------------------------";
echo "-----=[ Vmess User Login ]=-----";
echo "-------------------------------";
for akun in "${data[@]}"
do
data2=( `lsof -n | grep ESTABLISHED | grep nginx | awk '{print $9}' | cut -d'>' -f2 | cut -d: -f1 | sort | uniq`);
for ip in "${data2[@]}"
do
jum=$(cat /var/log/nginx/access.log | grep -w $ip | awk '{print $7}' | cut -d@ -f2 | grep -w $akun | sort | uniq)
if [[ -z "$jum" ]]; then
echo > /dev/null
else
echo "$jum : $ip";
echo "-------------------------------";
fi
done
done
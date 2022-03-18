#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
CEKEXPIRED () {
    today=$(date -d +1day +%Y-%m-%d)
    Exp1=$(curl -sS https://raw.githubusercontent.com/Endka22/aksessc/main/IP.txt | grep $MYIP | awk '{print $3}')
    if [[ $today < $Exp1 ]]; then
    echo -e "\e[32mSTATUS SCRIPT AKTIF...\e[0m"
    else
    echo -e "\e[31mSCRIPT ANDA EXPIRED!\e[0m";
    echo -e "\e[31mRenew IP dulu ya.... #\e[0m"
    exit 0
fi
}
IZIN=$(curl -sS https://raw.githubusercontent.com/Endka22/aksessc/main/IP.txt | awk '{print $4}' | grep $MYIP)
if [ $MYIP = $IZIN ]; then
echo -e "\e[32mPermission Accepted...\e[0m"
CEKEXPIRED
else
echo -e "\e[31mPermission Denied!\e[0m";
echo -e "\e[31mDaftarkan IP Anda Terlebih Dahulu #\e[0m"
exit 0
fi
clear
data=( `cat /var/lib/premium-script/data-user-l2tp | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/var/lib/premium-script/data-user-l2tp" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/d" "/var/lib/premium-script/data-user-l2tp"
sed -i '/^"'"$user"'" l2tpd/d' /etc/ppp/chap-secrets
sed -i '/^'"$user"':\$1\$/d' /etc/ipsec.d/passwd
chmod 600 /etc/ppp/chap-secrets* /etc/ipsec.d/passwd*
fi
done
data=( `cat /var/lib/premium-script/data-user-pptp | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/var/lib/premium-script/data-user-pptp" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/d" "/var/lib/premium-script/data-user-pptp"
sed -i '/^"'"$user"'" pptpd/d' /etc/ppp/chap-secrets
chmod 600 /etc/ppp/chap-secrets*
fi
done
data=( `cat /etc/shadowsocks-libev/akun.conf | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/etc/shadowsocks-libev/akun.conf" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/,/^port_http/d" "/etc/shadowsocks-libev/akun.conf"
systemctl disable shadowsocks-libev-server@$user-tls.service
systemctl disable shadowsocks-libev-server@$user-http.service
systemctl stop shadowsocks-libev-server@$user-tls.service
systemctl stop shadowsocks-libev-server@$user-http.service
rm -f "/etc/shadowsocks-libev/$user-tls.json"
rm -f "/etc/shadowsocks-libev/$user-http.json"
fi
done
data=( `cat /usr/local/shadowsocksr/akun.conf | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/usr/local/shadowsocksr/akun.conf" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/d" "/usr/local/shadowsocksr/akun.conf"
cd /usr/local/shadowsocksr
match_del=$(python mujson_mgr.py -d -u "${user}"|grep -w "delete user")
cd
fi
done
/etc/init.d/ssrmu restart
data=( `cat /var/lib/premium-script/data-user-sstp | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/var/lib/premium-script/data-user-sstp" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/d" "/var/lib/premium-script/data-user-sstp"
sed -i '/^'"$user"'/d' /home/sstp/sstp_account
fi
done
data=( `cat /etc/trojan/akun.conf | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/etc/trojan/akun.conf" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/d" "/etc/trojan/akun.conf"
sed -i '/^,"'"$user"'"$/d' /etc/trojan/config.json
fi
done
systemctl restart trojan
data=( `cat /etc/wireguard/wg0.conf | grep '^### Client' | cut -d ' ' -f 3`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### Client $user" "/etc/wireguard/wg0.conf" | cut -d ' ' -f 4)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### Client $user $exp/,/^AllowedIPs/d" /etc/wireguard/wg0.conf
rm -f "/home/vps/public_html/$user.conf"
fi
done
systemctl restart wg-quick@wg0
data=( `cat /etc/v2ray/config.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/etc/v2ray/config.json" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/,/^},{/d" /etc/v2ray/config.json
sed -i "/^### $user $exp/,/^},{/d" /etc/v2ray/none.json
rm -f /etc/v2ray/$user-tls.json /etc/v2ray/$user-none.json
fi
done
systemctl restart v2ray
systemctl restart v2ray@none
data=( `cat /etc/v2ray/vless.json | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/etc/v2ray/vless.json" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/,/^},{/d" /etc/v2ray/vless.json
sed -i "/^### $user $exp/,/^},{/d" /etc/v2ray/vnone.json
fi
done
systemctl restart v2ray@vless
systemctl restart v2ray@vnone
data=( `cat /etc/trojango/$user-trojan.txt | grep '^###' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^### $user" "/etc/trojango/$user-trojan.txt" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^### $user $exp/d" "/etc/trojango/$user-trojan.txt"
sed -i '/^,"'"$user"'"$/d' /usr/local/etc/xray/trojanws.json
fi
done
systemctl restart xray@trojanws

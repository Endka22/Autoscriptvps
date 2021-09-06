#!/bin/bash             
NUMBER_OF_CLIENTS=$(grep -c -E "^### Vmess " "/etc/nginx/conf.d/v2ray.conf")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "You have no existing clients!"
		exit 1
	fi

	clear
	echo ""
	echo " Select the existing client you want to remove"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo "     No  Expired   User"
	grep -E "^### Vmess " "/etc/nginx/conf.d/v2ray.conf" | cut -d ' ' -f 3-4 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E "^### Vmess " "/etc/nginx/conf.d/v2ray.conf" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^### Vmess " "/etc/nginx/conf.d/v2ray.conf" | cut -d ' ' -f 4 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^### Vmess $user $exp/,/^}/d" /etc/nginx/conf.d/v2ray.conf
systemctl disable v2ray@vmess-$user
systemctl stop v2ray@vmess-$user
rm -f /etc/v2ray/vmess-$user.json
systemctl reload nginx
clear
echo " V2RAY Akun berhasil dihapus"
echo " =========================="
echo " Client Name : $user"
echo " Expired On  : $exp"
echo " =========================="
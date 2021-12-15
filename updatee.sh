#!/bin/bash
if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- ifconfig.co);
IZIN=$( curl http://akses.vmess.my.id:81/aksesku | grep $MYIP )
if [ $MYIP = $IZIN ]; then
echo -e "${green}Permission Accepted...${NC}"
else
echo -e "${red}Permission Denied!${NC}";
echo "Please Contact Admin"
echo "Telegram t.me/Endka22"
rm -f setup.sh
exit 0
fi
echo "Start Update"
cd /usr/bin
wget -O add-xr "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/add-xr.sh"
wget -O add-xvless "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/add-xvless.sh"
wget -O del-xr "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/del-xr.sh"
wget -O del-xvless "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/del-xvless.sh"
wget -O xp-xr "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/xp-xr.sh"
wget -O xp-xvless "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/xp-xvless.sh"
chmod +x add-xr
chmod +x add-xvless
chmod +x del-xr
chmod +x del-xvless
chmod +x xp-xr
chmod +x xp-xvless
echo "0 0 * * * root xp-xr" >> /etc/crontab
echo "0 0 * * * root xp-xvless" >> /etc/crontab
clear
echo " Fix minor Bugs"
echo " Now You Can Change Port Of Some Services"
echo " Reboot 5 Sec"
sleep 5
rm -f update.sh
reboot

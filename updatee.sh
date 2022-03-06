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
#enc
shc -r -f add-xr -o add-xr
shc -r -f add-xvless -o add-xvless
shc -r -f del-xr -o del-xr
shc -r -f del-xvless -o del-xvless
shc -r -f xp-xr -o xp-xr
shc -r -f xp-xvless -o xp-xvless
echo "0 0 * * * root xp-xr" >> /etc/crontab
echo "0 0 * * * root xp-xvless" >> /etc/crontab
clear
echo " Fix minor Bugs"
echo " Now You Can Change Port Of Some Services"
echo " Reboot 5 Sec"
sleep 5
rm -f update.sh
reboot

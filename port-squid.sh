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
sqd="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}' | head -n1)"
sqd2="$(cat /etc/squid/squid.conf | grep -i http_port | awk '{print $2}' | tail -n1)"
echo -e "======================================" | lolcat
echo -e ""
echo -e "     [1]  Change Port $sqd"
echo -e "     [2]  Change Port $sqd2"
echo -e "     [x]  Exit"
echo -e "======================================" | lolcat
echo -e ""
read -p "     Select From Options [1-2 or x] :  " prot
echo -e ""
case $prot in
1)
read -p "New Port Squid: " squid
if [ -z $squid ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $squid)
if [[ -z $cek ]]; then
sed -i "s/$sqd/$squid/g" /etc/squid/squid.conf
sed -i "s/$sqd/$squid/g" /root/log-install.txt
/etc/init.d/squid restart > /dev/null
echo -e "\e[032;1mPort $squid modified successfully\e[0m"
else
echo "Port $squid is used"
fi
;;
2)
read -p "New Port Squid: " squid
if [ -z $squid ]; then
echo "Please Input Port"
exit 0
fi
cek=$(netstat -nutlp | grep -w $squid)
if [[ -z $cek ]]; then
sed -i "s/$sqd2/$squid/g" /etc/squid/squid.conf
sed -i "s/$sqd2/$squid/g" /root/log-install.txt
/etc/init.d/squid restart > /dev/null
echo -e "\e[032;1mPort $squid modified successfully\e[0m"
else
echo "Port $squid is used"
fi
;;
x)
exit
menu
;;
*)
echo "Please enter an correct number"
;;
esac


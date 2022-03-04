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
figlet -f small Panel SSH | lolcat
echo -e ""
echo -e "======================================" | lolcat
echo -e ""
echo -e "     [1]  Create SSH & OpenVPN Account"
echo -e "     [2]  Trial Account SSH & OpenVPN"
echo -e "     [3]  Renew SSH & OpenVPN Account"
echo -e "     [4]  Delete SSH & OpenVPN Account"
echo -e "     [5]  Check User Login SSH & OpenVPN"
echo -e "     [6]  Daftar Member SSH & OpenVPN"
echo -e "     [7]  Delete User Expired SSH & OpenVPN"
echo -e "     [8]  Set up Autokill SSH"
echo -e "     [9]  Cek Users Who Do Multi Login SSH"
echo -e "     [10] Restart Service Dropbear, Squid3"
echo -e "     [x]  Exit"
echo -e "======================================" | lolcat
echo -e ""
read -p "     Select From Options [1-10 or x] :  " port
echo -e ""
case $port in
1)
usernew
;;
2)
trial
;;
3)
renew
;;
4)
deluser
;;
5)
cek
;;
6)
member
;;
7)
delete
;;
8)
autokill
;;
9)
ceklim
;;
10)
restart
;;
x)
clear
menu
;;
*)
echo "Please enter an correct number"
;;
esac

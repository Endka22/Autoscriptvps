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
figlet -f small Panel L2TP | lolcat
echo -e ""
echo -e "======================================" | lolcat
echo -e ""
echo -e "     [1]  Creating L2TP Account"
echo -e "     [2]  Create Account PPTP"
echo -e "     [3]  Deleting L2TP Account"
echo -e "     [4]  Delete PPTP Account"
echo -e "     [5]  Check User Login PPTP"
echo -e "     [6]  Renew L2TP Account"
echo -e "     [7]  Renew PPTP Account"
echo -e "     [x]  Exit"
echo -e "======================================" | lolcat
echo -e ""
read -p "     Select From Options [1-7 or x] :  " port
echo -e ""
case $port in
1)
add-l2tp
;;
2)
add-pptp
;;
3)
del-l2tp
;;
4)
del-pptp
;;
5)
cek-pptp
;;
6)
renew-l2tp
;;
7)
renew-pptp
;;
x)
clear
menu
;;
*)
echo "Please enter an correct number"
;;
esac

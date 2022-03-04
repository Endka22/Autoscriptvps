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
    echo -e "\e[31mRenew IP dulu okay?hehehehe #\e[0m"
    exit 0
fi
}
IZIN=$(curl -sS https://raw.githubusercontent.com/Endka22/aksessc/main/IP.txt | awk '{print $4}' | grep $MYIP)
if [ $MYIP = $IZIN ]; then
echo -e "\e[32mPermission Accepted...\e[0m"
CEKEXPIRED
else
echo -e "\e[31mPermission Denied!\e[0m";
echo -e "\e[31mDaftar IP dulu sayang okay?#\e[0m"
exit 0
fi
clear
echo -e "=================================================" | lolcat
echo -e "#         Premium Auto Script         #"
echo -e "#-----------------------------------------------#"
echo -e "# For Debian 9 & Debian 10 64 bit               #"
echo -e "# For Ubuntu 18.04 & Ubuntu 20.04 64 bit        #"
echo -e "# For VPS with KVM and VMWare virtualization    #"
echo -e "# Build Up By Endka                           #"
echo -e "#-----------------------------------------------#"
echo -e "# Thanks To                                     #"
echo -e "#-----------------------------------------------#"
echo -e "#                                      #"
echo -e "# Allah                                 #"
echo -e "# My Family                                     #"
echo -e "# Google                                        #"
echo -e "#-----------------------------------------------#"
echo -e "=================================================" | lolcat

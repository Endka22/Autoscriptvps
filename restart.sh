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
echo -e ""
echo -e "======================================" | lolcat
echo -e ""
echo -e ""
echo -e "    [1] Restart All Services"
echo -e "    [2] Restart OpenSSH"
echo -e "    [3] Restart Dropbear"
echo -e "    [4] Restart Stunnel4"
echo -e "    [5] Restart OpenVPN"
echo -e "    [6] Restart Squid"
echo -e "    [7] Restart Nginx"
echo -e "    [8] Restart Badvpn"
echo -e "    [x] Exit"
echo -e ""
read -p "    Select From Options [1-8 or x] :  " Restart
echo -e ""
echo -e "======================================" | lolcat
sleep 1
clear
case $Restart in
                1)
                clear
                /etc/init.d/ssh restart
                /etc/init.d/dropbear restart
                /etc/init.d/stunnel4 restart
                /etc/init.d/openvpn restart
                /etc/init.d/fail2ban restart
                /etc/init.d/cron restart
                /etc/init.d/nginx restart
                /etc/init.d/squid restart
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 1000
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 1000
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 1000
                echo -e ""
                echo -e "======================================" | lolcat
                echo -e ""
                echo -e "          Service/s Restarted         "
                echo -e ""
                echo -e "======================================" | lolcat
                exit
                ;;
                2)
                clear
                /etc/init.d/ssh restart
                echo -e ""
                echo -e "======================================" | lolcat
                echo -e ""
                echo -e "         SSH Service Restarted        "
                echo -e ""
                echo -e "======================================" | lolcat
                exit
                ;;
                3)
                clear
                /etc/init.d/dropbear restart
                echo -e ""
                echo -e "======================================" | lolcat
                echo -e ""
                echo -e "       Dropbear Service Restarted     "
                echo -e ""
                echo -e "======================================" | lolcat
                exit
                ;;
                4)
                clear
                /etc/init.d/stunnel4 restart
                echo -e ""
                echo -e "======================================" | lolcat
                echo -e ""
                echo -e "        Stunnel4 Service Restarted    "
                echo -e ""
                echo -e "======================================" | lolcat
                exit
                ;;
                5)
                clear
                /etc/init.d/openvpn restart
                echo -e ""
                echo -e "======================================" | lolcat
                echo -e ""
                echo -e "       OpenVPN Service Restarted      "
                echo -e ""
                echo -e "======================================" | lolcat
                exit
                ;;
                6)
                clear
                /etc/init.d/squid restart
                echo -e ""
                echo -e "======================================" | lolcat
                echo -e ""
                echo -e "        Squid3 Service Restarted      "
                echo -e ""
                echo -e "======================================" | lolcat
                exit
                ;;
                7)
                clear
                /etc/init.d/nginx restart
                echo -e ""
                echo -e "======================================" | lolcat
                echo -e ""
                echo -e "         Nginx Service Restarted      "
                echo -e ""
                echo -e "======================================" | lolcat
                exit
                ;;
                8)
                clear
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
                screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
                echo -e ""
                echo -e "======================================" | lolcat
                echo -e ""
                echo -e "    Badvpn  Badvpn Service Restarted  "
                echo -e ""
                echo -e "======================================" | lolcat
                exit
                ;;
                x)
                clear
                exit
                ;;
        esac

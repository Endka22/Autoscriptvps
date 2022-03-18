#!/bin/bash
#
# ==================================================

# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Indonesia
locality=Indonesia
organization=www.endka.xyz
organizationalunit=www.endka.xyz
commonname=www.endka.xyz
email=admin@endka.xyz

# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/password"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

#install jq
apt -y install jq

#install shc
apt -y install shc

# install wget and curl
apt -y install wget curl

#figlet
apt-get install figlet -y
apt-get install ruby -y
gem install lolcat

#set panel
mkdir -p /etc/trojango/
mkdir -p /etc/v2ray/user/

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install
apt-get --reinstall --fix-missing install -y linux-headers-cloud-amd64 bzip2 gzip coreutils wget jq screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl git lsof
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

install_ssl(){
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            else
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            fi
    else
        yum install -y nginx certbot
        sleep 3s
    fi

    systemctl stop nginx.service

    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            else
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            fi
    else
        echo "Y" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
        sleep 3s
    fi
}

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/Endka22/Autos/main/vps.conf"
/etc/init.d/nginx restart

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

# setting port ssh
cd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g'
# /etc/ssh/sshd_config
sed -i '/Port 22/a Port 500' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 40000' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 51443' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 58080' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 200' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart

echo "=== Install Dropbear ==="
# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/ssh restart
/etc/init.d/dropbear restart

# install squid
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.7.tar.gz
tar zxvf vnstat-2.7.tar.gz
cd vnstat-2.7
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.7.tar.gz
rm -rf /root/vnstat-2.7

cd
#install sslh
apt-get install sslh -y

#konfigurasi
#port 443 to 77 and 777
wget -O /etc/default/sslh "https://raw.githubusercontent.com/Endka22/Autosc/main/sslh.conf"
service sslh restart

# install stunnel
apt install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 222
connect = 127.0.0.1:22

[dropbear]
accept = 777
connect = 127.0.0.1:22

[openvpn]
accept = 442
connect = 127.0.0.1:1194

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

#OpenVPN
wget https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh

#Edu
wget https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/websocket.sh &&  chmod +x websocket.sh && ./websocket.sh

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# banner /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/bannerssh.conf"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
cd /usr/bin
wget -O add-host "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/add-host.sh"
wget -O about "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/about.sh"
wget -O menu "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/hapus.sh"
wget -O member "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/member.sh"
wget -O delete "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/delete.sh"
wget -O cek "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/cek.sh"
wget -O restart "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/info.sh"
wget -O ram "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/ram.sh"
wget -O renew "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/renew.sh"
wget -O autokill "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/autokill.sh"
wget -O ceklim "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/tendang.sh"
wget -O clear-log "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/clear-log.sh"
wget -O change-port "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/change.sh"
wget -O port-ovpn "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/port-ovpn.sh"
wget -O port-ssl "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/port-ssl.sh"
wget -O port-wg "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/port-wg.sh"
wget -O port-tr "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/port-tr.sh"
wget -O port-sstp "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/port-sstp.sh"
wget -O port-squid "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/port-squid.sh"
wget -O port-ws "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/port-ws.sh"
wget -O port-vless "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/port-vless.sh"
wget -O wbmn "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/webmin.sh"
wget -O xp "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/xp.sh"
wget -O kernel-updt "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/kernel-update.sh"
wget -O tessh "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/tessh.sh"
wget -O ssstp "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/ssstp.sh"
wget -O sssr "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/sssr.sh"
wget -O ltp "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/ltp.sh"
wget -O wgg "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/wgg.sh"
wget -O trj "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/trj.sh"
wget -O wss "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/wss.sh"
wget -O vls "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/vls.sh"
wget -O updatee "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/updatee.sh"
wget -O auto-reboot "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/auto-reboot.sh"
wget -O clear-log "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/clear-log.sh"
# menu system
wget -O m-system "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/m-system.sh"
wget -O info-menu "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/info-menu.sh"
wget -O vpsinfo "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/vpsinfo.sh"
wget -O status "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/status.sh"
wget -O bbr "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/bbr.sh"
wget -O auto-reboot "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/auto-reboot.sh"
wget -O clear-log "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/clear-log.sh"
wget -O clearcache "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/clearcache.sh"
wget -O restart "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/restart.sh"
wget -O bw "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/bw.sh"
wget -O resett "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/resett.sh"
wget -O kernel-updt "https://raw.githubusercontent.com/Endka22/Autoscriptvps/main/kernel-updt.sh"
chmod +x add-host
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x member
chmod +x delete
chmod +x cek
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x autokill
chmod +x tendang
chmod +x ceklim
chmod +x ram
chmod +x renew
chmod +x clear-log
chmod +x change-port
chmod +x port-ovpn
chmod +x port-ssl
chmod +x port-wg
chmod +x port-sstp
chmod +x port-tr
chmod +x port-squid
chmod +x port-ws
chmod +x port-vless
chmod +x wbmn
chmod +x xp
chmod +x m-system
chmod +x tessh
chmod +x ssstp
chmod +x sssr
chmod +x ltp
chmod +x wgg
chmod +x trj
chmod +x wss
chmod +x vls
chmod +x updatee
chmod +x clear-log
chmod +x vpsinfo
chmod +x status
chmod +x about
chmod +x bbr
chmod +x auto-reboot
chmod +x clear-log
chmod +x clearcache
chmod +x restart
chmod +x bw
chmod +x resett
chmod +x kernel-updt
#enc
shc -r -f add-host -o add-host
shc -r -f menu -o menu
shc -r -f usernew -o usernew
shc -r -f trial -o trial
shc -r -f hapus -o hapus
shc -r -f member -o member
shc -r -f delete -o delete
shc -r -f cek -o cek
shc -r -f restart -o restart
shc -r -f speedtest -o speedtest
shc -r -f info -o info
shc -r -f about -o about
shc -r -f autokill -o autokill
shc -r -f tendang -o tendang
shc -r -f ceklim -o ceklim
shc -r -f ram -o ram
shc -r -f renew -o renew
shc -r -f clear-log -o clear-log
shc -r -f change-port -o change-port
shc -r -f port-ovpn -o port-ovpn
shc -r -f port-ssl -o port-ssl
shc -r -f port-wg -o port-wg
shc -r -f port-sstp -o port-sstp
shc -r -f port-tr -o port-tr
shc -r -f port-squid -o port-squid
shc -r -f port-ws -o port-ws
shc -r -f port-vless -o port-vless
shc -r -f wbmn -o wbmn
shc -r -f xp -o xp
shc -r -f m-system -o m-system
shc -r -f tessh -o tessh
shc -r -f ssstp -o ssstp
shc -r -f sssr -o sssr
shc -r -f ltp -o ltp
shc -r -f wgg -o wgg
shc -r -f trj -o trj
shc -r -f wss -o wss
shc -r -f vls -o vls
shc -r -f updatee -o updatee
shc -r -f vpsinfo -o vpsinfo
shc -r -f status -o status
shc -r -f bbr -o bbr
shc -r -f auto-reboot -o auto-reboot
shc -r -f clearcache -o clearcache
shc -r -f restart -o restart
shc -r -f bw -o bw
shc -r -f resett -o resett
shc -r -f kernel-updt -o kernel-updt
echo "0 0 * * * root clear-log && reboot" >> /etc/crontab
echo "0 0 * * * root xp" >> /etc/crontab
# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

# finihsing
clear

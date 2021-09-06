#!/bin/bash
domain=$(cat /root/domain)
apt install iptables iptables-persistent -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
chronyc sourcestats -v
chronyc tracking -v
date
# install v2ray
wget https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/go.sh && chmod +x go.sh && ./go.sh
rm -f /root/go.sh
# ambil versi trojan-go terbaru
latest_version="$(curl -s "https://api.github.com/repos/p4gefau1t/trojan-go/releases" | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
echo "The latest version of trojan-go is ${latest_version}"
trojango_link="https://github.com/p4gefau1t/trojan-go/releases/download/v${latest_version}/trojan-go-linux-amd64.zip"
mkdir -p "/usr/bin/trojan-go"
mkdir -p "/etc/trojan-go"
cd /etc/trojan-go
curl -sL "${trojango_link}" -o trojan-go.zip
unzip -q trojan-go.zip && rm -rf trojan-go.zip
chmod +x /etc/trojan-go/trojan-go
mkdir /var/log/trojan-go/
touch /etc/trojan-go/akun.conf
touch /etc/trojan-go/trojan-go.pid
touch /var/log/trojan-go/trojan-go.log
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/v2ray/v2ray.crt --keypath /etc/v2ray/v2ray.key --ecc
uuid=$(cat /proc/sys/kernel/random/uuid)
cat > /etc/trojan-go/config.json << EOF
{
  "run_type": "server",
  "local_addr": "127.0.0.1",
  "local_port": 2096,
  "remote_addr": "127.0.0.1",
  "remote_port": 81,
  "log_level": 1,
  "log_file": "/var/log/trojan-go/trojan-go.log",
  "password": [
    "$uuid"

  ],
  "disable_http_check": true,
  "udp_timeout": 60,
  "ssl": {
    "verify": true,
    "verify_hostname": true,
    "cert": "/etc/v2ray/v2ray.crt",
    "key": "/etc/v2ray/v2ray.key",
    "cipher": "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384",
    "cipher_tls13": "TLS_AES_128_GCM_SHA256:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_256_GCM_SHA384",
    "prefer_server_cipher": true,
    "alpn": [
      "http/1.1"
    ],
    "session_ticket": true,
    "reuse_session": true,
    "plain_http_response": "",
    "fallback_addr": "",
    "fallback_port": 81,
    "fingerprint": ""
  },
  "tcp": {
    "no_delay": true,
    "keep_alive": true,
    "prefer_ipv4": false
  },
  "transport_plugin": {
    "enabled": true,
    "type": "plaintext"
  },
  "websocket": {
    "enabled": true,
    "path": "/Trojan-go"
  }
}
EOF
cat <<EOF > /etc/trojan-go/uuid.txt
$uuid
EOF

# service trojan-go
cat > "/etc/systemd/system/trojan-go.service" << EOF
[Unit]
Description=trojan-go
Documentation=https://github.com/p4gefau1t/trojan-go
After=network.target nss-lookup.target

[Service]
Type=simple
StandardError=journal
PIDFile=/etc/trojan-go/trojan-go.pid
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/trojan-go/trojan-go -config /etc/trojan-go/config.json
ExecReload=
ExecStop=/etc/trojan-go/trojan-go
LimitNPROC=10000
LimitNOFILE=1000000
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /etc/trojan-go/uuid.txt
$uuid
EOF

cat >/etc/nginx/conf.d/v2ray.conf <<EOF
    server {
        listen 80;
        listen [::]:80;
        listen 443 ssl http2 reuseport;
        listen [::]:443 http2 reuseport;
        ssl_certificate       /etc/v2ray/v2ray.crt;
        ssl_certificate_key   /etc/v2ray/v2ray.key;
        ssl_protocols         TLSv1.3;
        ssl_ciphers           TLS13-AES-256-GCM-SHA384:TLS13-CHACHA20-POLY1305-SHA256:TLS13-AES-128-GCM-SHA256:TLS13-AES-128-CCM-8-SHA256:TLS13-AES-128-CCM-SHA256:EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
        
        # Config for 0-RTT in TLSv1.3
        ssl_early_data on;
        ssl_stapling on;
        ssl_stapling_verify on;
        add_header Strict-Transport-Security "max-age=31536000";
        }
EOF
sed -i '$ ilocation /Trojan-go' /etc/nginx/conf.d/v2ray.conf
sed -i '$ i{' /etc/nginx/conf.d/v2ray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/v2ray.conf
sed -i '$ iproxy_pass http://127.0.0.1:2096;' /etc/nginx/conf.d/v2ray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/v2ray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/v2ray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/v2ray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/v2ray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/v2ray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/v2ray.conf
sed -i '$ iproxy_set_header Early-Data \$ssl_early_data;' /etc/nginx/conf.d/v2ray.conf
sed -i '$ i}' /etc/nginx/conf.d/v2ray.conf
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 80 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
systemctl daemon-reload
systemctl enable trojan-go.service
systemctl stop trojan-go.service
systemctl start trojan-go.service
systemctl restart nginx
cd /usr/bin
wget -O addws "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/addws.sh"
wget -O addvless "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/addvless.sh"
wget -O delws "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/delws.sh"
wget -O delvless "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/delvless.sh"
wget -O cekws "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/cekws.sh"
wget -O cekvless "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/cekvless.sh"
wget -O renewws "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/renewws.sh"
wget -O renewvless "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/renewvless.sh"
wget -O renewtr "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/renewtr.sh"
wget -O xp-ws "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/xp-ws.sh"
wget -O xp-vless "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/xp-vless.sh"
wget -O certv2ray "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/cert.sh"
wget -O addtrgo "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/addtrgo.sh"
wget -O deltrgo "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/deltrgo.sh"
wget -O cektrgo "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/cektrgo.sh"
wget -O xp-trgo "https://raw.githubusercontent.com/Endka2210/Autoscriptvps/main/xp-trgo.sh"
chmod +x addtrgo
chmod +x deltrgo
chmod +x cektrgo
chmod +x xp-trgo
chmod +x addws
chmod +x addvless
chmod +x delws
chmod +x delvless
chmod +x cekws
chmod +x cekvless
chmod +x renewws
chmod +x renewtr
chmod +x renewvless
chmod +x xp-ws
chmod +x xp-vless
chmod +x certv2ray
cd
mv /root/domain /etc/v2ray
echo "59 23 * * * root xp-ws" >> /etc/crontab
echo "59 23 * * * root xp-trgo" >> /etc/crontab
echo "59 23 * * * root xp-vless" >> /etc/crontab
#!/bin/bash

# Buat direktori untuk menyimpan file setup
mkdir -p /root/san/xray

# Buat file script untuk memeriksa dan mengelola layanan XRAY
cat <<EOF > /root/san/xray/check_xray.sh
#!/bin/bash

# Variabel warna
green='\033[0;32m'
red='\033[0;31m'
NC='\033[0m'

# Mendapatkan status layanan XRAY
xray_service=\$(systemctl is-active xray)

# Memeriksa jika layanan XRAY sedang berjalan
if [[ \$xray_service == "active" ]]; then 
   status_xray="\${green}ON\${NC}"
else
   status_xray="\${red}OFF\${NC}"
   # Restart layanan jika tidak berjalan
   systemctl restart xray
fi

echo "Status XRAY: \$status_xray"
EOF

# Beri izin eksekusi pada file script
chmod +x /root/san/xray/check_xray.sh

# Buat file unit systemd untuk menjalankan script secara otomatis
cat <<EOF > /etc/systemd/system/check_xray.service
[Unit]
Description=Check XRAY service status and restart if necessary
After=network.target

[Service]
Type=simple
ExecStart=/root/san/xray/check_xray.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload daemon systemd dan mulai serta aktifkan layanan
systemctl daemon-reload
systemctl start check_xray
systemctl enable check_xray

# Tambahkan script ke crontab agar berjalan saat VPS reboot
(crontab -l 2>/dev/null; echo "@reboot /root/san/xray/check_xray.sh") | crontab -

rm restart_xray.sh

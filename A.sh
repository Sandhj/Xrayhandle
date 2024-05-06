#!/bin/bash

# Buat direktori jika belum ada
mkdir -p /root/
cd /root/

# Buat script untuk restart otomatis Xray
cat << 'EOF' > nama.py

 #ISI SCRIPT DSINI
 
EOF

# Berikan izin eksekusi pada script
chmod +x x.py

# Buat file unit systemd untuk menjalankan script
cat << 'EOF' > /etc/systemd/system/nama.service
[Unit]
Description=San Store
After=network.target

[Service]
User=root
WorkingDirectory=/root/
ExecStart=/usr/bin/python3 nama.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload konfigurasi systemd
systemctl daemon-reload

# Aktifkan dan mulai layanan
systemctl start x.service
systemctl enable x.service
systemctl status x.service
sleep 2

echo "Restart X-ray tiap 5 Menit Dimulai"

cd
rm namascript.sh

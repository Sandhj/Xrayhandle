#!/bin/bash

# Buat direktori jika belum ada
mkdir -p /root/san/xray
cd /root/san/xray

# Buat script untuk restart otomatis Xray
cat << 'EOF' > x.py
import subprocess
import time

while True:
    try:
        subprocess.run(['systemctl', 'restart', 'xray'], check=True)
        print("Xray berhasil direstart.")
    except subprocess.CalledProcessError as e:
        print("Gagal melakukan restart Xray:", e)
    time.sleep(300)  # Menunggu 5 menit sebelum melakukan restart lagi

EOF

# Berikan izin eksekusi pada script
chmod +x x.sh

# Buat file unit systemd untuk menjalankan script
cat << 'EOF' > /etc/systemd/system/x.service
[Unit]
Description=Telegram Bot
After=network.target

[Service]
User=root
WorkingDirectory=/root/san/xray
ExecStart=/usr/bin/python3 x.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload konfigurasi systemd
systemctl daemon-reload

# Aktifkan dan mulai layanan
systemctl enable x.service
systemctl start x.service

echo "Restart X-ray tiap 5 Menit Dimulai"

cd
rm autorestartxray.sh

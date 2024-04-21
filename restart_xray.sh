#!/bin/bash

# Buat direktori untuk menyimpan script dan service
mkdir -p /root/san/xray

# Buat script untuk restart xray
cat <<EOT >> /root/san/xray/restart_xray.sh
#!/bin/bash

# Restart xray
systemctl restart xray
EOT

# Berikan izin eksekusi pada script restart_xray.sh
chmod +x /root/san/xray/restart_xray.sh

# Buat systemd service untuk restart xray
cat <<EOT >> /etc/systemd/system/restart_xray.service
[Unit]
Description=Restart xray Service Every Hour

[Service]
Type=simple
ExecStart=/root/san/xray/restart_xray.sh

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd agar mengenali service baru yang telah dibuat
systemctl daemon-reload

# Aktifkan service agar berjalan otomatis setiap kali VPS booting
systemctl enable restart_xray.service

# Tambahkan cron job untuk menjalankan script setiap satu jam
(crontab -l ; echo "0 * * * * /root/san/xray/restart_xray.sh") | crontab -

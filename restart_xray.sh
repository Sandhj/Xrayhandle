#!/bin/bash

# Buat direktori jika belum ada
mkdir -p /root/san/xray
cd /root/san/xray

# Buat script untuk restart otomatis Xray
cat << 'EOF' > auto_restart_xray.sh
#!/bin/bash

# Cek apakah xray.service tidak running
if ! systemctl is-active --quiet xray.service; then
    # Lakukan restart xray.service
    systemctl restart xray.service
    
    # Loop sampai xray.service berjalan
    while ! systemctl is-active --quiet xray.service; do
        sleep 1
    done
    
    echo "xray.service telah di-restart dan berjalan."
fi
EOF

# Berikan izin eksekusi pada script
chmod +x auto_restart_xray.sh

# Buat file unit systemd untuk menjalankan script
cat << 'EOF' > /etc/systemd/system/auto_restart_xray.service
[Unit]
Description=Auto Restart Xray Service

[Service]
Type=simple
ExecStart=/root/san/xray/auto_restart_xray.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Reload konfigurasi systemd
systemctl daemon-reload

# Aktifkan dan mulai layanan
systemctl enable auto_restart_xray.service
systemctl start auto_restart_xray.service

echo "Setup auto restart Xray selesai."
cd
rm restart_xray.sh

#!/bin/bash

# Buat direktori jika belum ada
mkdir -p /root/bot
cd /root/bot

# Buat script untuk restart otomatis Xray
cat << 'EOF' > clearlog.py
 import os
import schedule
import time

def clear_logs():
    # Cari dan hapus file log dengan ekstensi .log
    log_files = os.popen("find /var/log/ -name '*.log'").read().splitlines()
    for log_file in log_files:
        print(f"{log_file} cleared")
        with open(log_file, "w") as file:
            file.write("")

    # Cari dan hapus file log dengan ekstensi .err
    err_files = os.popen("find /var/log/ -name '*.err'").read().splitlines()
    for err_file in err_files:
        print(f"{err_file} cleared")
        with open(err_file, "w") as file:
            file.write("")

    # Cari dan hapus file log yang dimulai dengan mail.
    mail_files = os.popen("find /var/log/ -name 'mail.*'").read().splitlines()
    for mail_file in mail_files:
        print(f"{mail_file} cleared")
        with open(mail_file, "w") as file:
            file.write("")

    # Kosongkan file log sistem yang spesifik
    system_logs = ['/var/log/syslog', '/var/log/btmp', '/var/log/messages', '/var/log/debug']
    for system_log in system_logs:
        print(f"{system_log} cleared")
        with open(system_log, "w") as file:
            file.write("")

def job():
    print("Running log cleanup job...")
    clear_logs()
    print("Logs cleared successfully!")

# Atur jadwal untuk menjalankan job setiap 5 menit
schedule.every(5).minutes.do(job)

# Loop utama untuk menjalankan jadwal
while True:
    schedule.run_pending()
    time.sleep(1)
 
EOF

# Berikan izin eksekusi pada script
chmod +x clearlog.py

# Buat file unit systemd untuk menjalankan script
cat << 'EOF' > /etc/systemd/system/autocl.service
[Unit]
Description=San Store
After=network.target

[Service]
User=root
WorkingDirectory=/root/bot
ExecStart=/usr/bin/python3 clearlog.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload konfigurasi systemd
systemctl daemon-reload

# Aktifkan dan mulai layanan
systemctl enable autocl.service
systemctl start autocl.service

echo "Auto Clear Log tiap 5 Menit Dimulai"

cd
rm Autocl.sh

#!/bin/bash
rm -r /root/bot
rm /etc/systemd/system/buyvpn.service

# Buat direktori jika belum ada
mkdir -p /root/bot/buyvpn
cd /root/bot/buyvpn
mkdir -p photos
touch ssh.txt
touch vmess.txt
touch vless.txt
touch trojan.txt
touch akun1.txt
touch akun2.txt
touch akun3.txt
touch akun4.txt
# Buat script untuk restart otomatis Xray
cat << 'EOF' > buyvpn.py
import os
import sqlite3
import telebot
from telebot import types

# Ganti TOKEN_BOT dengan token bot Anda
TOKEN_BOT = '6474341901:AAH574AEKvhq1jK_N0NMBLjGezFbXDQLm-s'
# Ganti ADMIN_ID dengan id admin yang akan menerima foto
ADMIN_ID = '576495165'
bot = telebot.TeleBot(TOKEN_BOT)

# Path ke folder penyimpanan foto
PHOTO_FOLDER = 'photos/'

# Path ke file teks yang berisi konten SSH, VMESS, VLESS, dan TROJAN
SSH_FILE = 'ssh.txt'
VMESS_FILE = 'vmess.txt'
VLESS_FILE = 'vless.txt'
TROJAN_FILE = 'trojan.txt'
AKUN1_FILE = 'akun1.txt'
AKUN2_FILE = 'akun2.txt'
AKUN3_FILE = 'akun3.txt'
AKUN4_FILE = 'akun4.txt'

# Default stock for each option
DEFAULT_STOCK = {
    '1IP': 10,
    '2IP': 10,
    '5IP': 10,
    '3BULAN': 10
}

# Current stock for each option
current_stock = DEFAULT_STOCK.copy()

@bot.message_handler(commands=['start'])
def start(message):
    markup = types.InlineKeyboardMarkup(row_width=2)
    item1 = types.InlineKeyboardButton("1 IP ({})".format(current_stock['1IP']), callback_data='1IP')
    item2 = types.InlineKeyboardButton("2 IP ({})".format(current_stock['2IP']), callback_data='2IP')
    item3 = types.InlineKeyboardButton("5 IP ({})".format(current_stock['5IP']), callback_data='3IP')
    item4 = types.InlineKeyboardButton("3 BULAN ({})".format(current_stock['3BULAN']), callback_data='3BULAN')
    
    # Cek apakah pengguna adalah admin
    if str(message.from_user.id) == ADMIN_ID:
        reset_button = types.InlineKeyboardButton("Reset Stock", callback_data='RESET_STOCK')
        markup.add(item1, item2, item3, item4, reset_button)
    else:
        markup.add(item1, item2, item3, item4)
    
    bot.send_message(message.chat.id, "LIST HARGA :\n1 IP = 3.000\n2 IP = 5.000\n5 IP = 10.000\n3 Bulan = 25.000", reply_markup=markup)

@bot.callback_query_handler(func=lambda call: True)
def callback_query(call):
    global current_stock
    
    if call.data in ['1IP', '2IP', '5IP', '3BULAN']:
        if current_stock[call.data] > 0:
            current_stock[call.data] -= 1
            
            bot.send_message(call.message.chat.id, "Silakan Lakukan Pembayaran Dan Kirim Bukti Transfer Untuk Melanjutkan :\nSHOPEE PAY,DANA,GOPAY\n082292615651 A.n HASDAR ARISANDI\nQRIS link : https://tinyurl.com/SanQris".format(call.data))
            if call.data == '3BULAN':
                bot.register_next_step_handler(call.message, process_photo_for_3bulan)
            else:
                bot.register_next_step_handler(call.message, process_photo_for_ip)
        else:
            bot.send_message(call.message.chat.id, "Maaf, stok untuk {} telah habis.".format(call.data))
    elif call.data in ['SSH', 'VMESS', 'VLESS', 'TROJAN', 'AKUN1', 'AKUN2', 'AKUN3', 'AKUN4']:
        send_content_from_file(call.data, call.message.chat.id)
        bot.edit_message_reply_markup(call.message.chat.id, call.message.message_id, reply_markup=None)
    elif call.data == 'RESET_STOCK':
        reset_stock()
        
        bot.answer_callback_query(call.id, "Stock telah direset ke nilai default.")
    else:
        bot.answer_callback_query(call.id, "Pembayaran Diterima Silahkan Pilih Protokol Yang Di Inginkan".format(call.data))

def process_photo_for_ip(message):
    if message.photo:
        # Simpan foto ke folder penyimpanan foto
        file_id = message.photo[-1].file_id
        file_info = bot.get_file(file_id)
        downloaded_file = bot.download_file(file_info.file_path)
        photo_path = os.path.join(PHOTO_FOLDER, '{}.jpg'.format(file_id))
        with open(photo_path, 'wb') as new_file:
            new_file.write(downloaded_file)
        
        forward_photo_to_admin(photo_path, message.chat.username)
        
        markup = types.InlineKeyboardMarkup(row_width=2)
        item1 = types.InlineKeyboardButton("SSH", callback_data='SSH')
        item2 = types.InlineKeyboardButton("VMESS", callback_data='VMESS')
        item3 = types.InlineKeyboardButton("VLESS", callback_data='VLESS')
        item4 = types.InlineKeyboardButton("TROJAN", callback_data='TROJAN')
        markup.add(item1, item2, item3, item4)
        bot.send_message(message.chat.id, "Pilih jenis IP yang Anda inginkan:", reply_markup=markup)
    else:
        bot.send_message(message.chat.id, "Kirim Bukti Transfer")
        bot.register_next_step_handler(message, process_photo_for_ip) 

def process_photo_for_3bulan(message):
    if message.photo:
        # Simpan foto ke folder penyimpanan foto
        file_id = message.photo[-1].file_id
        file_info = bot.get_file(file_id)
        downloaded_file = bot.download_file(file_info.file_path)
        photo_path = os.path.join(PHOTO_FOLDER, '{}.jpg'.format(file_id))
        with open(photo_path, 'wb') as new_file:
            new_file.write(downloaded_file)
        
        forward_photo_to_admin(photo_path, message.chat.username)
        
        markup = types.InlineKeyboardMarkup(row_width=2)
        item1 = types.InlineKeyboardButton("AKUN1", callback_data='AKUN1')
        item2 = types.InlineKeyboardButton("AKUN2", callback_data='AKUN2')
        item3 = types.InlineKeyboardButton("AKUN3", callback_data='AKUN3')
        item4 = types.InlineKeyboardButton("AKUN4", callback_data='AKUN4')
        markup.add(item1, item2, item3, item4)
        bot.send_message(message.chat.id, "Pilih jenis AKUN 3 BULAN yang Anda inginkan:", reply_markup=markup)
    else:
        bot.send_message(message.chat.id, "Kirim Bukti Transfer")
        bot.register_next_step_handler(message, process_photo_for_ip) 

def forward_photo_to_admin(photo_path, username):
    if username:
        caption = "Bukti Transfer dari @" + username
    else:
        caption = "Bukti Transfer Dari No.Telegram " + str(message.chat.id)
    bot.send_photo(ADMIN_ID, open(photo_path, 'rb'), caption=caption)

def send_content_from_file(file_type, chat_id):
    file_path = ''
    if file_type == 'SSH':
        file_path = SSH_FILE
    elif file_type == 'VMESS':
        file_path = VMESS_FILE
    elif file_type == 'VLESS':
        file_path = VLESS_FILE
    elif file_type == 'TROJAN':
        file_path = TROJAN_FILE
    elif file_type == 'AKUN1':
        file_path = AKUN1_FILE
    elif file_type == 'AKUN2':
        file_path = AKUN2_FILE
    elif file_type == 'AKUN3':
        file_path = AKUN3_FILE
    elif file_type == 'AKUN4':
        file_path = AKUN4_FILE

    # Mendapatkan path file teks yang benar
    script_dir = os.path.dirname(__file__)
    file_path = os.path.join(script_dir, file_path)

    with open(file_path, 'r') as file:
        content = file.read()
        bot.send_message(chat_id, content)

def reset_stock():
    global current_stock
    current_stock = DEFAULT_STOCK.copy()

bot.polling()
EOF

# Berikan izin eksekusi pada script
chmod +x buyvpn.py

# Buat file unit systemd untuk menjalankan script
cat << 'EOF' > /etc/systemd/system/buyvpn.service
[Unit]
Description=San Store
After=network.target

[Service]
User=root
WorkingDirectory=/root/bot/buyvpn
ExecStart=/usr/bin/python3 buyvpn.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload konfigurasi systemd
systemctl daemon-reload

# Aktifkan dan mulai layanan
systemctl start buyvpn.service
systemctl enable buyvpn.service
systemctl status buyvpn.service
sleep 2

echo "INSTALL SUCCESFULLY"

cd
rm buyprem.sh

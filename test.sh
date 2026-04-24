#!/bin/bash
echo "Testing Gamify App..."
# Tunggu 20 detik biar makin aman, Java/Nginx butuh waktu buat 'bangun'
sleep 30 # MySQL butuh waktu buat "siap-siap"

# Ganti ke 8082 karena 8080 punyanya si Jenkins
# Ganti localhost dengan IP Host/LXC kamu
# Tambahkan /login.html di belakang IP
status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8082/login.html)
if [ $status -eq 200 ]; then
  echo "SUCCESS: App is rendering (HTTP 200)"
  exit 0
else
  echo "FAILED: App returned $status (Targeting Port 8082)"
  exit 1
fi
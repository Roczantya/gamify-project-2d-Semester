#!/bin/bash

# Ambil IP dari argument pertama, kalau kosong pakai default
TARGET_IP=${1:-"192.168.1.16"} 
PORT="8082"

echo "---------------------------------------"
echo "Testing Gamify App at http://$TARGET_IP:$PORT..."
echo "---------------------------------------"

# Tunggu sebentar biar app benar-benar up
sleep 10

# Cek koneksi ke login.html
status=$(curl -s -o /dev/null -w "%{http_code}" http://$TARGET_IP:$PORT/login.html)

if [ "$status" -eq 200 ]; then
  echo "✅ SUCCESS: App is rendering (HTTP 200)"
  exit 0
else
  echo "❌ FAILED: App returned $status"
  echo "Coba cek: Apakah port $PORT sudah di-expose di docker-compose?"
  exit 1
fi
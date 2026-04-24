#!/bin/bash
echo "Testing Gamify App..."
sleep 30

# MASUKKAN IP LXC KAMU SECARA MANUAL (Misal 192.168.1.16)


# Coba nembak ke login.html (pastikan nama filenya benar)
status=$(curl -s -o /dev/null -w "%{http_code}" http://172.17.0.1:8082/login.html)
if [ $status -eq 200 ]; then
  echo "SUCCESS: App is rendering (HTTP 200)"
  exit 0
else
  echo "FAILED: App returned $status (Targeting Port 8082 di $TARGET_IP)"
  exit 1
fi
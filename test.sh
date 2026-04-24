#!/bin/bash
echo "Testing Gamify App..."
sleep 15 # Tunggu container naik
status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)

if [ $status -eq 200 ]; then
  echo "SUCCESS: App is rendering (HTTP 200)"
  exit 0
else
  echo "FAILED: App returned $status"
  exit 1
fi
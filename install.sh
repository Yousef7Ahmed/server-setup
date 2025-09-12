#!/bin/bash
set -e

echo "[1/5] Updating system..."
apt update && apt upgrade -y

echo "[2/5] Installing required packages..."
apt install -y lxde-core lxterminal tightvncserver xvfb git python3 python3-pip novnc websockify curl

echo "[3/5] Setting up VNC server..."
rm -f /tmp/.X1-lock || true
killall Xtigervnc || true
vncserver :1 -geometry 1280x720 -depth 24

echo "[4/5] Setting up noVNC proxy..."
cd ~/noVNC || git clone https://github.com/novnc/noVNC.git ~/noVNC && cd ~/noVNC
./utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

echo "[5/5] Done!"
echo "Open this in your browser:"
echo "http://YOUR_SERVER_IP:6080/vnc.html?host=YOUR_SERVER_IP&port=6080"

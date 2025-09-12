#!/bin/bash
set -e

echo "[1/6] Updating system..."
apt update && apt upgrade -y

echo "[2/6] Installing required packages..."
apt install -y lxde-core lxterminal tightvncserver xvfb git python3 python3-pip novnc websockify curl

echo "[3/6] Installing Wine..."
dpkg --add-architecture i386
apt update
apt install -y wine64 wine32 winetricks

echo "[4/6] Setting up VNC server..."
rm -f /tmp/.X1-lock || true
killall Xtigervnc || true
vncserver :1 -geometry 1280x720 -depth 24

echo "[5/6] Setting up noVNC proxy..."
cd ~/noVNC || git clone https://github.com/novnc/noVNC.git ~/noVNC && cd ~/noVNC
./utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

echo "[6/6] Done!"
echo "Open this in your browser:"
echo "http://YOUR_SERVER_IP:6080/vnc.html?host=YOUR_SERVER_IP&port=6080"
echo
echo "To run your game later, upload it to the server and run:"
echo "wine your-game.exe"


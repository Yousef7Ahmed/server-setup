#!/bin/bash
set -e

# -------------------------------
#  سكربت شامل لتشغيل VNC + noVNC + LXDE
# -------------------------------

echo "[1/8] Updating system..."
apt update && apt upgrade -y

echo "[2/8] Installing required packages..."
apt install -y tigervnc-standalone-server tigervnc-common novnc websockify net-tools lxde-core lxterminal xvfb git python3 python3-pip curl x11-xserver-utils wget

echo "[3/8] Installing Wine..."
dpkg --add-architecture i386
apt update
apt install -y wine64 wine32 winetricks

echo "[4/8] Cleaning previous VNC sessions..."
rm -f /tmp/.X1-lock || true
vncserver -kill :1 || true
killall Xtigervnc || true

echo "[5/8] Setting up VNC server..."
mkdir -p ~/.vnc
echo "123456" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

echo "#!/bin/bash
xrdb \$HOME/.Xresources
startlxde" > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup

vncserver :1 -geometry 1280x720 -depth 24

echo "[6/8] Setting up noVNC proxy..."
cd ~/noVNC || git clone https://github.com/novnc/noVNC.git ~/noVNC && cd ~/noVNC
./utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

echo "[7/8] Opening firewall port 6080..."
if command -v ufw >/dev/null 2>&1; then
    ufw allow 6080/tcp
    ufw reload
fi
iptables -C INPUT -p tcp --dport 6080 -j ACCEPT 2>/dev/null || iptables -A INPUT -p tcp --dport 6080 -j ACCEPT

echo "[8/8] Done! Opening browser..."
sleep 3
URL="http://$(curl -s ifconfig.me):6080/vnc.html?host=$(curl -s ifconfig.me)&port=6080"
echo "🌐 Open your browser at:"
echo "$URL"
xdg-open "$URL" || echo "Visit manually: $URL"

echo
echo "To run your game later, upload it to the server and run:"
echo "wine your-game.exe"



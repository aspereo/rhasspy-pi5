#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# 1.  Install libssl1.1 + dependencies
# ─────────────────────────────────────────────────────────────
sudo apt install -y libopenblas0 libgfortran5 jq sox wget
cd /tmp
wget -q http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.1w-0+deb11u2_arm64.deb
sudo dpkg -i libssl1.1_1.1.1w-0+deb11u2_arm64.deb

# ─────────────────────────────────────────────────────────────
# 2.  Fetch latest Rhasspy ARM64 .deb and patch deps
# ─────────────────────────────────────────────────────────────
cd ~
RHASSPY_DEB=$(curl -sL https://api.github.com/repos/rhasspy/rhasspy/releases/latest \
  | jq -r '.assets[] | select(.name|test("arm64.deb$")).browser_download_url')
wget -q -O rhasspy_arm64.deb "$RHASSPY_DEB"

mkdir -p rhasspy_pkg
dpkg-deb -x rhasspy_arm64.deb rhasspy_pkg/
dpkg-deb -e rhasspy_arm64.deb rhasspy_pkg/DEBIAN
sed -i -e 's/libgfortran4/libgfortran5/' -e 's/libopenblas-base/libopenblas0/' rhasspy_pkg/DEBIAN/control
dpkg-deb -b rhasspy_pkg rhasspy_arm64_bookworm.deb >/dev/null
sudo dpkg -i rhasspy_arm64_bookworm.deb

sudo apt --fix-broken install -y
sudo apt install -y supervisor

sudo apt update
sudo apt install -y mosquitto
sudo systemctl enable --now mosquitto

cd /tmp
wget http://ftp.debian.org/debian/pool/main/libf/libffi/libffi6_3.2.1-9_arm64.deb
sudo dpkg -i libffi6_3.2.1-9_arm64.deb


# ─────────────────────────────────────────────────────────────
# 3.  Bootstrap profile + systemd user service
# ─────────────────────────────────────────────────────────────
mkdir -p ~/.config/rhasspy/profiles/en
rhasspy --user-profiles ~/.config/rhasspy/profiles --profile en --cli export \
  | tar -xz -C ~/.config/rhasspy/profiles/en

cat > ~/.config/systemd/user/rhasspy.service <<'UNIT'
[Unit]
Description=Rhasspy Voice Assistant
After=pulseaudio.service network.target sound.target

[Service]
ExecStart=/usr/bin/rhasspy --user-profiles %h/.config/rhasspy/profiles -p en
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
UNIT

systemctl --user daemon-reload
systemctl --user enable --now rhasspy.service

echo
echo ">>> Rhasspy running at http://$(hostname -I | awk '{print $1}'):12101"
echo "    Use Audio ▸ Test to confirm Record/Play."
EOSH
chmod +x ~/setup_rhasspy.sh

#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────
# 1.  Install PulseAudio/Bluetooth basics
# ─────────────────────────────────────────────────────────────
sudo apt update
sudo apt install -y pulseaudio pulseaudio-module-bluetooth \
                    bluez bluetooth lsof

# Disable PipeWire’s Pulse shim (to avoid port conflicts)
systemctl --user --now disable pipewire-pulse.socket pipewire-pulse.service 2>/dev/null || true

# Make sure user services live beyond SSH
sudo loginctl enable-linger "$USER"

# ─────────────────────────────────────────────────────────────
# 2.  Pair your BT speaker‑phone (interactive)
# ─────────────────────────────────────────────────────────────
echo
echo ">>> Put your speaker‑phone in pair‑mode, then run:"
echo "    bluetoothctl -- pairable on"
echo "    bluetoothctl -- scan on    (wait for MAC)"
echo "    bluetoothctl -- pair <MAC>"
echo "    bluetoothctl -- connect <MAC>"
echo
read -p "Press ENTER after the device shows 'Connected: yes'…"

# ─────────────────────────────────────────────────────────────
# 3.  Route ALSA default → Pulse
# ─────────────────────────────────────────────────────────────
sudo tee /etc/asound.conf >/dev/null <<'EOF'
pcm.!default {
  type pulse
}
ctl.!default {
  type pulse
}
EOF

# ─────────────────────────────────────────────────────────────
# 4.  Start user‑session PulseAudio & set HFP as default
# ─────────────────────────────────────────────────────────────
systemctl --user enable --now pulseaudio.socket
pulseaudio --check || pulseaudio --start --exit-idle-time=-1

# Switch card and set default sink
CARD=$(pactl list short cards | awk '/bluez_card/ {print $1; exit}')
pactl set-card-profile "$CARD" handsfree_head_unit || true
SINK=$(pactl list short sinks | awk '/handsfree_head_unit/ {print $2; exit}')
pactl set-default-sink "$SINK"

echo
echo ">>> Audio path ready. Test with:"
echo "    aplay -D default /usr/share/sounds/alsa/Front_Center.wav"
echo
EOSH
chmod +x ~/audio_fix.sh

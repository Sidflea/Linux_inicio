#!/bin/bash

#---Update && Upgrade
sudo pacman -Syyu

# --- Setup UFW rules
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# --- Harden /etc/sysctl.conf
sudo sysctl kernel.modules_disabled=1
sudo sysctl -a
sudo sysctl -A
sudo sysctl mib
sudo sysctl net.ipv4.conf.all.rp_filter
sudo sysctl -a --pattern 'net.ipv4.conf.(eth|wlan)0.arp'

# --- PREVENT IP SPOOFS
cat <<EOF > /etc/host.conf
order bind,hosts
multi on
EOF

# --- Enable fail2ban
sudo cp jail.local /etc/fail2ban/
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

echo "listening ports"
sudo netstat -tunlp

#---Yay
sudo pacman -Syu
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay --version

#---Brave
yay -S brave-bin
yay -S brave-beta-bin
yay -S brave-nightly-bin

#---Flatpak && Flathub
sudo pacman -S flatpak

shutdown -h now

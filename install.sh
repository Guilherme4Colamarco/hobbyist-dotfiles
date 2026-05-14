#!/usr/bin/env bash

set -euo pipefail

echo "[+] Starting Arch setup..."

echo "[+] Installing base packages..."
sudo pacman -S --needed --noconfirm base-devel stow fish eza git

echo "[+] Verifying whether yay is installed or not..."
if ! command -v yay &>/dev/null; then
    echo "[!] yay not found"
    echo "[+] Installing yay..."
    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' EXIT
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
else
    echo "[=] yay already installed"
fi

echo "[+] Creating config directories..."
mkdir -p ~/.local/share/fonts

DOTFILES="$HOME/hobbyist-dotfiles"

if [ -d "$DOTFILES" ]; then
    echo "[+] Applying dotfiles..."
    "$DOTFILES/stow-configs.sh"

    echo "[+] Copying fonts and wallpapers..."
    cp -r "$DOTFILES/Configs/Resources/fonts/." ~/.local/share/fonts/
    cp -r "$DOTFILES/Wallpapers" ~/

    pkglist="$DOTFILES/Configs/installed-pkg/pkglist.txt"
    if [ -f "$pkglist" ]; then
        echo "[+] Installing packages from list..."
        xargs yay -S --needed --answerclean All --answerdiff None --noconfirm \
            < "$pkglist"
    fi
else
    echo "[!] Dotfiles repo not found at $DOTFILES — skipping dotfiles, resources, and package list."
fi

if command -v fish &>/dev/null; then
    echo "[+] Setting fish as default shell..."
    chsh -s "$(command -v fish)"
fi

if ! pacman -Q bluez bluez-utils &>/dev/null; then
  yay -S bluez bluez-utils && echo "bluez and bluez-utils installed successfully"
fi
echo "[+] Enabling Bluetooth..."
sudo systemctl enable --now bluetooth.service
sudo rfkill unblock bluetooth || true

echo "[+] Setting Niri as default..."
if [[ -f "$HOME/.config/systemd/user/niri.service" ]]; then
  systemctl --user daemon-reload
  systemctl --user enable --now niri.service
fi

echo "[+] Enabling mako sound..."
if [[ -f "$HOME/.config/systemd/user/mako-sound.service" ]]; then
  systemctl --user daemon-reload
  systemctl --user enable --now mako-sound.service
fi

echo "[+] Installing WhiteSur icon pack..."
cd ~
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
cd ~/WhiteSur-icon-theme
bash install.sh
rm -rf ~/WhiteSur-icon-theme/

echo "[✓] Setup completed successfully!"

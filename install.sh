#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DEFAULT="$SCRIPT_DIR"
DOTFILES="${DOTFILES:-$DOTFILES_DEFAULT}"
ASSUME_YES="${DOTFILES_ASSUME_YES:-0}"
BROWSERS_ENV="${DOTFILES_BROWSERS:-}"

if [[ "${EUID}" -eq 0 ]]; then
    printf '%s\n' "Do not run this installer as root. Run it as your user; it will ask sudo when needed." >&2
    exit 1
fi

green='\033[1;32m'
yellow='\033[1;33m'
red='\033[1;31m'
blue='\033[1;34m'
reset='\033[0m'

header() { printf '%b\n' "${blue}==> $*${reset}"; }
info() { printf '%b\n' "${green}[+] $*${reset}"; }
warn() { printf '%b\n' "${yellow}[!] $*${reset}"; }
error() { printf '%b\n' "${red}[x] $*${reset}"; }

have_cmd() { command -v "$1" >/dev/null 2>&1; }
pkg_installed() { pacman -Q "$1" >/dev/null 2>&1; }

yes_no() {
    local prompt="$1" default="${2:-N}" reply
    local suffix="[y/N]"
    [[ "$default" == "Y" || "$default" == "y" ]] && suffix="[Y/n]"
    if [[ "$ASSUME_YES" == "1" ]]; then
        [[ "$default" == "Y" || "$default" == "y" ]]
        return
    fi
    while true; do
        read -r -p "$prompt $suffix: " reply || true
        reply="${reply:-$default}"
        case "$reply" in
            y|Y|yes|YES) return 0 ;;
            n|N|no|NO) return 1 ;;
        esac
    done
}

select_menu() {
    local prompt="$1"; shift
    local -a options=("$@")
    local i choice
    printf '%b\n' "${blue}${prompt}${reset}"
    for i in "${!options[@]}"; do
        printf '  %d) %s\n' "$((i + 1))" "${options[$i]}"
    done
    if [[ "$ASSUME_YES" == "1" ]]; then
        printf '%s\n' "1"
        return 0
    fi
    while true; do
        read -r -p "Select 1-${#options[@]}: " choice || true
        [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#options[@]} )) && { printf '%s\n' "$choice"; return 0; }
    done
}

multiselect_menu() {
    local prompt="$1"; shift
    local -a options=("$@")
    local choice selected=() item
    printf '%b\n' "${blue}${prompt}${reset}"
    for item in "${!options[@]}"; do
        printf '  %d) %s\n' "$((item + 1))" "${options[$item]}"
    done
    printf '  0) None\n'
    if [[ "$ASSUME_YES" == "1" ]]; then
        printf '0\n'
        return 0
    fi
    while true; do
        read -r -p "Select comma-separated choices: " choice || true
        [[ -z "$choice" ]] && choice="0"
        IFS=',' read -r -a selected <<< "$choice"
        if [[ "${#selected[@]}" -gt 0 ]]; then
            local ok=1
            for item in "${selected[@]}"; do
                item="${item//[[:space:]]/}"
                [[ "$item" =~ ^[0-9]+$ ]] && (( item >= 0 && item <= ${#options[@]} )) || ok=0
            done
            (( ok )) && { printf '%s\n' "$choice"; return 0; }
        fi
    done
}

bootstrap_yay() {
    if have_cmd yay; then
        info "yay already installed"
        return
    fi
    warn "yay not found; bootstrapping"
    install_core_packages git base-devel
    local tmpdir
    tmpdir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
}

install_core_packages() {
    local -a requested=("$@") filtered=()
    local pkg
    for pkg in "${requested[@]}"; do
        pkg_installed "$pkg" && { info "Skipping installed core package: $pkg"; continue; }
        filtered+=("$pkg")
    done
    ((${#filtered[@]} == 0)) && return 0
    info "Installing core packages with pacman: ${filtered[*]}"
    if [[ "$ASSUME_YES" == "1" ]]; then
        sudo pacman -S --needed --noconfirm "${filtered[@]}"
    else
        sudo pacman -S --needed "${filtered[@]}"
    fi
}

install_packages() {
    local -a requested=("$@") filtered=() seen=()
    local pkg
    for pkg in "${requested[@]}"; do
        [[ -z "$pkg" ]] && continue
        [[ " ${seen[*]} " == *" $pkg "* ]] && continue
        seen+=("$pkg")
        if pkg_installed "$pkg"; then
            info "Skipping installed package: $pkg"
            continue
        fi
        filtered+=("$pkg")
    done
    ((${#filtered[@]} == 0)) && return 0
    info "Installing: ${filtered[*]}"
    if [[ "$ASSUME_YES" == "1" ]]; then
        yay -S --needed --noconfirm "${filtered[@]}"
    else
        yay -S --needed "${filtered[@]}"
    fi
}

install_whitesur() {
    info "Installing WhiteSur icon pack"
    local tmpdir
    tmpdir="$(mktemp -d)"
    git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git "$tmpdir/WhiteSur-icon-theme"
    (cd "$tmpdir/WhiteSur-icon-theme" && bash install.sh)
    rm -rf "$tmpdir"
}

apply_dotfiles() {
    [[ -d "$DOTFILES" ]] || { warn "Dotfiles repo not found at $DOTFILES"; return; }
    info "Applying dotfiles from $DOTFILES"
    "$DOTFILES/stow-configs.sh"
    mkdir -p "$HOME/.local/share/fonts"
    [[ -d "$DOTFILES/Configs/Resources/fonts" ]] && cp -rn "$DOTFILES/Configs/Resources/fonts/." "$HOME/.local/share/fonts/" || true
    [[ -d "$DOTFILES/Wallpapers" ]] && cp -rn "$DOTFILES/Wallpapers" "$HOME/" || true
}

mapfile -t PKGLIST < <(awk 'NF && $1 !~ /^#/ {print $1}' "$DOTFILES/Configs/installed-pkg/pkglist.txt" 2>/dev/null || true)

SPECIAL_SKIP=(brave-origin-beta-bin brave-bin firefox zen-browser-bin helium-browser-bin timeshift snapper niri niri-git mangowm-git)
is_special_skip() {
    local p="$1" s
    for s in "${SPECIAL_SKIP[@]}"; do [[ "$p" == "$s" ]] && return 0; done
    return 1
}

COMMON_PKGS=()
OPTIONAL_LIBREWOLF=()
for pkg in "${PKGLIST[@]}"; do
    [[ "$pkg" == librewolf-bin ]] && OPTIONAL_LIBREWOLF+=("$pkg") && continue
    is_special_skip "$pkg" && continue
    COMMON_PKGS+=("$pkg")
done

header "Arch/CachyOS dotfiles installer"
info "DOTFILES: $DOTFILES"

mkdir -p "$HOME/.local/share/fonts"

CORE_PKGS=()
CORE_DEFAULT_PKGS=(base-devel stow fish eza git)
COMMON_SELECTION=()
if [[ "$ASSUME_YES" == "1" ]] || yes_no "Install core packages?" Y; then
    CORE_PKGS=("${CORE_DEFAULT_PKGS[@]}")
fi

install_core_packages "${CORE_PKGS[@]}"
bootstrap_yay

if [[ "$ASSUME_YES" == "1" ]] || yes_no "Apply dotfiles/resources (stow + fonts/wallpapers)?" Y; then
    apply_dotfiles
fi

if [[ "$ASSUME_YES" == "1" ]] || yes_no "Install common packages from pkglist?" Y; then
    COMMON_SELECTION=("${COMMON_PKGS[@]}")
fi

browser_choices=()
browser_map=("brave-bin" "firefox" "zen-browser-bin" "helium-browser-bin")
browser_names=("Brave" "Firefox" "Zen" "Helium")
printf '%b\n' "${blue}Browser choices${reset}"
for i in "${!browser_map[@]}"; do
    status=""
    pkg="${browser_map[$i]}"
    pkg_installed "$pkg" && status=" (installed)"
    printf '  %d) %s%s -> %s\n' "$((i + 1))" "${browser_names[$i]}" "$status" "$pkg"
done
printf '  0) None\n'
if [[ -n "$BROWSERS_ENV" ]]; then
    IFS=',' read -r -a browser_choices <<< "$BROWSERS_ENV"
elif [[ "$ASSUME_YES" == "1" ]]; then
    browser_choices=()
else
    read -r -p "Select browsers (comma-separated, 0 for none): " browser_input || true
    browser_input="${browser_input:-0}"
    IFS=',' read -r -a browser_choices <<< "$browser_input"
fi

selected_browsers=()
for choice in "${browser_choices[@]}"; do
    choice="${choice//[[:space:]]/}"
    case "$choice" in
        1) selected_browsers+=("brave-bin") ;;
        2) selected_browsers+=("firefox") ;;
        3) selected_browsers+=("zen-browser-bin") ;;
        4) selected_browsers+=("helium-browser-bin") ;;
        0|"") ;;
    esac
done

compositor_selection=()
if [[ "$ASSUME_YES" == "1" ]]; then
    compositor_selection=()
else
    printf '%b\n' "${blue}Compositor choice${reset}"
    printf '  1) niri-git\n  2) mangowm-git\n  3) both\n  4) none\n'
    read -r -p "Select compositor: " compositor_choice || true
    compositor_choice="${compositor_choice:-4}"
    case "$compositor_choice" in
        1) compositor_selection=(niri-git) ;;
        2) compositor_selection=(mangowm-git) ;;
        3) compositor_selection=(niri-git mangowm-git) ;;
        *) compositor_selection=() ;;
    esac
fi

if [[ " ${compositor_selection[*]} " == *" niri-git "* ]] && pkg_installed niri; then
    warn "niri is installed; niri-git may conflict with it."
    if yes_no "Remove niri before installing niri-git?" N; then
        remove_args=(-Rns niri)
        [[ "$ASSUME_YES" == "1" ]] && remove_args=(-Rns --noconfirm niri)
        if ! yay "${remove_args[@]}"; then
            warn "Removal failed. If niri-deps/inir-deps is installed as a dependency chain, remove it manually first."
        fi
    else
        warn "Skipping niri-git because niri is installed and removal was not approved."
        compositor_selection=("${compositor_selection[@]/niri-git/}")
    fi
fi

snapshot_selection=()
if pkg_installed snapper; then
    warn "Snapper is already installed; recommended snapshot tool."
fi
if [[ "$ASSUME_YES" == "1" ]]; then
    if pkg_installed snapper; then
        snapshot_selection=(snapper)
    fi
else
    printf '%b\n' "${blue}Snapshot choice${reset}"
    printf '  1) Snapper\n  2) Timeshift\n  3) none\n'
    read -r -p "Select snapshot tool: " snapshot_choice || true
    snapshot_choice="${snapshot_choice:-3}"
    case "$snapshot_choice" in
        1) snapshot_selection=(snapper) ;;
        2) pkg_installed snapper && warn "Snapper is installed; Timeshift will only be installed because you explicitly chose it."; snapshot_selection=(timeshift) ;;
        *) snapshot_selection=() ;;
    esac
fi

service_pkgs=()
enable_bluetooth=0
if [[ "$ASSUME_YES" == "1" ]] || yes_no "Install and enable bluetooth service?" Y; then
    service_pkgs+=(bluez bluez-utils)
    enable_bluetooth=1
fi
enable_niri_service=0
yes_no "Enable niri user service after package install?" Y && enable_niri_service=1
enable_mako_sound=0
yes_no "Enable mako sound service after package install?" Y && enable_mako_sound=1

whitesur_selection=()
if [[ "$ASSUME_YES" != "1" ]] && yes_no "Install WhiteSur icon pack?" N; then
    whitesur_selection=(whitesur-icon-theme)
fi

all_packages=("${COMMON_SELECTION[@]}" "${selected_browsers[@]}" "${compositor_selection[@]}" "${snapshot_selection[@]}" "${service_pkgs[@]}")
install_packages "${all_packages[@]}"

if [[ "$enable_bluetooth" == "1" ]]; then
    sudo systemctl enable --now bluetooth.service || true
    sudo rfkill unblock bluetooth || true
fi

if [[ "${#OPTIONAL_LIBREWOLF[@]}" -gt 0 ]] && yes_no "Install optional Librewolf package?" N; then
    install_packages "${OPTIONAL_LIBREWOLF[@]}"
fi

if [[ "$enable_niri_service" == "1" ]]; then
    if [[ -f "$HOME/.config/systemd/user/niri.service" ]]; then
        systemctl --user daemon-reload
        systemctl --user enable --now niri.service || warn "Failed to enable niri user service."
    else
        warn "niri.service not found; skipping user service enablement."
    fi
fi

if [[ "$enable_mako_sound" == "1" ]]; then
    if [[ -f "$HOME/.config/systemd/user/mako-sound.service" ]]; then
        systemctl --user daemon-reload
        systemctl --user enable --now mako-sound.service || warn "Failed to enable mako sound service."
    else
        warn "mako-sound.service not found; skipping user service enablement."
    fi
fi

if [[ "${#whitesur_selection[@]}" -gt 0 ]]; then
    install_whitesur
fi

if have_cmd fish && yes_no "Set fish as default shell?" Y; then
    info "Setting fish as default shell"
    fish_path="$(command -v fish)"
    if grep -qxF "$fish_path" /etc/shells; then
        chsh -s "$fish_path" || warn "Failed to change shell."
    else
        warn "$fish_path is not listed in /etc/shells; skipping chsh."
    fi
fi

info "Setup completed successfully"

#!/usr/bin/env bash
# Installs the tools/fonts these dotfiles assume are present.
# Does NOT symlink any files into place - that's a separate, manual step.
set -euo pipefail

info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
skip() { printf '\033[1;33m--\033[0m %s (skipped)\n' "$1"; }

uname_arch() {
  case "$(uname -m)" in
    x86_64|amd64) echo "x86_64" ;;
    arm64|aarch64) echo "arm64" ;;
    *) echo "unsupported" ;;
  esac
}

install_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [[ -d "$tpm_dir" ]]; then
    return
  fi
  info "Installing tmux plugin manager (tpm)"
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$tpm_dir"
}

# --- macOS -------------------------------------------------------------

install_macos() {
  if ! command -v brew &>/dev/null; then
    echo "Homebrew not found - install it first: https://brew.sh" >&2
    exit 1
  fi

  info "Installing CLI tools via Homebrew"
  brew install git eza bat ripgrep fzf direnv zoxide atuin neovim tmux lazygit starship herdr

  info "Installing Ghostty and Meslo Nerd Font"
  brew install --cask ghostty font-meslo-lg-nerd-font
}

# --- Linux (apt / Debian, Ubuntu) --------------------------------------

install_starship() {
  command -v starship &>/dev/null && return
  info "Installing starship"
  curl -sS https://starship.rs/install.sh | sh -s -- -y
}

install_zoxide() {
  command -v zoxide &>/dev/null && return
  info "Installing zoxide"
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

install_atuin() {
  command -v atuin &>/dev/null && return
  info "Installing atuin"
  curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh
}

install_lazygit() {
  command -v lazygit &>/dev/null && return
  local arch version
  arch="$(uname_arch)"
  if [[ "$arch" == "unsupported" ]]; then
    skip "lazygit (unsupported architecture: $(uname -m))"
    return
  fi
  info "Installing lazygit"
  version=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_${arch}.tar.gz"
  tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit -D -t /usr/local/bin/
  rm -f /tmp/lazygit.tar.gz /tmp/lazygit
}

install_eza() {
  command -v eza &>/dev/null && return
  local arch target version
  arch="$(uname_arch)"
  if [[ "$arch" == "unsupported" ]]; then
    skip "eza (unsupported architecture: $(uname -m))"
    return
  fi
  case "$arch" in
    x86_64) target="x86_64-unknown-linux-gnu" ;;
    arm64)  target="aarch64-unknown-linux-gnu" ;;
  esac
  info "Installing eza"
  version=$(curl -s "https://api.github.com/repos/eza-community/eza/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
  curl -Lo /tmp/eza.tar.gz "https://github.com/eza-community/eza/releases/download/${version}/eza_${target}.tar.gz"
  tar xf /tmp/eza.tar.gz -C /tmp eza
  sudo install /tmp/eza -D -t /usr/local/bin/
  rm -f /tmp/eza.tar.gz /tmp/eza
}

install_meslo_font_linux() {
  local font_dir="$HOME/.local/share/fonts/NerdFonts"
  if compgen -G "$font_dir/Meslo*.ttf" &>/dev/null; then
    return
  fi
  info "Installing Meslo Nerd Font"
  mkdir -p "$font_dir"
  curl -Lo /tmp/Meslo.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
  unzip -oq /tmp/Meslo.zip -d "$font_dir"
  rm -f /tmp/Meslo.zip
  fc-cache -f "$font_dir" &>/dev/null || true
}

install_linux_apt() {
  if ! command -v apt-get &>/dev/null; then
    echo "This script's Linux path only supports apt (Debian/Ubuntu)." >&2
    exit 1
  fi

  info "Installing CLI tools via apt"
  sudo apt-get update
  sudo apt-get install -y git tmux fzf ripgrep direnv neovim bat curl unzip fontconfig

  # Debian/Ubuntu ship bat's binary as `batcat` (name clash with another package)
  if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  fi

  install_starship
  install_zoxide
  install_atuin
  install_lazygit
  install_eza
  install_meslo_font_linux

  skip "herdr (no confirmed Linux install path - see https://herdr.dev)"
  skip "Ghostty (packaging varies by distro - see https://ghostty.org/docs/install/binary)"
}

# --- Entry point ---------------------------------------------------------

case "$(uname -s)" in
  Darwin) install_macos ;;
  Linux)  install_linux_apt ;;
  *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

install_tpm

info "Done. Inside tmux, press prefix + I to have tpm install the configured plugins."

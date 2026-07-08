# dotfiles

Personal dotfiles shared across macOS and Linux.

## Contents

| File / dir           | Purpose                                                              |
| --------------------- | --------------------------------------------------------------------- |
| `zshrc`               | zsh config — bootstraps [zinit](https://github.com/zdharma-continuum/zinit), loads `aliases`/`exports`/`functions`, wires up starship/zoxide/atuin |
| `aliases`             | shell aliases (navigation, git, `eza`/`bat` shortcuts)               |
| `exports`             | environment variables (`EDITOR`, locale, `PATH`, `fzf`/`bat` tuning) |
| `functions`           | shell functions (`extract`, `clone`, `mkd`, `gz`, `compress`, `mov_to_mp4`, `copy_website`) |
| `tmux.conf`           | tmux config — `C-a` prefix, vi copy-mode, [tpm](https://github.com/tmux-plugins/tpm)-managed plugins |
| `starship.toml`       | [starship](https://starship.rs) prompt config                       |
| `ghostty/config`      | [Ghostty](https://ghostty.org) terminal config                      |
| `herdr/config.toml`   | [herdr](https://herdr.dev) config — tmux-muscle-memory keybindings  |
| `gitconfig`           | git config (user identity, aliases)                                 |
| `gitignore`           | global gitignore (OS cruft: `.DS_Store`, `Thumbs.db`, etc.)          |
| `install.sh`          | installs the CLI tools and fonts these dotfiles assume are present  |

## Setup

1. Install dependencies:
   ```sh
   ./install.sh
   ```
   Installs CLI tools (`eza`, `bat`, `ripgrep`, `fzf`, `direnv`, `zoxide`, `atuin`, `neovim`, `tmux`, `lazygit`, `starship`) and the Meslo Nerd Font via Homebrew on macOS, or apt + upstream install scripts on Debian/Ubuntu. herdr and Ghostty are macOS-only for now — install those manually on Linux. zsh itself and [zinit](https://github.com/zdharma-continuum/zinit) are not installed by the script: zsh is expected to already be your shell, and zinit self-bootstraps the first time `zshrc` is sourced.

2. Symlink the files you want into place, e.g.:
   ```sh
   ln -sf "$PWD/zshrc" ~/.zshrc
   ln -sf "$PWD/aliases" ~/.aliases
   ln -sf "$PWD/exports" ~/.exports
   ln -sf "$PWD/functions" ~/.functions
   ln -sf "$PWD/gitconfig" ~/.gitconfig
   ln -sf "$PWD/gitignore" ~/.gitignore
   ln -sf "$PWD/tmux.conf" ~/.tmux.conf
   ln -sf "$PWD/starship.toml" ~/.config/starship.toml
   ln -sf "$PWD/herdr/config.toml" ~/.config/herdr/config.toml
   # macOS
   ln -sf "$PWD/ghostty/config" ~/Library/Application\ Support/com.mitchellh.ghostty/config
   # Linux
   ln -sf "$PWD/ghostty/config" ~/.config/ghostty/config
   ```
   This is intentionally manual rather than scripted, since it can overwrite existing config — back up anything you care about first.

3. Inside tmux, press `prefix + I` to have tpm install the plugins declared in `tmux.conf`.

## Scope

These files are meant to be safe to make public: no work-specific (Bitso) commands, no Kubernetes/cloud-provider aliases, no API keys, tokens, or emails. Anything environment- or employer-specific lives outside this repo.

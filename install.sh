#!/usr/bin/env bash

set -e

dotfiles_dir="$(cd "$(dirname "$0")" && pwd)"

apt_install() {
  sudo apt -y install "$@"
}

snap_install() {
  sudo snap install --classic "$@"
}

clone() {
  local src="$1"
  local dst="$2"

  set +e
  git clone "$src" "$dst" 2>/dev/null
  set -e
}

setup_nvim_config() {
  python3 -m pip install --upgrade pynvim

  clone \
    "https://github.com/luan/nvim" \
    "$HOME/.config/nvim"

  nvim -c 'GoInstallBinaries' -c 'quitall'
  nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
  nvim -c 'UpdateRemotePlugins' -c 'quitall'
  #nvim --headless -c 'TSInstallSync all' -c 'quitall'
  nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}

add_ppa() {
  sudo add-apt-repository -y ppa:$1
}

main() {
  (
  cd "$dotfiles_dir"

  add_ppa "neovim-ppa/stable"
  sudo apt -y update
  sudo apt -y upgrade
  sudo apt -y autoremove

  apt_install bat
  apt_install coreutils
  apt_install curl
  apt_install findutils
  apt_install fd-find
  apt_install fzf
  apt_install htop
  apt_install jq
  apt_install neovim
  apt_install python3
  apt_install python3-pip
  apt_install ripgrep
  apt_install tmux

  snap_install go
  snap_install node
  #snap_install nvim
  snap_install rustup
  snap_install starship

  setup_nvim_config
  )
}

main

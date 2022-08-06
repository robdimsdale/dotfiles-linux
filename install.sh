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
  #nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
  #nvim -c 'UpdateRemotePlugins' -c 'quitall'
  #nvim --headless -c 'TSInstallSync all' -c 'quitall'
  #nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}

add_ppa() {
  sudo add-apt-repository -y ppa:$1
}

setup_gitconfig() {
  if ! grep --quiet "path=$dotfiles_dir/gitconfig" "$HOME/.gitconfig"; then
  cat << EOF >> "$HOME/.gitconfig"
[include]
  path=$dotfiles_dir/gitconfig
EOF
  else
    echo "Skipping gitconfig"
  fi
}

main() {
  (
  cd "$dotfiles_dir"

  add_ppa "neovim-ppa/stable"
  sudo apt -y update
  sudo apt -y upgrade
  sudo apt -y autoremove

  apt_install $(tr '\n' ' ' < ./apt_packages)

  while read -r pkg; do
    [[ -z "${pkg}" ]] && continue
    snap_install "${pkg}"
  done < ./snap_packages

  setup_gitconfig

  # Sometimes machines come with an existing bashrc file. We can completely overwrite it.
  rm -rf $HOME/.bashrc

  mkdir -p "$HOME/.config"
  stow -R home -t "$HOME"
  stow -R xdg-configs -t "$HOME/.config"

  setup_nvim_config
  )
}

main

#!/usr/bin/env bash

set -e

DOTFILES_ROOT=$(pwd -P)
echo -e "Dotfiles dir: $DOTFILES_ROOT"

OMZ_DIR=$HOME/.oh-my-zsh
echo -e "Oh-My-ZSH path: $OMZ_DIR"

[ ! -d "$OMZ_DIR" ] && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM=${ZSH_CUSTOM:-$OMZ_DIR/custom}
echo -e "ZSH_CUSTOM path: $ZSH_CUSTOM"

ZSH_THEMES=${ZSH_CUSTOM}/themes
ZSH_PLUGINS=${ZSH_CUSTOM}/plugins

[ ! -d "$ZSH_THEMES/powerlevel10k" ] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_THEMES}/powerlevel10k

# installs zsh-syntax-highlighting plugin to a common directory
[ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_PLUGINS}/zsh-syntax-highlighting

# nvm itself (lazy-loaded by zshrc), pinned to its latest release tag.
if [ ! -d "$HOME/.nvm" ]; then
  git clone https://github.com/nvm-sh/nvm.git "$HOME/.nvm"
  git -C "$HOME/.nvm" checkout -q "$(git -C "$HOME/.nvm" describe --abbrev=0 --tags)"
fi

# Files where tools may append to ~/<file> (e.g. `gt completion >> ~/.zshrc`,
# `git config --global …`, pnpm/nvm/conda installers). Install as a real file
# that sources/includes the tracked one, so tool-injected lines stay local
# in ~/.zshrc.local / ~/.gitconfig.local and never get committed.
install_zshrc_stub() {
  if [ -L ~/.zshrc ] || [ ! -f ~/.zshrc ]; then
    rm -f ~/.zshrc
    cat > ~/.zshrc <<EOF
# Tracked dotfiles
[ -f "${DOTFILES_ROOT}/zshrc" ] && source "${DOTFILES_ROOT}/zshrc"

# Local additions live below — never committed.
# Tools that append to ~/.zshrc (gt completion, nvm, pnpm, tec, etc.) land here.
[ -f "\$HOME/.zshrc.local" ] && source "\$HOME/.zshrc.local"
EOF
    echo "Created ~/.zshrc stub"
  else
    echo "Skipped ~/.zshrc (already a real file; not overwriting)"
  fi
}

install_gitconfig_stub() {
  if [ -L ~/.gitconfig ] || [ ! -f ~/.gitconfig ]; then
    rm -f ~/.gitconfig
    cat > ~/.gitconfig <<EOF
[include]
	path = ${DOTFILES_ROOT}/gitconfig
	path = ~/.gitconfig.local
EOF
    echo "Created ~/.gitconfig stub"
  else
    echo "Skipped ~/.gitconfig (already a real file; not overwriting)"
  fi
}

install_zshrc_stub
install_gitconfig_stub

# Global gitignore — git reads this via `core.excludesfile = ~/.gitignore`.
ln -sf ${DOTFILES_ROOT}/gitignore ~/.gitignore

# Note: aliases and macos_aliases are sourced directly from the repo by zshrc,
# so they don't need symlinks in $HOME.

echo -e "Dotfiles installed succesfully!"

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

[ ! -d "$ZSH_THEMES/powerlevel9k" ] && git clone https://github.com/Powerlevel9k/powerlevel9k.git ${ZSH_THEMES}/powerlevel9k

# installs zsh-syntax-highlighting plugin to a common directory
[ ! -d "$ZSH_PLUGINS/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_PLUGINS}/zsh-syntax-highlighting
[ ! -d "$ZSH_PLUGINS/zsh-nvm" ] && git clone https://github.com/lukechilds/zsh-nvm.git ${ZSH_PLUGINS}/zsh-nvm

# dotfiles
ln -sf ${DOTFILES_ROOT}/zshrc ~/.zshrc
ln -sf ${DOTFILES_ROOT}/gitconfig ~/.gitconfig
ln -sf ${DOTFILES_ROOT}/gitignore ~/.gitignore
ln -sf ${DOTFILES_ROOT}/aliases ~/.aliases

echo -e "Dotfiles installed succesfully!"

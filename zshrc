# Powerlevel10k instant prompt: draws the prompt immediately while the rest of
# this file loads. Keep this block at the top. Anything that needs console
# input or prints output during init must go above it.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Powerlevel10k reads the legacy POWERLEVEL9K_* settings, so these keep the
# old powerlevel9k look. They must be set before oh-my-zsh loads the theme.
# Run `p10k configure` to generate ~/.p10k.zsh instead (sourced at the end).
POWERLEVEL9K_MODE='awesome-patched'
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
POWERLEVEL9K_INSTANT_PROMPT=quiet
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir rbenv vcs git_reftable)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_CUSTOM=$ZSH/custom

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="emileber-zsh-powerline"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# No update check at startup; run `omz update` manually.
zstyle ':omz:update' mode disabled

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# nvm is not a plugin: it is lazy-loaded below, since loading it eagerly
# roughly doubled startup time.
plugins=(git git-flow zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Shorter prompt style
DEFAULT_USER="$USER"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Source companion files directly from the repo (no $HOME symlinks needed).
# `${0:A:h}` resolves to the directory of this file with all symlinks resolved.
DOTFILES_DIR="${0:A:h}"
[ -f "$DOTFILES_DIR/aliases" ] && source "$DOTFILES_DIR/aliases"
[ -f "$DOTFILES_DIR/macos_aliases" ] && source "$DOTFILES_DIR/macos_aliases"
unset DOTFILES_DIR

# Homebrew's `brew shellenv` runs in ~/.zprofile (login shells), so it is
# not repeated here.

# $TTY, not $(tty): with instant prompt, stdin is not the terminal during init.
export GPG_TTY=$TTY

# nvm, on demand.
# - `nvm` loads nvm on first use.
# - Entering a directory tree that has an .nvmrc switches to that version;
#   leaving it restores the previous node.
# - Trees managed by shadowenv (.shadowenv.d) are left alone, and
#   NVM_AUTO_USE_IGNORE=(dir ...) skips other trees whose node is managed
#   elsewhere.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
typeset -ga NVM_AUTO_USE_IGNORE

__nvm_load() {
  (( $+functions[nvm_find_nvmrc] )) && return 0
  [[ -s $NVM_DIR/nvm.sh ]] || { print -u2 "nvm: not installed in $NVM_DIR"; return 1; }
  # Sourcing nvm.sh replaces the `nvm` stub below with the real function.
  source "$NVM_DIR/nvm.sh" --no-use
}
nvm() { __nvm_load && nvm "$@"; }

__nvm_auto_use() {
  local dir=$PWD ignored
  for ignored in $NVM_AUTO_USE_IGNORE; do
    [[ $dir == $ignored || $dir == $ignored/* ]] && { dir=; break; }
  done
  while [[ -n $dir && ! -f $dir/.nvmrc ]]; do
    [[ -d $dir/.shadowenv.d ]] && { dir=; break; }
    dir=${dir%/*}
  done
  local rc=${dir:+$dir/.nvmrc}

  [[ $rc == ${__nvm_auto_rc-} ]] && return 0
  __nvm_auto_rc=$rc

  if [[ -n $rc ]]; then
    __nvm_load || return
    if nvm use --silent >/dev/null 2>&1; then
      # nvm updates PATH in place; put its bin first so other managers
      # prepended later in init do not shadow it.
      path=("$NVM_BIN" ${path:#$NVM_BIN})
    else
      nvm deactivate >/dev/null 2>&1
      print -u2 "nvm: node $(<$rc) from $rc is not installed (run: nvm install)"
    fi
  elif (( $+functions[nvm_find_nvmrc] )); then
    nvm deactivate >/dev/null 2>&1
  fi
}

# Check once at the first prompt, after all init has adjusted PATH.
__nvm_auto_use_first() {
  add-zsh-hook -d precmd __nvm_auto_use_first
  __nvm_auto_use
}
autoload -Uz add-zsh-hook
add-zsh-hook chpwd __nvm_auto_use
add-zsh-hook precmd __nvm_auto_use_first

# p10k's gitstatusd (libgit2) can't read repos that use git's reftable ref
# storage, so the vcs segment disappears there. This segment shows the branch
# using the git CLI, and only runs git inside reftable repos. It shows no dirty
# state: reftable repos tend to be huge monorepos where `git status` takes
# seconds, so the neutral color does not claim the tree is clean.
typeset -gA __git_reftable_cache
__git_reftable_repo() {
  local dir=$PWD gitdir common
  while [[ -n $dir && ! -e $dir/.git ]]; do dir=${dir%/*}; done
  [[ -n $dir ]] || return 1
  if [[ -z ${__git_reftable_cache[$dir]} ]]; then
    if [[ -f $dir/.git ]]; then
      gitdir=${"$(<$dir/.git)"#gitdir: }
      [[ $gitdir == /* ]] || gitdir=$dir/$gitdir
    else
      gitdir=$dir/.git
    fi
    common=$gitdir
    if [[ -f $gitdir/commondir ]]; then
      common=$(<$gitdir/commondir)
      [[ $common == /* ]] || common=$gitdir/$common
    fi
    [[ -d $common/reftable ]] && __git_reftable_cache[$dir]=1 || __git_reftable_cache[$dir]=0
  fi
  (( __git_reftable_cache[$dir] ))
}
prompt_git_reftable() {
  __git_reftable_repo || return
  local ref
  ref=$(git symbolic-ref --short -q HEAD 2>/dev/null) ||
    ref="@$(git rev-parse --short HEAD 2>/dev/null)"
  p10k segment -b 244 -f black -r -i VCS_BRANCH_ICON -t "${ref//\%/%%}"
}

# Optional full Powerlevel10k config from `p10k configure`.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

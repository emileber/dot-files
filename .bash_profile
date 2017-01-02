alias gs='git status $*'
alias gl='git l $*'
alias ll='ls -alhF $*'
alias ls='ls -F --color=auto --show-control-chars $*'
alias lsls='ls -lhFA | less'
alias cd..="cd .."
alias ..="cd .."
alias fhere="find . -name "
alias df="df -Tha --total"    # disk usage in human-readable units

alias ps="ps auxf"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"    # Searchable process list

alias mkdir="mkdir -pv"    # Create any parent directory

alias histg="history | grep"

export EDITOR=vim

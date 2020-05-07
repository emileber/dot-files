alias gs='git status $*'
alias gl='git l $*'
alias fhere="find . -name "

alias ps="ps aux"

alias mkdir="mkdir -pv"    # Create any parent directory

alias histg="history | grep"


alias pbdecrypt='pbpaste | keybase decrypt | pbcopy'
pbencrypt(){
    pbpaste | keybase encrypt $@ | pbcopy
}

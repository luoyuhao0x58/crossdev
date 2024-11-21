export PS1='\[\e[100;1m\]\[\e[31;1m\]@\[\e[33;1m\]\h\[\e[32;1m\]:\[\e[36;1m\]\w\[\e[0m\]\[\e[35;1m\]$(__git_ps1 " (%s)" 2> /dev/null)\[\e[0m\] \[\e[34;1m\]\$\[\e[0m\] '
export PS2='\[\e[34;1m\]>\[\e[0m\] '
export SUDO_PS1=$PS1
export PROMPT=$PS1
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;33m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;32m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;37;45m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[4;34m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export GPG_TTY=$(tty)

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias ls="ls --color=auto"
alias cz="git cz"
alias curl="curl --retry 3 --retry-delay 5"
eval $(dircolors -b)

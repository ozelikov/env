# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export LC_ALL="en_US.utf8"

HOSTNAME=${HOSTNAME:=$(hostname)}
USER=${USER:=$(whoami)}
PROMPT_USER_HOST=${PROMPT_USER_HOST:="$USER@$HOSTNAME"}
PROMPT_HOSTNAME=$HOSTNAME
if [[ ${#PROMPT_HOSTNAME} -gt 20 ]] ; then
    PROMPT_HOSTNAME="${PROMPT_HOSTNAME:0:20}"
    PROMPT_USER_HOST="$USER@$PROMPT_HOSTNAME"
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

TERM=xterm-256color

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Some fix for tmux
echo -ne "\033P\033\033[0 q\033\\ \n"

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [[ -n "$force_color_prompt" ]]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

_my_path()
{
    local str=${PWD/$HOME/"~"}
    if [[ ${#str} -gt 35 ]]; then
        str="${str:0:15}...${str:$((${#str}-20)):20}"
    fi
    echo $str
}

# TODO: detect if triangle char is available and enable nice_prompt
nice_prompt="yes"

_set_nice_prompt()
{
    # NOTE: non-printable chars should be enclosed in \[ and \]
    local PATH_BG="\[\e[48;5;236m\]"
    local PATH_FG="\[\e[38;5;236m\]"
    local RESET="\[\e[0m\]"

    if [[ $USER = "root" ]] ; then
        local USER_BG="\[\e[48;5;167m\]"
        local USER_FG="\[\e[38;5;167m\]"
        local triangle_1=$(echo -e "${USER_FG}${PATH_BG}\uE0B0${RESET}")
        local triangle_2=$(echo -e "${PATH_FG}\uE0B0")

        PS1="${USER_BG}$PROMPT_HOSTNAME${RESET}${triangle_1}${PATH_BG} \$(_my_path) ${RESET}${triangle_2}${RESET} "
    else
        local USER_BG="\[\e[48;5;23m\]"
        local USER_FG="\[\e[38;5;23m\]"
        local triangle_1=$(echo -e "${USER_FG}${PATH_BG}\uE0B0${RESET}")
        local triangle_2=$(echo -e "${PATH_FG}\uE0B0")

        PS1="${USER_BG}$PROMPT_USER_HOST${RESET}${triangle_1}${PATH_BG} \$(_my_path) ${RESET}${triangle_2}${RESET} "
    fi
}

if [[ "$nice_prompt" = "yes" ]] ; then
    _set_nice_prompt
elif [[ "$color_prompt" = "yes" ]]; then
    PS1='\[[01;35m\]$PROMPT_USER_HOST\[[00m\]:\[[35;1m\]$(_my_path)\[[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt nice_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [[ $(uname) != 'Darwin' ]] ; then
    ls_options='--time-style=long-iso'
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls $ls_options"
    #alias ls="ls --color=auto $ls_options"
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    alias ls="ls $ls_options"
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -lF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

set -o vi
export VISUAL=vi
export DISPLAY=:0
alias g=gvim

alias gitstat='git status -sb'
#alias gitdiff='git difftool -y -t xxdiff'
alias gitdiff='git difftool -y -t vimdiff'
alias gitdiffv='git difftool -y -t vimdiff'
alias gitlogn='git --no-pager log --oneline --stat'
alias gitlog='git log --pretty="%C(nodim)%C(yellow)%h %C(green)%C(bold)%s %C(cyan)%C(dim)%d%C(white)"'
alias gitdiffstash='gitdiff stash@{0}'

alias cgrep='grep -r --include=*.c --include=*.cpp --include=*.h --include=*.hpp --include=*.tpp'

alias vg=vagrant

alias tmux="tmux -2"

PATH="$HOME/srcs/scripts:$PATH"
[[ -e ~/srcs/scripts/oautocomplete ]] && source ~/srcs/scripts/oautocomplete

alias sshp='ssh -o PreferredAuthentications=password'
alias scpp='scp -o PreferredAuthentications=password'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Map Ctrl-Z in bash to 'fg'
stty susp undef
bind '"\C-z":"fg\015"'

function fstash() {
    [[ ! -f ~/.fzf.bash ]] && echo "fzf is not installed" >&2  && exit 1
    local stash=$(git stash list | fzf --reverse --border)
    [[ -z $stash ]] && return
    echo "$stash"| perl -npe 's/^([^:]+).*/$1/'
}

function fbranch() {
    [[ ! -f ~/.fzf.bash ]] && echo "fzf is not installed" >&2  && exit 1
    local branch=$(git branch -v "$@" | fzf --reverse --border)
    [[ -z $branch ]] && return
    echo "$branch"| perl -npe 's/^\s*\*?\s*(\S+).*$/$1/'
}

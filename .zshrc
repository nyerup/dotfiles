setopt appendhistory incappendhistory extendedhistory
setopt autocd beep nomatch interactivecomments
setopt null_glob
unsetopt extendedglob notify

zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
autoload -Uz compinit
autoload -U colors && colors
compinit

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\ee' edit-command-line

stty werase undef

# Keyboard bindings
bindkey -e
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word
#bindkey "^?" backwards-delete-char

# Arrow-key history completion
#bindkey "^[[A" history-beginning-search-backward
#bindkey "^[[B" history-beginning-search-forward

# Start with this, if you go back to vim-mode ZLE.
#bindkey "^R" history-incremental-search-backward
#bindkey "^K" kill-line
#bindkey "^[." insert-last-word
#bindkey "^[q" push-line

# Enabling dynamic titles in XTerm-windows
case $TERM in (xterm*|rxvt*)
    autotitle () {
        precmd () { print -Pn "\e]0;%n@%m: %~\a" }
        preexec () { print -Pn "\e]0;%n@%m: $1\a" }
    }
    title () {
        unfunction precmd  2>/dev/null
        unfunction preexec 2>/dev/null
        print -Pn "\e]0;$@\a"
    }
    autotitle
    ;;
esac

WORDCHARS=${WORDCHARS//[\/.;]}
ZLS_COLORS=$LS_COLORS
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.histfile

PATH="${PATH}:${HOME}/bin"
PATH="${PATH}:/usr/local/opt/coreutils/libexec/gnubin"
PATH="${PATH}:/opt/local/bin"
PATH="${PATH}:/opt/local/sbin"
PATH="${PATH}:/opt/java/bin"
PATH="${PATH}:/usr/local/opt/ruby/bin"
PATH="${PATH}:/opt/chefdk/bin"
PATH="${PATH}:/usr/local/bin"
PATH="${PATH}:/usr/local/go/bin"

MANPATH="${MANPATH}:/usr/share/man/"
MANPATH="${MANPATH}:/usr/local/share/man/"
MANPATH="${MANPATH}:/usr/local/opt/coreutils/libexec/gnuman/"

export PATH
export MANPATH
export LC_ALL=en_US
export GIT_AUTHOR_NAME="Jesper Dahl Nyerup"
export GIT_AUTHOR_EMAIL=jespern@unity3d.com
export GIT_COMMITTER_NAME="${GIT_AUTHOR_NAME}"
export GIT_COMMITTER_EMAIL="${GIT_AUTHOR_EMAIL}"
export DEBFULLNAME="${GIT_AUTHOR_NAME}"
export DEBEMAIL="${GIT_AUTHOR_EMAIL}"
export DEBCHANGE_AUTO_NMU=no
export EDITOR=vim
export GOPATH="$HOME/go"
export SHELL=$(which zsh)

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# Don't complete with git ls-files
__git_files () {
  _files
  return 0
}

if [ $(id -u) -eq 0 ]; then
    # Root terminal
    PROMPT_COLOR=red
else
    if [ "$SSH_TTY" ]; then
        # Non-local terminal
        PROMPT_COLOR=yellow
    else
        # Local terminal
        PROMPT_COLOR=green
    fi
fi

case $(uname -s) in
    'Linux')
        alias ls='ls -F --color=auto'
        ;;
    'Darwin')
        alias ls='ls -FG'
        ;;
esac

# Setting up aliases
alias ll='ls -lAh'
alias la='ls -la'
alias count='sort| uniq -c| sort -n'
alias forever='while true'
alias indent="perl -nle 'print \"    \".\$_'"
alias dch='dch --no-auto-nmu'
alias ssg='ssh'
alias ssj='ssh'
alias cdiff="sed -e '/^---/s/^\(.*\)/[1m\1[0m/' -e '/^+++/s/^\(.*\)/[1m\1[0m/' -e '/^@@/s/^\(.*\)/[1m\1[0m/' -e '/^-/s/^\(.*\)/[31m\1[0m/' -e '/^\+/s/^\(.*\)/[32m\1[0m/' | less -C -R $@"
alias xping='xping -C'
alias dig='dig +noall +answer'
alias vi=vim
alias start='sudo systemctl start'
alias restart='sudo systemctl restart'
alias stop='sudo systemctl stop'
alias status='sudo systemctl status'

# Warning if system wide SendEnv is active in /etc/ssh/ssh_config
if [ -r /etc/ssh/ssh_config ]; then
    grep -q '^ *SendEnv LANG' /etc/ssh/ssh_config && print -Pn "\e[7;31m*** Warning: /etc/ssh/ssh_config will SendEnv LANG ***\e[0m\n\n"
fi

# Setting up the prompt
AFQDN=$(hostname -f 2>/dev/null |cut -d' ' -f1 |sed -e 's/.local$//')
if [ -n "$AFQDN" ]; then
	export PS1="%{$fg_bold[${PROMPT_COLOR}]%}${AFQDN} %{$reset_color%}%# "
else
	export PS1="%{$fg_bold[${PROMPT_COLOR}]%}%M %{$reset_color%}%# "
fi

rprompt () {
    export RPS1="%{$fg[white]%}%~%{$reset_color%}"
}
norprompt () {
    unset RPS1
}
rprompt

# rbenv
if (type rbenv >/dev/null); then
    eval "$(rbenv init -)"
fi

for file in .zsh/*.zsh.inc; do
    source "$file"
done

# vim: set et ts=4 sw=4:

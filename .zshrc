setopt appendhistory incappendhistory extendedhistory
setopt autocd beep nomatch interactivecomments
unsetopt extendedglob notify

zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
autoload -Uz compinit
compinit

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\ee' edit-command-line

stty werase undef
WORDCHARS=${WORDCHARS//[\/.;]}

# Keyboard bindings
bindkey -v
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[^[[D" backward-word
bindkey "^[^[[C" forward-word
#bindkey "^?" backwards-delete-char

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

ZLS_COLORS=$LS_COLORS
HISTSIZE=1000
SAVEHIST=1000
PATH="${HOME}/bin:/opt/local/bin:/opt/local/sbin:/opt/java/bin:/usr/local/opt/ruby/bin:/usr/local/bin:"$PATH

export GIT_AUTHOR_NAME="Jesper Dahl Nyerup"
export GIT_AUTHOR_EMAIL=nyerup@one.com
export GIT_COMMITTER_NAME="${GIT_AUTHOR_NAME}"
export GIT_COMMITTER_EMAIL="${GIT_AUTHOR_EMAIL}"
export DEBFULLNAME="${GIT_AUTHOR_NAME}"
export DEBEMAIL="${GIT_AUTHOR_EMAIL}"
export DEBCHANGE_AUTO_NMU=no
export REPLYTO=nyerup@one.com
export ONECOMID=nyerup
export EDITOR=vi

# Don't complete with git ls-files
__git_files () {
  _files
  return 0
}

case $(hostname) in
    'enceladus'|'iapetus')
        ${HOME}/bin/enable_ssh-agent
        source .ssh-agent.rc > /dev/null
        ;;
esac

case $(hostname) in
    'enceladus'|'iapetus'|'atlas'|'mimas'|'calypso'|'linux')
        if [ $(id -u) -eq 0 ]; then
            PROMPT_COLOR=34         # Blue for root terminal
        else
			if [ "$SSH_TTY" -a $(hostname) != 'linux' ]; then
                PROMPT_COLOR=33     # Yellow for non-local terminal
            else
                PROMPT_COLOR=32     # Green for local terminal
            fi
        fi
        ;;
    *)
        PROMPT_COLOR=31             # Red for unknown systems
        ;;
esac

case $(uname -s) in
    'Linux')
        # Less Colors for Man Pages
        export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
        export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
        export LESS_TERMCAP_me=$'\E[0m'           # end mode
        export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
        export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
        export LESS_TERMCAP_ue=$'\E[0m'           # end underline
        export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

        alias ls='ls -F --color=auto'
        ;;
    'Darwin')
        alias ls='ls -FG'
        ;;
esac

# Finding prompt sign
if [ $(whoami) = "root" ]; then
    PROMPT_SIGN='#'
    # Maybe in shared ~/
    HISTFILE=~/.histfile_nyerup
else
    PROMPT_SIGN='%%' # Yes. Two.
    # My own histfile
    HISTFILE=~/.histfile
fi

if [ $(hostname) = 'linux' ]; then
	HISTFILE=~/.histfile.linux
fi

# Setting up aliases
alias ll='ls -l'
alias la='ls -la'
alias count='sort| uniq -c| sort -n'
alias forever='while true'
alias indent="perl -nle 'print \"    \".\$_'"
alias dch='dch --no-auto-nmu'
alias ssg='ssh'
alias ssj='ssh'
alias gmail='mutt -F ~/.muttrc.gmail'
alias bmail='mutt -F ~/.muttrc.one.com'
alias cdiff="sed -e '/^---/s/^\(.*\)/[1m\1[0m/' -e '/^+++/s/^\(.*\)/[1m\1[0m/' -e '/^@@/s/^\(.*\)/[1m\1[0m/' -e '/^-/s/^\(.*\)/[31m\1[0m/' -e '/^\+/s/^\(.*\)/[32m\1[0m/' | less -C -R $@"
alias xping='xping -C'

# Warning if system wide SendEnv is active in /etc/ssh/ssh_config
if [ -r /etc/ssh/ssh_config ]; then
    WARNING=$(grep 'SendEnv LANG' /etc/ssh/ssh_config | perl -nle 'unless (/^#/) {print "!"}')
fi

# Setting up the prompt
export PS1="$(print '[%T]'${WARNING}' %{\e[1;'${PROMPT_COLOR}'m%}%M%{\e[0m%}') ${PROMPT_SIGN} "
export RPS1="%~"

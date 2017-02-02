# The following lines were added by compinstall

zstyle ':completion:*' auto-description '%d'
zstyle ':completion:*' completer _expand _complete _files _ignored _match _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' glob 1
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
#zstyle ':completion:*' matcher-list ''
zstyle ':completion:*' matcher-list 'r:|[._-]=** r:|=**' ''
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/barakor/.zshrc'
fpath=(~/.zsh/completion $fpath)

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory notify
unsetopt autocd beep extendedglob nomatch
bindkey -e
# End of lines configured by zsh-newuser-install
bindkey "^R" history-incremental-search-backward
bindkey "^[[Z" reverse-menu-complete
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

alias ls='ls --color=auto'
alias ll='ls -l'
alias shutdown='sudo shutdown -h now'
alias hibernate='systemctl hibernate'
alias vim='vim -p'
viw() {
    vim `which "$1"`
}
alias cut_names='cut -d: -f1 | sort | uniq'
mpl() {
    if [[ -d "$1" ]]; then
        if [[ `echo "$1"/*.mp3` == "$1/*.mp3" ]]; then
            title mpv --gapless-audio --no-video "$1"/* #--ao="alsa:device=[hw:0,0]" "$1"/*
        else
            title mpv --gapless-audio --no-video "$1"/*.mp3 #--ao="alsa:device=[hw:0,0]" "$1"/*.mp3
        fi
    else
        title mpv --gapless-audio --no-video "$@" #--ao="alsa:device=[hw:0,0]" "$1"
    fi
}
alias vcr='source ~/vcr/ve/bin/activate; cd ~/git/vcr'
alias grept='grep --binary-files=without-match'
alias vim_rec='vim `find -name "*.swp" | python -c "import sys; import re; print(\"\n\".join([\"\".join(re.match(\"(\.[^\.]*).(.*).swp\",x).groups()) for x in sys.stdin.read().splitlines()]))"`'
alias vim_rm='rm `find -name "*.swp"`'
alias psg='ps -fe | grep'

nohup() {
    "$@" 2>/dev/null &!
}

for i in {xpdf,xv,evince,djview,libreoffice}; do
    alias $i="nohup /usr/bin/$i"
done

timer() {
    if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
        echo "Usage: $0 <sleep_time> <n_repeat> <string>"
        echo "sleep_time : time to sleep, sleep syntax ([default]:secs, m:mins, etc.)"
        echo "n_repeat : how many times to speak."
        echo "string : string to say when time is out."
    else
        sleep "$1"
        repeat "$3" espeak -a 200 "$2" 2> /dev/null
    fi
}

title() {
    /home/amos/scripts/xterm_title "$1"
    "$@"
}

mvd() {
    mkdir ${@: -1}
    mv $@
}

cpd() {
    mkdir ${@: -1}
    cp $@
}

ve() {
    source "/home/amos/ves/$1/bin/activate"
    cd "/home/amos/git/$1"
}

sudo() {
    /usr/bin/sudo "$@"
    if [[ "$1" == "-i" ]]; then
        print -Pn "\e]0;%n@%m: %~\a"
    fi
}

autoload -U colors && colors
PS1=%{$reset_color%}[%{$reset_color$fg[cyan]%}%n%{$reset_color$fg[yellow]%}@%{$reset_color$fg[red]%}%m\ %{$reset_color$fg[blue]%}%~%{$reset_color%}]%#\ 

export EDITOR=/usr/bin/vim

case $TERM in
    *xterm*)
        chpwd () {print -Pn "\e]0;%n@%m: %~\a"}
        ;;
esac
print -Pn "\e]0;%n@%m: %~\a"


#
# defines transfer alias and provides easy command line file and folder sharing.
#
# Authors:
#   Remco Verhoef <remco@dutchcoders.io>
#

curl --version 2>&1 > /dev/null
if [ $? -ne 0 ]; then
  echo "Could not find curl."
  return 1
fi

transfer() { 
    # check arguments
    if [ $# -eq 0 ]; 
    then 
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    # get temporarily filename, output is written to this file show progress can be showed
    tmpfile=$( mktemp -t transferXXX )
    
    # upload stdin or file
    file=$1

    if tty -s; 
    then 
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g') 

        if [ ! -e $file ];
        then
            echo "File $file doesn't exists."
            return 1
        fi
        
        if [ -d $file ];
        then
            # zip directory and transfer
            zipfile=$( mktemp -t transferXXX.zip )
            cd $(dirname $file) && zip -r -q - $(basename $file) >> $zipfile
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> $tmpfile
            rm -f $zipfile
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> $tmpfile
        fi
    else 
        # transfer pipe
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> $tmpfile
    fi
   
    # cat output link
    cat $tmpfile

    # cleanup
    rm -f $tmpfile
}


#thefuck alias 
eval "$(thefuck --alias)"


# svpn snx alias
alias svpn='snx -s svpn.weizmann.ac.il -u'

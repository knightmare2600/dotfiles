##----------------------------------------------------------------------------##
## .zshrc Make zsh dance to my tune. Deliberately preserve any bashisms like  ##
##        "fg" behaviour. Thee compatibility shims are commented as such...   ##
##                                                                            ##
## History:                                                                   ##
##                                                                            ##
## 31 Oct 2024  v1.00  Initial version. New arrival from bash                 ##
## 02 Nov 2024  v1.01  Compatibility shims like fg & keyboard "word" movement ##
## 01 Apr 2025  v1.02  plug-ins, confirm the MacOS Homebrew vs Linux paths    ##
## 24 Dec 2025  v1.05  Compatibility shim for arm64 vs amd64 MacOS            ##
## 25 May 2026  v1.10  Rework MacOS shim: build it better, faster, stronger   ##
## 30 May 2026  v1.11  Add midnight commander solarized dark support in zsh   ##
##                                                                            ##
##----------------------------------------------------------------------------##

## How to get the pakcages:
## { apk | apt | brew | yum } { install | add } zsh zsh-autosuggestions zsh-common zsh-syntax-highlighting   

## Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
ZSH_THEME="parrot"

## Jump around
bindkey -e
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

##  Completion
zstyle ':completion:*' menu select
autoload -U promptinit && promptinit
autoload -Uz compinit
compinit

## Bash-like fg compatibility
fg() {
  if [[ "$*" =~ ^[0-9]+$ ]]; then
    builtin fg %"$*"
  else
    builtin fg "$@"
  fi
}

## Bash-like fg compatibility
fg() {
  if [[ "$*" =~ ^[0-9]+$ ]]; then
    builtin fg %"$*"
  else
    builtin fg "$@"
  fi
}

## Platform detection ##
case "$(uname -s)" in
  Darwin)
    ## Apple Silicon Homebrew
    if [[ -d /opt/homebrew ]]; then
      export HOMEBREW_PREFIX="/opt/homebrew"

    ## Intel Homebrew
    elif [[ -d /usr/local/Homebrew ]] || [[ -d /usr/local/opt ]]; then
      export HOMEBREW_PREFIX="/usr/local"
    fi

    ## PATH
    [[ -n "$HOMEBREW_PREFIX" ]] && export PATH="$HOMEBREW_PREFIX/bin:$PATH"

    ## GNU ls if installed via coreutils
    if command -v gls >/dev/null 2>&1; then
      alias ls='gls --color=auto'
    else
      alias ls='ls -G'
    fi

    ## Plug-ins
    for plugin in zsh-autosuggestions/zsh-autosuggestions.zsh zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    do
      [[ -f "$HOMEBREW_PREFIX/share/$plugin" ]] && source "$HOMEBREW_PREFIX/share/$plugin"
    done
    ;;

  Linux)
    alias ls='ls --color=auto'
    for plugin in  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    do
      [[ -f "$plugin" ]] && source "$plugin"
    done
    ;;
esac

## Shell behaviour
# setopt NO_HUP
setopt CHECK_JOBS
setopt CHECK_RUNNING_JOBS
setopt interactive_comments

## Prompt
PROMPT='%F{red}┌─[%F{green}%n%F{cyan}@%F{white}%m%F{red}]─[%F{green}%d%F{red}]
└──╼ %F{%(#.red.yellow)}$ %F{reset}'

## Solarized dark for Midnight Commander
## mkdir -p ~/.config/mc && git clone https://github.com/denius/mc-solarized-skin.git ~/.config/mc/mc-solarized-skin
export MC_SKIN=$HOME/.config/mc/mc-solarized-skin/solarized.ini

## Erm....
#export PATH="/usr/local/sbin:$PATH"

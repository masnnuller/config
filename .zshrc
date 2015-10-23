#基本設定いろいろ
xset -b
export LANG=ja_JP.UTF-8
export TERM=xterm
export EDITOR=vim
setopt no_beep
setopt nolistbeep
setopt auto_pushd
setopt auto_cd
setopt correct
setopt notify
setopt prompt_subst
setopt equals

#history
HISTFILE=~/.zsh_hist
HISTSIZE=10000
SAVEHIST=10000
setopt bang_hist
setopt extended_history
setopt hist_ignore_dups
setopt hist_reduce_blanks

bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
#color
autoload -U colors;colors
autoload -U compinit;compinit

#alias
alias ln="ln -i"
alias cl="clear"
alias rm="rm -I"
alias cp="cp -i"
alias mv="mv -i"
alias vi=vim
alias ls="ls --color -F"
alias la="ls -a"
alias ll="ls -l"
alias mkrepo="platex Report.tex&&dvipdfmx Report.dvi"
alias more=less
alias gpp='g++ -lm'
alias gis="git status"
alias gil="git log"
alias cl='clear'
alias gtp='gcc $(pkg-config --cflags --libs gtk+-2.0)'
alias pandocpdf='pandoc -V documentclass=ltjarticle --latex-engine=lualatex '
alias gd='git diff --color'
alias kbjp='setxkbmap -model pc106 -layout jp'
alias kbus='setxkbmap -model pc105 -layout us'
alias bx='bundle exec'
alias bi='bundle install'
alias bu='bundle update'

# vcs_info
autoload -Uz vcs_info
zstyle ':vcs_info:*' max-exports 3
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'

_battery_status() {
  battey_status=""
  if [[ -x /usr/bin/acpi ]] {
    battey_status="%F{cyan}Battery:$(acpi -b 2> /dev/null | grep -o '[0-9]*%')%"
    _state=$(acpi -b 2> /dev/null | grep -o '[a-zA-Z]\+,')
    [[ ${_state} = Charging, ]] && battey_status="${battey_status}+";
    [[ ${_state} = Discharging, ]] && battey_status="${battey_status}-";
    battey_status="${battey_status} %f"
  }
}

recalc_prompt() {
  #もふもふ
  #プロンプトのせってい
  # 一般ユーザ時
  #  _battery_status
  tmp_prompt="%B%F{blue}[%n@%M] %f%b${battey_status}%F{black}%d%f"$'\n'$'%F{cyan}%#%f'
  tmp_prompt2="%B%F{blue}%M %b%F{cyan}_> %f"
  tmp_rprompt="%F{green}%1v%f"
  tmp_sprompt="%F{yellow}%r is correct? [Yes, No, Abort, Edit]:%f"
  # rootユーザ時(太字にし、アンダーバーをつける)
  if [ ${UID} -eq 0 ]; then
    tmp_prompt="%B%U${tmp_prompt}%u%b"
    tmp_prompt2="%B%U${tmp_prompt2}%u%b"
    tmp_rprompt="%B%U${tmp_rprompt}%u%b"
    tmp_sprompt="%B%U${tmp_sprompt}%u%b"
  fi

  PROMPT=$tmp_prompt    # 通常のプロンプト
  PROMPT2=$tmp_prompt2  # セカンダリのプロンプト(コマンドが2行以上の時に表示される)
  RPROMPT=$tmp_rprompt  # 右側のプロンプト
  SPROMPT=$tmp_sprompt  # スペル訂正用プロンプト
  # SSHログイン時のプロンプト
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
  ;

  case "${TERM}" in
    kterm*|xterm*)
      precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}\007"
      }
      ;;
  esac
}

recalc_prompt
#Enterだけを押すとgit status とls
function do_enter() {
if [ -n "$BUFFER" ]; then
  zle accept-line
  return 0
fi
echo
ls_abbrev
# ls_abbrev
if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
  echo
  echo -e "\e[0;33m--- git status ---\e[0m"
  git status -sb
fi
zle reset-prompt
return 0
}
zle -N do_enter
bindkey '^m' do_enter

function peco-dfind() {
  local current_buffer=$BUFFER
  local selected_dir="$(find . -maxdepth 5 -type d ! -path "*/.*" | peco)"
  BUFFER="${current_buffer} ${selected_dir}"
  CURSOR=$#BUFFER
  zle accept-line
  zle clear-screen
}
zle -N peco-dfind
bindkey '^f' peco-dfind

ls_abbrev() {
  # -a : Do not ignore entries starting with ..
  # -C : Force multi-column output.
  # -F : Append indicator (one of */=>@|) to entries.
  local cmd_ls='ls'
  local -a opt_ls
  opt_ls=('-aCF' '--color=always')
  case "${OSTYPE}" in
    freebsd*|darwin* )
      if type gls > /dev/null 2>&1; then
        cmd_ls='gls'
      else
        # -G : Enable colorized output.
        opt_ls=('-aCFG')
      fi
      ;;
  esac

  local ls_result
  ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

  local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

  if [ $ls_lines -gt 10 ]; then
    echo "$ls_result" | head -n 5
    echo '...'
    echo "$ls_result" | tail -n 5
    echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
  else
    echo "$ls_result"
  fi
}

_my_precmd() {
  psvar=()
  LANG=en.US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
  recalc_prompt
}

precmd_functions=($precmd_functions _my_precmd)

chpwd(){
  ls_abbrev
}

if  [ ${UID} -ne 0 ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - 2> /dev/null)"
  [ -s $HOME/.nvm/nvm.sh ] && . $HOME/.nvm/nvm.sh  # This loads NVM
fi

#setting for go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

export PATH=$PATH:$HOME/local/bin

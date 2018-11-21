########################################
# 環境設定
########################################
# ロケール環境設定
export LANG=ja_JP.UTF-8

# Emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=${HOME}/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default

# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified


########################################
# 色設定
########################################
# zshの色コマンドを使用出来るようにする
autoload -Uz colors && colors

# lsの色設定
export LS_COLORS='di=36:ln=1;31:so=35:pi=33:ex=32:or=30;41:mi=1;31;47:bd=1;31;44:cd=1;33;44:su=30;42:sg=34;42:tw=31;42:ow=1;36;40:st=1;36;41'
alias ls='ls --color=auto'

# grepの色設定
export GREP_COLOR="1;35"
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias zgrep='zgrep --color=auto'


########################################
# 補完
########################################
# 補完機能を有効にする
autoload -Uz compinit && compinit

# 予測変換機能を有効にする
# autoload -Uz predict-on && predict-on

# zshの補完にもLS_COLORSと同様の色を設定する
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# 補完時に自分でカーソル移動で選択可能
zstyle ':completion:*:default' menu select=1


########################################
# プロンプト系の設定
########################################
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

# promptinitでの設定の場合
# autoload -Uz promptinit && promptinit
# prompt adam1 とか

# 変数の設定
# 直前に実行したコマンドの戻り値が { 0 -> cyan; 0以外 -> magenta }
local p_color="%(?.%{${fg[cyan]}%}.%{${fg[magenta]}%})"

# rootはred、それ以外はblue
if [ $(id | sed -r 's/uid=([0-9]+)\(.*/\1/') -eq 0 ]; then
  local userColor="red"
else
  local userColor="blue"
fi

# 左側のプロンプト
# 1行表示
# PROMPT="
# %{${fg_bold[${userColor}]}%}%n%# %{${reset_color}%}"
# 2行表示
PROMPT="
[%{${fg_bold[${userColor}]}%}%n%{$reset_color%}@%m] %{$fg[cyan]%}%~
%{${reset_color}%}%# "

# 右側のプロンプト
RPROMPT="${p_color} return:[%?]%{${reset_color}%}"

# git用のvcs_info
# 【参照】https://qiita.com/umasoya/items/f3bd6cffd418f3830b75
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+"
zstyle ':vcs_info:*' formats "%F{green}[%b]%c%u%f"
zstyle ':vcs_info:*' actionformats '%F{red}[%b|%a]%f'

# hook用関数
function _update_vcs_info_msg() {
  LANG=en_US.UTF-8 vcs_info
  RPROMPT="${vcs_info_msg_0_}${p_color} return:[%?]%{${reset_color}%}"
}

add-zsh-hook precmd _update_vcs_info_msg


########################################
# オプション
########################################
# 開始と終了を記録
setopt EXTENDED_HISTORY

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups

# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# 余分な空白は詰めて記録
setopt hist_reduce_blanks

# historyコマンドは履歴に登録しない
setopt hist_no_store

# 補完時にヒストリを自動的に展開
setopt hist_expand

# 履歴をインクリメンタルに追加
setopt inc_append_history

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# "#" 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# = の後はパス名として補完する
setopt magic_equal_subst

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# ヒストリファイルに保存するとき、すでに重複したコマンドがあったら古い方を削除する
setopt hist_save_no_dups

# 補完候補が複数あるときに自動的に一覧表示する
setopt auto_menu

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# Googleカラーでサジェスト
setopt correct
SPROMPT="( ´・ω・) ＜ %{$fg[blue]%}も%{${reset_color}%}%{$fg[red]%}し%{${reset_color}%}%{$fg[yellow]%}か%{${reset_color}%}%{$fg[green]%}し%{${reset_color}%}%{$fg[red]%}て%{${reset_color}%}: %{$fg[red]%}%r%{${reset_color}%}？ [(y)es,(n)o,(a)bort,(e)dit]
-> "


########################################
# キーバインド
########################################
# ^R, ^S で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward


########################################
# エイリアス
########################################
alias l='ls -CF'
alias la='ls -CFA'
alias ll='ls -alFh'

alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias du='du -h'
alias df='df -h'
alias j='jobs -l'

# rootのみうっかり削除を防止
if [ $(id | sed -r 's/uid=([0-9]+)\(.*/\1/') -eq 0 ]; then
  alias rm='rm -i'
fi

# sudoの後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'


########################################
# 自作関数
########################################
# mkcd [Path] => ディレクトリの作成と対象ディレクトリの移動を同時に行う
function mkcd(){mkdir $1 && cd $1}


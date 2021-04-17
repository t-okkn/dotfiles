##### ~/.zshrc #####

########################################
# 環境設定
########################################
# インタラクティブモードで動作していなければ、何もしない
case $- in
  *i*) ;;
    *) return;;
esac

# Emacs 風キーバインドにする
bindkey -e

# コマンドの実行にx秒以上時間がかかった場合、システム使用レポートを出力
REPORTTIME=5


########################################
# ヒストリ設定
########################################
# ヒストリファイル
HISTFILE=${HOME}/.zsh_history

# サイズ設定
HISTSIZE=20000
SAVEHIST=20000

# [$HISTFILE] に時間も記録
setopt extended_history

# 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_dups

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups

# ヒストリファイルに保存するとき、古いコマンドと同じなら無視
setopt hist_save_no_dups

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

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 履歴検索系のキーバインドを入れ替えるために、キーバインドの割当を解除
bindkey -r "^N"
bindkey -r "^P"
bindkey -r "^R"
bindkey -r "^S"

# ^R, ^S で履歴検索をすると、既に打ち込んだコマンドに前方一致するコマンドのみを
# 結果として返すようにする
# （コマンド履歴検索モードに突入しない）
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^R" history-beginning-search-backward-end
bindkey "^S" history-beginning-search-forward-end

# ^P, ^N で履歴検索をするときに * でワイルドカードを使用出来るようにする
# （コマンド履歴検索モードに突入する）
bindkey '^P' history-incremental-pattern-search-backward
bindkey '^N' history-incremental-pattern-search-forward


########################################
# cd設定
########################################
# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups


########################################
# 色設定
########################################
# zshの色コマンドを使用出来るようにする
autoload -Uz colors && colors

# lsの色設定
if type dircolors &> /dev/null; then
  if [ -r ${HOME}/.dircolors ]; then
    eval "$(dircolors -b ${HOME}/.dircolors)"

  else
    export LS_COLORS='rs=0:di=36:ln=01;31:mh=00:pi=01;35:so=35:do=04;35:bd=01;04;33:cd=01;33:or=37;41:mi=01;37;41:su=33:sg=04;33:ca=01;31;47:tw=04;37;46:ow=37;46:st=04;36:ex=01;32'
  fi

  alias ls='ls --color=auto'
fi

# grepの色設定
export GREP_COLOR="01;31"

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias zgrep='zgrep --color=auto'

# gccの色設定
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# zshの補完にもLS_COLORSと同様の色を設定する
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}


########################################
# 補完、パス名展開、変数展開設定
########################################
# 補完機能を有効にする
autoload -Uz compinit && compinit

# 単語の区切り文字を指定する
autoload -Uz select-word-style && select-word-style default

# 予測変換機能を有効にする
# autoload -Uz predict-on && predict-on

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

# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

# セパレータを設定する
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# コマンドラインの引数でも補完を有効にする（--prefix=/userなど）
setopt magic_equal_subst

# 補完候補が複数あるときに自動的に一覧表示する
setopt auto_menu

# 補完候補表示時にビープ音を鳴らさない
setopt nolistbeep

# カッコの対応などを自動的に補完
setopt auto_param_keys


########################################
# その他設定
########################################
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# "#" 以降をコメントとして扱う
setopt interactive_comments

# コマンドのスペルミスを指摘
setopt correct


########################################
# vcs_info（バージョン管理システム情報）
#
# 参照）https://qiita.com/mollifier/items/8d5a627d773758dd8078
########################################
# vcs_info 機能を有効にする
autoload -Uz vcs_info

# is-at-least でバージョン比較を行えるようにする
autoload -Uz is-at-least

# 以下の4つのメッセージをエクスポートする
#  $vcs_info_msg_0_ : vcs情報・branch情報 (緑)
#  $vcs_info_msg_1_ : ステージング情報 (カスタム)
#  $vcs_info_msg_2_ : 警告メッセージ用 (黄色)
#  $vcs_info_msg_3_ : エラーメッセージ用 (赤)
zstyle ':vcs_info:*' max-exports 4

# Git, SVN, Mercurial でのみ vcs_info を有効化
zstyle ':vcs_info:*' enable git svn hg

# 標準フォーマット（git 以外で使用）
# misc(%m) は通常は空文字列に置き換えられる
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '%F{yellow}%c%F{009}%u%f' '%m' '<%a>'
zstyle ':vcs_info:(svn|hg):*' branchformat '%b:r%r'

if is-at-least 4.3.10; then
  # git 用のフォーマット
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "%F{yellow}+"  # %c で表示する文字列
  zstyle ':vcs_info:git:*' unstagedstr "%F{009}!"   # %u で表示する文字列
  zstyle ':vcs_info:git:*' formats '[%b]' '%c%u' '%m'
  zstyle ':vcs_info:git:*' actionformats '[%b]' '%c%u' '%m' '<%a!>'
fi

# hooks 設定
if is-at-least 4.3.11; then
  # git のときは hook 関数を設定する

  # formats, actionformats のメッセージを設定する直前のフック関数
  # formats の時は3つ、actionformats の時は4つメッセージがあるので
  # 各関数が最大4回呼び出される
  zstyle ':vcs_info:git+set-message:*' hooks \
                                       git-hook-begin \
                                       git-untracked \
                                       git-stash-count \
                                       git-push-status \
                                       git-nomerge-branch

  ## フックの最初の関数
  #  git の作業コピーのあるディレクトリのみフック関数を呼び出すようにする
  #  (.git ディレクトリ内にいるときは呼び出さない)
  #  .git ディレクトリ内では git status --porcelain などがエラーになるため
  function +vi-git-hook-begin() {
    if [ "$(command git rev-parse --is-inside-work-tree 2> /dev/null)" != "true" ]; then
      # 0以外を返すとそれ以降のフック関数は呼び出されない
      return 1
    fi

    return 0
  }

  ## untracked ファイル表示
  #  untracked ファイル(バージョン管理されていないファイル)がある場合は
  #  unstaged (%u) に ? を表示
  function +vi-git-untracked() {
    # zstyle formats, actionformats の2番目のメッセージのみ対象にする
    if [ "$1" != "1" ]; then
      return 0
    fi

    local untracked=$(command git status --porcelain 2> /dev/null \
        | command grep -F '??' &> /dev/null \
        | wc -l)

    if [ "$untracked" -gt 0 ]; then
      # unstaged (%u) に追加
      hook_com[unstaged]+="%F{012}?"
    fi
  }

  ## stash 件数表示
  #  stash している場合は :SN という形式で unstaged (%u) に表示
  function +vi-git-stash-count() {
    # zstyle formats, actionformats の2番目のメッセージのみ対象にする
    if [ "$1" != "1" ]; then
      return 0
    fi

    local stash=$(command git stash list 2> /dev/null | wc -l)

    if [ "$stash" -gt 0 ]; then

      # unstaged (%u) に追加
      if [ "${hook_com[unstaged]}" != "" ]; then
        hook_com[unstaged]="${hook_com[unstaged]}%F{010}:S${stash}"
      else
        hook_com[unstaged]="%F{010}S${stash}"
      fi
    fi
  }

  ## push していないコミットの件数表示
  #  リモートリポジトリに push していないコミットの件数を
  #  pN という形式で misc (%m) に表示する
  function +vi-git-push-status() {
    # zstyle formats, actionformats の3番目のメッセージのみ対象にする
    if [ "$1" != "2" ]; then
      return 0
    fi

    # push していないコミット数を取得する
    local ahead=$(command git rev-list origin/${hook_com[branch]}..${hook_com[branch]} 2> /dev/null \
        | wc -l)

    if [ "$ahead" -gt 0 ]; then

      # misc (%m) に追加
      if [ "${hook_com[misc]}" != "" ]; then
        hook_com[misc]="${hook_com[misc]} (p${ahead})"
      else
        hook_com[misc]="(p${ahead})"
      fi
    fi
  }

  ## マージしていない件数表示
  #  master 以外のブランチにいる場合に、
  #  現在のブランチ上でまだ master, main にマージしていないコミットの件数を
  #  (mN) という形式で misc (%m) に表示
  function +vi-git-nomerge-branch() {
    # zstyle formats, actionformats の3番目のメッセージのみ対象にする
    if [ "$1" != "2" ]; then
      return 0
    fi

    if [ "${hook_com[branch]}" = "master" ] \
        || [ "${hook_com[branch]}" = "main" ]; then

      # main, master ブランチの場合は何もしない
      return 0
    fi

    # main, masterの判定
    local default="main"
    command git rev-list --max-count=1 ${default} &> /dev/null || local default="master"

    local nomerged=$(command git rev-list ${default}..${hook_com[branch]} 2> /dev/null | wc -l)

    if [ "$nomerged" -gt 0 ]; then
      local c="$(echo ${hook_com[misc]} | grep -E '(\(p[0-9]+\))$' &> /dev/null && echo ok)"

      # misc (%m) に追加
      if [ "${c-ng}" = "ok" ]; then
        hook_com[misc]="${hook_com[misc]%*)}, m${nomerged})"

      elif [ "${hook_com[misc]}" != "" ]; then
        hook_com[misc]="${hook_com[misc]} m${nomerged})"

      else
        hook_com[misc]="(m${nomerged})"
      fi
    fi
  }
fi


########################################
# プロンプト系の設定
########################################
# promptinitでの設定の場合
# autoload -Uz promptinit && promptinit
# prompt adam1 とか

function precmd() {
  # 1行空ける
  print

  # User
  # rootは205（ピンク系）、それ以外は045（明るめの青）
  if [ $(id -u) -eq 0 ]; then
    local p_user="%F{205}%n%f"
  else
    local p_user="%F{045}%n%f"
  fi

  # HostName
  case ${SOURCE_SSH_CONNECTION##*,} in
    0) local p_host="%F{015}%m%f" ;;
    1) local p_host="%F{156}%m%f" ;;
    2) local p_host="%F{220}%m%f" ;;
    3) local p_host="%F{218}%m%f" ;;
    *) local p_host="%F{218}%K{197}%m !!TOO MANY CASCADE CONNECTION!!%k%f" ;;
  esac

  # Directory
  local p_dir="%F{cyan}%~%f"

  # 左側プロンプト
  local left="[${p_user}@${p_host}] ${p_dir}"

  # vcs_infoの実行
  LANG=en_US.UTF-8 vcs_info

  # 右側プロンプト
  local right

  if [ "$vcs_info_msg_0_" = "" ]; then
    # vcs_info で何も取得していない場合はプロンプトを表示しない
    right=""

  else
    # vcs_info で情報を取得した場合
    # $vcs_info_msg_0_, $vcs_info_msg_1_, $vcs_info_msg_2_, $vcs_info_msg_3_ を
    # それぞれ緑、色変更なし、黄色、赤で表示する
    [ "$vcs_info_msg_0_" != "" ] && right="%F{010}${vcs_info_msg_0_}%f"
    [ "$vcs_info_msg_1_" != "" ] && right="${right%*]*}|${vcs_info_msg_1_}%F{010}]%f"
    [ "$vcs_info_msg_2_" != "" ] && right="${right} %F{yellow}${vcs_info_msg_2_}%f"
    [ "$vcs_info_msg_3_" != "" ] && right="${right} %F{009}${vcs_info_msg_3_}%f"
  fi

  if [ "$right" != "" ]; then
    # スペースの長さを計算
    # テキストを装飾する場合、エスケープシーケンスをカウントしないようにする
    local invisible='%([BSUbfksu]|([FK]|){*})'
    local leftwidth=${#${(S%%)left//$~invisible/}}
    local rightwidth=${#${(S%%)right//$~invisible/}}
    local padwidth=$(($COLUMNS - ($leftwidth + $rightwidth) % $COLUMNS - 1))

    print -P $left${(r:$padwidth:: :)}$right

  else
    print -P $left
  fi
}

# 左側のプロンプト
PROMPT="%(!.#.$) "

# 右側のプロンプト
# 直前に実行したコマンドの戻り値が { 0 -> cyan; 0以外 -> magenta }
RPROMPT="%(?.%F{cyan}.%F{magenta})[return:%?]%f"


# Googleカラーでサジェストプロンプトを表示
if [[ $TERM == 'linux' ]]; then
  SPROMPT=":‑/ < %{$fg[blue]%}Di%{${reset_color}%}%{$fg[red]%}d %{${reset_color}%}%{$fg[yellow]%}yo%{${reset_color}%}%{$fg[blue]%}u %{${reset_color}%}%{$fg[green]%}me%{${reset_color}%}%{$fg[red]%}an%{${reset_color}%}...; %{$fg[red]%}%r%{${reset_color}%}? [(y)es, (n)o, (a)bort, (e)dit] -> "
else
  SPROMPT="( ´・ω・) ＜ %{$fg[blue]%}も%{${reset_color}%}%{$fg[red]%}し%{${reset_color}%}%{$fg[yellow]%}か%{${reset_color}%}%{$fg[green]%}し%{${reset_color}%}%{$fg[red]%}て%{${reset_color}%}: %{$fg[red]%}%r%{${reset_color}%}？ [(y)es, (n)o, (a)bort, (e)dit] -> "
fi


########################################
# Alias設定
########################################
if [ -f ${HOME}/.bash_aliases ]; then
    source ${HOME}/.bash_aliases
fi


########################################
# 関数設定
########################################
if [ -f ${DOTEXTRA_PATH}/functions.sh ]; then
    source ${DOTEXTRA_PATH}/functions.sh
fi


########################################
# zsh_history記録除外設定
########################################
zshaddhistory() {
  # STEALTHを含むホストへのSSH接続はhistoryに残さない
  #if [[ "${1%%$'\n'}" =~ ^ssh.\+STEALTH.* ]]; then
  #  false
  #fi
}

########################################
# プラグイン設定
########################################
# 工事中


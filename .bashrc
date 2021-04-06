##### ~/.bashrc #####

########################################
# 環境設定
########################################
# インタラクティブモードで動作していなければ、何もしない
case $- in
    *i*) ;;
      *) return;;
esac

########################################
# ヒストリ設定
########################################
# ヒストリファイル
HISTFILE=${HOME}/.bash_history

# サイズ設定
HISTSIZE=20000
HISTFILESIZE=20000

# 重複行、もしくは空白で始まる行はヒストリに追加しない
HISTCONTROL=ignoreboth

# 特定コマンドのヒストリ出力を抑止する
#HISTIGNORE=”history:cd:ssh”

# 複数行に分けて入力したコマンドラインを、1行のヒストリとして保存
shopt -s cmdhist

# cmdhistオプションが有効な場合、複数行に分けて入力したコマンドラインを
# [;] 区切りではなく改行区切りでヒストリに保存
#shopt -s lithist

# シェルの終了時に、HISTFILEで指定したファイルに
# ヒストリのリストを追加する（上書きしない）
shopt -s histappend

# 失敗したヒストリ置換を再編集できるようにする
# （「!番号」で該当するヒストリがない場合、コマンドラインに「!番号」を再表示）
#shopt -s histreedit

# [!] 記号でヒストリーを置換した結果を、すぐに実行するのではなく
# コマンドラインに表示する
shopt -s histverify


########################################
# cd設定
########################################
# ディレクトリ名だけで cd する
shopt -s autocd

# cdコマンドの引数として変数を使用できるようにする
# （[$] 無しで変数として認識させる）
#shopt -s cdable_vars

# cdコマンドで指定したディレクトリの軽微なミス
# （文字の入れ替わり、1文字欠けている、1文字多い）
# を修正して実行する
#shopt -s cdspell


########################################
# 補完、パス名展開、変数展開設定
########################################
# 指定したディレクトリが存在しない場合、
# 補完の際にディレクトリ名の訂正を試みる
shopt -s dirspell

# 補完の際にシェル変数「FIGNORE」で指定した接尾辞を無視する
shopt -s force_fignore

# 空行に対するコマンド補完を行う際に、
# 補完候補をPATHから検索しない
#shopt -s no_empty_cmd_completion

# パス名展開でファイル名のマッチに失敗した場合、エラーにする
#shopt -s failglob

# パス名展開ができなかった場合、空文字列にする
#shopt -s nullglob

# パス名展開で「**」を使用可能にする
# （ディレクトリ下のファイルを再帰的に検索して全てのファイルにマッチする）
#shopt -s globstar

# [.]（ドット）で始まるファイル名をパス名展開の結果に含める
# ※想定している挙動と変わってしまうため、かなり危険（rmやmv等）※
##shopt -s dotglob

# パス名展開で、「?(パターンリスト)」のように、[?] [*] [+] [@] [!] と [()] を
# 組み合わせたパターン指定（拡張パターンマッチング）を使用
shopt -s extglob

# パス名展開の際に、ファイル名の大文字と小文字を区別しない
shopt -s nocaseglob

# [case] コマンドや「[[」実行時のパターンマッチで大文字と小文字を区別しない
#shopt -s nocasematch

# プログラム補完機能を使用する
shopt -s progcomp

# エイリアスの展開を行う
shopt -s expand_aliases

# [@] 記号でホスト名展開を行う
shopt -s hostcomplete

# ダブルクオート中にある「${パラメーター}」の展開で、
# 「$'文字列'」と「$"文字列"」のクオートを機能させる
shopt -s extquote

# プロンプト文字列に対して、パラメーター展開やコマンド置換、
# 算術式展開、クオート削除を行う
shopt -s promptvars

# [echo] コマンドで、[-e] オプションがない場合でも、
# バックスラッシュによるエスケープシーケンスを展開する
#shopt -s xpg_echo


########################################
# コマンド終了時、シェル終了時の設定
########################################
# 対話シェルが終了する前に、停止中や実行中のジョブの状態を表示する
#shopt -s checkjobs

# 対話ログインシェルを終了する際に、全てのジョブにSIGHUPシグナルを送る
##shopt -s huponexit

# [exec] コマンドへの引き数として指定したファイルが実行できなくても、
# 非対話シェルを終了しない（対話シェルがexecに失敗しても終了しない）
#shopt -s execfail

# コマンドを実行した際に、端末画面の大きさの確認を行い、
# 必要に応じて [$LINES] や [$COLUMNS] の値の更新を行う
shopt -s checkwinsize


########################################
# 互換関連の設定
########################################
# 条件コマンド「[[」で、「=~」演算子に対するクオートの付いた引数の扱いを
# bash 3.1の動作に変更する
#shopt -s compat31

# 条件コマンド「[[」で、「<」演算子と「>」演算子によるロケール固有の
# 文字列比較の扱いをbash 3.2の動作に変更する
#shopt -s compat32

# 条件コマンド「[[」で、「<」演算子と「>」演算子によるロケール固有の
# 文字列比較の扱いとコマンドリストの解釈の効果をbash 4.0の動作に変更する
#shopt -s compat40

# POSIXモードの際に、ダブルクオートの中のパラメーター展開でシングルクオートを
# 特殊文字として扱う（bash 4.1互換の動作）
#shopt -s compat41

# シェルのエラーメッセージをGNU標準の形式で出力する
#shopt -s gnu_errfmt


########################################
# その他設定
########################################
# ハッシュテーブルで見つけたコマンドを実行する前に、
# コマンドが実際に存在するかどうか確認する
shopt -s checkhash

# [source] コマンド（[.] コマンド）で、指定したファイルをPATHから探す
shopt -s sourcepath

# ジョブ制御が有効な場合、バックグラウンドでの実行ではないパイプラインの最後のコマンドを、
# 現在のシェル環境で実行する
#shopt -s lastpipe

# [#] 以降を無視する（コメント扱いにする）
shopt -s interactive_comments

# [shift] コマンドで、シフトの回数が位置パラメーターの数を超えた場合、
# エラーメッセージを出力する
shopt -s shift_verbose

# メールのファイルがアクセス済みである場合に「The mail in メールファイル名 has been read」
# というメッセージを表示する
#shopt -s mailwarn

# デバッガ用の動作を有効にする（詳細内容は「man bash」を参照）
#shopt -s extdebug


##### ---------- ↑ここまで精査完了↑ ---------- #####



# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
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

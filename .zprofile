#######################################
# 環境変数設定
########################################
# ロケール環境変数の設定
# コンソールログインの場合はLANGを日本語にしない
if [[ $TERM == 'linux' ]]; then
  export LANG=en_US.UTF-8
else
  export LANG=ja_JP.UTF-8
fi

# SSH多段接続用環境変数の設定
# TMUXログインを考慮
if [ -z $TMUX ]; then
  SOURCE_SSH_CONNECTION="$SOURCE_SSH_CONNECTION $SSH_CONNECTION"
fi
export SOURCE_SSH_CONNECTION

# PATHに[$HOME/.bin]を追加
if [ -n $HOME/.bin ];then
   PATH=$PATH:$HOME/.bin
fi

# GO言語モジュール導入用
export GO111MODULE=on


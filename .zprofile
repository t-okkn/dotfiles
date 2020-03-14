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

# 暗号化用公開鍵のPATH設定
if [ -n $HOME ]; then
  PUBLICKEY_PATH="${HOME}/dotfiles/etc/PublicKey"
  export PUBLICKEY_PATH
fi

# GO言語モジュール導入用
export GO111MODULE=on


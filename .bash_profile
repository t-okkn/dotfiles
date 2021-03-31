##### ~/.bash_profile #####

#######################################
# 環境変数設定
########################################
# ロケール環境変数の設定
# コンソールログインの場合はLANGを日本語にしない
if [ "$TERM" = "linux" ]; then
  export LANG=en_US.UTF-8
else
  export LANG=ja_JP.UTF-8
fi

# SSH多段接続用環境変数の設定
# TMUXログインを考慮
if [ "$TMUX" = "" ]; then
  if [ "$SSH_CONNECTION" = "" ]; then
    SOURCE_SSH_CONNECTION="-,0"

  else
    from_host=$(echo $SSH_CONNECTION | awk '{ print $1 }')
    from_port=$(echo $SSH_CONNECTION | awk '{ print $2 }')
    to_host=$(echo $SSH_CONNECTION | awk '{ print $3 }')
    to_port=$(echo $SSH_CONNECTION | awk '{ print $4 }')

    if [ "$SOURCE_SSH_CONNECTION" = "-,0" ]; then
      SOURCE_SSH_CONNECTION="${from_host}:${from_port} -> ${to_port}:${to_host}"

    else
      from=":${from_port}"
      last_host=$(echo ${SOURCE_SSH_CONNECTION##*:} | sed -r -e 's/,[0-9]+//')

      if [ "$last_host" != "$from_host" ]; then
        from="(${from_host}):${from_port}"
      fi

      SOURCE_SSH_CONNECTION="${SOURCE_SSH_CONNECTION%,*}${from} -> ${to_port}:${to_host}"
    fi

    count=$(echo $SOURCE_SSH_CONNECTION | awk -F ' -> ' '{ print NF-1 }')
    SOURCE_SSH_CONNECTION="${SOURCE_SSH_CONNECTION},$count"
  fi
fi

export SOURCE_SSH_CONNECTION

# Bashが動作していれば、[.bashrc]を読み込み
if [ -n "$BASH_VERSION" ]; then
  # [.bashrc]の存在確認
  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
fi

# PATHに[$HOME/.bin]を追加
if [ -d "$HOME/.bin" ]; then
  PATH="$PATH:$HOME/.bin"
fi

# GO言語モジュール導入用
export GO111MODULE=on


#######################################
# 環境変数設定
########################################
# ロケール環境変数の設定
export LANG=ja_JP.UTF-8

# SSH多段接続用環境変数の設定
SOURCE_SSH_CONNECTION="$SOURCE_SSH_CONNECTION $SSH_CONNECTION"
export SOURCE_SSH_CONNECTION


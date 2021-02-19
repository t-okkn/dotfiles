#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  echo "[ERROR:1] root権限で実行してください"
  exit 1
fi

if [ "$1" = "" ]; then
  echo "Usage: $0 <{new | update | delete}> [user]"
  exit 127
fi

OS_ID=$(cat /etc/os-release | grep -E "^ID=" | sed 's/ID=//')

if [ "$OS_ID" != "ubuntu" ] && [ "$OS_ID" != "debian" ];then
  echo "[ERROR:2] Debian または Ubuntu 系のLinuxのみで使用可能です"
  exit 2
fi

TARGET_USER=$(env | grep -E "^USER=" | sed 's/USER=//')

if [ "$2" != "" ]; then
  id $2 &> /dev/null

  if [ $? -eq 1 ]; then
    echo "[ERROR:3] 指定されたUserは存在しません"
    exit 3
  fi

  TARGET_USER="$2"

else
  if [ "$(env | grep SUDO_USER)" != "" ]; then
    TARGET_USER=$(env | grep SUDO_USER | sed 's/SUDO_USER=//')
  fi
fi

GITHUB_URL="https://github.com/cdr/code-server"
LATEST_URL="$GITHUB_URL/releases/latest"
PW_URL="https://www.passwordrandom.com/query"
PW_QUERY="?command=password&scheme=LlNlLN\!LNlNLl"

SERVICE_NAME="code-server@$TARGET_USER"
TARGET_HOME=$(cat /etc/passwd | grep -E "^${TARGET_USER}:" | awk -F':' '{ print $6 }')

CONFIG_PATH="$TARGET_HOME/.config/code-server"
CONFIG_FILE="$CONFIG_PATH/config.yaml"
CONFIG_OLD="$CONFIG_PATH/config.yaml.old"

PASSWORD=$(curl -sSfL "${PW_URL}${PW_QUERY}" | xargs echo "password:")
LATEST=$(curl -sSfLI -o /dev/null -w "%{url_effective}" $LATEST_URL | sed -e 's/.*\/v//')
DEB_FILE="code-server_${LATEST}_amd64.deb"
FILE_URL="$GITHUB_URL/releases/download/v${LATEST}/${DEB_FILE}"

function install_file() {
  curl -sSfL -o /tmp/$DEB_FILE $FILE_URL
  dpkg -i /tmp/$DEB_FILE
  rm -f /tmp/$DEB_FILE
}

function update_password() {
  cat $CONFIG_FILE > $CONFIG_OLD
  sed -i -e "s/^password:.*$/$PASSWORD/" $CONFIG_FILE
}

function send_message() {
  msg=$(echo -e "【code-serverパスワード変更通知】\n\n$PASSWORD")
  line-message.sh "$msg"
}


if [ "$1" = "new" ]; then
  if type "code-server" &> /dev/null; then
    echo "[ERROR:4] code-server は既にインストール済みです"
    exit 4
  fi

  install_file && update_password
  systemctl enable --now $SERVICE_NAME
  send_message

elif [ "$1" = "update" ]; then
  is_install=1
  is_enable=0

  if type "code-server" &> /dev/null; then
    current=$(code-server --version | awk '{ print $1 }')

    if [ $current = $LATEST ]; then
      echo "[$(date '+%Y-%m-%d_%H:%M:%S')] 最新バージョン（v${LATEST}）です"
      is_install=0

    else
      echo "v$LATEST に更新します・・・"
    fi

    systemctl stop $SERVICE_NAME

  else
    is_enable=1
  fi

  if [ $is_install -eq 1 ]; then
    install_file && update_password

    if [ $is_enable -eq 1 ]; then
      systemctl enable $SERVICE_NAME
    else
      systemctl daemon-reload
    fi

  else
    # インストールせずともパスワード更新のみは行う
    update_password
  fi

  systemctl start $SERVICE_NAME
  send_message

elif [ "$1" = "delete" ]; then
  if !(type "code-server" &> /dev/null); then
    echo "[ERROR:5] code-server はインストールされていません"
    exit 5
  fi

  rm -f $CONFIG_OLD
  systemctl stop $SERVICE_NAME
  systemctl disable $SERVICE_NAME
  dpkg -r code-server

else
  echo "[ERROR:255] Unknown subcommand: $1"
  echo "Usage: $0 <{new | update | delete}> [user]"
  exit 255
fi


#!/bin/bash

if [ "$1" = "" ]; then
  echo "Usage: $0 <message> [LineNotify SecretToken]"
  exit 1
fi

LINE_URL="https://notify-api.line.me/api/notify"
TOKEN=""

if [ "$2" != "" ]; then
  TOKEN="$2"
else
  if [ "$LINE_SECRET_TOKEN" != "" ]; then
    TOKEN="$LINE_SECRET_TOKEN"
  fi
fi

if [ "$TOKEN" = "" ]; then
  echo "LineNotifyでメッセージを送信するにはTOKENが必要です"
  exit 2
fi

HEADER="Authorization: Bearer $TOKEN"
MSG=$(echo -e "message=[$(hostname)]\n$1")
OUT="message: %{http_code}\n"

curl -sS -o /dev/null -w "$OUT" -X POST -H "$HEADER" -F "$MSG" $LINE_URL


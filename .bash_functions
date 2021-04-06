##### ~/.bash_functions #####

########################################
# My Functions
########################################
# mkcd path => ディレクトリの作成と対象ディレクトリの移動を同時に行う
function mkcd() {
  if [ "$1" != "" ]; then
    if [ ! -d $1 ]; then
      # フォルダが存在しなければ作成して移動
      mkdir $1 && cd $1

    else
      # フォルダが存在すればただの移動
      cd $1
    fi

  else
    echo "Usage: mkcd path"
  fi
}

# tmux-attach [sesssion_name] => tmuxのセッションに接続する
function tmux-attach() {
  if [ "$1" != "" ]; then
    tmux attach-session -t $1 2>/dev/null || tmux new-session -s $1
  else
    tmux attach-session 2>/dev/null || tmux
  fi
}

# tmux-list-all => tmuxで稼働中のセッションについて、window, paneの詳細情報も含めて表示する
function tmux-list-all() {
  tmux list-sessions -F '#{session_id} [name: #{session_name}] [created: #{t:session_created}] #{?session_attached,* attached,-}' \
    | sort | while read s t; do
        echo $s $t
        tmux list-windows -t "$s" -F '#{window_id} [name: #{window_name}] [#{window_width}x#{window_height}] [layout: #{window_layout}]' \
          | while read w x; do
              echo "  $w" $x
              tmux list-panes -t "$w" -F "    #D($s:#I.#P) [title: #T] [tty: #{pane_tty}] [command: #{pane_current_command}]"
              echo
            done
      done
}

# kill-session => SSHなどで強制切断されて残ってしまったセッションをkillする
function kill-session() {
  # tmuxで使用中の端末デバイスを取得
  local tmux_pts=$(tmux list-panes -a -F "#{pane_tty}" 2>/dev/null | sed 's/\/dev\///')

  # 除外文字列の構築
  local exclude=$(echo "(grep|$(tty | sed 's/\/dev\///')$(if [ "$tmux_pts" != "" ]; then echo $tmux_pts | while read e; do printf "|$e"; done; fi))")

  # プロセス一覧から検索する文字列を「w」コマンドから構築
  local search=$(w | tail -n +3 | awk '{ printf("%s.+%s\n", $2, $8) }' | grep pts | grep -Ev "$exclude")

  # プロセス一覧から検索文字列を用いて、Killすべきpidの一覧を求める
  local target_pids=$(for i in $search; do ps -ef | grep -E "$i" | grep -v grep | awk '{ print $3 }'; done)

  # すべてのpidをkillする
  echo $target_pids | while read i; do
    if [ "$i" != "" ]; then
      kill -9 $i
    fi
  done
}

# png2jpg [resize] => Convert from png format to jpg format
function png2jpg() {
  if type mogrify >& /dev/null; then
    local resize="100%"

    if [ ! $1 = "" ]; then
      resize=$(echo "$1" | cut -d " " -f 1)
    fi

    mogrify -format jpg -quality 90 -resize $resize *.png

  else
    echo "Please install imagemagick"
  fi
}

# img2pdf => 画像ファイルの入ったフォルダ群を画像pdfファイルに変換する
function img2pdf() {
  if type convert >& /dev/null && type exiftool >& /dev/null; then

    find ./ -mindepth 1 -maxdepth 1 -type d -print | while read i; do
      e=$(\ls -1 --color=none $i/ | head -n 1 | sed -r 's/^.*\.//')

      if [ -z "$(\ls -1 --color=none $i/ | grep -v \.$e)" ]; then
        convert $i/*.$e ${i##*/}.pdf \
          && exiftool -title="${i##*/}" ${i##*/}.pdf > /dev/null \
          && echo "${i##*/} -> Success"

      else
        echo "${i##*/} -> 【.$e】以外の拡張子のファイルが存在します"
      fi
    done && rm -f *pdf_original

  else
    echo "Plese install imagemagick and exiftool"
  fi
}


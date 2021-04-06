########################################
# Alias一覧
########################################
# ls
alias l='ls -CF'
alias la='ls -CFA'
alias ll='ls -alFh --time-style=long-iso'

# ファイル操作系
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv --preserve-root'

alias mkdir='mkdir -p'

# 情報閲覧系
alias du='du -h'
alias df='df -h'
alias j='jobs -l'

# zshの場合のみ、sudoの後のコマンドでエイリアスを有効にする
case "$SHELL" in
  *zsh) alias sudo='sudo ';;
esac

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# tmux関連
alias t='tmux-attach'
alias tl='tmux-list-all'

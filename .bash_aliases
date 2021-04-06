##### ~/.bash_aliases #####

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

# tmux関連
alias t='tmux-attach'
alias tl='tmux-list-all'

##### ----- zsh ONLY ----- #####
case "$SHELL" in
  *zsh) # sudoの後のコマンドでエイリアスを有効にする
        alias sudo='sudo '
        ##
        # global alias
        alias -g A='| awk'
        alias -g H='| head'
        alias -g L='| less'
        alias -g G='| grep'
        alias -g T='| tail'
        alias -g X='| xargs'
        ##
        # suffix alias
        # 解凍系（./hoge.tar.gz で展開できる）
        alias -s gz='tar -xzvf'
        alias -s bz2='tar -jxvf'
        alias -s xz='tar -Jxvf'
        alias -s tar='tar -xvf'
        alias -s zip='unar'
        ;;
esac

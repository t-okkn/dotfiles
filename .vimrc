" SyntaxHighlight
syntax on
set syntax=mel

" 改行形式の自動判別
set fileformats=unix,dos,mac

" ファイル読み込み時のエンコーディングの指定
set encoding=utf-8

" defaultのエンコーディングを設定
set fileencodings=utf-8

" 行番号表示
set number

" クリップボード連携の有効化
set clipboard^=unnamedplus

"タブ、空白、改行の可視化
set list
set listchars=tab:>-,trail:-,extends:>,precedes:<,nbsp:%
"改行も可視化する場合、行末に「,eol:$」を挿入

"全角スペースをハイライト表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif

" インデント関連設定
" 改行時に前の行のインデントを計測
set autoindent
" 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent
" 新しい行を作った時に高度な自動インデントを行う
set smarttab

" キーボードから入るタブの数
set softtabstop=2
" 自動インデントで入る空白数
set shiftwidth=2
" タブを含むファイルを開いた際、タブを何文字の空白に変換するか
set tabstop=2
" タブ入力を複数の空白に置き換える
set expandtab

if has("autocmd")
  " ファイルタイプの検出を有効化
  filetype on

  "ファイルタイプの検索を有効にする
  filetype plugin on

  "ファイルタイプに合わせたインデントを利用
  filetype indent on

  " 改行での自動コメントアウトを無効
  autocmd FileType * setlocal formatoptions-=ro

  "sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
  autocmd FileType c           setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType js          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript  setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType json        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType go          setlocal sw=4 sts=4 ts=4 noet
endif

"ターミナル上で背景色をターミナルの背景色と同色にする
autocmd ColorScheme * highlight Normal ctermbg=none
autocmd ColorScheme * highlight LineNr ctermbg=none
"set background=dark

" Plugin管理ソフトNeoBundleさん
" ---neobundle settings Start---

if has('vim_starting')
  set nocompatible
  " neobundle をインストールしていない場合は自動インストール
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    echo "install neobundle..."
    " vim からコマンド呼び出しているだけ neobundle.vim のクローン
    :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
  endif
  " runtimepath の追加は必須
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle'))
let g:neobundle_default_git_protocol='https'

" neobundle#begin - neobundle#end の間に導入するプラグインを記載します。
NeoBundleFetch 'Shougo/neobundle.vim'

" pluginリスト
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'jpo/vim-railscasts-theme'
NeoBundle 'vim-scripts/Wombat'
NeoBundle 'kana/vim-submode'
NeoBundle 'w0rp/ale'

" vimrc に記述されたプラグインでインストールされていないものがないかチェックする
NeoBundleCheck
call neobundle#end()
filetype plugin indent on

" ---neobundle settings End---

" カラースキームの設定
"colorscheme railscasts
colorscheme jellybeans


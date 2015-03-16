silent! call pathogen#infect()

syntax on
filetype plugin indent on

set t_Co=256
set encoding=utf-8
set vb
set ruler
set showmatch
set backspace=2
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:→·,trail:·
set laststatus=2
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set statusline+=%#warningmsg#
set statusline+=%*
highlight SpecialKey ctermfg=19
highlight CursorLine cterm=NONE ctermbg=17
highlight StatusLine ctermfg=18 ctermbg=106

autocmd FileType text set tw=80
autocmd Filetype tex setlocal nofoldenable|set tw=80
autocmd BufNewFile,BufRead /tmp/mutt* set tw=72

let g:vim_markdown_folding_disabled=1

if has("gui_running")
    set lines=24 columns=80
endif

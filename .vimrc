silent! call pathogen#infect()

syntax on
filetype plugin indent on

set vb
set ruler
set showmatch
set backspace=2
set tabstop=4
set shiftwidth=4
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

autocmd FileType text set tw=80
autocmd Filetype tex setlocal nofoldenable|set tw=80
autocmd BufNewFile,BufRead /tmp/mutt* set tw=72

let g:vim_markdown_folding_disabled=1

if has("gui_running")
    set lines=24 columns=80
endif

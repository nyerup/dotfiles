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
set modeline
set modelines=5
set cursorline
set laststatus=2
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set statusline+=%#warningmsg#
set statusline+=%*
set splitbelow
set splitright

let g:vim_markdown_folding_disabled=1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = "▸"
let g:syntastic_warning_symbol = "▸"
let g:syntastic_style_error_symbol = "▹"
let g:syntastic_style_warning_symbol = "▹"
let g:syntastic_enable_perl_checker = 1
let g:syntastic_python_pylint_exec = '/usr/local/bin/pylint'
let g:syntastic_python_checkers = ['python', 'pylint']
let g:syntastic_perl_checkers = ['perl']

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'Þ'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''

let g:gitgutter_override_sign_column_highlight = 0

highlight SpecialKey ctermfg=19
highlight CursorLine cterm=NONE ctermbg=17
highlight StatusLine ctermfg=18 ctermbg=106
highlight ExtraWhitespace ctermbg=red
highlight SignColumn ctermbg=236

match ExtraWhitespace /\s\+$/

autocmd FileType text setlocal tw=80 noexpandtab
autocmd FileType mail setlocal tw=72 noexpandtab
autocmd FileType mail highlight ExtraWhitespace none
autocmd FileType markdown setlocal tw=80
autocmd FileType tex setlocal nofoldenable tw=80
autocmd FileType python setlocal expandtab ts=4 sw=4
autocmd FileType ruby setlocal expandtab ts=4 sw=4
autocmd FileType javascript setlocal expandtab ts=4 sw=4
autocmd FileType json setlocal expandtab ts=4 sw=4
autocmd FileType yaml setlocal expandtab ts=2 sw=2

autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

autocmd BufNewFile,BufRead /tmp/mutt* set tw=72
autocmd BufNewFile,BufRead *.json.disabled set ft=json
autocmd BufNewFile,BufRead *.jsondisabled set ft=json
autocmd BufWritePost *.tex call TypesetLatex()

autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

autocmd VimEnter * :call AfterOpen()

map ] :bnext<CR>
map [ :bprev<CR>
map <C-n> :NERDTreeToggle<CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

if has("gui_running")
	set lines=24 columns=80
endif

function TypesetLatex()
	silent !pdflatex -interaction=nonstopmode %
	redraw!
endfunction

function AfterOpen()
	if exists("g:loaded_syntastic_plugin")
		set statusline+=%{SyntasticStatuslineFlag()}
	endif
endfunction

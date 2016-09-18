set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
execute pathogen#infect()

inoremap jk <ESC>

let mapleader = "\<Space>"

filetype plugin indent on
filetype plugin on
let python_highlight_all=1
syntax on
set encoding=utf-8

" Spellcheck
set spell 
nnoremap <leader>s :set spell!<CR>
nnoremap <leader>r ]sli<C-x><C-s><C-p>

"Folding
nnoremap <C-+> 1z=

" Fugitive plugin
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_quiet_messages = { "type": "style" }
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }

" CtrlP mapping
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <leader>f za

" Window switching
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Colon as semi-colon
nnoremap : ;
nnoremap ; :

" Disable annoying beeping
set noerrorbells
set vb t_vb=

" Show docstring with folding
let g:SimpylFold_docstring_preview=1

" PEP8 Indentation
au BufNewFile,BufRead *.py : 
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    "\ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
au BufNewFile,BufRead *.js,*.html,*.css :
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |

" Color scheme
if has('gui_running')
  set background=dark
  colorscheme solarized
else
  colorscheme zenburn
endif

" Line numbering
set nu

" Special characters
nnoremap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" Buffer switching
nnoremap <F5> :buffers<CR>:buffer<Space>
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" Source the vimrc file after saving it
if has("autocmd")
  autocmd!
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Open .vimrc quickly
noremap <leader>v :tabedit $MYVIMRC<CR>

" Tab completion
set wildmode=longest,list

" Extend command history
set history=200

" Command history scrolling
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Run a shell that doesn't suck shit
"set shell=C:/cygwin/bin/bash
"set shellcmdflag=-c
"set shellxquote=\" 

" File expansion
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Navigate display lines rather than real lines
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j

" Switch without saving buffer
set hidden

" Make search case sensitive if there is a capital character
set smartcase

" Very magic searching for regex that makes sense
"nnoremap / /\v
"cnoremap %s/ %s/\v

" Muting highlight search
nnoremap <silent> <C-l> :<C-u>set hlsearch!<CR><C-l>

" Count search matches
nnoremap <leader>c :%s///gn<CR>

" Search visual selection
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
	let temp = @s
	norm! gv"sy
	let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
	let @s = temp
endfunction

" Set Quickfix list as args list
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
 let buffer_numbers = {}
 for quickfix_item in getqflist()
  let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
 endfor
 return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

" Arduino hardy plugin
let g:hardy_arduino_path = "C:\\Program Files (x86)\\Arduino"

"Shitty summing function; Need to print g:S after running to get sum
let g:S = 0  "result in global variable S
function! Sum(number)
  let g:S = g:S + a:number
  return a:number
endfunction

"Toggle search highlight
nnoremap <leader>l :set hlsearch!<CR>

"Footnotes
nmap <leader>f <Plug>AddVimFootnote 
nmap <leader>n <Plug>ReturnFromFootnote 

"Replace last search with input
nnoremap <F3> :%s///g<left><left>

"Stop .swp already exists messages
set shortmess+=A

" Jedi plugin, python autocomplete
let g:jedi#use_splits_not_buffers = "top"
let g:jedi#auto_initialization = 0

" Python specific
function! PyComment()
	norm! ^
	if getline(".")[col(".")-1] =~ '#'
		normal! x
	else
		normal! i#
	endif
endfunction
augroup PythonCommenting
	autocmd!
	autocmd BufNewFile,BufRead *.py nnoremap <Leader>/ :call PyComment()<CR>
	autocmd BufNewFile,BufRead *.py vnoremap <Leader>/ :'<,'>call PyComment()<CR>
augroup END

" YCM 
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_global_ycm_extra_conf.py'

set pumheight=10

nnoremap <leader>w :YcmCompleter GoTo<CR>
nnoremap <leader>u :YcmCompleter GoToReferences<CR>
nnoremap <leader>q :YcmCompleter GetDoc<CR>

" Prolog extention
au BufRead,BufNewFile *.txt		setfiletype text

" Autosave
" let g:auto_save = 1
let g:auto_save_silent = 1

" Relative numbers
set relativenumber

" Lightline
set laststatus=2
let g:lightline = {
	\ 'colorscheme': 'wombat',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
        \ },
	\ 'component': {
	\   'readonly': '%{&filetype=="help"?"":&readonly?"":""}',
	\   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
	\   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
	\ },
        \ 'component_visible_condition': {
        \   'readonly': '(&filetype!="help"&& &readonly)',
        \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
        \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
        \ },
	\ 'separator': { 'left': '', 'right': '' },
	\ 'subseparator': { 'left': '', 'right': '' }
	\ }



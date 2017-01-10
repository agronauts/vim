" TODO Preserve working directory between buffers
" TODO Folding format/python
" TODO Variable highlighting when cursor hovers

" Pathogen
execute pathogen#infect()
" Clean autocmds
autocmd!

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ascend to the next generation
set nocompatible
" Switch without saving buffer
set hidden
" Our holy leader
let mapleader = "\<Space>"
" Source when saved
" if has("autocmd")
"   autocmd bufwritepost .vimrc source $MYVIMRC
" endif
" Keyremapping
inoremap jk <ESC>l " TODO Causes Jedi to crash
" Edit vimrc easily
nnoremap <Leader>v :tabnew $MYVIMRC<CR>
" inoremap <c-Space> <BS> " TODO Not working :'(
" Disable showmode
set noshowmode
" Filetype specific config
filetype plugin indent on
syntax on
" Encoding
set encoding=utf-8
" Disable annoying beeping
set noerrorbells
set vb t_vb=
" Spellcheck
nnoremap <leader>s :set spell!<CR>
nnoremap <leader>r ]sli<c-x><c-s><c-p>
" Folding
set foldmethod=indent
set foldlevel=99
nnoremap <c-+> 1z=
nnoremap <leader>f za
" Window switching
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
" Navigate display lines rather than real lines
nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j
" Colon as semi-colon
nnoremap : ;
nnoremap ; :
vnoremap : ;
vnoremap ; :
 " TODO make this work for readonly files
" if g:modifiable
"   set fileformat=unix
" endif
" Limit output log
set pumheight=10
" Line numbering
set nu
set relativenumber
" Tab completion
set wildmode=longest,list
" Extend command history
set history=200
"Stop .swp already exists messages
set shortmess+=A
" Make search case sensitive if there is a capital character
set ignorecase smartcase
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
"Toggle search highlight
nnoremap <leader>h :set hlsearch!<CR>
" Normally, Vim messes with iskeyword when you open a shell file. This can
" leak out, polluting other file types even after a 'set ft=' change. This
" variable prevents the iskeyword change so it can't hurt anyone.
let g:sh_noisk=1
" System copy/paste
nmap <c-v> "+p
imap <c-v> <ESC><c-v>
vmap <c-v> c<c-v>
vmap <c-c> "+y
nmap <c-c> V"+y<ESC>
" Command history scrolling
cnoremap <c-p> <Up>
cnoremap <c-n> <Down>
" Filename expansion
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Regex search
nnoremap <c-_> /\v
" Muting highlight search
"nnoremap <silent> <c-h> :<c-u>set hlsearch!<CR><c-l>
" Count search matches
nnoremap <leader>c :%s///gn<CR>
" Autosave
let g:auto_save_silent = 1
" Color scheme (After Lightline)
if has('gui_running')
  colorscheme solarized
  set background=dark
else
  colorscheme tender
endif
" Save folds
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview 
" Autosave on
let g:auto_save = 1
" Sets working directory to invoked location
:cd %:p:h
" Help page fullscreen
set helpheight=1000
" Save despite RO status
cmap w!! w !sudo tee %
" Better searching
set incsearch
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM FUNCTIONS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search visual selection
xnoremap * :<c-u>call <SID>VSetSearch()<CR>/<c-R>=@/<CR><CR>
xnoremap # :<c-u>call <SID>VSetSearch()<CR>?<c-R>=@/<CR><CR>
function! s:VSetSearch()
	let temp = @s
	norm! gv"sy
	let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
	let @s = temp
endfunction

"Shitty summing function; Need to print g:S after running to get sum
let g:S = 0  "result in global variable S
function! Sum(number)
  let g:S = g:S + a:number
  return a:number
endfunction

"Replace last search with input
nnoremap <F3> :%s///g<left><left>

" Set Quickfix list as args list
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
 let buffer_numbers = {}
 for quickfix_item in getqflist()
  let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
 endfor
 return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufLeave *.py,*.js :call <SID>StripTrailingWhitespaces()

nnoremap <Leader>t :!python3 -m doctest %<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PLUGIN CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lightline
set laststatus=2
let g:lightline = {
	\ 'colorscheme': 'tender',
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
" NERDtree
let NERDTreeHijackNetrw=1
" Syntastic plugin
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_quiet_messages = { "type": "style" }
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
" CtrlP mapping
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"
set runtimepath+=~/.vim/bundle/ultisnips
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsSnippetsDir="~/.vim/ultisnips"
let g:UltiSnipsSnippetDirectories=["ultisnips"]
" Show docstring with folding
let g:SimpylFold_docstring_preview=1
" Commenting remapping
nnoremap <Leader>/ :Commentary<CR>
vnoremap <Leader>/ :Commentary<CR>
" Jedi
let g:jedi#completions_command = "<C-N>"
let g:jedi#show_call_signatures = 2
let g:jedi#show_call_signatures_delay = 0
let g:jedi#squelch_py_warning = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM FILTYPES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Note
:let g:notes_suffix = '.note'
:let g:notes_title_sync = 'no'

au BufNewFile,BufRead *.note :
    \ set filetype=notes
au BufNewFile,BufRead *.py :
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set formatprg=autopep8\ - |
au BufNewFile,BufRead *.js,*.html,*.css :
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab |
    \ set autoindent |
au BufRead,BufNewFile *.txt		setfiletype text

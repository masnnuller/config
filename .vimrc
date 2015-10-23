set encoding=utf-8
set nowrap
set smarttab
set expandtab
"set listchars=eol:$,tab:->
"set list
set tabstop=2
set shiftwidth=2
set backspace=start,eol,indent
set nocompatible
set mouse=a
set ttymouse=xterm

augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
  autocmd CursorHold,CursorHoldI * setlocal cursorline
augroup END

filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif
call neobundle#begin (expand('~/.vim/bundle'))
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache.vim'
NeoBundle 'Align'
NeoBundle 'yanktmp.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/unite-ssh'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'thinca/vim-ref'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'osyo-manga/vim-over'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'derekwyatt/vim-scala'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'gregsexton/gitv'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'kannokanno/previm'
NeoBundle 'easymotion/vim-easymotion'
NeoBundle 'wookiehangover/jshint.vim'

call neobundle#end()

filetype plugin indent on
syntax on
" Settings for neocomplcache {{{
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
" }}}

"key mapping {{{
let mapleader = ","

"mapping for vim-easymotion
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
"mapping for vimfiler
nnoremap <Leader>f  :VimFiler<CR>
"remove keymap for ex mode
nnoremap Q :QuickRun<CR>
nnoremap <silent> <leader>m :OverCommandLine<CR>

imap "" ""<Left>
imap '' ''<Left>
imap () ()<Left>
imap <> <><Left>
imap {} {}<Left>
imap [] []<Left>
"}}}
""unite.vim {{{
let g:unite_source_history_yanl_enable = 1
try
  let g:unite_source_rec_async_command = 'ag --nocolor --nogroup -g ""'
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
catch
endtry

"prefix key
nnoremap [unite] <Nop>
nmap <Leader>f [unite]
"unite keymap
nnoremap [unite]u :<C-u>Unite --no-split<Space>
nnoremap <silent> [unite]f :<C-u>Unite<Space>buffer<CR>
nnoremap <silent> [unite]b :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]m :<C-u>Unite<Space>file_mru<CR>
nnoremap <silent> [unite]r :<C-u>UniteWithBufferDir file<CR>
nnoremap <silent> ,vr :UniteResume<CR>
nnoremap <space><space> :<C-u>Unite -start-insert file_rec/async<cr>
nnoremap <space>r <Plug>(unite_restart)
" vinarise
let g:vinarise_enable_auto_detect = 1
"  
" unite-build map
nnoremap <silent> ,vb :Unite build<CR>
nnoremap <silent> ,vcb :Unite build:!<CR>
nnoremap <silent> ,vch :UniteBuildClearHighlight<CR>
"}}}

"filetype
autocmd BufRead,BufNewFile *.md setfiletype markdown
autocmd BufRead,BufNewFile *.mkd setfiletype markdown
"conrfigure for lightline.vim
if !has('gui_running')
  set t_Co=256
endif

let g:lightline = {
  \ 'colorscheme' : 'wombat',
  \ 'separator' : {'left': '','right': ''},
  \ 'subseparator': {'left': '|','right': '|'}
  \}

colorscheme delek
set laststatus=2
set noshowmode

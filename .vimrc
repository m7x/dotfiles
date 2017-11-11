" apt-get install vim-gtk && vim -version (check +python)
syntax on
set number
:color desert

"set t_Co=256     " set 256 colors
set enc=utf-8    " utf-8 by default
set cursorline   " shows line under the cursor's line
set showmatch    " shows matching part of bracket pairs (), [], {}
set autoindent   " indent when moving to the next line while writing code
set nofoldenable " don't fold when open a file

" Showing line numbers and length
"set tw=139   " width of document (used by gd) - changed from 79 to 139 to honour github
"set nowrap  " don't automatically wrap on load
"set fo-=t   " don't automatically wrap text when typing
set colorcolumn=139 " Changed from 79 to 139 for github
"highlight ColorColumn ctermbg=233

" Prevent VIM to make :q uppercase
" https://stackoverflow.com/questions/25255830/how-to-prevent-the-q-will-be-uppercase-automatically-while-try-to-quit-vim
command! -bang Q q<bang>

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" jump to the last position when reopening a file
if has("autocmd")
      au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Better copy and paste
" https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

" Rebind <Leader> key
let mapleader = ","

" Bind nohl
" Removes highlight of your last search
" ``<C>`` stands for ``CTRL`` and therefore ``<C-n>`` stands for ``CTRL+n``
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>

" Quicksave command
noremap <C-Z> :update<CR>
vnoremap <C-Z> <C-C>:update<CR>
inoremap <C-Z> <C-O>:update<CR>

" Quick quit command
noremap <Leader>q :q!<CR>  " Quit current window
noremap <Leader>Q :qa!<CR>   " Quit all windows

"bind Ctrl+<movement> keys to move around the windows (:vsplit,split), instead of using Ctrl+w + <movement>
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" easier moving of code blocks
" Try to go into visual mode (v), thenselect several lines of code here and
""then press ``>`` several times.
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation

" easier moving between tabs
map <Leader>n <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

" Pasting with comments
" filetype off
" filetype plugin indent on

" Comment a big block. Use Shift+v to select the block and then
" `#` to comment, `-#` to uncomment
vnoremap <silent> # :s#^#\##<cr>:noh<cr>
vnoremap <silent> -# :s#^\###<cr>:noh<cr>

" Make tabnew filename completation like bash
set wildmode=longest,list,full
set wildmenu

" ============================================================================
" Python IDE Setup
" ============================================================================

au BufNewFile,BufRead *.py
    \ set tabstop=4     |
    \ set softtabstop=4 |
    \ set shiftwidth=4  |
    \ set textwidth=79  |
    \ set expandtab     |
    \ set autoindent    |
    \ set fileformat=unix

" https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
" git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" To install the plugins `:PluginInstall`
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/syntastic'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'nvie/vim-flake8'
Plugin 'kien/ctrlp.vim'
Plugin 'Vimjas/vim-python-pep8-indent'
call vundle#end()


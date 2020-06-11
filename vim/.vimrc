" version 6.0
" if &cp | set nocp | endif
" let s:cpo_save=&cpo
" set cpo&vim
" vmap gx <Plug>NetrwBrowseXVis
" nmap gx <Plug>NetrwBrowseX
" vnoremap <silent> <Plug>NetrwBrowseXVis :call netrw#BrowseXVis()
" nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(expand((exists("g:netrw_gx")? g:netrw_gx : '<cfile>')),netrw#CheckIfRemote())
" let &cpo=s:cpo_save
" unlet s:cpo_save
" set backspace=indent,eol,start
" set fileencodings=ucs-bom,utf-8,default,latin1
" set helplang=en
" set nomodeline
" set printoptions=paper:a4
" set ruler
" set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim80,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after
" set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
" Custom Edits
" syntax on 
" colorscheme delek
" set expandtab ts=4 sw=4 ai
" vim: set ft=vim :

version 8.0


" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Enabling syntax highlighting
if has("syntax")
  syntax on
endif

" Ensure vim knows that the background is dark
set background=dark

" Un/comment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set ignorecase         " Do case insensitive matching
set smartcase          " Do smart case matching
set incsearch          " Incremental search
set autowrite          " Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set mouse=a            " Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif


" ------------ END OF DEFAULT VIMRC -----------------------


" This specifies where in Insert mode the <BS> is allowed to delete the
" character in front of the cursor.  The three items, separated by commas, tell
" Vim to delete the white space at the start of the line, a line break and the
" character before where Insert mode started.
set backspace=indent,eol,start

" Control number of commands and search patterns kept in history
set history=500

" Display coordinates in bottom-right corner
set ruler

" Display command completion option on <Tab>
set wildmenu

" Display @@@ when the last line is truncated
set display=truncate

" ----------------------- PLUGIN CONFIGS --------------------

" -x-x-x- NERDTree Config -x-x-x-

" Open NERDTree automatically, when vim opens up
" Refer: https://vimawesome.com/plugin/nerdtree-red
autocmd vimenter * NERDTree


" Stick this in your vimrc to open NERDTree with Ctrl+n (you can set whatever key you want):
map <C-n> :NERDTreeToggle<CR>

" -x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-




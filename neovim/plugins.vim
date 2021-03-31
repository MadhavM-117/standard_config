" Manage all plugin related configs
call plug#begin('~/.config/nvim/plugged')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
	" (Optional) Multi-entry selection UI.
	Plug 'junegunn/fzf'
	Plug 'ervandew/supertab'
	Plug 'deoplete-plugins/deoplete-jedi'
	Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'sheerun/vim-polyglot'
call plug#end()

" Ensure python path is preserved through environment
let g:python3_host_prog = '/usr/bin/python3'

" <deoplete> ------
let g:deoplete#enable_at_startup = 1

call deoplete#custom#option('ignore_sources', {'_': ['around', 'buffer']})

" maximum candidate window length
call deoplete#custom#source('_', 'max_menu_width', 80)

" deoplete tab-complete
" inoremap <expr><tab> pumvisible() ? "\<c-p>" : "\<tab>"

" </deoplete> -------

" <language-client> ---------

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ }

" note that if you are using Plug mapping you should not use `noremap` mappings.
nmap <F5> <Plug>(lcn-menu)
" Or map each action separately
nmap <silent>K <Plug>(lcn-hover)
nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> <F2> <Plug>(lcn-rename)

" </language-client> ---------------
source ~/.config/nvim/defx.vim

" <defx> -----------------------
" Defx is what we'll use as a file explorer




" Keyboard shortcuts"

" Open Defx in the right hand side
nnoremap <leader>f :<C-u>Defx -split=vertical -winwidth=50 -direction=topleft -listed -resume<CR>

" List the available buffers to switch between in the current window
nnoremap <leader>b :<C-u>Denite buffer -auto-resize<CR>

" Open terminal at the bottom of the current window
nnoremap <leader>t :<C-u>12split term://zsh<CR>


" Command shortcuts 
command IDE 6split term://zsh <bar> 
	\ Defx -split=vertical -winwidth=50 -direction=topleft -listed -resume <bar>
	\ wincmd l


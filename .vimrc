" set runtimepath+=~/.vim_runtime

" Suggestted here: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'dracula/vim', { 'as': 'dracula'  }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'  }
Plug 'tpope/vim-fugitive'
call plug#end()

" source ~/.vim_runtime/vimrcs/basic.vim
" source ~/.vim_runtime/vimrcs/filetypes.vim
" source ~/.vim_runtime/vimrcs/plugins_config.vim
" source ~/.vim_runtime/vimrcs/extended.vim

" Theme
syntax enable
colorscheme dracula

:set number
" Want :GoBuild to auto-write
:set autowrite
" Tabs or spaces?
:set tabstop=4
:set shiftwidth=4
:set expandtab

" Start autocompleting immediately 
"" "au filetype go inoremap <buffer> . .<C-x><C-o>
" TODO: make a .rgignore file or something.
let $FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --glob="!{**/node_modules**,**/npm-packages-offline-cache/**,.git/*,bazel-**,go/pkg/**,go/bin/**,opt/**,go/.cache/**,**.bazelcache/**}"'
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
map <C-p> :FZF<CR>
nnoremap <leader>a :cclose<CR>
" Make go really colorful
let g:go_highlight_types = 1
" go imports on save
let g:go_fmt_options = { 'goimports': '-local samsaradev.io' }
let g:go_fmt_command = "goimports"

" Ripped from:
" https://github.com/fatih/vim-go/issues/2256#issuecomment-571986144
let g:go_auto_sameids = 1
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1

" Autocomplete everything to help
"" set completeopt+=menuone
"" set completeopt+=noselect
"" set shortmess+=c   " Shut off completion messages
"" set belloff+=ctrlg " If Vim beeps during completion
"" let g:mucomplete#enable_auto_at_startup = 1

" Go build, run, test
autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)


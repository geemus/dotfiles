set runtimepath^=~/.vim runtimepath+=/.vim/after
let &packpath = &runtimepath

set nocompatible                    " avoid crazy vi backwards compatibility stuff

" misc
syntax enable                       " enable syntax highlighting
set backspace=2                     " set backspace
set expandtab                       " expand tab to spaces in insert mode
set ignorecase                      " case-insensitive searching
set incsearch                       " incrementally highlight during search
set isk+=_,$,@,%,#,-                " mark rubyisms as keywords
set laststatus=2                    " always display status line
let mapleader="\<space>"            " more accessible leader character
set number                          " show line numbers
set nobackup                        " do not make a backup before overwriting a file
set nohlsearch                      " don't highlight matches after search
set noswapfile                      " do not create swap files
set nowrap                          " do not wrap lines
set nowritebackup                   " do not make a backup before overwriting a file
set shiftwidth=2                    " number of spaces used for each step in indentation
set showcmd                         " display partial commands in bottom right
set showmode                        " display the current mode
set showtabline=2                   " always display tab line
set smartcase                       " case-sensitive searching when expression contains capital letters
set smartindent                     " more clever auto-indenting behavior
set softtabstop=2                   " number of spaces to insert for a tab
set tabstop=2                       " number of spaces a tab stands for
set termguicolors                   " 14-bit RGB colors
set visualbell                      " use visual rather than audible bell
set wildmode=longest,full           " file name tab completion

filetype plugin indent on           " enable filetype detection for syntax and indent rules
autocmd BufNew,BufNewFile,BufRead *.md setlocal filetype=markdown " use markdown for *.md instead of modula2
autocmd BufNew,BufNewFile,BufRead *.json,*.jsonp setlocal filetype=json " use json for *.json
autocmd BufNew,BufNewFile,BufRead *.json.jbuilder setlocal filetype=ruby " use ruby for *.json.jbuilder

" use tab to switch to next tab
noremap <Tab> :tabn<CR>
" use shift-tab to switch to previous tab
noremap <S-Tab> :tabp<CR>

" allow the . to execute once for each line of a visual selection
vnoremap . :normal .<CR>

" jump to last known position after opening file if '" mark is set
:au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" disable strange json quote hiding
let g:vim_json_syntax_conceal = 0

" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()
" Default plugin directories for Neovim: stdpath('data').
Plug 'dense-analysis/ale'
Plug 'ishan9299/nvim-solarized-lua'
Plug 'junegunn/fzf'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
call plug#end()

colorscheme solarized
" Ale configuration
let g:ale_fixers = {
\ 'go': ['gofmt', 'goimports']
\}
let g:ale_fix_on_save = 1

" fzf configuration
nnoremap <silent><leader>s :FZF<CR>

" lualine configuration
lua << END
require('lualine').setup {
  options = { theme = 'solarized_dark' }
}
END

" Source nvim/init.vm file after saving changes
" http://vimcasts.org/episodes/updating-your-vimrc-file-on-the-fly/
if has("autocmd")
  autocmd bufwritepost $MYVIMRC source $MYVIMRC
endif

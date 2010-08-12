set nocompatible 		  " avoid crazy vi backwards compatibility stuff

filetype plugin indent on	  " enable filetype detection
syntax enable			  " enable syntax highlighting
set background=dark               " set dark background
set directory=$HOME/.vim/tmp//,.  " keep swap files in one location
set hidden			  " nicer multiple buffer handling
set ignorecase			  " case-insensitive searching
set laststatus=2		  " always display status line
set number			  " show line numbers
set nobackup			  " do not make a backup before overwriting a file
set nowritebackup		  " do not make a backup before overwriting a file
set ruler			  " show cursor position
set showcmd			  " display incomplete commands
set showmode			  " display the current mode
set smartcase			  " case-sensitive searching when expression contains capital letters
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P
set title			  " set terminal title
set visualbell			  " use visual rather than audible bell
set wildmenu 			  " command line tab completion
set wildmode=list:longest 	  " file name tab completion

hi clear
hi LineNr term=none ctermbg=none ctermfg=Grey
set runtimepath^=~/.vim runtimepath+=/.vim/after
let &packpath = &runtimepath

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
Plug 'folke/trouble.nvim'
Plug 'ishan9299/nvim-solarized-lua'
Plug 'junegunn/fzf'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-surround'
call plug#end()

" Ale configuration
let g:ale_fixers = {
\ 'go': ['gofmt', 'goimports']
\}
let g:ale_fix_on_save = 1

lua << EOF
vim.cmd.colorscheme("solarized")

-- options
vim.opt.backup = false        -- do not make a backup before overwriting a file
vim.opt.expandtab = true      -- expand tab to spaces in insert mode
vim.opt.hlsearch = false      -- don't highlight matches after search
vim.opt.ignorecase = true     -- case-insensitive searching
vim.opt.incsearch = true      -- incrementally highlight during search
vim.opt.laststatus = 2        -- always display status line
vim.opt.number = true         -- show line numbers
vim.opt.softtabstop = 2       -- number of spaces to insert for a tab
vim.opt.shiftwidth = 2        -- number of spaces used for each step in indentation
vim.opt.showcmd = true        -- display partial commands in bottom right
vim.opt.showmode = true       -- display the current mode
vim.opt.showtabline = 2       -- always display tab line
vim.opt.smartcase = true      -- case-sensitive searching when expression contains capital letters
vim.opt.smartindent = true    -- more clever auto-indenting behavior
vim.opt.swapfile = false      -- do not create swap files
vim.opt.tabstop = 2           -- number of spaces a tab stands for
vim.opt.termguicolors = true  -- 14-bit RGB colors
vim.opt.visualbell = true     -- use visual rather than audible bell
vim.opt.wrap = false          -- do not wrap lines
vim.opt.writebackup = false   -- do not make a backup before overwriting a file

-- leader
vim.g.mapleader = ' ' -- set space as leader

-- leader: s to initiate FZF
vim.keymap.set('n', '<leader>s', ':FZF<CR>')

-- leader: y to replace system clipboard or Y to append to it
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y')
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+Y')

-- leader: p to paste from system clipboard
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p')

-- remaps

-- execute . once for each line of a visual selection
vim.keymap.set('v', '.', ':normal .<CR>')

-- use J/K in visual mode to move selection up or down and reindent as needed
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- tab for next tab, shift-tab for previous tab
vim.keymap.set('n', '<Tab>', ":tabn<CR>")
vim.keymap.set('n', '<S-Tab>', ":tabp<CR>")

-- plugin configuration

require('gitsigns').setup()

vim.cmd [[highlight IndentBlanklineIndent1 guibg=#073642 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guibg=#002b36 gui=nocombine]]
require('indent_blankline').setup {
  char = "",
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
  },
  show_current_context = true,
  space_char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
  },
  show_trailing_blankline_indent = false,
  use_treesitter = true,
}

require('lualine').setup {
  options = { theme = 'solarized_dark' }
}

require('nvim-treesitter.configs').setup {
  auto_install = true, -- automatically install parsers for file types
  highlight = {
    enable = true -- use treesitter highlighting instead of vim regexes
  }
}

require("trouble").setup()
vim.keymap.set('n', '<leader>tt', '<cmd>TroubleToggle<cr>')
vim.keymap.set('n', '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<cr>')
vim.keymap.set('n', '<leader>td', '<cmd>TroubleToggle document_diagnostics<cr>')
vim.keymap.set('n', '<leader>tl', '<cmd>TroubleToggle loclist<cr>')
vim.keymap.set('n', '<leader>tq', '<cmd>TroubleToggle quickfix<cr>')
EOF

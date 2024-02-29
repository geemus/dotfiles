" jump to last known position after opening file if '" mark is set
:au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'tpope/vim-surround'

" lsp-zero: LSP Support
Plug 'neovim/nvim-lspconfig'                           " Required
Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'} " Optional
Plug 'williamboman/mason-lspconfig.nvim'               " Optional

" lsp-zero: Autocompletion
Plug 'hrsh7th/nvim-cmp'     " Required
Plug 'hrsh7th/cmp-nvim-lsp' " Required
Plug 'L3MON4D3/LuaSnip'     " Required

Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}
call plug#end()

" filetype configuration
augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.jbuilder set filetype=ruby
    au BufNewFile,BufRead *.mdx set filetype=markdown
augroup END

" Ale configuration
let g:ale_fixers = {
\ '*': ['remove_trailing_lines', 'trim_whitespace'],
\ 'eruby': ['erb-formatter'],
\ 'go': ['gofmt', 'goimports'],
\ 'terraform': ['terraform']
\}
let g:ale_fix_on_save = 1
let g:ale_linter_aliases = {
\  'eruby': ['eruby', 'text']
\}

lua << EOF
vim.cmd.colorscheme("solarized")

-- options
vim.opt.backup = false        -- do not make a backup before overwriting a file
vim.opt.expandtab = true      -- expand tab to spaces in insert mode
vim.opt.hlsearch = false      -- don't highlight matches after search
vim.opt.ignorecase = true     -- case-insensitive searching
vim.opt.incsearch = true      -- incrementally highlight during search
vim.opt.laststatus = 2        -- always display status line
vim.opt.mouse = ''            -- disable mouse
vim.opt.number = true         -- show line numbers
vim.opt.softtabstop = 2       -- number of spaces to insert for a tab
vim.opt.shiftwidth = 2        -- number of spaces used for each step in indentation
vim.opt.showcmd = true        -- display partial commands in bottom right
vim.opt.showmode = true       -- display the current mode
vim.opt.showtabline = 2       -- always display tab line
vim.opt.smartcase = true      -- case-sensitive searching when expression contains capital letters
vim.opt.smartindent = true    -- more clever auto-indenting behavior
vim.opt.spelllang = 'en_us'   -- use US English for spellcheck
vim.opt.spell = true          -- enable spell checking
vim.opt.swapfile = false      -- do not create swap files
vim.opt.tabstop = 2           -- number of spaces a tab stands for
vim.opt.termguicolors = true  -- 14-bit RGB colors
vim.opt.visualbell = true     -- use visual rather than audible bell
vim.opt.wrap = false          -- do not wrap lines
vim.opt.writebackup = false   -- do not make a backup before overwriting a file

-- disable arrow keys (and by extension touchpad in terminal emulators)
vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })

-- leader
vim.g.mapleader = ' ' -- set space as leader

-- leader: s to initiate FZF
vim.keymap.set('n', '<leader>s', ':Files<CR>')

-- leader: system clipboard commands
vim.keymap.set({'n', 'v'}, '<leader>d', '"+d')
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p')
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y')

-- leader: tc for close tab, tm for tab move, tn for new tab
vim.keymap.set('n', '<leader>tc', ':tabclose<cr>')
vim.keymap.set('n', '<leader>tm', ':tabmove<cr>')
vim.keymap.set('n', '<leader>tn', ':tabnew<cr>')

-- remaps

-- execute . once for each line of a visual selection
vim.keymap.set('v', '.', ':normal .<CR>')

-- use J/K in visual mode to move selection up or down and reindent as needed
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- move search results to center of screen
vim.keymap.set('n', '*', '*zz') -- next occurrence of current word
vim.keymap.set('n', '#', '#zz') -- previous occurrence of current word
vim.keymap.set('n', 'n', 'nzz') -- next searched term
vim.keymap.set('n', 'N', 'Nzz') -- previous searched term

-- split nav without ctrl-w prefix for simplicity and speed
vim.keymap.set({'n', 'v'}, '<C-H>', '<C-W><C-H>')
vim.keymap.set({'n', 'v'}, '<C-J>', '<C-W><C-J>')
vim.keymap.set({'n', 'v'}, '<C-K>', '<C-W><C-K>')
vim.keymap.set({'n', 'v'}, '<C-L>', '<C-W><C-L>')

-- tab for next tab, shift-tab for previous tab
vim.keymap.set('n', '<Tab>', ":tabn<CR>")
vim.keymap.set('n', '<S-Tab>', ":tabp<CR>")

-- plugin configuration

local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({select = true})
  }
})

require('gitsigns').setup()

local highlight = {
    "CursorColumn",
    "Whitespace",
}
require("ibl").setup {
    indent = { highlight = highlight, char = "" },
    whitespace = {
        highlight = highlight,
        remove_blankline_trail = false,
    },
    scope = { enabled = false },
}

local lsp = require('lsp-zero')
lsp.preset({
  name = 'recommended',
  manage_nvim_cmp = {
    set_extra_mappings = true
  }
})
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)
lsp.setup()

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

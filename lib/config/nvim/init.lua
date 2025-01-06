vim.loader.enable() -- compile lua to bytecode and cache

-- leader (before lazy.nvim to ensure mappings are correct)
vim.g.mapleader = ' ' -- set space as leader

-- bootstrap lazy.nvim if/when needed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins')

-- set colorscheme
vim.cmd.colorscheme("solarized")

-- add extra filetype mapping
vim.filetype.add({
  extension = {
    golden = "markdown",
    jbuilder = "ruby",
    mdx = "markdown",
  },
  pattern = {
    ['openapi.ya?ml'] = 'yaml.openapi',
    ['openapi.json'] = 'json.openapi',
  }
})

-- use lsp folding instead when supported, see :help lsp-core
-- TODO: awaiting not-yet-released features. See: https://github.com/neovim/neovim/pull/31311
--[[
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method('textDocument/foldingRange') then
      vim.wo.foldmethod = 'expr'
      vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
})
--]]

-- options
vim.opt.backup = false        -- do not make a backup before overwriting a file
vim.opt.conceallevel = 2      -- hide concealed text unless replacement is defined
vim.opt.expandtab = true      -- expand tab to spaces in insert mode
vim.opt.foldlevel = 99        -- start with everything open
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

-- leader: FZF commands
vim.keymap.set('n', '<leader>t', ':FzfLua files<CR>')
vim.keymap.set('n', '<leader>f', ':FzfLua grep_curbuf<CR>')
vim.keymap.set('n', '<leader><leader>f', ':FzfLua grep_project<CR>')

-- leader: luasnip commands
vim.keymap.set('i', '<C-s>', '<CMD>lua require("luasnip.extras.select_choice")()<CR>')
vim.keymap.set('n', '<C-s>', '<CMD>lua require("luasnip.extras.select_choice")()<CR>')

-- leader: system clipboard commands
vim.keymap.set({'n', 'v'}, '<leader>d', '"+d')
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p')
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y')

-- leader: tc for close tab, tm for tab move, tn for new tab
vim.keymap.set('n', '<leader><leader>tc', ':tabclose<cr>')
vim.keymap.set('n', '<leader><leader>tm', ':tabmove<cr>')
vim.keymap.set('n', '<leader><leader>tn', ':tabnew<cr>')

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

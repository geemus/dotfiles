return {
  { 'dense-analysis/ale',
    config = function()
      local g = vim.g
      g.ale_fix_on_save = 1
      g.ale_fixers = {
        ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
        eruby = { 'erb-formatter' },
        go = { 'gofmt', 'goimports' },
        terraform = { 'terraform' }
      }
      g.ale_linter_aliases = {
        eruby = { 'eruby', 'text' }
      }
    end,
    event = 'VeryLazy',
  },
  { 'ibhagwan/fzf-lua',
    event = 'VeryLazy',
  },
  { 'lewis6991/gitsigns.nvim' },
  { 'lukas-reineke/indent-blankline.nvim' },
  { 'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  { 'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    event = 'VeryLazy',
  },
  { 'williamboman/mason.nvim',
    event = 'VeryLazy',
  },
  { 'williamboman/mason-lspconfig.nvim',
    event = 'VeryLazy',
  },
  { 'VonHeikemen/lsp-zero.nvim',
    event = 'VeryLazy',
  },
  { 'neovim/nvim-lspconfig',
    event = 'VeryLazy',
  },
  { 'hrsh7th/nvim-cmp',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'quangnguyen30192/cmp-nvim-tags' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
    event = 'InsertEnter',
  },
  { 'ishan9299/nvim-solarized-lua',
    lazy = true
  },
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-context' },
    },
    event = 'VeryLazy',
  },
  { 'nvim-tree/nvim-web-devicons' },
  { 'stevearc/oil.nvim' },
  { 'davidgranstrom/scnvim',
    lazy = true
  },
  { 'folke/trouble.nvim',
    event = 'VeryLazy',
  },
  { 'tpope/vim-surround',
    event = 'VeryLazy',
  },
  { "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
}

-- Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

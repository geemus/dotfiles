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
  { 'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },
  { 'lukas-reineke/indent-blankline.nvim',
    config = function()
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
    end,
  },
  { 'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = { theme = 'solarized_dark' }
      }
    end,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'ishan9299/nvim-solarized-lua' },
    },
  },
  { 'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    event = 'VeryLazy',
  },
  { 'VonHeikemen/lsp-zero.nvim',
    config = function()
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
    end,
    event = 'VeryLazy',
  },
  { 'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim',
        config = function()
          require("mason").setup()
          require("mason-lspconfig").setup()
        end,
        dependencies = {
          { 'williamboman/mason-lspconfig.nvim' },
        },
      },
    },
    event = 'VeryLazy',
  },
  { 'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
      local cmp_action = require('lsp-zero').cmp_action()
      local cmp_format = require('lsp-zero').cmp_format({details = true})

      require("luasnip").add_snippets("supercollider", require("scnvim/utils").get_snippets())
      require('luasnip.loaders.from_lua').lazy_load({paths = "~/.config/nvim/LuaSnip/"})

      cmp.setup({
        sources = {
          {name = 'nvim_lsp'},
          {name = 'nvim_lua'},
          {name = 'luasnip'},
          {name = 'buffer'},
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({select = true}),
          ['<Tab>'] = cmp_action.luasnip_supertab(),
          ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        }),
        formatting = cmp_format, -- show source name
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = 'menu,menuone,noinsert' -- automatically select first item
        },
      })
    end,
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lua' },
      { 'quangnguyen30192/cmp-nvim-tags' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
    event = 'InsertEnter',
  },
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        auto_install = true, -- automatically install parsers for file types
        highlight = {
          enable = true -- use treesitter highlighting instead of vim regexes
        }
      }
    end,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-context' },
    },
    event = 'VeryLazy',
  },
  { 'nvim-tree/nvim-web-devicons' },
  { 'stevearc/oil.nvim',
    config = function()
      require('oil').setup()
      vim.keymap.set('n', '-', '<CMD>Oil --float<CR>', { desc = "Open parent directory with oil.nvim" })
    end,
  },
  { 'davidgranstrom/scnvim',
    config = function()
      local scnvim = require 'scnvim'
      local map = scnvim.map
      local map_expr = scnvim.map_expr
      scnvim.setup({
        keymaps = {
          ['<M-e>'] = map('editor.send_line', {'i', 'n'}),
          ['<C-e>'] = {
            map('editor.send_block', {'i', 'n'}),
            map('editor.send_selection', 'x'),
          },
          ['<CR>'] = map('postwin.toggle'),
          ['<M-CR>'] = map('postwin.toggle', 'i'),
          ['<M-L>'] = map('postwin.clear', {'n', 'i'}),
          ['<C-k>'] = map('signature.show', {'n', 'i'}),
          ['<F12>'] = map('sclang.hard_stop', {'n', 'x', 'i'}),
          ['<leader>st'] = map('sclang.start'),
          ['<leader>sk'] = map('sclang.recompile'),
          ['<F1>'] = map_expr('s.boot'),
          ['<F2>'] = map_expr('s.meter'),
        },
        editor = {
          highlight = {
            color = 'IncSearch',
          },
        },
        postwin = {
          float = {
            enabled = true,
          },
        },
      })
      vim.g.scnvim_snippet_format = "luasnip"
    end,
    ft = 'supercollider',
  },
  { 'folke/trouble.nvim',
    config = function()
      require("trouble").setup()
      vim.keymap.set('n', '<leader><leader>tt', '<cmd>Trouble diagnostics toggle<cr>')
      vim.keymap.set('n', '<leader><leader>tl', '<cmd>Trouble loclist toggle<cr>')
      vim.keymap.set('n', '<leader><leader>tq', '<cmd>Trouble qflist toggle<cr>')
    end,
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

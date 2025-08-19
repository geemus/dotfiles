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
        eruby = { 'eruby', 'text' } -- run vale on eruby
      }
    end,
    event = {
      "BufReadPre",
      "BufNewFile",
    },
  },
  { 'jghauser/follow-md-links.nvim',
    event = 'VeryLazy'
  },
  { 'ibhagwan/fzf-lua',
    config = function()
      require('fzf-lua').setup()
      require('fzf-lua').register_ui_select()
    end,
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
      { 'nvim-tree/nvim-web-devicons' }
    },
  },
  { 'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    event = 'VeryLazy',
  },
  { 'echasnovski/mini.surround',
    config = function()
      require('mini.surround').setup()
    end,
    event = 'VeryLazy',
    version = '*',
  },
  {
    'gsuuon/model.nvim',
    cmd = { 'M', 'Model', 'Mchat' },
    config = function()
      require('model').setup({
        default_prompt = require('model.prompts.starters')['anthropic:claude-code'],
      })
    end,
    event = 'VeryLazy',
    init = function()
      vim.filetype.add({
        extension = {
          mchat = 'mchat',
        }
      })
    end,
    ft = 'mchat',
    keys = {
      {'<C-m>d', ':Mdelete<cr>', mode = 'n'},
      {'<C-m>s', ':Mselect<cr>', mode = 'n'},
      {'<C-m><space>', ':Mchat<cr>', mode = 'n' }
    },
  },
  { 'neovim/nvim-lspconfig',
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    dependencies = {
      { 'williamboman/mason.nvim' },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    init = function()
      -- reserve a space in gutter to avoid layout shift
      vim.opt.signcolumn = 'yes'
    end,
    config = function()
      local lsp_defaults = require('lspconfig').util.default_config

      -- Add cmp_nvim_lsp capabilities settings to lspconfig
      -- This should be executed before you configure any language server
      lsp_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      require("mason").setup({})
      require("mason-tool-installer").setup({
        ensure_installed = {
          "bash-language-server", -- bash: language server
          "dockerfile-language-server", -- dockerfile: language server
          "golangci-lint", -- go: lint
          "gopls", -- go: language server
          "hadolint", -- dockerfile: lint
          "luacheck", -- lua: lint and static analysis
          "lua-language-server", -- lua: language server
          "rubocop", -- ruby: lint
          "shellcheck", -- sh: lint
          "tailwindcss-language-server", -- tailwind css: language server
          "vacuum", -- openapi: lint
          "vale", -- prose: lint
        },
      })
      require("mason-lspconfig").setup({
        handlers = {
          -- default for anything without a custom handler
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
        }
      })
    end,
  },
  { 'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')
      local luasnip = require("luasnip")

      -- require("luasnip").add_snippets("supercollider", require("scnvim/utils").get_snippets())
      require('luasnip.loaders.from_lua').lazy_load({paths = "~/.config/nvim/LuaSnip/"})

      cmp.setup({
        sources = {
          {name = 'nvim_lsp'},
          {name = 'nvim_lua'},
          {name = 'luasnip'},
          {name = 'buffer'},
        },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                  if luasnip.expandable() then
                      luasnip.expand()
                  else
                      cmp.confirm({
                          select = true,
                      })
                  end
              else
                  fallback()
              end
          end),

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
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
  { 'ishan9299/nvim-solarized-lua',
    config = function()
      vim.cmd.colorscheme 'solarized'
    end,
    lazy = false,
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
      vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.opt.foldmethod = 'expr'
    end,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-context' },
    },
    event = 'VeryLazy',
  },
  { 'nvim-tree/nvim-web-devicons' },
  { 'epwalsh/obsidian.nvim',
    version = "*",
    lazy = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "ishan9299/nvim-solarized-lua" },
    },
    event = {
      "BufReadPre " .. vim.fn.expand "~" .. "/Documents/obsidian-remote/*.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/Documents/obsidian-remote/*.md",
    },
    opts = {
      daily_notes = {
        folder = "Daily",
        date_format = "%Y/%m-%b/%Y-%m-%d-%a",
        default_tags = {},
        template = "daily.md",
      },
      follow_url_func = function(url)
        vim.ui.open(url)
      end,
      -- Optional, alternatively you can customize the frontmatter data.
      ---@return table
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        -- Set created to birthtime for existing files or now for new files
        local created = os.time()
        if note.path ~= nil and note.path:is_file() then
          local stat = note.path:stat()
          created = stat['birthtime']['sec']
        end

        local out = {
          id = note.id,
          aliases = note.aliases,
          created = os.date("%Y-%m-%d %H:%M", created),
          date = os.date("%Y-%m-%d", created),
          tags = note.tags
        }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,
      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        local note_id = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          note_id = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 6 random uppercase letters to the suffix.
          for _ = 1, 6 do
            note_id = note_id .. string.char(math.random(65, 90))
          end
        end
        return note_id
      end,
      picker = {
        name = "fzf-lua",
      },
      templates = {
        folder = "Templates",
      },
      ui = {
        checkboxes = {
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
        },
      },
      workspaces = {
        {
          name = "remote",
          path = "~/Documents/obsidian-remote",
        },
      }
    }
  },
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
            enabled = false,
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

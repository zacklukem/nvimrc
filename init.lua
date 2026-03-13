require("config.lazy")

----------------------
-- General Settings --
----------------------

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "80"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.winborder = "rounded"

-------------
-- Plugins --
-------------

require("lazy").setup({
  spec = {
    -- gruvbox.nvim
    {
      "ellisonleao/gruvbox.nvim",
      priority = 1000,
      config = true,
      opts = {
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          emphasis = false,
          comments = false,
          operators = false,
          folds = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        inverse = true,
        contrast = "hard",
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = true,
      },
    },

    -- auto-save.nvim
    {
      "okuuva/auto-save.nvim",
      event = { "InsertLeave", "TextChanged" },
      opts = {
        debounce_delay = 2000, -- save 2s after last change
      },
    },

    -- nvim-surround
    {
      "kylechui/nvim-surround",
      version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({})
      end,
    },

    -- barbar.nvim
    {
      'romgrk/barbar.nvim',
      dependencies = {
        'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {},
      version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },

    -- telescope.nvim
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8',
      dependencies = {
        'nvim-lua/plenary.nvim',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      },
      opts = {
        extensions = {
          file_browser = {
            -- theme = "ivy",
          },
        },
        defaults = {
          preview = {
            treesitter = false,
          },
        },
      },
    },

    -- blink.cmp
    {
      'saghen/blink.cmp',
      version = '1.*',
      opts = {
        fuzzy = {
          prebuilt_binaries = {
            download = true, -- explicitly enable binary download
          },
        },
        completion = {
          menu = {
            auto_show = true,
            border = "rounded",
            winhighlight =
            "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
          },
          documentation = {
            auto_show = true,
            window = {
              border = "rounded",
            },
          },
        },
      },
    },

    {
      "neovim/nvim-lspconfig",
      lazy = false,
    },

    {
      "nvim-tree/nvim-tree.lua",
      opts = {},
    },

    -- codediff.nvim
    {
      "esmuellert/codediff.nvim",
      cmd = "CodeDiff",
    },

    -- nvim-autopairs
    {
      'windwp/nvim-autopairs',
      event = "InsertEnter",
      config = true
    },

    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        {
          'mrcjkb/rustaceanvim',
          version = '^8',
          lazy = false,
        }
      },
      config = function()
        require('neotest').setup({
          adapters = {
            require('rustaceanvim.neotest')
          },
        })
      end,
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "gruvbox" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})

--------------------------
-- Post-plugin Settings --
--------------------------

-- LSP
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('sourcekit')

vim.cmd("colorscheme gruvbox")

---------------------
-- Keymap settings --
---------------------

-- TELESCOPE

local builtin = require("telescope.builtin")
local telescope = require("telescope")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- TAB MOVEMENT

vim.keymap.set("n", "gt", '<Cmd>BufferNext<CR>', {})
vim.keymap.set("n", "gT", '<Cmd>BufferPrevious<CR>', {})

for i = 1, 9 do
  vim.keymap.set("n", "g" .. i, '<Cmd>BufferGoto ' .. i .. '<CR>', {})
end

-- TAB MANIPULATION

vim.keymap.set("n", "<leader>w", '<Cmd>BufferClose<CR>', {})

-- WINDOW MOVEMENT

vim.keymap.set("t", "<C-x>", [[<C-\><C-n>]], {})

for _, dir in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set({ "n", "t" }, "<C-" .. dir .. ">", "<Cmd>wincmd " .. dir .. "<CR>", {})
end

-- TREE

vim.keymap.set("n", "<leader>bb", '<Cmd>NvimTreeToggle<CR>', {})
vim.keymap.set("n", "<leader>bf", '<Cmd>NvimTreeFindFile<CR>', {})

-- GIT

vim.keymap.set("n", "<leader>gg", '<Cmd>CodeDiff<CR>', {})

-- LSP

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local map = function(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    local telescope = require("telescope.builtin")

    -- Navigation
    map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
    map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("n", "gr", telescope.lsp_references, "Goto References")
    map("n", "gi", telescope.lsp_implementations, "Goto Implementation")
    -- map("n", "gt", telescope.lsp_type_definitions, "Goto Type Definition")

    -- Diagnostics
    map("n", "<leader>d", vim.diagnostic.open_float, "Show Diagnostic")
    map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
    map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
    map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostic List")

    -- Actions
    map("n", "<F2>", vim.lsp.buf.rename, "Rename")
    map("n", "<C-.>", vim.lsp.buf.code_action, "Code Action")
    map("i", "<C-.>", vim.lsp.buf.code_action, "Code Action")
    map("n", "<leader>fm", vim.lsp.buf.format, "Format")

    -- Hover / Signature
    map("n", "K", vim.lsp.buf.hover, "Hover Docs")
    map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")

    -- Workspace
    map("n", "<leader>ws", telescope.lsp_workspace_symbols, "Workspace Symbols")
    map("n", "<leader>ds", telescope.lsp_document_symbols, "Document Symbols")
  end,
})

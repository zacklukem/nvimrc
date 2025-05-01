require("config.lazy")

----------------------
-- General Settings --
----------------------

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "80"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

    -- nvim-surround
    {
      "kylechui/nvim-surround",
      version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({})
      end,
    },

    -- blink.cmp
    {
      'saghen/blink.cmp',
      dependencies = { 'rafamadriz/friendly-snippets' },
      version = '1.*',
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        keymap = { preset = 'super-tab' },
        appearance = { nerd_font_variant = 'normal' },
        completion = { documentation = { auto_show = false } },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },

    -- copilot.lua
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "InsertEnter",
      config = function()
        require("copilot").setup({
          suggestion = {
            auto_trigger = true,
            keymap = {
              accept = "<Tab>",
            },
          },
        })
      end,
    },

    -- barbar.nvim
    {
      'romgrk/barbar.nvim',
      dependencies = {
        'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
      },
      init = function() vim.g.barbar_auto_setup = false end,
      opts = {},
      version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },

    -- telescope-file-browser.nvim
    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },

    -- telescope.nvim
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' },
      opts = {
        extensions = {
          file_browser = {
            -- theme = "ivy",
          },
        },
      },
    },

    -- toggleterm.nvim
    {'akinsho/toggleterm.nvim', version = "*", opts = {}}
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "gruvbox" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

--------------------------
-- Post-plugin Settings --
--------------------------

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.b.copilot_suggestion_hidden = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})

vim.cmd("colorscheme gruvbox")

---------------------
-- Keymap settings --
---------------------

-- TELESCOPE

local builtin = require("telescope.builtin")
local telescope = require("telescope")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
-- vim.keymap.set("n", "<leader>ff", telescope.extensions.file_browser.file_browser, {})
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

-- TERMINAL

vim.keymap.set({ "n", "t" }, "<C-`>", '<Cmd>ToggleTerm<CR>', {})


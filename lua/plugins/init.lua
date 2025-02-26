return {
  -- Theme
  { "folke/tokyonight.nvim", lazy = false, priority = 1000, config = function()
    vim.cmd("colorscheme tokyonight")
  end },

  -- File Icons
  { "nvim-tree/nvim-web-devicons" },

  -- File Explorer
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
    require("nvim-tree").setup()
  end },

  -- Status Line
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
    require("lualine").setup()
  end },

  -- Git Integration
  { "lewis6991/gitsigns.nvim", config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true, -- Show inline blame
    })
  end },

  { "tpope/vim-fugitive" }, -- Git commands like :Git, :Gdiff, :Gblame, etc.

  -- LSP & Autocomplete
  { "neovim/nvim-lspconfig", config = function()
    local lspconfig = require("lspconfig")

    -- Set diagnostic icons
    local signs = { Error = "", Warn = "", Hint = "", Info = "" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    -- Enable TypeScript & React LSP (use ts_ls instead of tsserver)
    lspconfig.ts_ls.setup({
      filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
      root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    })

    -- Enable ESLint
    lspconfig.eslint.setup({
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
    })
  end },

  -- Autocomplete
  { "hrsh7th/nvim-cmp", dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim" -- Icons for autocomplete
    }, config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text", -- Show text + icon
            maxwidth = 50,
            ellipsis_char = "...",
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
  end },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        user_default_options = { names = false },
      })
    end,
  },
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2,
      })
    end,
  },
    {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Adds file icons
    config = function()
      require("bufferline").setup({
        options = {
          numbers = "ordinal", -- Show buffer numbers
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = false,
          show_close_icon = false,
          separator_style = "slant",
        },
      })
    end,
  },

  -- Keybindings for cycling through buffers
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.api.nvim_set_keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>q", ":bd<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>q1", ":%bd|e#|bd#<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>qa", ":bufdo bd<CR>", { noremap = true, silent = true })

    end,
  },
}


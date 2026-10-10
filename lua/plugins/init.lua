return {
  -- Theme
  { "Mofiqul/vscode.nvim", lazy = false, priority = 1000, config = function()
    require("vscode").setup({
      style = "dark",
      transparent = false,
      italic_comments = false,
      terminal_colors = true,
      disable_nvimtree_bg = true,
    })
    vim.cmd.colorscheme("vscode")
  end },

  -- File Icons
  { "nvim-tree/nvim-web-devicons" },

  -- VS Code-like breadcrumbs and symbol outline
  {
    "utilyre/barbecue.nvim",
    version = "2.*",
    dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("barbecue").setup({
        show_dirname = true,
        show_basename = true,
        show_modified = true,
        attach = true,
      })
    end,
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = { highlight = true, depth = 5, separator = "  ›  " },
  },
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialOpen", "AerialNavToggle" },
    keys = {
      { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "Toggle symbol outline" },
      { "<leader>O", "<cmd>Telescope aerial<CR>", desc = "Search document symbols" },
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = { min_width = 28, default_direction = "right", placement = "edge" },
      show_guides = true,
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    config = function(_, opts)
      require("aerial").setup(opts)
      require("telescope").load_extension("aerial")
    end,
  },

  -- File Explorer
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
    require("nvim-tree").setup({
      view = { width = 30, side = "left", preserve_window_proportions = true },
      renderer = { highlight_git = "name", indent_markers = { enable = true } },
      git = { enable = true },
    })
  end },

  -- Status Line
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
    require("lualine").setup({
      options = {
        theme = "vscode",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype", "encoding", "fileformat" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
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

  -- Git Diff Viewer
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { noremap = true, silent = true, desc = "Git Diff" })
      vim.keymap.set("n", "<leader>gx", ":DiffviewClose<CR>", { noremap = true, silent = true, desc = "Close Git Diff" })
    end,
  },

  -- LSP & Autocomplete
  { "neovim/nvim-lspconfig", config = function()
      local lspconfig = require("lspconfig")

      local navic = require("nvim-navic")
      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
      end

      -- Set diagnostic icons
      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Enable TypeScript & React LSP (use ts_ls instead of tsserver)
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
      })

      -- Enable ESLint
      lspconfig.eslint.setup({
        on_attach = on_attach,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
    })

    -- Enable Python LSP (Pyright)
    lspconfig.pyright.setup({
      on_attach = on_attach,
      filetypes = { "python" },
      root_dir = lspconfig.util.root_pattern(".git", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt"),
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",  -- Change to "strict" for more checks
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
          }
        }
      }
    })
  end 
},

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
          mode = "buffers",
          numbers = "ordinal", -- Show buffer numbers
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = false,
          show_close_icon = false,
          separator_style = "slant",
          always_show_bufferline = true,
          offsets = {
            { filetype = "NvimTree", text = "", padding = 1 },
          },
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

  -- 1. Which-Key (Keybinding popup cheat sheet)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  -- 2. Treesitter (Better Highlighting & Code Comprehension)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "python", "html", "css" },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Indentation and scope guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, char = "│" },
      exclude = {
        filetypes = { "help", "NvimTree" },
      },
    },
  },

  -- 3. Nvim-Surround (Add/change/delete surrounding characters)
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  -- 4. Conform.nvim (Painless Code Formatting)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fm",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- 5. Flash.nvim (Instant File Navigation)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    },
  },
}

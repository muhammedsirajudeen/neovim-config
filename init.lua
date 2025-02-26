-- Set leader key
vim.g.mapleader = " "

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)
-- Load plugins
require("lazy").setup("plugins")
require("lspconfig").tailwindcss.setup{}

-- Basic settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.opt.background = "dark"
vim.cmd("highlight Normal guibg=black")
vim.cmd("highlight NonText guibg=black")
vim.cmd("highlight NvimTreeNormal guibg=black")
vim.cmd("highlight NvimTreeEndOfBuffer guibg=black")

--my function definition
local function goto_source()
  require("telescope.builtin").find_files()
end
vim.keymap.set("n", "fs", goto_source, { noremap = true, silent = true })

-- Insert date time
local function date_time_insert()
  local date = os.date("%Y-%m-%d")
  vim.api.nvim_put({date},"",true,true)
end

vim.keymap.set("!","~!",date_time_insert,{noremap=true,silent=true})


vim.keymap.set("n", "gs", function()
  require("telescope.builtin").lsp_definitions()
end, { noremap = true, silent = true })

-- These are all custom keybindings 
vim.api.nvim_set_keymap('n', '<leader>cs', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', ':Telescope help_tags<CR>', { noremap = true, silent = true })

local popup_win = nil
local popup_buf = nil

function ClosePopup()
    if popup_win then
        vim.api.nvim_win_close(popup_win, true)
        popup_win = nil
        popup_buf = nil
    end
end
 
function ShowPopup()
    if popup_win then return end

    popup_buf = vim.api.nvim_create_buf(false, true)
    local width = 50
    local height = 10
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = 'minimal',
        border = 'rounded',
    }

    popup_win = vim.api.nvim_open_win(popup_buf, true, opts)

    -- Define your keybindings for display
    local keybindings = {
        "Keybinding Reference:",
        "----------------------",
        "<leader>cs -> Search Text (Telescope live_grep)",
        "<leader>fb -> Open Buffers (Telescope)",
        "<leader>fh -> Help Tags (Telescope)",
        "fs -> Find Files (Telescope)",
        "gs -> Go to LSP Definition",
        "~! -> Insert Current Date",
        "<leader>h -> Show This Popup",
        "<Tab>  ->  Move to next tab",
        "<S-Tab> Move to prev tab",
        "<leader>q -> Close Current Tab ",
        "<leader>q1  -> Close All Tabs except current",
        "<leader>qa  -> Close all Tabs",
        "<leader>e   -> Open File Explorer",
        "<leader>qf  ->  Close File Explorer",
        "",
        "[ Press ENTER to Close ]"
    }

    vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, keybindings)

    -- Set background color to black
    vim.api.nvim_win_set_option(popup_win, "winhl", "Normal:PopupBackground")

    -- Define the highlight group
    vim.cmd("highlight PopupBackground guibg=#000000 guifg=#FFFFFF")

    -- Map <Enter> key inside the floating window to close it
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<CR>', ':lua ClosePopup()<CR>', { noremap = true, silent = true })
end

vim.api.nvim_set_keymap('n', '<leader>h', ':lua ShowPopup()<CR>', { noremap = true, silent = true })
-- custom key binding to show focus on to the file explorer
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>qf", ":NvimTreeClose<CR>", { noremap = true, silent = true })




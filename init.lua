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
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
-- Use an editor-style blinking caret instead of the default block cursor.
vim.opt.guicursor = {
  "n-v-c:block-blinkwait700-blinkon400-blinkoff250",
  "i-ci-ve:ver25-blinkwait700-blinkon400-blinkoff250",
  "r-cr:hor20-blinkwait700-blinkon400-blinkoff250",
  "o:hor50",
  "a:blinkwait700-blinkon400-blinkoff250",
}

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
    
    local width = 60
    local height = 21
    local opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        style = 'minimal',
        border = 'rounded',
        title = ' ⌨️  Keybinding Reference ',
        title_pos = 'center',
    }

    popup_win = vim.api.nvim_open_win(popup_buf, true, opts)

    -- Define keybindings (key, description)
    local kb_data = {
        {"<leader>cs", "Search Text (Telescope)"},
        {"<leader>fb", "Open Buffers (Telescope)"},
        {"<leader>fh", "Help Tags (Telescope)"},
        {"fs", "Find Files (Telescope)"},
        {"gs", "Go to LSP Definition"},
        {"~!", "Insert Current Date"},
        {"<leader>h", "Show This Popup"},
        {"<Tab>", "Move to next tab"},
        {"<S-Tab>", "Move to prev tab"},
        {"<leader>q", "Close Current Tab "},
        {"<leader>q1", "Close All Tabs except current"},
        {"<leader>qa", "Close all Tabs"},
        {"<leader>e", "Open File Explorer"},
        {"<leader>qf", "Close File Explorer"},
        {"<leader>gd", "Open Git Diff"},
        {"<leader>gx", "Close Git Diff"},
    }

    local lines = { "" }
    local highlight_ranges = {}

    for i, item in ipairs(kb_data) do
        local key_str = item[1]
        local desc = item[2]
        
        -- Format columns
        local line_text = string.format("   %-16s │  %s", key_str, desc)
        table.insert(lines, line_text)
        
        -- Save highlight range for the key (1-based line index in API, but our lines table will be 0-based in buffer)
        -- i starts at 1, lines[1] is empty, so line index in buffer will be i
        table.insert(highlight_ranges, {line = i, start_col = 3, end_col = 3 + string.len(key_str)})
    end

    table.insert(lines, "")
    table.insert(lines, "   [ Press ENTER, q, or ESC to Close ]")

    vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, lines)

    -- Set modern GUI-like colors
    vim.cmd("highlight PopupBackground guibg=#1e1e2e guifg=#cdd6f4")
    vim.cmd("highlight PopupKey guifg=#89b4fa gui=bold")
    vim.cmd("highlight PopupBorder guifg=#89b4fa guibg=#1e1e2e")
    vim.cmd("highlight PopupTitle guifg=#a6e3a1 guibg=#1e1e2e gui=bold")

    vim.api.nvim_win_set_option(popup_win, "winhl", "Normal:PopupBackground,FloatBorder:PopupBorder,FloatTitle:PopupTitle")

    -- Apply highlights to keys
    local ns_id = vim.api.nvim_create_namespace("popup_keys")
    for _, range in ipairs(highlight_ranges) do
        vim.api.nvim_buf_add_highlight(popup_buf, ns_id, "PopupKey", range.line, range.start_col, range.end_col)
    end

    -- Map keys to close the floating window
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<CR>', ':lua ClosePopup()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', 'q', ':lua ClosePopup()<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(popup_buf, 'n', '<Esc>', ':lua ClosePopup()<CR>', { noremap = true, silent = true })
end

vim.api.nvim_set_keymap('n', '<leader>h', ':lua ShowPopup()<CR>', { noremap = true, silent = true })
-- custom key binding to show focus on to the file explorer
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>qf", ":NvimTreeClose<CR>", { noremap = true, silent = true })




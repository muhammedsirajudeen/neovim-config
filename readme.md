# Neovim Configuration

This is my personal Neovim configuration, optimized for speed, usability, and productivity. It includes a modular setup with lazy-loading plugins and a structured directory for easy customization.

## 📁 Directory Structure

```
📦 nvim
├── 📜 init.lua          # Main entry point for Neovim configuration
├── 📜 lazy-lock.json    # Lockfile for lazy.nvim package manager
└── 📂 lua/              # Custom Lua configuration files
    └── 📂 plugins/      # Plugin definitions and lazy.nvim setup
        ├── 📜 init.lua  # Plugin management
```

## 🚀 Features
- **Lazy-loaded Plugins**: Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for optimal performance.
- **Optimized Keybindings**: Custom mappings for efficiency.
- **Minimal & Clean Setup**: Simple structure with essential configurations.

## 🛠️ Installation

### **1️⃣ Prerequisites**
Ensure you have the following installed:
- **Neovim** (>= 0.9)
- **Git**
- **Node.js** (for LSPs & Treesitter)
- **Python** (for certain plugins)
- **ripgrep & fd** (for telescope.nvim)

### **2️⃣ Clone the Repo**
```sh
git clone https://github.com/yourusername/nvim ~/.config/nvim
```

### **3️⃣ Start Neovim & Install Plugins**
Open Neovim and run:
```sh
nvim
```
Lazy.nvim will automatically install the required plugins.

## 📌 Keybindings
| Keybinding | Action |
|------------|--------|
| `<leader>ff` | Find files with Telescope |
| `<leader>fg` | Live grep |
| `<leader>fb` | Show buffers |
| `<leader>q`  | Close buffer |
| `<leader>e`  | Open file explorer (nvim-tree) |

## 🎯 Customization
Modify `lua/plugins/init.lua` to tweak settings or add new plugins.

## 📜 License
This configuration is open-source under the MIT License.

---
Made with ❤️ using Neovim & Lua.



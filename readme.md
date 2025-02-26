
---

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
- **Smooth Workflow**: Integrated with **tmux** and optimized for **Alacritty**.

## 🛠️ Installation

### **1️⃣ Prerequisites**
Ensure you have the following installed:
- **Neovim** (>= 0.9)
- **Git**
- **Node.js** (for LSPs & Treesitter)
- **Python** (for certain plugins)
- **ripgrep & fd** (for telescope.nvim)
- **tmux** (for better window management)
- **Alacritty** (for a fast terminal experience)
- **Nerd Font** (for icons)

### **2️⃣ Install a Nerd Font (Required for Icons)**
Run:
```sh
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip FiraCode.zip
rm FiraCode.zip
fc-cache -fv
```
Then, set the font in **Alacritty** (`~/.config/alacritty/alacritty.yml`):
```yaml
font:
  normal:
    family: "FiraCode Nerd Font"
    style: Regular
  bold:
    family: "FiraCode Nerd Font"
    style: Bold
  italic:
    family: "FiraCode Nerd Font"
    style: Italic
  size: 12
```

### **3️⃣ Clone the Repo**
```sh
git clone https://github.com/yourusername/nvim ~/.config/nvim
```

### **4️⃣ Start Neovim & Install Plugins**
Open Neovim and run:
```sh
nvim
```
Lazy.nvim will automatically install the required plugins.

## 📌 Keybindings
| Keybinding  | Action |
|-------------|--------|
| `<leader>ff` | Find files with Telescope |
| `<leader>fg` | Live grep |
| `<leader>fb` | Show buffers |
| `<leader>q`  | Close buffer |
| `<leader>e`  | Open file explorer (nvim-tree) |
| `<C-h>, <C-l>` | Move between splits (tmux + Neovim) |

## 🎯 Customization
Modify `lua/plugins/init.lua` to tweak settings or add new plugins.

## 📜 License
This configuration is open-source under the MIT License.

---
Made with ❤️ using Neovim, Alacritty, and tmux.

---

This ensures everything is properly documented for a **smooth Neovim workflow**! 🚀 Let me know if you need any changes.

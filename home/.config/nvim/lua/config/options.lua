-- leader must be set before lazy.nvim loads any plugin
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- ui
opt.number = true
opt.cursorline = true
opt.showmatch = true
opt.signcolumn = "yes"
opt.colorcolumn = "80"
opt.termguicolors = true
opt.mouse = "a"

-- search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"

-- indentation (2 spaces by default; see autocmds for per-language overrides)
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- behavior
opt.clipboard = "unnamedplus" -- share with the macOS clipboard
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.autoread = true
opt.hidden = true
opt.infercase = true
opt.updatetime = 300
opt.wrap = true
opt.splitright = true
opt.splitbelow = true

-- folding
opt.foldmethod = "indent"
opt.foldlevel = 99

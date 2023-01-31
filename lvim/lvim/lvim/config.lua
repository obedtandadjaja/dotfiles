-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.colorscheme = "tokyonight"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

vim.opt.number = true
vim.opt.showcmd = true
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.lazyredraw = true
vim.opt.mouse = "nicr"
vim.opt.termguicolors = true

-- Reload file when it changes on disk
vim.opt.autoread = true

-- Setting column to 80 characters
vim.opt.colorcolumn = "80"

-- Wildmenu - shows list in cmd
vim.opt.wildmenu = true

-- Set clipboard to be system wide
vim.opt.clipboard = "unnamed"

-- Vim history
vim.opt.history = 500

-- Smarter completion by infering the case
vim.opt.infercase = true

-- Search
vim.opt.ignorecase = true -- ignore case
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = true -- highlight matches
vim.opt.inccommand = "nosplit"

-- Backspace
vim.opt.backspace = "eol,start,indent"

-- Always show status line
vim.opt.laststatus = 2

vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#330000" })

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

lvim.builtin.which_key.mappings["w"] = {
  name = "Window",
  j = { "<C-w>j", "Pan to Window Down" },
  k = { "<C-w>k", "Pan to Window Up" },
  h = { "<C-w>h", "Pan to Window Left" },
  l = { "<C-w>l", "Pan to Window Right" },
  ["/"] = { "<C-w>v", "Split Window Half Vertical" },
  ["-"] = { "<C-w>s", "Split Window Half Horizontal" },
  ["="] = { "<C-w>=", "Split Window Equal" },
}

lvim.builtin.which_key.mappings["/"] = { "<cmd>Telescope live_grep<cr>", "Find Text" }

-- Project
lvim.builtin.which_key.mappings["pf"] = { function()
  require("lvim.core.telescope.custom-finders").find_project_files { previewer = false }
end, "Explore Files" }
lvim.builtin.which_key.mappings["pt"] = { "<cmd>NvimTreeToggle<CR>", "Toggle Tree" }

-- Buffers
lvim.builtin.which_key.mappings["bl"] = { "<cmd>BufferLineCycleNext<cr>", "Next" }
lvim.builtin.which_key.mappings["bh"] = { "<cmd>BufferLineCyclePrev<cr>", "Previous" }

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

lvim.plugins = {
  { "tpope/vim-abolish" },
  { "terryma/vim-multiple-cursors" },
}

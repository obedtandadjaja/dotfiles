return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>pt", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    { "<leader>fT", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in tree" },
  },
  opts = {
    filters = { custom = { "^\\.DS_Store$" } },
    renderer = { icons = { show = { git = false } } },
    actions = {
      open_file = {
        window_picker = {
          chars = "123456789",
        },
      },
    },
  },
}

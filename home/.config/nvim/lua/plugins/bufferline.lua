return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "BufReadPre",
  keys = {
    { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      offsets = {
        { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", separator = true },
      },
    },
  },
}

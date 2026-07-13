return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  keys = {
    { "<leader>tr", "<cmd>Trouble lsp_references toggle<cr>", desc = "References" },
    { "<leader>tf", "<cmd>Trouble lsp_definitions toggle<cr>", desc = "Definitions" },
    { "<leader>td", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
    { "<leader>tw", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace diagnostics" },
    { "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
    { "<leader>tl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
  },
  opts = {},
}

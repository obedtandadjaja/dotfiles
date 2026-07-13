return {
  "NeogitOrg/neogit",
  dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
  cmd = "Neogit",
  keys = {
    { "<leader>g", function() require("neogit").open() end, desc = "Neogit" },
  },
}

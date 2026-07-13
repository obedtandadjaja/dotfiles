return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>pr", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
    { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  },
  config = function()
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- <CR> opens every multi-selected (Tab-marked) file, not just the
    -- focused one
    local open_marked = function(prompt_bufnr)
      local picker = action_state.get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      actions.select_default(prompt_bufnr)
      for _, entry in pairs(multi) do
        if entry.path ~= nil then
          vim.cmd.edit(entry.path)
        end
      end
    end

    require("telescope").setup({
      defaults = {
        path_display = { "truncate" },
        file_ignore_patterns = { "%.git/" },
        mappings = {
          i = { ["<CR>"] = open_marked },
          n = { ["<CR>"] = open_marked },
        },
      },
      pickers = {
        find_files = { hidden = true },
        buffers = { sort_mru = true },
      },
    })
  end,
}

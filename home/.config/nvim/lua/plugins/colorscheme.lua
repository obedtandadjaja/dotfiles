return {
  "rose-pine/neovim",
  lazy = false,
  priority = 1000,
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      dark_variant = "moon",
      dim_inactive_windows = false,
      extend_background_behind_borders = false,
      styles = {
        italic = false,
        transparency = vim.uv.os_uname().sysname == "Darwin",
      },
    })

    vim.cmd.colorscheme("rose-pine")
  end,
}

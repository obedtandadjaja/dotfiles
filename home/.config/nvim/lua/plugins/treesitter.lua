return {
  "nvim-treesitter/nvim-treesitter",
  -- "main" is upstream's incompatible rewrite; the old configs.lua API
  -- (ensure_installed/highlight.enable/indent.enable) only exists on the
  -- now-legacy "master" branch. Pinned explicitly so a future default
  -- branch change upstream can't silently break this again.
  branch = "main",
  build = ":TSUpdate",
  lazy = false, -- the rewrite dropped support for lazy-loading
  config = function()
    require("nvim-treesitter").install({
      "bash",
      "c",
      "css",
      "go",
      "java",
      "javascript",
      "json",
      "latex",
      "lua",
      "markdown",
      "markdown_inline",
      "nix",
      "python",
      "rust",
      "tsx",
      "typescript",
      "vimdoc",
      "yaml",
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}

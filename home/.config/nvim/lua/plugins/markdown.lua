return {
  -- render headings, lists, tables, checkboxes, code blocks etc. in-buffer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  -- render images inline; kitty protocol, which Ghostty implements
  {
    "3rd/image.nvim",
    build = false,
    opts = {
      backend = "kitty",
      processor = "magick_cli",
    },
  },
  -- render mermaid code blocks in markdown as diagrams via image.nvim
  -- (needs `mmdc` from mermaid-cli, see home.nix)
  {
    "3rd/diagram.nvim",
    ft = "markdown",
    dependencies = { "3rd/image.nvim" },
    opts = {},
  },
}

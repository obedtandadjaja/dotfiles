return {
  -- LaTeX editing: syntax, compilation via latexmk, forward search into Skim.
  {
    "lervag/vimtex",
    lazy = false, -- vimtex manages its own lazy-loading internally
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_quickfix_mode = 0 -- don't steal focus into the quickfix list on warnings
    end,
  },
}

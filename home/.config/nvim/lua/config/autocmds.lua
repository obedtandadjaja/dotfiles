local autocmd = vim.api.nvim_create_autocmd

-- `autoread` (see options.lua) only takes effect where Vim already checks
-- for file changes; it doesn't add new checkpoints. This is what actually
-- picks up edits made outside nvim (an agent, another process) by running
-- `:checktime` on focus/buffer-enter/idle. Skipped inside the cmdline
-- window, where `:checktime` is disallowed and would error.
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- float diagnostics under the cursor after `updatetime` of idle
autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
  end,
})

autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.colorcolumn = "100"
  end,
})

autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.textwidth = 79
  end,
})

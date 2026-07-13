local map = vim.keymap.set

-- window navigation
map("n", "<leader>wj", "<C-w>j", { desc = "Window down" })
map("n", "<leader>wk", "<C-w>k", { desc = "Window up" })
map("n", "<leader>wh", "<C-w>h", { desc = "Window left" })
map("n", "<leader>wl", "<C-w>l", { desc = "Window right" })

-- window splits
map("n", "<leader>w/", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>w-", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })

-- go to window 1-9
for i = 1, 9 do
  map("n", "<leader>" .. i, i .. "<C-w>w", { desc = "Window " .. i })
end

-- move current buffer into window 1-9, following it there
local function move_buf_to_window(n)
  local target = vim.fn.win_getid(n)
  if target == 0 or target == vim.api.nvim_get_current_win() then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_buf(target, bufnr)
  local alt = vim.fn.bufnr("#")
  if alt ~= -1 and alt ~= bufnr then
    vim.api.nvim_win_set_buf(0, alt)
  end
  vim.api.nvim_set_current_win(target)
end

for i = 1, 9 do
  map("n", "<leader>m" .. i, function() move_buf_to_window(i) end, { desc = "Move buffer to window " .. i })
end

-- save
map({ "n", "i" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- buffers
map("n", "<leader>bl", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bh", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bp | bd #<cr>", { desc = "Delete buffer, keep split" })
map("n", "<leader>ba", '<cmd>%bd!|e #|bd #|normal `"<cr>', { desc = "Close all other buffers" })
map("n", "<leader><tab>", "<cmd>b#<cr>", { desc = "Alternate buffer" })

-- clear search highlight
map("n", "<esc>", "<cmd>nohlsearch<cr>")

-- pasting over a selection no longer clobbers your clipboard
vim.cmd([[ xnoremap <expr> p 'pgv"'.v:register.'y' ]])

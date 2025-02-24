-- define common options
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
}

-----------------
-- Normal mode --
-----------------

-- Resize with arrows
-- delta: 2 lines
vim.keymap.set('n', '<C-Up>',    ':resize +2<CR>', opts)
vim.keymap.set('n', '<C-Down>',  ':resize -2<CR>', opts)
vim.keymap.set('n', '<C-Left>',  ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Move text up and down
vim.keymap.set("n", "<A-J>", ":m .+1<CR>==", opts)
vim.keymap.set("n", "<A-K>", ":m .-2<CR>==", opts)

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-------------------
-- Terminal mode --
-------------------

local t_opts = {silent = true}
vim.keymap.set('t', '<esc>', '<C-\\><C-N><C-W>p', t_opts)

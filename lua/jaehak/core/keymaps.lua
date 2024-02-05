-- change leader key
vim.g.mapleader = ' '

local opts = {noremap = true}

-- change cursor move key in normal mode
vim.keymap.set({'n','v'}, 'j', 'k', opts)
vim.keymap.set({'n','v'}, 'k', 'j', opts)
vim.keymap.set({'n'}, '<C-w>k', '<C-w>j', opts)
vim.keymap.set({'n'}, '<C-w>j', '<C-w>k', opts)
vim.keymap.set({'i'}, 'jk', '<Esc>', opts)   -- must be lowercase to esc


-- set cursor move key in insert mode and command mode
vim.keymap.set({'i','c'}, '<C-h>', '<Left>', opts)
vim.keymap.set({'i','c'}, '<C-j>', '<Up>', opts)
vim.keymap.set({'i','c'}, '<C-k>', '<Down>', opts)
vim.keymap.set({'i','c'}, '<C-l>', '<Right>', opts)
vim.keymap.set({'i','c'}, '<C-e>', '<Del>', opts)


-- set edit keys in normal mode
vim.keymap.set('n', 'ee', 'i<space><esc>', opts)		-- space
vim.keymap.set('n', 'tt', 'i<Tab><esc>', opts)			-- tab
vim.keymap.set('n', '<S-CR>', 'o<esc>', opts)			-- new line (i heard it works only gui)
vim.keymap.set('n', 'U', ':redo<CR>', opts)				-- redo
vim.keymap.set('n', '<C-/>', '/\\<\\><Left><Left>',opts)

-- set visual mode behavior
vim.keymap.set('v', '<C-h>', '"hy:s/<C-r>h//gc<Left><Left><Left>', opts)
vim.keymap.set('n', '<C-h>', 'viw"hy:s/<C-r>h//gc<Left><Left><Left>', opts)


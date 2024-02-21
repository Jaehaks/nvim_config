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
vim.keymap.set('n', 'ww', 'i<space><esc>', opts)		-- space
vim.keymap.set('n', 'tt', 'i<Tab><esc>', opts)			-- tab
vim.keymap.set('n', '<S-CR>', 'o<esc>', opts)			-- new line (i heard it works only gui)
vim.keymap.set('n', 'U', ':redo<CR>', opts)				-- redo
vim.keymap.set('n', '<C-/>', '/\\<\\><Left><Left>',opts)



-- set find/replace behavior
vim.keymap.set('v', '<C-h>', '"hy:.,$s/<C-r>h//gc<Left><Left><Left>', opts)
vim.keymap.set('n', '<C-h>', 'viw"hy:.,$s/<C-r>h//gc<Left><Left><Left>', opts)
vim.keymap.set('v', '<C-f>', '"hy/<C-r>h<CR>N', opts)
vim.keymap.set('n', '<C-f>', 'yiw/\\<C-r>0\\><CR>N', opts)
vim.keymap.set('n', '*', '*N', opts)
vim.keymap.set('n', '<F2>', ':let @/=""<CR>', opts)

local function table_contains(tbl, x)
	local found = false
	for _, v in pairs(tbl) do
		if v == x then
			found = true
		end
	end
	return found
end

--function HighlightWordUnderCursor()
--	local disabled_ft = {'lir', 'diff', 'fzf', 'TelescopePrompt', 'floatterm', 'help'}
--	if table_contains(disabled_ft, vim.bo.filtype)
--		return
--	end
--
--	local cur_word = vim.fn.expand('<cword>')
--	if vim. 




local aug_WinLeave_Cursor = vim.api.nvim_create_augroup('WinLeave_Cursor', {clear = true})
vim.api.nvim_create_autocmd({'WinEnter', 'BufRead'}, {
	group = aug_WinLeave_Cursor,
	pattern = '*',
	callback = function() vim.opt_local.cursorline = false end
})

-- set file managing
vim.keymap.set('n', '<C-g>', '<Cmd>echom expand("%:p")<CR>', opts)


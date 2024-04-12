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
vim.keymap.set({'i','c','t'}, '<C-h>', '<Left>', opts)
vim.keymap.set({'i','c','t'}, '<C-j>', '<Up>', opts)
vim.keymap.set({'i','c','t'}, '<C-k>', '<Down>', opts)
vim.keymap.set({'i','c','t'}, '<C-l>', '<Right>', opts)
vim.keymap.set({'i','c'}, '<C-e>', '<Del>', opts)

-- set action in terminal mode 
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts) 	-- out from terminal mode


-- set edit keys in normal mode
vim.keymap.set('n', 'ww', 'i<space><esc>', opts)		-- space
vim.keymap.set('n', 'tt', 'i<Tab><esc>', opts)			-- tab
vim.keymap.set('n', '<S-CR>', 'o<esc>', opts)			-- new line (i heard it works only gui)
vim.keymap.set('n', 'U', ':redo<CR>', opts)				-- redo
vim.keymap.set('n', '<C-/>', '/\\<\\><Left><Left>',opts)
vim.keymap.set('n', ':', ';',opts)
vim.keymap.set({'n', 'v'}, ';', ':',opts) -- replace ;q instead of :q
vim.keymap.set('n', 'zf', 'z=1<CR>', opts) -- replace wrong word to suggested spell


-- set find/replace behavior
vim.keymap.set('v', '<C-h>', '"hy:.,$s/<C-r>h//gc<Left><Left><Left>', opts)
vim.keymap.set('n', '<C-h>', 'viw"hy:.,$s/<C-r>h//gc<Left><Left><Left>', opts)
vim.keymap.set('v', '<C-f>', '"hy/<C-r>h<CR>N', opts)
vim.keymap.set('n', '<C-f>', 'yiw/\\<C-r>0\\><CR>N', opts)
vim.keymap.set({'n','v'}, '*', '*N', opts)
vim.keymap.set('n', '<F2>', ':let @/=""<CR>', opts)

-- clear keymap
vim.keymap.set({'n'}, '<C-l>', '<Nop>', opts) -- default is redraw (highlight all blank region)
-- vim.keymap.set('n', [[q:]], '<Nop>', opts) -- q: shortcut cannot change

-- only show cursorline in current buffer
local aug_User_defined = vim.api.nvim_create_augroup('User_defined', {clear = true})
vim.api.nvim_create_autocmd({'WinEnter', 'BufRead'}, {
	group = aug_User_defined,
	pattern = '*',
	callback = function() vim.opt_local.cursorline = false end
})
-- use q instead of :q when close some filetype
vim.api.nvim_create_autocmd({'Filetype'}, {
	group = aug_User_defined,
	pattern = '*',
	callback = function(event)
		local diable_ft = {'help', 'terminal', 'FTerm', 'floaterm'}	-- disable filetype list
		local filetype = vim.bo[event.buf].filetype
		local ok = nil
		for _, val in ipairs(diable_ft) do
			if filetype == val then ok = true end
		end

		if ok then
			-- apply to the specific buffer only
			vim.keymap.set('n', 'q', ':q!<CR>', {silent = true, buffer = 0, noremap = true})
		end
	end
})

-- set file managing
vim.keymap.set('n', '<C-g>', '<Cmd>echom expand("%:p")<CR>', opts)


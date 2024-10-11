-- change leader key
vim.g.mapleader = ' '

local opts = {noremap = true}

-- change cursor move key in normal mode
vim.keymap.set({'n','v'}, 'j', 'k', opts)
vim.keymap.set({'n','v'}, 'k', 'j', opts)
vim.keymap.set({'n'}, '<C-w>k', '<C-w>j', opts)
vim.keymap.set({'n'}, '<C-w>j', '<C-w>k', opts)
vim.keymap.set({'i'}, 'jk', '<Esc>', opts)      -- must be lowercase to esc
vim.keymap.set({'n'}, '<C-o>', '<C-o>zz', opts) -- move center of screen after restore cursor location


-- set cursor move key in insert mode and command mode
vim.keymap.set({'i','c','t'}, '<C-h>', '<Left>', opts)
vim.keymap.set({'i','c','t'}, '<C-j>', '<Up>', opts)
vim.keymap.set({'i','c','t'}, '<C-k>', '<Down>', opts)
vim.keymap.set({'i','c','t'}, '<C-l>', '<Right>', opts)
vim.keymap.set({'i','c'}, '<C-d>', '<Del>', opts)
vim.keymap.set({'i','c'}, '<C-a>', '<Home>', opts)
vim.keymap.set({'i','c'}, '<C-e>', '<End>', opts)

-- set action in terminal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts) -- out from terminal mode
vim.keymap.set({'i'},'<C-p>','<Nop>')              -- disable default completion next
vim.keymap.set({'i'},'<C-n>','<Nop>')              -- disable default completion previous

-- set edit keys in normal mode
vim.keymap.set('n', 'ww', 'i<space><esc>', opts)  -- space
vim.keymap.set('n', 'tt', 'i<Tab><esc>', opts)    -- tab
vim.keymap.set('n', 'U', ':redo<CR>', opts)       -- redo
vim.keymap.set('n', '?', '/\\<\\><Left><Left>',opts) -- find exact word, <C-/> doesn't work in terminal
vim.keymap.set('n', ':', ';',opts)
vim.keymap.set({'n', 'v'}, ';', ':',opts)         -- replace ;q instead of :q
vim.keymap.set('n', 'zf', '[s1z=', opts)          -- replace current/previous word on cursor to 1st suggested spell
vim.keymap.set('n', 'Y', '"*yy', opts)            -- copy a line using system clipboard
vim.keymap.set('v', 'Y', '"*y', opts)             -- copy a visual block using system clipboard
vim.keymap.set('n', 'P', '"*p', opts)             -- paste from system clipboard

-- set diff keymaps
vim.keymap.set({'n', 'v'}, 'do', ':diffg<CR>', {silent = true, noremap = true}) -- copy continuous region of change from other to cursor
vim.keymap.set({'n', 'v'}, 'dp', ':diffpu<CR>', {silent = true, noremap = true}) -- copy continuous region of change from cursor to other

-- set find/replace behavior
vim.keymap.set('v', '<C-h>', '"hy:.,$s/<C-r>h//gc<Left><Left><Left>', opts)
vim.keymap.set('n', '<C-h>', 'viw"hy:.,$s/<C-r>h//gc<Left><Left><Left>', opts)
vim.keymap.set('v', '<C-f>', '"hy/<C-r>h<CR>N', opts)
vim.keymap.set('n', '<C-f>', 'yiw/\\<C-r>0\\><CR>N', opts)
vim.keymap.set({'n','v'}, '*', '*N', opts)
vim.keymap.set('n', '<F2>', ':let @/=""<CR>', opts)

-- clear keymap
vim.keymap.set({'n'}, '<C-l>', '<Nop>', opts) -- default is redraw (highlight all blank region)
vim.keymap.set({'i'}, '<C-Space>', '<Nop>', opts) -- default is paste

-- Insert New line
vim.keymap.set('n', '<CR>', 'o<esc>', {silent = true, noremap = true})       -- new line without split(i heard it works only gui)
vim.keymap.set('n', '<C-i>', 'a<CR><esc><Up>$', {silent = true, noremap = true}) -- new line with split(i heard it works only gui)

-- use q instead of :q when close some filetype
local aug_QuickQuit = vim.api.nvim_create_augroup("aug_QuickQuit", { clear = true })
vim.api.nvim_create_autocmd({'Filetype'}, {
	group = aug_QuickQuit,
	pattern = {
		'help',
		'qf',
		'Outline',
		'TelescopePrompt',
		'toggleterm',
		'CodeAction',
		'checkhealth',
	},
	callback = function(event)
		local filetype = vim.bo[event.buf].filetype -- get current filetype
		vim.bo[event.buf].buflisted = false  -- ensure the buffer don't listed in 'ls'

		if filetype == 'help' or filetype == 'checkhealth' then
			-- it prevents that whole neovim termination when I quit a help file which is in full screen
			vim.keymap.set('n', 'q', ':bd<CR>', {silent = true, buffer = event.buf, noremap = true})

			-- disable keymaps to not modifiable file
			vim.keymap.set('n', '<CR>', '<CR>', {silent = true, buffer = event.buf, noremap = true})
			vim.keymap.set('n', '<C-i>', '<Nop>', {silent = true, buffer = event.buf, noremap = true})
		else
			vim.keymap.set('n', 'q', ':q!<CR>', {silent = true, buffer = event.buf, noremap = true}) -- apply to the specific buffer only
		end
	end
})

-- set file managing
vim.keymap.set('n', '<C-g>', '<Cmd>echom expand("%:p")<CR>', opts)


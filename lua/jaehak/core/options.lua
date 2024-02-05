local opt = vim.opt 		-- for conciseness 

------------- font setting -----------------------
opt.guifont = 'FiraCode Nerd Font Mono:h11'


------------- file detect -----------------------
--vim.opt.path:prepend('./**10') -- add current subdirectory for gf
opt.path:append('C:/Users/USER/.config/nvim/**10')
--vim.api.nvim_create_autocmd('BufEnter', {
--	pattern = '*',
--	desc = 'Change pwd of current buffer',
--	command = 'silent! lcd %:p:h',
--})

------------- editing -----------------------
opt.number = true  			-- set line number 
opt.tabstop = 4				-- set inserted space in TAB
opt.shiftwidth = 4          -- set indent space 
opt.autoindent = true 		-- when enter next line, automatically indent from start line
--opt.smarttab = true

opt.wrap = false			-- disable line wrapping  




------------- output file -------------------
opt.swapfile = false		-- no swap file when file is created 
opt.backup = false 			-- no backup file when file is created
--opt.shell = 'cmd "C:\\Users\\USER\\user_installed\\cmder_mini\\vendor\\init.bat"'



------------- case sensitive ----------------
opt.ignorecase = true		-- ignore case when searching 
opt.smartcase = true		-- when pattern has upper case, disable ignorecase 



------------ gui windows ------------------------
-- show cursorline only current buffer 
opt.termguicolors = true 	-- change cursor line from line to block 
local aug_BufLeave_Cursor = vim.api.nvim_create_augroup('BufLeave_Cursor', {clear = true})
vim.api.nvim_create_autocmd('BufLeave', {
	group = aug_BufLeave_Cursor,
	pattern = '*',
	callback = function() vim.opt_local.cursorline = false end
})
vim.api.nvim_create_autocmd('BufEnter', {
	group = aug_BufLeave_Cursor,
	pattern = '*',
	callback = function() vim.opt_local.cursorline = true end
})

--opt.cursorline = true		-- show underline where current cursor is located
--opt.signcolumn = 'yes' 	-- show additional gray column on the leftside of line number 
--vim.cmd[[set mouse=]]		-- disable mouse operation

opt.clipboard:append('unnamedplus')		-- share clipboard between vim and system
										-- "*p doest not need to paste from system clipboard
opt.iskeyword:append('-')				-- i don't know 


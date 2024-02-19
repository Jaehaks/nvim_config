local opt = vim.opt 		-- for conciseness 

------------- font setting -----------------------
opt.guifont = 'FiraCode Nerd Font Mono:h11'


------------- file detect -----------------------
--vim.opt.path:prepend('./**10') -- add current subdirectory for gf
vim.g.python3_host_prog = 'C:\\Users\\USER\\Python\\.Nvim_venv\\scripts\\python'		-- use python support
vim.g.python_host_prog = 'C:\\Users\\USER\\Python\\Python27\\python'		-- use python support
opt.path:append(vim.fn.stdpath("config") .. "/**10")
opt.path:append(vim.fn.stdpath("data") .. "/**10")
--vim.api.nvim_create_autocmd('BufEnter', {
--	pattern = '*',
--	desc = 'Change pwd of current buffer',
--	command = 'silent! lcd %:p:h',
--})

------------- editing -----------------------
opt.number = true  			-- set line number 
opt.relativenumber = true	-- set relative line number
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
local aug_WinLeave_Cursor = vim.api.nvim_create_augroup('WinLeave_Cursor', {clear = true})
vim.api.nvim_create_autocmd({'BufLeave', 'WinLeave'}, {
	group = aug_WinLeave_Cursor,
	pattern = '*',
	callback = function() vim.opt_local.cursorline = false end
})
vim.api.nvim_create_autocmd({'BufRead', 'WinEnter'}, {
	group = aug_WinLeave_Cursor,
	pattern = '*',
	callback = function() vim.opt_local.cursorline = true end
})

--opt.cursorline = true		-- show underline where current cursor is located
--opt.signcolumn = 'yes' 	-- show additional gray column on the leftside of line number 
--vim.cmd[[set mouse=ni]]		-- disable mouse operation
								-- In neovim, mouse is disabled after entered visual mode, it is weird

opt.clipboard:append('unnamedplus')		-- share clipboard between vim and system
										-- "*p doest not need to paste from system clipboard
opt.iskeyword:append('-')				-- i don't know 


local opt = vim.opt 		-- for conciseness 


-- 1) neovide supports customize cursor highlight 
-- 2) neovide supports turnon/off IME default
--------- neovide config ------------
if vim.g.neovide then
	-- turn off all animations
	vim.g.neovide_scroll_animation_length = 0
	vim.g.neovide_hide_mouse_when_typing = true
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_trail_size = 0
	vim.g.neovide_cusor_antialiasing = false
	vim.g.neovide_cursor_animate_in_insert_mode = false
	vim.g.neovide_cursor_animate_command_line = false
	-- vim.g.neovide_font_features = {
	-- 	["FiraCode Nerd Font Mono"] = {
	-- 		'-liga',
	-- 		'+ss07',
	-- 		'calt=0',
	-- 		'cv49=16',
	-- 		'cv94=1',
	-- 		'VXLA=2',
	-- 		'VXLC=2',
	-- 		'cv34=12',
	-- 		'cv31=13',
	-- 	}
	-- }
	-- vim.g.neovide_font_settings ={
	-- 	['FiraCode Nerd Font Mono'] = {
	-- 		features = {
	-- 			'-liga'
	-- 		},
	-- 		weight = 'lighter'
	-- 	}
	-- }

	-- it works in neovide, but not in nvim, nvim-qt
	-- connect cursor to highlight group depending mode
 	vim.opt.guicursor = "n-v-c:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,sm:block-lCursor"

	-- turn on IME to use non-english words in only insert mode 
	local function set_ime(args)
		if args.event:match("Enter$") then
			vim.g.neovide_input_ime = true
		else
			vim.g.neovide_input_ime = false
		end
	end

	local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

	vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
		group = ime_input,
		pattern = "*",
		callback = set_ime
	})

	vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
		group = ime_input,
		pattern = "[/\\?]",
		callback = set_ime
	})
end





------------- font setting -----------------------
opt.guifont = 'FiraCode Nerd Font Mono:h11'
opt.guifontwide = '나눔고딕:h11'
opt.fileencodings = {'utf-8', 'cp949'}	 -- find encodings in this table


------------ gui windows ------------------------
-- show cursorline only current buffer 
opt.cursorline = true		-- show underline where current cursor is located
opt.termguicolors = true 	-- change cursor line from line to block 
opt.signcolumn = 'yes' 	-- show additional gray column on the leftside of line number 
opt.shellslash = false -- if true, '/' is used for expanding directory


-- cursor line in only active window
-- if cursorline false at BufRead, the cursorline is off in case of moving to other buffer in current window
-- becase when :bn, BufRead invoked but WinEnter didn't not invoke
local aug_WinLeave_Cursor = vim.api.nvim_create_augroup('WinLeave_Cursor', {clear = true})
vim.api.nvim_create_autocmd({'WinLeave'}, {
	group = aug_WinLeave_Cursor,
	pattern = '*',
	callback = function() vim.opt_local.cursorline = false end
})
vim.api.nvim_create_autocmd({'BufRead', 'WinEnter'}, {
	group = aug_WinLeave_Cursor,
	pattern = '*',
	callback = function() vim.opt_local.cursorline = true end
})

------------- file detect -----------------------
vim.g.has_win32 = vim.fn.has('win32')
if vim.g.has_win32 == 1 then
	vim.g.python3_host_prog = vim.fn.stdpath('config') .. '\\.Nvim_venv\\Scripts\\python'		-- use python support
	opt.path:append(vim.fn.stdpath("config") .. "\\**10")
	opt.path:append(vim.fn.stdpath("data") .. "\\**10")
else
	vim.g.python3_host_prog = '~/.config/.Nvim_venv/bin/python'		-- use python support
	opt.path:append(vim.fn.stdpath("config") .. "/**10")
	opt.path:append(vim.fn.stdpath("data") .. "/**10")
end
opt.autochdir = true	-- change pwd where current buffer is located
--opt.autoread = true		-- auto reload when file has been changed outside of vim
local aug_NvimFocus = vim.api.nvim_create_augroup('aug_NvimFocus', {clear = true})
vim.api.nvim_create_autocmd({'FocusGained'}, {    -- inquire file reload when nvim focused
	group = aug_NvimFocus,
	pattern = '*',
	command = 'silent! checktime'	-- check the buffer is changed out of neovim
})

------------- editing -----------------------
opt.inccommand = ''       -- disable show effect of substitute
opt.number = true         -- set line number
opt.relativenumber = true -- set relative line number
opt.tabstop = 4           -- set inserted space in TAB
opt.shiftwidth = 4        -- set indent space
-- opt.smarttab = true
opt.autoindent = true     -- when enter next line, automatically indent from start line
-- opt.smartindent = true    -- smart autoindent when starting new line
                          -- when 'cindent' is on  (or) 'indentexpr' is set => smartindent is no effect
                          -- it add indent after { or 'if, else ... '
                          -- so in markdown, 'indentexpr' is nil as default. so it requires smartindent
                          -- but smartindent makes new line and indent after {.
                          -- and then, if I enter } at the next line, outdent occurs.
                          -- so <autoclose> plugins are not works directly
                          -- plus, '#' removes all indent at the line, but not works?
                          -- if '#' is located at first column, '>>' doesn't work
						  -- I'll use nvim-FeMaco.lua in markdown instead of it 

opt.wrap = false          -- disable line wrapping
opt.splitright = true	  -- focus to new window when vsplit
-- opt.splitbelow = true	  -- focus to new window when split

------------- output file -------------------
opt.swapfile = false		-- no swap file when file is created 
opt.backup = false 			-- no backup file when file is created
--opt.shell = 'cmd "C:\\Users\\USER\\user_installed\\cmder_mini\\vendor\\init.bat"'



------------- case sensitive ----------------
opt.ignorecase = true		-- ignore case when searching 
opt.smartcase = true		-- when pattern has upper case, disable ignorecase 




--vim.cmd[[set mouse=ni]]		-- disable mouse operation
								-- In neovim, mouse is disabled after entered visual mode, it is weird

-- opt.clipboard:append('unnamedplus') -- share clipboard between vim and system
                                    -- "*p doest not need to paste from system clipboard
                                    -- it makes editing very slower, set keymap to use system clipboard instead of it
opt.iskeyword:append('-')           -- i don't know



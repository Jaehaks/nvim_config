local opt = vim.opt 		-- for conciseness
local paths = require('jaehak.core.paths')

-- first
vim.g.has_win32 = vim.fn.has('win32')
opt.tabstop        = 4        -- set inserted space in TAB
opt.shiftwidth     = 4        -- set indent space

------------- font setting -----------------------
opt.guifont       = 'FiraCode Nerd Font Mono:h11'
opt.guifontwide   = '나눔고딕:h11'
local aug_UserOptions = vim.api.nvim_create_augroup('aug_UserOptions', {clear = true})
opt.encoding      = 'utf-8'                         -- set utf-8 without BOM as default encoding
opt.fileencodings = { 'ucs-bom', 'utf-8', 'cp949' } -- consider ucs-bom for encoding with BOM like utf-16le


------------ gui windows ------------------------
-- show cursorline only current buffer
opt.cursorline    = true    -- show underline where current cursor is located
opt.termguicolors = true    -- change cursor line from line to block
if vim.g.has_win32 == 1 then
	opt.shellslash    = false    -- if true, '/' is used for expanding directory
	opt.completeslash = 'slash' -- slash is used for path completion
end

-- cursor line in only active window
-- if cursorline false at BufRead, the cursorline is off in case of moving to other buffer in current window
-- becase when :bn, BufRead invoked but WinEnter didn't not invoke
vim.api.nvim_create_autocmd({'WinLeave'}, {
	group = aug_UserOptions,
	pattern = '*',
	callback = function() vim.opt_local.cursorline = false end
})
vim.api.nvim_create_autocmd({'BufRead', 'WinEnter'}, {
	group = aug_UserOptions,
	pattern = '*',
	callback = function() vim.opt_local.cursorline = true end
})

------------- file detect -----------------------

-- register config / data directory to runtimepath
-- register python program
if vim.g.has_win32 == 1 then
	vim.g.python3_host_prog = paths.nvim.python
	opt.path:append(paths.config_dir .. "\\**10")
	opt.path:append(paths.data_dir .. "\\**10")
	opt.path:prepend(paths.home_dir .. '\\scoop\\apps\\neovim\\current\\bin')
else
	vim.g.python3_host_prog = '~/.config/.Nvim_venv/bin/python'		-- use python support
	opt.path:append(paths.config_dir .. "/**10")
	opt.path:append(paths.data_dir .. "/**10")
end
vim.g.loaded_perl_provider = 0 -- disable perl provider warning


-- change
opt.autochdir = true	-- change pwd where current buffer is located
--opt.autoread = true		-- auto reload when file has been changed outside of vim

-- force modify filetype
vim.filetype.add({
	extension = {
		scm = 'query', -- .scm is 'scheme' as default, 'query' is more colorful
	}
})



------------- editing -----------------------
opt.inccommand     = ''       -- disable show effect of substitute
opt.number         = true     -- set line number
opt.relativenumber = true     -- set relative line number
opt.signcolumn     = 'yes'    -- show additional gray column on the leftside of line number
opt.statuscolumn   = '%=%l%s' -- change order of signcolumn. line number(left), sign(right)
                              -- opt.smarttab = true
opt.autoindent     = true     -- when enter next line, automatically indent from start line
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

opt.wrap       = false -- disable line wrapping
opt.splitright = true  -- focus to new window when vsplit
                       -- opt.splitbelow = true	  -- focus to new window when split
opt.scrolloff  = 5     -- scroll start offset line
opt.foldenable = false -- disable folding automatically with marker (ex, toml )
vim.g.editorconfig = false

-- for nvim-cmp (init() of lazy.nvim is slow)
opt.spell     = true
opt.spelllang = {'en_us', 'cjk'} -- disable spell check for asian char
opt.pumheight = 10               -- maximum item number when show completion

-- set local options for markdown because markdown's ftplugin must set expandtab
vim.api.nvim_create_autocmd({'FileType'}, {    -- inquire file reload when nvim focused
	group = aug_UserOptions,
	pattern = 'markdown',
	callback = function ()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4           -- set inserted space in TAB
		vim.opt_local.shiftwidth = 4        -- set indent space
	end
})

------------- diff -----------------------
opt.diffopt = {
    'internal',
    'filler',
    'closeoff',
	'linematch:60', -- match 2 buffer diff hunk of 30 lines each,
	'iwhite',       -- ignore white space change to more exact diff result
}



------------- output file -------------------
opt.swapfile = false -- no swap file when file is created
opt.backup   = false -- no backup file when file is created
--opt.shell = 'cmd "C:\\Users\\USER\\user_installed\\cmder_mini\\vendor\\init.bat"'

opt.sessionoptions = "buffers,curdir,folds,tabpages,winsize" -- get rid of 'blank,buffers' to remove unlisted buffer
													 -- get rid of 'help, terminal'

------------- case sensitive ----------------
opt.ignorecase = true -- ignore case when searching
opt.smartcase  = true -- when pattern has upper case, disable ignorecase
--vim.cmd[[set mouse=ni]]		-- disable mouse operation
								-- In neovim, mouse is disabled after entered visual mode, it is weird
-- opt.clipboard:append('unnamedplus') -- share clipboard between vim and system
                                    -- "*p doest not need to paste from system clipboard
                                    -- it makes editing very slower, set keymap to use system clipboard instead of it
opt.iskeyword:append('-')           -- i don't know





---------- file type ---------
if vim.g.has_win32 ~= 1 then
	-- set filetype of zsh as sh to recognize bash treesitter
	vim.filetype.add({
		extension = {
			zsh = 'sh',
			sh = 'sh'
		},
		filename = {
			['.zshrc'] = 'sh',
			['.zshenv']= 'sh',
		}
	})
end

local M = {}

M.nvim = {
	config = vim.fn.stdpath("config") .. "\\lua\\jaehak\\plugins",
	data   = vim.fn.stdpath("data") .. "\\lazy",
	python = vim.fn.stdpath('config') .. '\\.Nvim_venv\\Scripts\\python',		-- use python support
	luarocks = vim.fn.expand('$HOME\\scoop\\apps\\luarocks\\current\\rocks\\share\\lua\\5.4'),
	treesitter_queries = vim.fn.stdpath("config") .. "\\queries\\nvim-treesitter"
}

M.project = {
	matlab = 'D:\\MATLAB_Project',
}

M.session = {
	saved = vim.fn.stdpath('data') .. '\\sessions\\session_saved.txt'
}

M.obsidian = {
	personal = vim.fn.expand('$HOME') .. '\\Obsidian_Nvim\\Personal',
}

return M

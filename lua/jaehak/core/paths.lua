local M = {}

M.nvim = {
	config = vim.fn.stdpath("config") .. "\\lua\\jaehak\\plugins",
	data   = vim.fn.stdpath("data") .. "\\lazy",
	python = vim.fn.stdpath('config') .. '\\.Nvim_venv\\Scripts\\python'		-- use python support
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

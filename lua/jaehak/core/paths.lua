local M = {}

M.nvim = {
	config = vim.fn.stdpath("config") .. "\\lua\\jaehak\\plugins",
	data   = vim.fn.stdpath("data") .. "\\lazy",
}

M.project = {
	matlab = 'D:\\MATLAB_Project',
}

M.session = {
	saved = vim.fn.stdpath('data') .. '\\sessions\\session_saved.txt'
}

M.obsidian = {
	vault = vim.fn.expand('$HOME') .. '\\Obsidian_Nvim\\Personal',
}

return M

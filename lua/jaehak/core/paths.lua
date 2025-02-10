local M = {}

M.nvim = {
	config             = vim.fn.stdpath("config") .. "\\lua\\jaehak\\plugins",
	data               = vim.fn.stdpath("data") .. "\\lazy",
	python             = vim.fn.stdpath('config') .. '\\.Nvim_venv\\Scripts\\python',		-- use python support
	luarocks           = vim.fn.expand('$HOME\\scoop\\apps\\luarocks\\current\\rocks\\share\\lua\\5.4'),
	treesitter_queries = vim.fn.stdpath("config") .. "\\queries\\nvim-treesitter",
	wordlist_korean    = vim.fn.stdpath('config') .. '\\queries\\dictionary\\wordslist_korean.txt',
}

local check_matlab_dir = function ()
	local candidate = {
		'C:\\Program Files\\MATLAB\\R2024b\\bin',
		'C:\\Program Files\\MATLAB\\R2024a\\bin',
	}

	for _, value in pairs(candidate) do
		if vim.fs.dir(value) then
			return value
		end
	end

	vim.api.nvim_err_writeln('User Error : matlab doesn\'t be installed')
	return ''
end

M.lsp = {
	ruff = {
		config_path   = vim.fn.stdpath('config') .. '\\queries\\ruff\\ruff.toml',
		cache_path    = vim.fn.stdpath('cache') .. '\\.ruff_cache',
		log_path      = vim.fn.stdpath('data') .. '\\ruff.log',
	},
	matlab = check_matlab_dir()
}

M.project = {
	matlab = 'D:\\MATLAB_Project',
}

M.session = {
	saved = vim.fn.stdpath('data') .. '\\sessions\\session_saved.txt'
}

M.obsidian = {
	personal = vim.fn.expand('$HOME') .. '\\Obsidian_Nvim\\Personal',
	project = vim.fn.expand('$HOME') .. '\\Obsidian_Nvim\\Project',
}

M.Filetypes_ForCode = { 'lua', 'matlab', 'json', 'python' }

return M

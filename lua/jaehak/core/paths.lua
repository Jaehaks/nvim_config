local M = {}

local config_dir = vim.fn.stdpath('config')
local data_dir   = vim.fn.stdpath('data')
local cache_dir  = vim.fn.stdpath('cache')
local home_dir   = vim.fn.expand('$HOME')

M.nvim = {
	config             = config_dir .. "\\lua\\jaehak\\plugins",
	data               = data_dir .. "\\lazy",
	python             = config_dir .. '\\.Nvim_venv\\Scripts\\python',		-- use python support
	luarocks           = home_dir .. '\\scoop\\apps\\luarocks\\current\\rocks\\share\\lua\\5.4',
	treesitter_queries = config_dir .. "\\queries\\nvim-treesitter",
	wordlist_korean    = config_dir .. '\\queries\\dictionary\\wordslist_korean.txt',
	rainbow_queries    = config_dir .. '\\queries\\rainbow-delimiters.nvim',
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
		config_path   = config_dir .. '\\queries\\ruff\\ruff.toml',
		cache_path    = cache_dir .. '\\.ruff_cache',
		log_path      = data_dir .. '\\ruff.log',
	},
	matlab = check_matlab_dir()
}

M.project = {
	matlab = 'D:\\MATLAB_Project',
}

M.session = {
	saved = data_dir .. '\\sessions\\session_saved.txt'
}

M.obsidian = {
	personal = home_dir .. '\\Obsidian_Nvim\\Personal',
	project = home_dir .. '\\Obsidian_Nvim\\Project',
}

M.Filetypes = {
	ForIlluminate = { 'lua', 'matlab', 'json', 'python', 'text', 'markdown' },
	ForCode = { 'lua', 'matlab', 'json', 'python' },
}

M.config_dir = config_dir
M.data_dir   = data_dir
M.cache_dir  = cache_dir
M.home_dir   = home_dir

return M

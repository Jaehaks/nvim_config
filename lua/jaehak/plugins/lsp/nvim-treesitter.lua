-- RRethy/nvim-treesitter-endwise : it doesn't need anymore because nvim-autopairs does same one
-- goldos24/rainbow-variables-nvim : it seems doesn't supports many languages yet.
local TS_filetype = require('jaehak.core.paths').Filetypes.ForTreesitter
return {
{
	'nvim-treesitter/nvim-treesitter',
	ft = TS_filetype,
	dependencies = {
		'HiPhish/rainbow-delimiters.nvim',
	},
	branch = 'main',
	build = ':TSUpdate',
	config = function ()
		local ts = require('nvim-treesitter')

		-- change install paths
		ts.setup({})

		-- install parsers asynchronously
		local parsers = {
			'lua', 'luadoc', 'luap', 'luau',
			'c', 'cpp', 'cmake', 'make', 'linkerscript',
			'matlab',
			'python',
			'vim', 'vimdoc',
			'markdown', 'markdown_inline',
			'html', 'json', 'toml', 'yaml',
			'diff', 'regex', 'ssh_config', 'powershell', 'bash',
			'latex', 'bibtex', -- for latex, tree-sitter-cli must be installed first, (scoop install main/tree-sitter)
		}
		ts.install(parsers)

		-- connect between filetype and treesitter parser if their names are different.
		-- you can get parser name from filetype using get_lang() function
		vim.treesitter.language.register('linkerscript', 'lnk')

		-- set treesitter highlights by filetype
		vim.api.nvim_create_autocmd('FileType', {
			pattern = TS_filetype,
			callback = function (args)
				local ft = vim.bo[args.buf].filetype
				-- start ts_parser explicitly using parser name which is matching with filetype
				local ts_parser = vim.treesitter.language.get_lang(ft) or ft
				local ok = pcall(vim.treesitter.start, args.buf, ts_parser)
				if not ok then -- fallback
					vim.bo[args.buf].syntax = 'on'
				end
			end
		})

		-- I don't use other features like `Folds` and `Indentation`
		-- If you want adding queries, 1) add .scm file in queries/<language> which is added in rtp.
		-- 							   2) add `; extends` marks at the top of the .scm file
	end

},
{
	-- rendering help using vimdoc treesitter
	"OXY2DEV/helpview.nvim",
	lazy = false, -- Recommended
},
}

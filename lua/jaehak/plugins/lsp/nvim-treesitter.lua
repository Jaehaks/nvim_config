-- RRethy/nvim-treesitter-endwise : it doesn't need anymore because nvim-autopairs does same one
-- goldos24/rainbow-variables-nvim : it seems doesn't supports many languages yet.
return {
{
	'nvim-treesitter/nvim-treesitter',
	event = {'BufReadPost'},
	ft = require('jaehak.core.paths').Filetypes.ForIlluminate,
	dependencies = {
		'HiPhish/rainbow-delimiters.nvim',
	},
	branch = 'main',
	build = ':TSUpdate',
	config = function ()
		local ts = require('nvim-treesitter')

		-- change install paths
		ts.setup({
			install_dir = require('jaehak.core.paths').data_dir .. '/nvim-treesitter/site'
		})

		-- install parsers asynchronously
		local parsers = {
			'lua', 'luadoc', 'luap', 'luau',
			'c',
			'matlab',
			'python',
			'vim', 'vimdoc',
			'markdown', 'markdown_inline',
			'html', 'json', 'toml',
			'diff', 'regex', 'ssh_config', 'powershell', 'bash',
			'latex' -- for latex, tree-sitter-cli must be installed first, (scoop install main/tree-sitter)
		}
		ts.install(parsers)

		-- set treesitter highlights by filetype
		local ft = {
			'lua',
			'c',
			'matlab',
			'python',
			'vim',
			'markdown',
			'html',
			'json',
			'toml',
			'diff',
			'config',
			'powershell',
			'bash',
			'zsh',
			'tex',
			'latex',
		}
		vim.api.nvim_create_autocmd('FileType', {
			pattern = ft,
			callback = function ()
				vim.treesitter.start()
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
	ft = 'help',
	-- lazy = false, -- Recommended
},
}

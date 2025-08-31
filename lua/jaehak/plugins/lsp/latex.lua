vim.g.maplocalleader = ' ' -- for vimtex

return {
{
	'Jaehaks/texflow.nvim',
	build = ':UpdateRemotePlugins',
	dependencies = {
		'j-hui/fidget.nvim',
	},
	ft = {'tex', 'latex', 'plaintex'},
	opts = {
		latex = {
			engine = 'latexmk',
			args = {
				'-pdf',                     -- make pdf for output
				'-outdir=@texname',			-- output folder after build
				'-interaction=nonstopmode', -- continuous mode compilation
				'-synctex=1',               -- enable synctex and make synctex.gz for forward/inverse search
				'@tex',                     -- current file
			},
			openAfter = true,
		},
	},
	config = function (_, opts)
		local texflow = require('texflow')
		texflow.setup(opts)

		local TexFlowMaps = vim.api.nvim_create_augroup('TexFlowMaps', {clear = true})
		vim.api.nvim_create_autocmd('FileType', {
			group = TexFlowMaps,
			pattern = {'tex', 'latex', 'plaintex'},
			callback = function ()
				vim.keymap.set('n', '<leader>ll', function () texflow.compile({ latex = { onSave = true, } })
				end, { buffer = true, desc = '[TexFlow] compile tex file and open pdf', silent = true })

				vim.keymap.set('n', '<leader>lf', function () texflow.compile({ latex = { openAfter = false, onSave = false, } })
				end, { buffer = true, desc = '[TexFlow] compile tex file and open pdf', silent = true })

				vim.keymap.set('n', '<leader>lv', function () texflow.view() end
				, { buffer = true, desc = '[TexFlow] view pdf file', silent = true })
			end
		})
	end

},
{
	'luochen1990/rainbow', -- for vimtex
	enabled = false,
	ft = {'tex', 'plaintex'},
	config = function ()
		vim.g.rainbow_active = 0
	end
},
{
	'junegunn/rainbow_parentheses.vim',  -- for vimtex
	enabled = false,
	ft = {'tex', 'plaintex'},
	config = function ()
		vim.g['rainbow#max_level'] = 16
		vim.g['rainbow#pairs'] = {
			{'(',')'},
			{'[',']'},
			{'{','}'},
		}
		vim.cmd([[:RainbowParentheses!<CR>]])
	end
},
}
-- texlab : use install latex lsp. it does not lspsaga support
-- 			it must use default vim.lsp behavior
-- 			it needs treesitter-latex / mason-texlab. so nvim_lsp source works to completion
-- 			1) it does not support conceallevel
-- 			2) forward search pdfviewer is not linked with nvim. pdf is remained after nvim closed. vimtex makes close
-- 			3) diagnostics view is good because it shows error signs in signcolumn.
-- 			4) I think build time is faster than vimtex
-- 	*) nvim-texlabconfig : config reverse-search for texlab (but I don't know how to make command for sumatrapdf)
-- 	*) texmagic.nvim : config latexmk by multiple engines (pdflatex, pdflua, etc...)
-- vimtex: it has more supports various features.
-- 		   1) but i don't like the error management. it opens additional buffer and focus ability is poor
-- 		   2) forward search / VimtexView focus on pdf previewer instead of nvim
-- 		   	  there are some hooks / callback to do this. but I don't know how to activate nvim-qt instance
-- 		   3) it cannot use treesitter , (rainbow bracket)
-- 		   	  - junegunn/rainbow_parentheses.vim : it works in plaintext. but it doesn't in equation
-- 		   	  - luochen1990/rainbow : it doesn't works.
-- 		   	  - I think treesitter has more functionality

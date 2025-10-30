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
				'-pdflatex=lualatex',
				'-pdflatex=lualatex',
				'-interaction=nonstopmode', -- continuous mode compilation
				'-synctex=1',               -- enable synctex and make synctex.gz for forward/inverse search
				'-silent', 					-- be more quiet progress message
				'@maintex',                 -- current file
			},
			openAfter = true,
		},
	},
	config = function (_, opts)
		-- appended .latex will be set highlight to latex file only
		-- check other way to change highlight not using @function
		-- @function affects other language files.
		-- or you need to change latex query capture
		vim.api.nvim_set_hl(0, "@markup.math.latex", {fg = '#ffffb3'})
		vim.api.nvim_set_hl(0, "@module.latex", {fg = '#da70d6'})
		vim.api.nvim_set_hl(0, "@markup.heading.latex", {fg = '#e68f30'}) -- \begin{frame}{<color is applied here>}
		vim.api.nvim_set_hl(0, "@markup.heading.1.latex", {fg = '#ffd700'}) -- title/author text
		vim.api.nvim_set_hl(0, "@markup.heading.2.latex", {fg = '#ff6984'}) -- chapter/part text
		vim.api.nvim_set_hl(0, "@markup.heading.3.latex", {fg = '#00ced1'}) -- section text
		vim.api.nvim_set_hl(0, "@markup.heading.4.latex", {fg = '#90ee90'}) -- subsection text
		vim.api.nvim_set_hl(0, "@markup.heading.5.latex", {fg = '#ffe4c4'}) -- paragraph text
		vim.api.nvim_set_hl(0, "@markup.heading.6.latex", {fg = '#e0ffff'}) -- subparagraph text
		vim.api.nvim_set_hl(0, "@function.macro.latex", {fg = '#888888'}) -- \label, \counter which is not show in output
		vim.api.nvim_set_hl(0, "@function.latex", {fg = '#79ccff'}) -- any \command name \mathbf \alpha etc....
		vim.api.nvim_set_hl(0, "@punctuation.delimiter.latex", {fg = '#888888'}) -- any \command name \mathbf \alpha etc....
		vim.api.nvim_set_hl(0, "@math.label.latex", {fg = '#c1c116'}) -- \begin{<color here>} for math_environment

		local texflow = require('texflow')
		texflow.setup(opts)

		local TexFlowMaps = vim.api.nvim_create_augroup('TexFlowMaps', {clear = true})
		vim.api.nvim_create_autocmd('FileType', {
			group = TexFlowMaps,
			pattern = {'tex', 'latex', 'plaintex'},
			callback = function ()
				vim.keymap.set('n', '<leader>ll', function () texflow.compile({ latex = { onSave = 'inherit' } })
				end, { buffer = true, desc = '[TexFlow] compile tex file and open pdf', silent = true })

				vim.keymap.set('n', '<leader>lf', function () texflow.compile({ latex = { openAfter = false, onSave = nil, } })
				end, { buffer = true, desc = '[TexFlow] compile tex file and open pdf', silent = true })

				vim.keymap.set('n', '<leader>lv', function () texflow.view() end
				, { buffer = true, desc = '[TexFlow] view pdf file', silent = true })

				vim.keymap.set('n', '<leader>lc', function () texflow.cleanup_auxfiles() end
				, { buffer = true, desc = '[TexFlow] cleanup aux files', silent = true })

			end
		})
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
-- pxwg/math-conceal : math conceal plugin for latex/md.
-- 					   It cannot support Windows
-- ryleelyman/latex.nvim : It needs nvim-treesitter old version , not using vim.treesitter for parsing.
-- 						   It occurs error.
-- dirichy/latex_concealer.nvim : It is not perfect. error occurs.
-- mathjiajia/nvim-latex-conceal : not works
-- bamonroe/rnoweb-nvim : not works

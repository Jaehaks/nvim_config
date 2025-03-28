vim.g.maplocalleader = ' ' -- for vimtex

return {
{
	-- 1) scoop install MikTex ⇒ compiler (for latexmk)
	-- 2) scoop install biber ⇒ syntax check / linting
	-- 3) scoop install mupdf ⇒ PDF viewer
	-- 4) treesitter-latex must be uninstalled
	'lervag/vimtex', -- it use lazy load default, do not set lazy
	enabled = true,
	ft = {'tex'},
	init = function()

		-- /////// compiler setting
		vim.g.vimtex_view_method = 'general' -- to use sumatraPDF as general viewer
		vim.g.vimtex_view_general_viewer = 'SumatraPDF'
		vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf "
			-- this option set forward search behavior,
			-- :VimtexView(<leader>lv) open a pdf if the viewer is not opened and do forward search if the viewer is opened
			-- -reverse-search cannot work in nvim-qt I thought. I have no idea
		vim.g.vimtex_compiler_method = 'latexmk' -- it supports continuous compile (compile when *.tex is saved)

		-- ////// configuration
		vim.g.vimtex_matchparen_enabled = 0 -- \begin <-> \end highlight

		-- //////// conceal setting
		local User_VimTex = vim.api.nvim_create_augroup('User_VimTex', {clear = true})
		vim.api.nvim_create_autocmd('FileType', {
			group = User_VimTex,
			pattern = {'tex', 'plaintex'},
			callback = function ()
				vim.opt_local.conceallevel = 2		-- raw char hide and latex symbols are shown in concealcursor mode
				-- vim.opt_local.concealcursor = 'nv'  -- which mode the latex symbols are shown
			end
		})

		-- /////// keymappings
		-- see :h vimtex-default-mappings
		-- <localleader>lt : toc open
		-- <localleader>lT : toc toggle
		-- <localleader>lv : vimtex view (forward search under cursor to pdf)
		-- <localleader>ll : vimtex compile (compile and open pdf file) - if retry, it will stop auto compile
		-- <localleader>lk : vimtex stop
		-- <localleader>lg : vimtex status
		-- <localleader>lq : vimtex log
		--
	end,
},
-- {
-- 	'micangl/cmp-vimtex',
-- 	lazy = false, -- Since nvim-cmp calls cmp-vimtex as a dependency, if lazy=true, it is called twice as a cmp source.
-- 				  -- although it is called from nvim-cmp as dependency, the source is duplicated if it is configured in dependencies of nvim-cmp
-- 				  -- it must be called ahead of nvim-cmp's cmp-vimtex
-- 				  -- It may seem to be silly, always call cmp-vimtex at start if I want to change configuration
-- 	enabled = true,
-- 	config = function ()
-- 		require('cmp_vimtex').setup({
-- 			additional_information = {
-- 				info_in_menu = false,       -- about citation
-- 				info_in_window = false,     -- about citation
-- 				info_max_length = 60,       -- about citation
-- 				match_against_info = false, -- about citation
-- 				symbols_in_menu = true,     -- show symbol in completion window
-- 			},
-- 			bibtex_parser = {
-- 				enabled = false,            -- it is used when i search for citation
-- 			},
-- 		})
-- 	end
-- },
-- 	'KeitaNakamura/tex-conceal.vim' : it aids to represent conceal of tex,
-- 									  After vimtex tag v2.0, it use own conceal which replaces tex-conceal.vim
-- 	'bamonroe/rnoweb-nvim' : it can be used without vimtex, but it show conceal of superscript / subsciprt not properly
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

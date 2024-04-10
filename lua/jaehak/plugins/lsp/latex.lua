return {
{
	-- requirement : 
	-- 1) scoop install tectonic ⇒ compiler
	-- 2) scoop install biber ⇒ syntax check / linting 
	-- 3) scoop install mupdf ⇒ PDF viewer
	'lervag/vimtex', -- it use lazy load default, do not set lazy 
	ft = {'tex'},
	init = function()

		vim.g.vimtex_view_method = 'mupdf'
		vim.g.vimtex_view_general_viewer = 'mupdf'
		-- vim.g.vimtex_view_general_options = "--unique file:@pdf\\#src:@line@tex"
		-- vim.g.vimtex_compiler_method = 'tectonic'
		vim.g.vimtex_compiler_method = 'generic'
		vim.g.vimtex_compiler_generic = {
			['command'] = 'ls *.tex | entr -c tectonic /_ --synctex --keep-logs'
		}

		vim.keymap.set('n', '<leader>lc', '<Cmd>VimtexCompile<CR>')
		vim.keymap.set('n', '<leader>lC', '<Cmd>VimtexCompileOutput<CR>')
		vim.keymap.set('n', '<leader>lv', '<Cmd>VimtexView<CR>')

	end,
},
{
	'micangl/cmp-vimtex',
	lazy = false, -- Since nvim-cmp calls cmp-vimtex as a dependency, if lazy=true, it is called twice as a cmp source.
				  -- although it is called from nvim-cmp as dependency, the source is duplicated if it is configured in dependencies of nvim-cmp
				  -- it must be called ahead of nvim-cmp's cmp-vimtex
				  -- It may seem to be silly, always call cmp-vimtex at start if I want to change configuration
	config = function ()
		require('cmp_vimtex').setup({
			additional_information = {
				info_in_menu = false,       -- about citation
				info_in_window = false,     -- about citation
				info_max_length = 60,       -- about citation
				match_against_info = false, -- about citation
				symbols_in_menu = true,     -- show symbol in completion window
			},
			bibtex_parser = {
				enabeld = false,            -- it is used when i search for citation
			},
		})
		-- vim.keymap.set('i','<C-i>',require('cmp_vimtex.search').search_menu)
	end
}
}

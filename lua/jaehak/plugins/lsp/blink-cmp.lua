return {
	'saghen/blink.cmp',
	version = '1.*',
	event = 'InsertEnter',
	opts = {
		keymap = { preset = 'default' },
		appearance = { nerd_font_variant = 'mono' },
		completion = {
			keyword = {
				range = 'prefix',
			},
			documentation = {
				auto_show = true
			},
		},
		sources = {
			default = {'lsp', 'path', 'snippets', 'buffer'},
			per_filetype = {
				lua = {'lsp', 'buffer'}
			},
			min_keyword_length = 0,
		},
		-- fuzzy = {
		-- 	implementation = 'prefer_rust_with_warning'
		-- }
	},
	opts_extend = {
		'sources.default'
	},
	config = function ()
		local capabilities = require('blink.cmp').get_lsp_capabilities()
		vim.lsp.config('*', {
			capabilities = capabilities,
		})
	end

}

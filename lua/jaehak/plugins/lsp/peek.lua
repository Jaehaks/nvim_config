return {
	-- markdown preview plugin
	'toppair/peek.nvim',
	-- event = {'VeryLazy'},
	ft = {'markdown'},
	-- need "deno" => choco install deno 
	build = 'deno task --quiet build:fast',
	config = function ()
		local peek = require('peek')
		peek.setup({
			auto_load = true, 	-- load preview when entering markdown buffer
			close_on_bdelete = true,  -- close preview on buffer delete
			app = 'webview',
		})

		vim.api.nvim_create_user_command('PeekOpen', peek.open, {})
		vim.api.nvim_create_user_command('PeekClose', peek.close, {})


		vim.keymap.set('n', '<leader>m', function ()
			if peek.is_open() then
				return peek.close()
			else
				return peek.open()
			end
		end,
		{desc = 'toggle markdown preview'})

	end
}

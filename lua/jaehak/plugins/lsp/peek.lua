return {
	-- markdown preview plugin
	-- BUG: (app = 'webview' only) if file open directly with double click, peekopen does not work 
	-- BUG: To execute peekopen function, you have to execute nvim-qt first and open the file lately
	'toppair/peek.nvim',
	-- event = {'VeryLazy'},
	ft = {'markdown'},
	-- need "deno" => choco install deno 
	-- build = 'deno task --quiet build:fast',
	config = function ()
		local peek = require('peek')
		peek.setup({
			auto_load = true, 	-- load preview when entering markdown buffer
			close_on_bdelete = true,  -- close preview on buffer delete
			app = 'browser',
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

return {
	'echasnovski/mini.nvim',
	enabled = false,
	version = false,
	event = 'VeryLazy',
	config = function()
		local notify = require('mini.notify')
		notify.setup()
		vim.notify = notify.make_notify({
			ERROR = { duration = 2000 },
			WARN = { duration = 2000 },
			INFO = { duration = 2000 },
		})

		vim.notify('error E1', vim.log.levels.ERROR)
	end
}

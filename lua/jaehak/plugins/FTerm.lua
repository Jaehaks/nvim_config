return {
{
	"numToStr/FTerm.nvim",
	enabled = false,
	config = function ()
		local fterm = require('FTerm')
		fterm.setup({
			ft = 'FTerm',
			border = 'rounded',
			cmd = 'cmd',
			dimensions = {
				height = 0.4,
				width = 0.9,
				x = 0.5,
				y = 0.9,
			}
		})

		vim.keymap.set('n', '<leader>tt',fterm.toggle, {desc = 'open FTerm'} )
	end
},
{
	'akinsho/toggleterm.nvim',
	-- enabled = false,
	version = '*',
	config = function ()
		require('toggleterm').setup({
			open_mapping = [[<leader>tt]],
			insert_mappings = false,
			terminal_mappings = false,
			autochdir = true,
			direction = 'float',
			-- shell = 'cmd.exe /k %userprofile%\\.config\\Dotfiles\\clink\\aliase.cmd'
			shell = function ()
				if vim.g.has_win32 == 1 then
					return 'cmd.exe /k %userprofile%\\.config\\Dotfiles\\clink\\aliase.cmd'
				else
					return '/usr/bin/zsh'
				end
			end

		})
	end
}
-- vim-floaterm : cannot select position in detail, but it seems faster than FTerm
}

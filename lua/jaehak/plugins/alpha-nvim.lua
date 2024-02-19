return {
	'goolord/alpha-nvim',
--	enabled = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
		local alpha = require('alpha')
		local dashboard = require('alpha.themes.dashboard')

		dashboard.section.buttons.val = {
			dashboard.button('e', '1 - New file',			':ene<CR>'),
			dashboard.button('r', '2 - Recent Files', 		'<Cmd>Telescope oldfiles<CR><Esc>'),
			dashboard.button('c', '3 - Folder : Config',	[[<Cmd>lua require("lir.float").toggle(vim.fn.stdpath("config") .. "/lua/jaehak/plugins")<CR>]]) -- open config folder 
		}

        alpha.setup(dashboard.config)	-- setting applyed 

		-- key mapping 
		vim.keymap.set('n', '<leader>a', '<Cmd>Alpha<CR>', {noremap = true})
    end
}


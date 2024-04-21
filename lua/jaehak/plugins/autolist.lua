return {
	-- add bullet automatically
	-- BUG: if indent executed by TAB, the numbering does not change automatically, you should use :AutolistRecalculate
	'gaoDean/autolist.nvim',
	ft = {'markdown', 'text'},
	config = function ()
		local autolist = require('autolist')
		autolist.setup({

		})

		local User_markdown = vim.api.nvim_create_augroup('User_markdown', {clear = true})
		vim.api.nvim_create_autocmd('FileType',{
			group = User_markdown,
			pattern = {'markdown', 'text'},
			callback = function ()
				local opts = {noremap = true, buffer = 0}
				vim.keymap.set('i', '<TAB>'     , '<Cmd>AutolistTab<CR>'             , opts)
				vim.keymap.set('i', '<S-TAB>'   , '<Cmd>AutolistShiftTab<CR>'        , opts)
				vim.keymap.set('i', '<CR>'      , '<CR><Cmd>AutolistNewBullet<CR>'   , opts)
				vim.keymap.set('n', 'o'         , 'o<Cmd>AutolistNewBullet<CR>'      , opts)
				vim.keymap.set('n', 'O'         , 'O<Cmd>AutolistNewBulletBefore<CR>', opts)
				vim.keymap.set('n', '<leader>mn', '<Cmd>AutolistCycleNext<CR>'       , opts)
				vim.keymap.set('n', '<leader>mr', '<Cmd>AutolistRecalculate<CR>'     , opts)
				vim.keymap.set('n', 'dd'        , 'dd<Cmd>AutolistRecalculate<CR>'   , opts)
				vim.keymap.set('v', 'd'         , 'd<Cmd>AutolistRecalculate<CR>'    , opts)
			end
		})

	end
}
-- bullets-vim/bullets.nvim : it does not work in neovim

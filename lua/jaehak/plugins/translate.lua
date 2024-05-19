return {
{
	'uga-rosa/translate.nvim',
	keys = {
		{'<leader>te', '<Cmd>Translate EN -output=floating<CR><Esc>', mode = {'n', 'v'}, desc = 'Translate to EN with floating'},
		{'<leader>tE', '<Cmd>Translate EN -output=replace<CR><Esc>' , mode = {'n', 'v'}, desc = 'Translate to EN with replace'} ,
		{'<leader>tk', '<Cmd>Translate KO -output=floating<CR><Esc>', mode = {'n', 'v'}, desc = 'Translate to KO with floating'},
		{'<leader>tK', '<Cmd>Translate kO -output=replace<CR><Esc>' , mode = {'n', 'v'}, desc = 'Translate to KO with replace'} ,
	},
	config = function ()
		local translate = require('translate')
		translate.setup({
			default = {
				commnad = 'google',
				output = 'floating',
			},
			preset = {
				command = {
					google = {
						args = { -- arguments to be passed to curl command
							'--retry',
							'5', -- retry when curl has error
						}
					}
				},
			},
			silent = true,
		})
	end
}
}
-- 'potamides/pantran.nvim' : using motion_translate or interactive mode, 'redraw' executes and it makes noisy background
-- 							  <cons> - visual translation don't work. it translate whole line always
-- 'uga-rosa/translate.nvim' : pantran.nvim is faster a bit little than translate. but it supports visual mode
-- 'niuiic/translate.nvim' : Not windows support (need translate-shell)
-- 'coffebar/crowtranslate.nvim' : Not windows support
-- 한글과 영어를 교차해서 번역할 수 있는 플러그인을 추가했다

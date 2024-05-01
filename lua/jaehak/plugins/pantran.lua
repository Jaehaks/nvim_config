return {
{
	'potamides/pantran.nvim',
	config = function ()
		local pantran = require('pantran')
		local actions = require('pantran.ui.actions')
		pantran.setup({
			default_engine = 'google',
			engines = {
				google = {
					-- default_source = 'ko',
					-- default_target = 'en' -- original default setting doesn't work, it will go fallback endpoint
					fallback = {
						default_source = 'ko',
						default_target = 'en'
					}
				}
			},
			controls = {
				mappings = {
					edit = {
						n = {
							['q'] = actions.close,
							['gr'] = actions.replace_close_translation,
							['ga'] = actions.append_close_translation,
							['gs'] = actions.switch_languages,

						}
					}
				}
			}

		})
		-- if you use motion_translate(), expr opts must be true. but it makes the background color noisy temporarily
		-- use replace mode : interactive mode makes background color noisy when I call Pantran in visual mode
		local opts = {noremap = true, silent = true, expr = false}
		vim.keymap.set({'n'}, '<leader>tw', ':Pantran source=ko target=en<CR>', vim.tbl_extend('keep',opts,{desc = 'show translate interactive window'}))
		vim.keymap.set({'v'}, '<leader>te', ':Pantran source=ko target=en mode=hover<CR>', vim.tbl_extend('keep',opts,{desc = 'hover ko -> en'}))
		vim.keymap.set({'v'}, '<leader>tE', ':Pantran source=ko target=en mode=replace<CR>', vim.tbl_extend('keep',opts,{desc = 'replace ko -> en'}))
		vim.keymap.set({'v'}, '<leader>tk', ':Pantran source=en target=ko mode=hover<CR>', vim.tbl_extend('keep',opts,{desc = 'hover en -> ko'}))
		vim.keymap.set({'v'}, '<leader>tK', ':Pantran source=en target=ko mode=replace<CR>', vim.tbl_extend('keep',opts,{desc = 'replace en -> ko'}))
	end
},
}
-- 'potamides/pantran.nvim' : using motion_translate or interactive mode, 'redraw' executes and it makes noisy background
-- 'uga-rosa/translate.nvim' : pantran.nvim is faster to translate. but it supports floating window
-- 'niuiic/translate.nvim' : Not windows support (need translate-shell)
-- 'coffebar/crowtranslate.nvim' : Not windows support
-- 한글과 영어를 교차해서 번역할 수 있는 플러그인을 추가했다 

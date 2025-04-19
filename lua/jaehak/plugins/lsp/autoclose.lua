local paths = require('jaehak.core.paths')
return {
	-- tpope/vim-endwise : it doesn't work
	-- ultimate-autopair.nvim  : it is too bulky and slow
	-- m4xshen/autoclose.nvim : more simple, but it cannot ignore like the "'" in "'don't"
	-- 							and it change some keymaps in settings automatically
	-- 'echasnovski/mini.pairs' : it works good and is lightweight but has some bugs with completion plugins
	-- 							  It supports auto indent when I enter <CR> inside {}, but this way use keycodes
	-- 							  not function. it returns the characters like '\r'
	-- 							  It returns original <CR> behavior when I execute fallback() for <CR> in blink.cmp
	-- 'windwp/nvim-autopairs' : it is lightweight if I don't use `check_ts`
	-- 							 it supports auto indent when I enter <CR> even though fallback() is executed
	-- 							 it supports adding endwise rule also without treesitter-endwise
{
	'windwp/nvim-autopairs',
	keys = {
		{'(', mode = {'i'}},
		{'[', mode = {'i'}},
		{'{', mode = {'i'}},
		{'<', mode = {'i'}},
		{')', mode = {'i'}},
		{']', mode = {'i'}},
		{'}', mode = {'i'}},
		{'>', mode = {'i'}},
		{'"', mode = {'i'}},
		{"'", mode = {'i'}},
		{"`", mode = {'i'}},
	},
	opts = {
		disable_filetype = {
		    "TelescopePrompt",
		    "spectre_panel",
		    "snacks_picker_input",
			"dashboard"
		},
		ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
		check_ts = false, -- don't use treesitter
		map_cr = true, -- make {|} to indented brackets
		map_bs = true,
		map_c_h = false,
		map_c_w = false,
	},
	config = function (_, opts)
		local npairs = require('nvim-autopairs')
		local Rule = require('nvim-autopairs.rule')
		local basic = require('nvim-autopairs.rules.basic')
		local endwise = require('nvim-autopairs.ts-rule').endwise

		-- nvim-autopairs setup
		npairs.setup(opts)

		-- additional rules
		local bracket = basic.bracket_creator(opts)
		npairs.add_rules({
			bracket('<','>')
		})




		-- endwise setup without treesitter
		npairs.add_rules({
			-- lua
			endwise('then$', 'end', 'lua', 'if_statement'),                    -- if  <right condition> then
			endwise('do$', 'end', 'lua', 'for_statement'),                     -- for <right condition> do
			endwise('do$', 'end', 'lua', 'while_statement'),                   -- while <right condition> do
			endwise('do$', 'end', 'lua', 'do_statement'),                      -- do <right condition> do
			endwise('function.*$', 'end', 'lua', 'function_declaration'),      -- local function a()
			endwise('function.*%(.*%)$', 'end', 'lua', 'function_definition'), -- local a = function()
		})

	end
},
{
	-- more simple and smart / but it cannot support filetype
	'echasnovski/mini.pairs',
	enabled = false,
	version = false,
	keys = {
		{'(', mode = {'i'}},
		{'[', mode = {'i'}},
		{'{', mode = {'i'}},
		{'<', mode = {'i'}},
		{')', mode = {'i'}},
		{']', mode = {'i'}},
		{'}', mode = {'i'}},
		{'>', mode = {'i'}},
		{'"', mode = {'i'}},
		{"'", mode = {'i'}},
		{"`", mode = {'i'}},
	},
	opts = {
		modes = { insert = true, command = true, terminal = true },

		mappings = {
			['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
			['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
			['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },
			['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].' },

			[')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
			[']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
			['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },
			['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].' },

			['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
			["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\%]\'].', register = { cr = false } },
			['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\%`].', register = { cr = false } },
		},
	}
},
{
	-- auto highlight to brackets
	-- if you use treesitter highlight, must use the rainbow plugins that use treesitter grammar, not regex
	-- I'll make matlab query some days
	'HiPhish/rainbow-delimiters.nvim',
	lazy = true, -- from nvim-treesitter
	opts = function()
		local rainbow_delimiters = require('rainbow-delimiters')
		return {
			strategy = {
				[''] = function(bufnr)
					local lc = vim.api.nvim_buf_line_count(bufnr)
					if lc > 5000 then
						return nil -- although it return nil, delimiters make slow read performance
					end
					return rainbow_delimiters.strategy['global']
				end,
			},
			priority = {
				[''] = 110,
				lua = 210,
			},
			query = {
				[''] = 'rainbow-delimiters',
				-- matlab query for delimiters is added. Confirmed it works
				-- copy directory "nvim/queries/rainbow-delimiters.nvim/matlab"  to "nvim-data/lazy/rainbow-delimiters.nvim/queries"
			},
			highlight = {
				'RainbowDelimiterRed',
				'RainbowDelimiterYellow',
				'RainbowDelimiterBlue',
				'RainbowDelimiterOrange',
				'RainbowDelimiterGreen',
				'RainbowDelimiterViolet',
				'RainbowDelimiterCyan',
			},
		}
	end,
	config = function (_, opts)
		-- This module contains a number of default definitions
		local rainbow_delimiters_setup = require('rainbow-delimiters.setup')

		-- rainbow_delimiters.config
		rainbow_delimiters_setup.setup(opts)

		-- if there is not matlab query directory, make it
		local source_dir = paths.nvim.rainbow_queries .. '\\matlab\\'
		local dest_dir = paths.data_dir .. '\\lazy\\rainbow-delimiters.nvim\\queries\\matlab\\'
		vim.uv.fs_scandir(dest_dir , function (err, userdata)
			if err then
				vim.uv.fs_mkdir(dest_dir, 777) -- make directory 'matlab'
				vim.uv.fs_copyfile(source_dir .. 'rainbow-delimiters.scm', dest_dir .. 'rainbow-delimiters.scm')
			end
		end)
	end
},
{
	-- show matchparen of current region
	"utilyre/sentiment.nvim",
	version = "*",
	ft = paths.Filetypes.ForCode,
	-- event = "VeryLazy", -- keep for lazy loading
	opts = {
		pairs = {
			{ '(', ')' },
			{ '{', '}' },
			{ '[', ']' },
			{ '<', '>' },
		}
	},
	init = function()
		vim.g.loaded_matchparen = 1

		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "*",
			callback = function ()
				if vim.bo.filetype == 'markdown' then
					require('sentiment').disable()
				else
					require('sentiment').enable()
				end
			end
		})

	end,
}
}


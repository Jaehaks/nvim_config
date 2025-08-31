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
	-- 							 but it cannot supports autoclose in cmdline
{
	'windwp/nvim-autopairs',
	-- event = 'InsertEnter',
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
		map_cr   = true,  -- make {|} to indented brackets
		map_bs   = true,
		map_c_h  = false,
		map_c_w  = false,
		fast_wrap = { -- add close parentheses like flash.nvim
			map = '<M-e>', -- do this at cursor | in "(|test test1 test" in insert mode
			end_key = '$',
			before_key = 'h', -- use 'H' if you want to set cursor to (test|) rather than (|test)
			after_key = 'l', -- use 'L' if you want to set cursor to (test)| rather than (test|) -- BUT BUG here
			cursor_pos_before = true,
		},
	},
	config = function (_, opts)
		local npairs  = require('nvim-autopairs')
		local Rule    = require('nvim-autopairs.rule')
		local cond    = require('nvim-autopairs.conds')
		local ts_cond = require('nvim-autopairs.ts-conds')
		local endwise = require('nvim-autopairs.ts-rule').endwise

		-- nvim-autopairs setup
		npairs.setup(opts)

		-- remove rules
		npairs.remove_rule('```') -- ``` makes one more ``` by default.
		npairs.get_rules("`")[1]:with_pair(cond.not_before_regex("[%w%`]")) -- ignore autopair after ``, it makes ```

		-- additional rules
		npairs.add_rules({
			Rule('<','>'):with_cr(cond.done()),

			-- ====== endwise setup without treesitter =================
			-- lua
			endwise('then$', 'end', 'lua', 'if_statement'),    -- if  <right condition> then
			endwise('do$'  , 'end', 'lua', 'for_statement'),   -- for <right condition> do
			endwise('do$'  , 'end', 'lua', 'while_statement'), -- while <right condition> do
			endwise('do$'  , 'end', 'lua', 'do_statement'),    -- do <right condition> do
			endwise('repeat$'  , 'until', 'lua', 'do_statement'),    -- do <right condition> do
			endwise('function.*%(.*%)$', 'end', 'lua', {'function_definition', 'local_function', 'function'}), -- function

			-- matlab
			endwise('if%s.+$'      , 'end', 'matlab', 'ERROR'), -- it doesn't work in comment node
			endwise('while%s.+$'   , 'end', 'matlab', 'ERROR'),
			endwise('for%s.+$'     , 'end', 'matlab', 'ERROR'),
			endwise('switch.*$'    , 'end', 'matlab', 'ERROR'),
			endwise('try.*$'       , 'end', 'matlab', 'ERROR'),
			endwise('classdef%s.+$', 'end', 'matlab', 'ERROR'),
			endwise('properties.*$', 'end', 'matlab', {'class_definition', 'methods'}),
			endwise('methods.*$'   , 'end', 'matlab', {'class_definition', 'methods'}),
			endwise('function%s.+$', 'end', 'matlab', 'ERROR'),

			-- sh, zsh
			endwise('then$', 'fi', 'sh', 'if_statement'),    -- if  <right condition> then
			endwise('do$', 'done', 'sh', 'for_statement'),    -- for  <right condition> do
			endwise('do$', 'done', 'sh', 'while_statement'),    -- while  <right condition> do
			endwise('do$', 'done', 'sh', 'until_statement'),    -- until  <right condition> do
			endwise('in$', 'esac', 'sh', 'case_statement'),    -- until  <right condition> do
		})

		-- overwrite <CR> in brackets to implement unified operation (avoid <CR> of autopairs)
		vim.keymap.set('i', '<CR>', function() -- smart enter for brackets
			return require('jaehak.core.smart_cr').smart_enter()
		end, { noremap = true, silent = true, desc = 'Smart enter in brackets' })
	end
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
		local source_dir = require('jaehak.core.paths').nvim.rainbow_queries .. '\\matlab\\'
		local dest_dir = require('jaehak.core.paths').data_dir .. '\\lazy\\rainbow-delimiters.nvim\\queries\\matlab\\'
		if not vim.g.has_win32 then
			string.gsub(source_dir, '\\', '/')
			string.gsub(dest_dir, '\\', '/')
		end
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
	ft = require('jaehak.core.paths').Filetypes.ForCode,
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


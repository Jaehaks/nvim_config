return {
	-- tpope/vim-endwise : it doesn't work
	-- ultimate-autopair.nvim  : it is too bulky and slow
	-- m4xshen/autoclose.nvim : more simple, but it cannot ignore like the "'" in "'don't"
	-- 							and it change some keymaps in settings automatically
	-- 'echasnovski/mini.pairs' : it works good and is lightweight but has some bugs with completion plugins
	-- 							  It supports auto indent when I enter <CR> inside {}, but this way use keycodes
	-- 							  not function. it returns the characters like '\r'
	-- 							  It returns original <CR> behavior when I execute fallback() for <CR> in blink.cmp
	--
	-- 							  I come back to mini.pairs to insert auto-pairs.
	-- 							  It supports autopairs in cmdline but it doesn't support indented
	-- 							  parentheses of pairs after new neovim version if you use blink-cmp. the
	-- 							  fallback() of blink.cmp prevent to proper operation of <CR> in brackets
	-- 							  because it implement this feature using replacing keycodes.
	--
	-- 							  If you use both `nvim-autopairs` and `mini.pairs` simultaneously,
	-- 							  Mappings of <CR> are conflicted and don't work one of them.
	-- 'windwp/nvim-autopairs' : it is lightweight if I don't use `check_ts`
	-- 							 it supports auto indent when I enter <CR> even though fallback() is executed
	-- 							 it supports adding endwise rule also without treesitter-endwise
	-- 							 but it cannot supports autoclose in cmdline
	--
	-- 					 		 nvim-autopairs supports endwise and auto pair.
	-- 					 		 But it doesn't support autopairs in cmdline and cannot separate between indented
	-- 					 		 parentheses of pairs and endwise function.
	-- 					 		 It can change the indented parentheses by changing rule with O<TAB>,
	-- 					 		 It doesn't show to consistent behavior according to languages.
	-- 					 		 Because indentexpr is different by languages, shiftwidth is changed by 2
	-- 					 		 times of vim.bo.shiftwidth and it makes double indentation. It makes me
	-- 					  		 confused.
	-- 							 And It has some bug that some parentheses cannot be applied what I set
	-- 							 rule although I set with the same method with other brackets.

{
	'Jaehaks/smart_cr.nvim',
	opts = {

	},
	config = function (_, opts)
		require('smart_cr').setup(opts)

		vim.keymap.set('i', '<CR>', function() -- smart enter for brackets
			local bracket = require('smart_cr').bracket.bracket_cr()
			local endwise = require('smart_cr').endwise.endwise_cr()

			if not bracket and not endwise then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
			end
		end, { noremap = true, silent = true, desc = 'Smart enter in brackets' })
	end

},
{
	'windwp/nvim-autopairs',
	enabled = false,
	event = 'InsertEnter',
	opts = {
		disable_filetype = {
		    "TelescopePrompt",
		    "spectre_panel",
		    "snacks_picker_input",
			"dashboard"
		},
		ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
		check_ts = false, -- don't use treesitter
		map_cr   = false,  -- make {|} to indented brackets
		map_bs   = false,
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

		npairs.remove_rule('`') -- ``` makes one more ``` by default.
		npairs.remove_rule('\'') -- ``` makes one more ``` by default.
		npairs.remove_rule('"') -- ``` makes one more ``` by default.
		npairs.remove_rule('<') -- ``` makes one more ``` by default.
		npairs.remove_rule('(') -- ``` makes one more ``` by default.
		npairs.remove_rule('{') -- ``` makes one more ``` by default.
		npairs.remove_rule('[') -- ``` makes one more ``` by default.

		-- additional rules
		npairs.add_rules({

			-- ====== endwise setup without treesitter =================
			-- lua
			endwise('then$', 'end', 'lua', 'if_statement'),    -- if  <right condition> then
			endwise('do$'  , 'end', 'lua', 'for_statement'),   -- for <right condition> do
			endwise('do$'  , 'end', 'lua', 'while_statement'), -- while <right condition> do
			endwise('do$'  , 'end', 'lua', 'do_statement'),    -- do <right condition> do
			endwise('repeat$'  , 'until', 'lua', 'do_statement'),    -- do <right condition> do
			endwise('function.*%(.*%)$', 'end', 'lua', {'function_call', 'function_definition', 'local_function', 'function'}), -- function

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
			endwise('then$', 'fi', 'sh', {'ERROR', 'if_statement'}),    -- if  <right condition> then
			endwise('do$', 'done', 'sh', {'ERROR', 'for_statement'}),    -- for  <right condition> do
			endwise('do$', 'done', 'sh', {'ERROR', 'while_statement'}),    -- while  <right condition> do
			endwise('do$', 'done', 'sh', {'ERROR', 'until_statement'}),    -- until  <right condition> do
			endwise('in$', 'esac', 'sh', {'ERROR', 'case_statement'}),    -- until  <right condition> do
		})

		-- overwrite <CR> in brackets to implement unified operation (avoid <CR> of autopairs)
	end
},
{
	-- more simple and smart / but it cannot support filetype
	'echasnovski/mini.pairs',
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
			['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].', register = { cr = false }  },
			['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].', register = { cr = false }  },
			['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].', register = { cr = false }  },
			['<'] = { action = 'open', pair = '<>', neigh_pattern = '[^\\].', register = { cr = false }  },

			[')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].', register = { cr = false }   },
			[']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].', register = { cr = false }   },
			['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].', register = { cr = false }   },
			['>'] = { action = 'close', pair = '<>', neigh_pattern = '[^\\].', register = { cr = false }   },

			['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
			["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\%]\'].', register = { cr = false } },
			['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\%`].', register = { cr = false } },
		},
	},
	-- config = function ()

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
				latex = 210,
			},
			query = {
				[''] = 'rainbow-delimiters',
				latex = 'rainbow-blocks', -- remove rainbow-blocks's error code to proper work
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
		local function add_scm(ts_name)
			local source_dir = require('jaehak.core.paths').nvim.rainbow_queries .. '\\' .. ts_name .. '\\'
			local dest_dir = require('jaehak.core.paths').data_dir .. '\\lazy\\rainbow-delimiters.nvim\\queries\\' .. ts_name .. '\\'
			if not vim.g.has_win32 then
				string.gsub(source_dir, '\\', '/')
				string.gsub(dest_dir, '\\', '/')
			end
			vim.uv.fs_scandir(dest_dir , function (err, _)
				if err then
					vim.uv.fs_mkdir(dest_dir, 777) -- make directory 'matlab'
					vim.uv.fs_copyfile(source_dir .. 'rainbow-delimiters.scm', dest_dir .. 'rainbow-delimiters.scm')
				end
			end)
		end

		add_scm('matlab')
		-- In  case of filetype tex, it use `latex` treesitter,
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


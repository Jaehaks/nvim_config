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
			local endwise = require('smart_cr').endwise.endwise_cr('<CR>')

			if not bracket and not endwise then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
			end
		end, { noremap = true, silent = true, desc = 'Smart enter in brackets' })

		vim.keymap.set('n', 'o', function()
			local endwise = require('smart_cr').endwise.endwise_cr('o')

			if not endwise then
				vim.api.nvim_feedkeys('o', "n", false)
			end
		end, { noremap = true, silent = true, desc = 'Smart enter in brackets' })
	end

},
{
	-- more simple and smart / but it cannot support filetype
	'echasnovski/mini.pairs',
	version = false,
	keys = {
		{'(', mode = {'i', 'c'}},
		{'[', mode = {'i', 'c'}},
		{'{', mode = {'i', 'c'}},
		{'<', mode = {'i', 'c'}},
		{')', mode = {'i', 'c'}},
		{']', mode = {'i', 'c'}},
		{'}', mode = {'i', 'c'}},
		{'>', mode = {'i', 'c'}},
		{'"', mode = {'i', 'c'}},
		{"'", mode = {'i', 'c'}},
		{"`", mode = {'i', 'c'}},
		{"$", mode = {'i', 'c'}},
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
	config = function (_, opts)
		local minipairs = require('mini.pairs')
		minipairs.setup(opts)

		--------------------------------------------------
		-- Create symmetrical `$$` pair for these filetype
		--------------------------------------------------
		-- mini.pair doesn't support filetype option
		local ft_list = {'markdown', 'tex', 'plaintex', 'latex'}
		local function tex_mapping(args)
			minipairs.map_buf(args.buf, 'i', '$', { action = 'closeopen', pair = '$$'})
		end

		-- Create autocmd for filetype (but the event doesn't work buffer opened before plugin is loaded)
		vim.api.nvim_create_autocmd('FileType', {
			pattern = ft_list,
			callback = tex_mapping,
		})

		-- Apply mapping to existing buffer
		for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(bufnr) then
				local ft = vim.api.nvim_get_option_value("filetype", {buf = bufnr})
				if vim.tbl_contains(ft_list, ft) then
					tex_mapping({buf = bufnr})
				end
			end
		end
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
				latex = 210,
			},
			query = {
				[''] = 'rainbow-delimiters',
				latex = 'rainbow-delimiters-my', -- remove rainbow-blocks's error code to proper work
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

		-- In  case of filetype tex, it use 'latex' treesitter,

		-- /////////// custom query /////////////
		-- If you want to add new custom rainbow queries, add 'nvim/after/queries/<filetype>/<any_query_name>.scm'
		-- and add <filetype> = '<any_query_name>' to `query` field of rainbow-delimiters.
		-- If you use 'rainbow-delimiters' as <any_query_name>, it is included in [''] = 'rainbow-delimiters'
		-- It doesn't overwrite original query of the filetype by nvim-treesitter. it seems adding.
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


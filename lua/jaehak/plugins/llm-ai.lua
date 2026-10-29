return {
{
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		focus_after_send = false,
		track_selection = false,
		terminal = {
			split_side = 'right',
			split_width_percentage = 0.40,
		},
	},
	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSelectModel",
		"ClaudeCodeAdd",
		"ClaudeCodeSend",
		"ClaudeCodeTreeAdd",
		"ClaudeCodeStatus",
		"ClaudeCodeStart",
		"ClaudeCodeStop",
		"ClaudeCodeOpen",
		"ClaudeCodeClose",
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
		"ClaudeCodeCloseAllDiffs",
	},
	keys = {
		{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
		-- { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
		{
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file from file picker",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
		},
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
	},
	config = function (_, opts)
		require('claudecode').setup(opts)

		--- find terminal bufnr of claude
		---@return integer? terminal bufnr
		local function find_claude_term()
			for _, b in ipairs(vim.api.nvim_list_bufs()) do
				if vim.bo[b].buftype == 'terminal'
					and vim.api.nvim_buf_get_name(b):lower():match('claude') then
					return b
				end
			end
		end


		local function send_text(text, submit)
			local term = find_claude_term()
			if not term then
				vim.notify('Claude terminal not found', vim.log.levels.ERROR)
				return false
			end
			local chan = vim.bo[term].channel
			vim.fn.chansend(chan, '\27[200~' .. text .. '\27[201~')
			if submit then
				vim.defer_fn(function() vim.fn.chansend(chan, '\r') end, 80)
			end
			return true
		end

		local function focus_term()
			local term = find_claude_term()
			local win = term and vim.fn.bufwinid(term) or -1
			if win ~= -1 then
				vim.api.nvim_set_current_win(win)
				vim.cmd('startinsert')
			end
		end

		local function open()
			local buf = vim.api.nvim_create_buf(false, false)
			vim.api.nvim_buf_set_name(buf, 'claude-prompt://' .. buf) -- If no name is found, :w fails with E32
			vim.bo[buf].buftype = 'acwrite' -- Intercept :w with BufWriteCmd
			vim.bo[buf].bufhidden = 'wipe'
			vim.bo[buf].swapfile = false
			vim.bo[buf].filetype = 'markdown'

			vim.cmd('botright 12split')
			vim.api.nvim_win_set_buf(0, buf)

			vim.api.nvim_create_autocmd('BufWriteCmd', {
				buffer = buf,
				callback = function()
					local text = vim.trim(table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n'))
					if text == '' then
						vim.bo[buf].modified = false
						return
					end
					if send_text(text, false) then
						vim.api.nvim_buf_set_lines(buf, 0, -1, false, {}) -- Clear sent content
						vim.bo[buf].modified = false
					end
					-- Since 'modified' is retained upon transmission failure, the 'q' in :wq is blocked by E37, preserving the content.
				end,
			})

			-- Return to Claude Terminal when the window is closed and the buffer is wiped
			vim.api.nvim_create_autocmd('BufWipeout', {
				buffer = buf,
				callback = function() vim.schedule(focus_term) end,
			})

			-- @ File completion (previous step code)
			vim.bo[buf].completefunc = "v:lua.require'claude_scratch'.complete"
			vim.keymap.set('i', '@', '@<C-x><C-u>', { buffer = buf })
			vim.cmd('startinsert')
		end

		--- Send visual selection range to Claude as @File#LStart-End
		local function claudevisualadd()
			local s, e = vim.fn.line('v'), vim.fn.line('.')
			if s > e then s, e = e, s end
			vim.cmd('normal! \27')  -- exit visual mode
			local file = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
			vim.cmd(('ClaudeCodeAdd %s %d %d'):format(file, s, e))
		end

		--- keymap
		vim.keymap.set('x', '<leader>as', claudevisualadd, { desc = 'Send selection to Claude' })
		vim.keymap.set({ 't' }, '<C-g>', function() open() end)
	end

	-- <C-o> in claude : 'scroll mode' in terminal
	-- 					 In normal mode, the cursor can be moved but it doesn't mean that is can scroll.
	-- 					 scroll mode is independent feature in native Claude
	-- 					 put 'q' to go out from scroll mode
	-- 					 'g', 'G', 'j' 'k', 'c-d', 'c-u' is supported
	-- 					 you can change keybindings in ~/.claude/keybindings.json
}
}

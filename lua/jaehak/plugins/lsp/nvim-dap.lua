local dap_ft = {'python', 'matlab'}
return {
{
	'Jaehaks/nvim-dap',
	ft = dap_ft,
	config = function ()
		local dap = require('dap')
		-- dap.set_log_level('TRACE')

		vim.keymap.set('n', '<leader>dr', function ()
			local session = dap.session()
			if session and not session.stopped_thread_id then
				dap.close() -- if debug run is completed but session is remaining
			end
			dap.continue()
		end, {desc = '[nvim-dap] Debug Run/continue'})
		vim.keymap.set('n', '<leader>dc', dap.run_to_cursor, {desc = '[nvim-dap] Debug Run to Cursor'})
		vim.keymap.set('n', '<F10>', dap.step_over, {desc = '[nvim-dap] Debug Step Over'})
		vim.keymap.set('n', '<F11>', dap.step_into, {desc = '[nvim-dap] Debug Step Into'})
		vim.keymap.set('n', '<F12>', dap.step_out, {desc = '[nvim-dap] Debug Step Out'})
		vim.keymap.set('n', '<leader>dp', dap.pause, {desc = '[nvim-dap] Debug Pause'})
		vim.keymap.set('n', '<leader>dt', dap.terminate, {desc = '[nvim-dap] Terminate Session'})
		vim.keymap.set('n', '<leader>du', dap.clear_breakpoints, {desc = '[nvim-dap] Clear all Breakpoints'})
		vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, {desc = '[nvim-dap] Set Breakpoint '})
		vim.keymap.set('n', '<leader>dB', function ()
			local condition = vim.fn.input('condition : ') -- insert condition without 'if' word.
			if condition and condition ~= '' then
				dap.toggle_breakpoint(condition)
			end
		end, {desc = '[nvim-dap] Set conditional Breakpoint '})
	end
},
{
	'Jaehaks/nvim-dap-matlab',
	ft = {'matlab'},
	dependencies = {
		'Jaehaks/nvim-dap',
	},
	opts = {
		repl = {
			keymaps = {
				previous_command_history = '<C-j>',
				next_command_history = '<C-k>',
			}
		}

	},
},
{
	'mfussenegger/nvim-dap-python',
	ft = {'python'},
	dependencies = {
		'Jaehaks/nvim-dap'
	},
	config = function ()
		-- setup() must accepts python path which is in venv of debugpy
		local debugpy_path = require('jaehak.core.paths').nvim.debugpy_python
		require('dap-python').setup(debugpy_path)
		-- require('dap-python').setup('uv')

	end
},
{
	'igorlfs/nvim-dap-view',
	keys = {
		{'<leader>dv', function () require('dap-view').toggle() end, desc = '[dap-view] Toggle dap view', mode = 'n'}
	},
	ft = dap_ft,
	opts = {
		winbar = {
			sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", 'console' },
			default_section = 'repl',
		},
		auto_toggle = true, -- open automatically, remain after normally termination but close after error while debug.
	},
	config = function (_, opts)
		local dap_view = require('dap-view')
		local dap = require('dap')

		dap_view.setup(opts)
		vim.keymap.set('n', '<leader>da', function ()
			local session = dap.session()
			if session and not session.stopped_thread_id then
				dap_view.add_expr()
			end
		end, {desc = '[nvim-dap] Debug Add variable to Watch'})
	end
	-- keymaps-------
	-- breakpoints
	-- 		<CR> : jump to breakpoints
	-- 		d : delete breakpoint
	-- watches
	-- 		<CR> : expand/collapse
	-- 		a : append an expression
	-- 		i : insert an expression
	-- 		d : delete an expression
	-- 		e : edit an expression
	-- 		s : set value
}
}

--[[ Understanding about dap

1) debugpy vs debugpy.adapter

- debugpy is debugger which supports debugging feature. it is executed with target python code.
  It needs to installed where the python program which you executes.

- debugpy.adapter is adapter which has responsibility to communicate between DAP of neovim and debugger.
  It transforms request of DAP command to form which debugpy can understand
  It is executed by independent process. Responsible only for communications

- If you use nvim-dap-python? it just supports how to configure the dap for python and give some more dap functions to useful usage.

2) workflow

nvim-dap -> debugpy.adapter -> debugpy -> python code
debugpy.adapter will create python process from `pythoPath` in configuration.
In this process, debugpy will be loaded automatically when you executes python code.


--]]

return {
{
	'Jaehaks/nvim-dap',
	config = function ()
		local dap = require('dap')
		-- dap.set_log_level('TRACE')

		dap.adapters.debugpy = {
			type = 'executable',
			command = os.getenv('HOME') .. '\\.config\\nvim-data\\mason\\bin\\debugpy-adapter.cmd'
		}

		vim.keymap.set('n', '<F5>', function ()
			local session = dap.session()
			if session and not session.stopped_thread_id then
				dap.close() -- if debug run is completed but session is remaining
			end
			dap.continue()
		end, {desc = '[nvim-dap] Debug Run/continue'})
		vim.keymap.set('n', '<F10>', dap.step_over, {desc = '[nvim-dap] Debug Step Over'})
		vim.keymap.set('n', '<F11>', dap.step_into, {desc = '[nvim-dap] Debug Step Into'})
		vim.keymap.set('n', '<F12>', dap.step_out, {desc = '[nvim-dap] Debug Step Out'})
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
	dependencies = {
		'Jaehaks/nvim-dap',
	},
	opts = {

	},
},
{
	'igorlfs/nvim-dap-view',
	opts = {}
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

-- Thank to kls1991 from https://github.com/keaising/im-select.nvim/issues/20

-- TODO:
-- When I type some Korean word in insert mode and out to normal mode using ESC,
-- The korean IME is remained so I cannot normal operation directly. It must need to change IME to English
-- This workflow is too annoying. So autocmd to change IME automatically is needed
-- im-select.exe can be solution but it is too old repository and doesn't work.

local ffi = require('ffi') -- get inherit ffi lua module to integrate c lang and la

-- declare c definition
ffi.cdef [[
    typedef unsigned int UINT, HWND, WPARAM;
    typedef unsigned long LPARAM, LRESULT;
    LRESULT SendMessageA(HWND hWnd, UINT Msg, WPARAM wParam, LPARAM lParam);
    HWND ImmGetDefaultIMEWnd(HWND unnamedParam1);
    HWND GetForegroundWindow();
]]

local user32 = ffi.load "user32.dll"
local imm32 = ffi.load "imm32.dll"
local ime_hwnd

local WM_IME_CONTROL = 0x283
local IMC_GETCONVERSIONMODE = 0x001
local IMC_SETCONVERSIONMODE = 0x002

-- Korean/English IME mode values
-- It is tested by get_ime_mode() for each IME mode
local ime_mode_kr = 1
local ime_mode_en = 0

-- set IME mode
local function set_ime_mode(mode)
    return user32.SendMessageA(ime_hwnd, WM_IME_CONTROL, IMC_SETCONVERSIONMODE, mode)
end

-- get IME mode
local function get_ime_mode()
    return user32.SendMessageA(ime_hwnd, WM_IME_CONTROL, IMC_GETCONVERSIONMODE, 0)
end

-- #############################################
-- ### Set autocmd for transition of IME #######
-- #############################################

-- Get the IME handler associated with the Neovim window
-- Runs only once when an InsertEnter/CmdlineEnter event occurs.
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
    group = 'UserSettings',
    once = true,
    desc = "Get ime control hwnd attached to nvim window",
    callback = function()
        ime_hwnd = imm32.ImmGetDefaultIMEWnd(user32.GetForegroundWindow())
		vim.g.ime_mode_in_insert = get_ime_mode()
    end,
})

-- Automatically switches IME to English mode when returning to Normal mode.
vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
    group = 'UserSettings',
    desc = "Switch IME to English mode when entering Normal mode",
    callback = function()
		vim.g.ime_mode_in_insert = get_ime_mode() -- save current IME mode
        if ime_mode_kr == vim.g.ime_mode_in_insert then
            set_ime_mode(ime_mode_en)
        end
    end,
})

-- Automatically switches IME to Korean mode when entering Insert mode.
vim.api.nvim_create_autocmd("InsertEnter", {
    group = 'UserSettings',
    desc = "Switch IME to Korean mode when entering insert mode",
    callback = function()
		if vim.g.ime_mode_in_insert ~= get_ime_mode() then
			set_ime_mode(vim.g.ime_mode_in_insert)
		end
    end,
})

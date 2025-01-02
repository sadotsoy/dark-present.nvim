---
---@module 'dark_present._core.create_window'
---

local M = {}

local api = vim.api

---@type vim.api.keyset.win_config
local dark_present_window_config = {
	relative = "editor",
	width = vim.o.columns,
	height = vim.o.lines,
	border = "none",
	col = 0,
	row = 0,
}

local function get_lines_by_separator(buffnr)
	local buff_lines = api.nvim_buf_get_lines(buffnr, 0, -1, false)

	local separator = "^#s+.*"

	for i = 1, #buff_lines do
		vim.api.nvim_echo({ { string.format("i: %d %s", i, buff_lines[i]) } }, true, {})
	end
end

local function create_buffer()
	return api.nvim_create_buf(true, false)
end

function M.create_window()
	-- Create buffer
	-- local buffnr = create_buffer()

	get_lines_by_separator(1)

	-- api.nvim_open_win(buffnr, true, dark_present_window_config)
end

M.create_window()

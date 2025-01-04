---
---@module 'dark_present._core.create_window'
---

local on_attach_core = require("dark_present._core.on_attach")

local slides_core = require("dark_present._core.slides")

local M = {}

local api = vim.api
local width = vim.o.columns
local height = vim.o.lines

---@type vim.api.keyset.win_config
local dark_present_window_config = {
	float_bg = {
		relative = "editor",
		width = width,
		height = height,
		style = "minimal",
		border = "none",
		col = 0,
		row = 0,
		zindex = 1,
	},
	float_header = {
		relative = "editor",
		width = width,
		height = 1,
		style = "minimal",
		border = "rounded",
		col = 0,
		row = 0,
		zindex = 2,
	},
	float_body = {
		relative = "editor",
		width = width - 20,
		height = height - 6,
		style = "minimal",
		border = { " ", " ", " ", " ", " ", " ", " ", " " },
		col = 20,
		row = 3,
		zindex = 2,
	},
}

---Function that creates a floating window
---@param config vim.api.keyset.win_config
---@param enter? boolean
---@return dark_present.Window
function M.create_floating_window(config, enter)
	enter = enter or false
	local bufnr = api.nvim_create_buf(false, true)

	local winnr = api.nvim_open_win(bufnr, enter, config)

	return {
		bufnr = bufnr,
		winnr = winnr,
	}
end

---Function that creates the presentation
---@param bufnr number
function M.create_presentation(bufnr)
	---@type Slides
	local slides = slides_core.get_slides(bufnr)
	if slides == nil then
		return
	end

	---@type dark_present.Windows
	---@diagnostic disable-next-line: missing-fields
	local windows = {}

	for window, config in pairs(dark_present_window_config) do
		if window == "float_body" then
			windows[window] = M.create_floating_window(config, true)
		else
			windows[window] = M.create_floating_window(config)
		end
	end

	-- Call attachments
	on_attach_core.on_attach(windows, slides)
end

return M

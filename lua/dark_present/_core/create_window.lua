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
	header = {
		relative = "editor",
		width = width,
		height = 1,
		style = "minimal",
		border = "rounded",
		col = 0,
		row = 0,
		zindex = 2,
	},
	body = {
		relative = "editor",
		width = width - 20,
		height = height - 6,
		style = "minimal",
		border = { " ", " ", " ", " ", " ", " ", " ", " " },
		col = 20,
		row = 3,
		zindex = 2,
	},
	bg = {
		relative = "editor",
		width = width,
		height = height,
		style = "minimal",
		border = "none",
		col = 0,
		row = 0,
		zindex = 1,
	},
}

---Function that creates a floating window
---@param config vim.api.keyset.win_config
---@return dark_present.Window
function M.create_floating_window(config)
	local bufnr = api.nvim_create_buf(false, true)

	local winnr = api.nvim_open_win(bufnr, true, config)

	return {
		bufnr = bufnr,
		winnr = winnr,
	}
end

---Function that creates the presentation
---@param bufnr number
function M.create_presentation(bufnr)
	local slides = slides_core.get_slides(bufnr)
	if slides == nil then
		return
	end

	-- Create floating windows for header and body
	local float_bg = M.create_floating_window(dark_present_window_config.bg)
	local float_header = M.create_floating_window(dark_present_window_config.header)
	local float_body = M.create_floating_window(dark_present_window_config.body)

	-- Call attachments
	on_attach_core.on_attach(float_header, float_body, float_bg, slides)
end

return M

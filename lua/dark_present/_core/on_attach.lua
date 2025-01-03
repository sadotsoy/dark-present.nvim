---
---@module 'dark_present._core.on_attach'
---

local api = vim.api
local filetype = "markdown"

---@type dark_present.ConfigVimOptions
local vim_config_tbl = {
	cmdheight = {
		original = vim.o.cmdheight,
		dark_present = 0,
	},
}

local M = {}

--- Function to handle the attachs
---@param windows dark_present.Windows
---@param slides Slides
function M.on_attach(windows, slides)
	-- Value to manage the slides
	local current_slide = 1

	-- Set Vim options for dark_present
	for option, config in pairs(vim_config_tbl) do
		vim.opt[option] = config.dark_present
	end

	-- Set filetype
	vim.bo[windows.float_body.bufnr].filetype = filetype
	vim.bo[windows.float_header.bufnr].filetype = filetype

	-- Set the first slide
	M.move_slide(windows, slides, current_slide)

	-- Set keymaps
	vim.keymap.set("n", "n", function()
		current_slide = math.min(current_slide + 1, #slides.slide)
		M.move_slide(windows, slides, current_slide)
	end, {
		buffer = windows.float_body.bufnr,
	})

	vim.keymap.set("n", "p", function()
		current_slide = math.max(current_slide - 1, 1)
		M.move_slide(windows, slides, current_slide)
	end, {
		buffer = windows.float_body.bufnr,
	})

	-- Bufleave event to close header floatin when the body is closed
	api.nvim_create_autocmd("BufLeave", {
		buffer = windows.float_body.bufnr,
		callback = function()
			-- Set vim option to original
			for option, config in pairs(vim_config_tbl) do
				vim.opt[option] = config.original
			end

			for _, config in pairs(windows) do
				api.nvim_win_close(config.winnr, true)
			end
		end,
	})
end

---Function to move between slides
---@param windows dark_present.Windows
---@param slides Slides
---@param idx number
function M.move_slide(windows, slides, idx)
	local current_slide = slides.slide[idx]
	local width = vim.o.columns
	local current_title = current_slide.title

	local total_string_to_title = string.rep(" ", (width - #current_title) / 2)
	local title = total_string_to_title .. current_title

	M.set_window_slides(windows.float_header.bufnr, { title })
	M.set_window_slides(windows.float_body.bufnr, current_slide.body)
end

---Function that sets the slides into the window
---@param bufnr number
---@param slide table
function M.set_window_slides(bufnr, slide)
	api.nvim_buf_set_lines(bufnr, 0, -1, false, slide)
end

return M

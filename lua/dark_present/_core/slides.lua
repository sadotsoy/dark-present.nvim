---
---@module 'dark_present._core.slides'
---

local M = {}

local api = vim.api

--- Function to parsed the slides by header separator
---@param lines string[]
---@return Slides
local function parsed_slides(lines)
	local header_separator = "^#%s" -- find for Markdown header #1

	---@type Slides
	local _slides = {
		---@diagnostic disable-next-line: missing-fields
		slide = {},
	}

	---@type Slide
	local _current_slide = {
		title = "",
		body = {},
	}

	for _, line in ipairs(lines) do
		if line:match(header_separator) then
			-- if we have already a title, then insert the current_slide into the slides
			if #_current_slide.title > 1 then
				table.insert(_slides.slide, _current_slide)
			end

			-- insert the title to the current_slide and reset the body table
			_current_slide = {
				title = line,
				body = {},
			}
		else
			-- insert the body into the current_slide
			table.insert(_current_slide.body, line)
		end
	end

	-- insert the last current_slide to the slides
	table.insert(_slides.slide, _current_slide)
	return _slides
end

--- function that return the markdown slides
---@param bufnr number
---@return Slides
function M.get_slides(bufnr)
	local buff_lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)

	return parsed_slides(buff_lines)
end

return M

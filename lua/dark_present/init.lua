---
---@module 'dark_present'
---

local window_core = require("dark_present._core.create_window")

local M = {}

---Function that starts the presentation
---@param opts dark_present.StartPresentationOpts
function M.start_presentation(opts)
	local bufnr = opts.bufnr or nil
	if bufnr == nil then
		return
	end

	window_core.create_presentation(bufnr)
end

return M

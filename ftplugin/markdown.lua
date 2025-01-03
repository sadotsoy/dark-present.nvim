local api = vim.api

local _PREFIX = "DarkPresent"

if not vim.g.dark_present then
	vim.g.dark_present = true

	api.nvim_create_user_command(_PREFIX, function()
		local init = require("dark_present")
		local bufnr = api.nvim_get_current_buf()

		init.start_presentation({
			bufnr = bufnr,
		})
	end, {})
end

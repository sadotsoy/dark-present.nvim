require("dark_present")

local _PREFIX = "DarkPresent"

---@class DarkPresentSubcommand
---@field impl fun(args:string[], opts: table) The command implementation
---@field complete? fun(subcmd_arg_lead: string): string[] (optional) Command completions callback, taking the lead of the subcommand's arguments

---@type table<string, DarkPresentSubcommand>
local subcommand_tbl = {
	Toggle = {
		impl = function(args, opts)
			-- toggle here
		end,
	},
}

---Dark present main command
---@param opts table
local function dark_present(opts)
	local fargs = opts.fargs
	local subcommand_key = fargs[1]

	local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
	local subcommand = subcommand_tbl[subcommand_key]

	if not subcommand then
		vim.notify("DarkPresent: Unknown command " .. subcommand_key, vim.log.levels.ERROR)
		return
	end

	subcommand.impl(args, opts)
end

local api = vim.api

api.nvim_create_user_command(_PREFIX, dark_present, {
	nargs = "+",
	desc = "Dark present command",
	complete = function(arg_lead, cmdline, _)
		local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*DarkPresent[!]*%s(%S+)%s(.*)$")
		if subcmd_key and subcmd_arg_lead and subcommand_tbl[subcmd_key] and subcommand_tbl[subcmd_key].complete then
			return subcommand_tbl[subcmd_key].complete(subcmd_arg_lead)
		end

		if cmdline:match("^['<,'>]*DarkPresent[!]*%s+%w*$") then
			local subcommand_keys = vim.tbl_keys(subcommand_tbl)
			return vim.iter(subcommand_keys)
				:filter(function(key)
					return key:find(arg_lead) ~= nil
				end)
				:totable()
		end
	end,
	bang = true,
})

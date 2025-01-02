---
---@module 'dark_present._commands.say.runner'
---

local constant = require("dark_present._commands.say.constants")

local M = {}

local function _say(phrase, repeat_, style)
	repeat_ = repeat_ or 1
	style = style or constant.Keyword.style.lowercase

	local text = vim.fn.join(phrase, " ")

	if style == constant.Keyword.style.lowercase then
		text = string.lower(text)
	elseif style == constant.Keyword.style.uppercase then
		text = string.upper(text)
	end

	for _ = 1, repeat_ do
		vim.notify(text, vim.log.levels.INFO)
	end
end

function M.run_say_word(word, repeat_, style)
	if word == "" then
		vim.notify("No word was given", vim.log.levels.ERROR)
		return
	end

	word = vim.split(word, " ")[1]

	vim.notify("Saying word", vim.log.levels.INFO)

	_say({ word }, repeat_, style)
end

return M

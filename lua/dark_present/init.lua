---
---@module 'dark_present'
---

local say_runner = require("dark_present._commands.say.runner")

local M = {}

--- Print word
---@param word  string: The text to say
---@param repeat_ number?: A 1-or-more value. The number to print `word`
---@param style  string?: `uppercase` or `lowercase`
function M.run_hello_word(word, repeat_, style)
	say_runner.run_say_word(word, repeat_, style)
end

return M

--- Slide
---@class Slide
---@field title string
---@field body table

--- Slides
---@class Slides
---@field slide Slide

--- CreateWindow return
---@class dark_present.Window
---@field bufnr number: Buff number
---@field winnr number: Window number

--- Config vim Options
---@class dark_present.ConfigVimOptions
---@type table<string, {original: any, dark_present: any}>

--- Windows
---@class dark_present.Windows
---@field float_bg dark_present.Window
---@field float_header dark_present.Window
---@field float_body dark_present.Window

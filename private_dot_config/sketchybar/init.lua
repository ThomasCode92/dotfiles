---@type Sketchybar
sbar = require("sketchybar")

sbar.begin_config()
require("bar")
require("default")
require("items")
sbar.end_config()

sbar.hotload(true)
sbar.event_loop()

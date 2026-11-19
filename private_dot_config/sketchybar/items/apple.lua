local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Padding item required because of bracket
sbar.add("item", { width = 5 })

local apple = sbar.add("item", {
	icon = {
		font = { family = settings.font.icons, style = "Bold", size = 16.0 },
		string = icons.apple,
		padding_right = 8,
		padding_left = 8,
	},
	label = { drawing = false },
	background = {
		color = colors.bg2,
		border_color = colors.black,
		border_width = 1,
	},
	padding_left = 1,
	padding_right = 1,
})

apple:subscribe("mouse.clicked", function(env)
	if env.BUTTON == "right" then
		sbar.trigger("swap_menus_and_spaces")
	else
		sbar.exec('"$CONFIG_DIR/helpers/menus/bin/menus" -s 0')
	end
end)

-- Double border for apple using a single item bracket
sbar.add("bracket", { apple.name }, {
	background = {
		color = colors.transparent,
		height = 30,
		border_color = colors.grey,
	},
})

-- Padding item required because of bracket
sbar.add("item", { width = 7 })

return apple

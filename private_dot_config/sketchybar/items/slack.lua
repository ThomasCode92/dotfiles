local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local slack = sbar.add("item", "slack", {
	position = "e",
	drawing = false,
	width = 28,
	icon = {
		string = icons.apps.slack,
		font = { family = settings.font.text, size = 17.0 },
		color = colors.grey,
		width = 28,
		align = "center",
		-- Optically center the Nerd Font glyph inside its fixed-width box.
		padding_left = 1,
		padding_right = -1,
	},
	label = { drawing = false },
	background = { color = colors.bg1, height = 28 },
	update_freq = 5,
	updates = true,
	click_script = "open -a Slack",
})

local updating = false
local function update_slack()
	if updating then
		return
	end
	updating = true
	sbar.exec('python3 "$CONFIG_DIR/helpers/slack/badge.py"', function(result, exit_code)
		updating = false
		local color = colors.grey
		local drawing = true
		if exit_code == 0 and type(result) == "table" then
			drawing = result.running ~= false
			if result.running ~= false and type(result.badge) == "string" then
				local count = tonumber(result.badge)
				if count and count > 0 then
					color = colors.red
				elseif not count and result.badge ~= "" then
					color = colors.blue
				end
			end
		end
		slack:set({
			drawing = drawing,
			icon = { color = color },
		})
	end)
end

slack:subscribe({ "routine", "forced", "system_woke", "front_app_switched" }, update_slack)
update_slack()

return slack

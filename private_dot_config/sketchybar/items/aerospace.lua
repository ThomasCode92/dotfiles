local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local workspace_ids = { "1", "2", "3", "B", "E", "M", "N", "S", "T" }
local workspace_items = {}
local workspace_brackets = {}
local workspace_paddings = {}
local workspace_elements = {}
local workspace_apps = {}
local spaces_visible = true
local focused_workspace = nil

local app_icons = {
	{ match = "Firefox", icon = icons.apps.firefox },
	{ match = "IntelliJ", icon = icons.apps.intellij },
	{ match = "Obsidian", icon = icons.apps.obsidian },
	{ match = "Postman", icon = icons.apps.postman },
	{ match = "Slack", icon = icons.apps.slack },
	{ match = "Spotify", icon = icons.apps.spotify },
	{ match = "kitty", icon = icons.apps.kitty },
	{ match = "Discord", icon = icons.apps.discord },
	{ match = "WhatsApp", icon = icons.apps.whatsapp },
	{ match = "Chrome", icon = icons.apps.chrome },
	{ match = "Safari", icon = icons.apps.safari },
}

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_mode_change")

local function trim(value)
	if type(value) ~= "string" then
		return ""
	end
	return value:gsub("^%s+", ""):gsub("%s+$", "")
end

local function app_icon(name)
	for _, entry in ipairs(app_icons) do
		if name:find(entry.match, 1, true) then
			return entry.icon
		end
	end
	return name:sub(1, 2):upper()
end

local function set_workspace_visible(id, visible)
	workspace_items[id]:set({ drawing = visible })
	workspace_brackets[id]:set({ drawing = visible })
	workspace_paddings[id]:set({ drawing = visible })
end

local function apply_visibility()
	for id in pairs(workspace_items) do
		local has_apps = workspace_apps[id] ~= nil or id == focused_workspace
		set_workspace_visible(id, spaces_visible and has_apps)
	end
end

local function apply_focus(workspace)
	focused_workspace = workspace
	for id, item in pairs(workspace_items) do
		local selected = id == workspace
		local bracket = workspace_brackets[id]
		item:set({
			icon = { highlight = selected },
			label = { highlight = selected },
			background = { border_color = selected and colors.grey or colors.bg2 },
		})
		bracket:set({
			background = { border_color = selected and colors.grey or colors.bg2 },
		})
	end
	apply_visibility()
end

local function update_focus(env)
	local workspace = trim(env.FOCUSED_WORKSPACE or env.FOCUSED)
	if workspace ~= "" then
		apply_focus(workspace)
		return
	end
	sbar.exec("aerospace list-workspaces --focused --format '%{workspace}'", function(result)
		apply_focus(trim(result))
	end)
end

local function update_workspace_labels()
	sbar.exec("aerospace list-windows --all --format '%{workspace}|%{app-name}'", function(output)
		local labels = {}
		for workspace, app in tostring(output):gmatch("([^|\r\n]+)|([^\r\n]+)") do
			local ws = trim(workspace)
			local app_name = trim(app)
			if app_name ~= "" then
				labels[ws] = labels[ws] or {}
				local seen = false
				for _, existing in ipairs(labels[ws]) do
					if existing == app_name then
						seen = true
						break
					end
				end
				if not seen then
					table.insert(labels[ws], app_name)
				end
			end
		end

		workspace_apps = labels
		apply_visibility()

		for id, item in pairs(workspace_items) do
			local apps = labels[id] or {}
			local text = "—"
			if #apps > 0 then
				local parts = {}
				for i = 1, math.min(#apps, 3) do
					parts[i] = app_icon(apps[i])
				end
				text = table.concat(parts, " ")
				if #apps > 3 then
					text = text .. "…"
				end
			end
			item:set({ label = { string = text } })
		end
	end)
end

local function refresh()
	update_focus({})
	update_workspace_labels()
end

for _, id in ipairs(workspace_ids) do
	local space = sbar.add("item", "aerospace.space." .. id, {
		icon = {
			font = {
				family = settings.font.numbers,
				style = settings.font.style_map["Bold"],
				size = 12.0,
			},
			string = id,
			padding_left = 10,
			padding_right = 3,
			color = colors.white,
			highlight_color = colors.blue,
		},
		label = {
			font = {
				family = settings.font.text,
				style = settings.font.style_map["Semibold"],
				size = 12.0,
			},
			string = "—",
			padding_left = 2,
			padding_right = 12,
			color = colors.grey,
			highlight_color = colors.white,
		},
		padding_left = 1,
		padding_right = 1,
		background = {
			color = colors.bg1,
			border_width = 1,
			height = 26,
			border_color = colors.bg2,
		},
		click_script = "aerospace workspace " .. id,
	})

	workspace_items[id] = space
	table.insert(workspace_elements, space)

	local bracket = sbar.add("bracket", "aerospace.space." .. id .. ".bracket", {
		space.name,
	}, {
		background = {
			color = colors.transparent,
			border_color = colors.bg2,
			height = 28,
			border_width = 2,
		},
	})
	workspace_brackets[id] = bracket
	table.insert(workspace_elements, bracket)

	local padding = sbar.add("item", "aerospace.space.padding." .. id, {
		width = settings.group_paddings,
	})
	workspace_paddings[id] = padding
	table.insert(workspace_elements, padding)
end

local spaces_indicator = sbar.add("item", "aerospace.switch", {
	padding_left = -3,
	padding_right = 0,
	icon = {
		font = { family = settings.font.icons, style = "Bold", size = 14.0 },
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bg1,
	},
	background = {
		color = colors.spaces.indicator.bg,
		border_color = colors.spaces.indicator.border,
	},
})

local service_indicator = sbar.add("item", "aerospace.service", {
	drawing = false,
	padding_left = 4,
	padding_right = 0,
	icon = {
		font = { family = settings.font.icons, style = "Bold", size = 14.0 },
		padding_left = 2,
		padding_right = 2,
		color = colors.orange,
		string = icons.service,
	},
	label = { drawing = false },
	background = { drawing = false },
})

local function update_service_mode()
	sbar.exec("aerospace list-modes --current", function(output)
		service_indicator:set({ drawing = trim(output) == "service" })
	end)
end

local workspace_observer = sbar.add("item", {
	drawing = false,
	updates = true,
	update_freq = 5,
})

workspace_observer:subscribe("aerospace_workspace_change", update_focus)
workspace_observer:subscribe({ "front_app_switched", "routine" }, function()
	update_workspace_labels()
	update_service_mode()
end)
workspace_observer:subscribe("aerospace_mode_change", update_service_mode)

workspace_observer:subscribe("swap_menus_and_spaces", function()
	spaces_visible = not spaces_visible
	for _, element in ipairs(workspace_elements) do
		element:set({ drawing = spaces_visible })
	end
	spaces_indicator:set({
		icon = { string = spaces_visible and icons.switch.on or icons.switch.off },
	})
	if spaces_visible then
		refresh()
	end
end)

spaces_indicator:subscribe("mouse.entered", function()
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function()
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function()
	sbar.trigger("swap_menus_and_spaces")
end)

update_service_mode()
refresh()

return workspace_observer

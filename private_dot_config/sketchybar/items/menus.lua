local colors = require("colors")
local settings = require("settings")
local apple = require("items.apple")

local function set_compact_apple(compact)
	local padding = compact and 2 or 8
	apple:set({ icon = { padding_left = padding, padding_right = padding } })
end

local menu_watcher = sbar.add("item", {
	drawing = false,
	updates = false,
})
-- Keep the toggle subscribed even while application-menu updates are disabled.
local menu_toggle = sbar.add("item", {
	drawing = false,
	updates = true,
})
sbar.add("event", "swap_menus_and_spaces")
sbar.add("event", "reveal_app_menus")
sbar.add("event", "open_app_menu")

local max_items = 15
local menu_items = {}
local menus_visible = false
local menus_expanded = false
local pending_open_app_menu = false
local menu_request = 0
local hovered_menu = nil
local selected_menu = nil

local function update_menu_styles()
	for i, menu in ipairs(menu_items) do
		local selected = selected_menu == i
		local hovered = hovered_menu == i
		menu:set({
			background = {
				drawing = selected or hovered,
				color = selected and colors.blue or colors.bg2,
				border_width = 0,
			},
			label = { color = selected and colors.black or colors.white },
		})
	end
end

local function reset_menu_styles()
	hovered_menu = nil
	selected_menu = nil
	update_menu_styles()
end

-- Native menus track the system menu-bar coordinates, not our text widths.
local menu_anchor = sbar.add("item", "native_menu_anchor", {
	drawing = false,
	width = 0,
	padding_left = 0,
	padding_right = 0,
	icon = { drawing = false },
	label = { drawing = false },
	background = { drawing = false },
})

for i = 1, max_items, 1 do
	local menu = sbar.add("item", "menu." .. i, {
		padding_left = settings.paddings,
		padding_right = settings.paddings,
		drawing = false,
		icon = { drawing = false },
		background = { drawing = false, border_width = 0 },
		label = {
			font = {
				style = settings.font.style_map[i == 1 and "Heavy" or "Semibold"],
			},
			padding_left = 6,
			padding_right = 6,
		},
		click_script = '"$CONFIG_DIR/helpers/menus/bin/menus" -s ' .. i,
	})

	menu_items[i] = menu
	menu:subscribe("mouse.entered", function()
		hovered_menu = i
		update_menu_styles()
	end)
	menu:subscribe("mouse.exited", function()
		if hovered_menu == i then
			hovered_menu = nil
		end
		update_menu_styles()
	end)
	menu:subscribe("mouse.clicked", function()
		-- This marks the last requested menu, not native dropdown visibility.
		-- Opening is handled directly by click_script, as in the upstream config.
		selected_menu = i
		update_menu_styles()
	end)
end

sbar.add("bracket", { "/menu\\..*/" }, {
	background = { color = colors.bg1 },
})

local menu_padding = sbar.add("item", "menu.padding", {
	drawing = false,
	width = 5,
})

local function update_menus()
	if not menus_visible or not menus_expanded then
		return
	end
	menu_request = menu_request + 1
	local request = menu_request
	reset_menu_styles()
	local function render_menus(menus, exit_code, geometry)
		-- Ignore results from an older app or a menu view that has been closed.
		if not menus_visible or not menus_expanded or request ~= menu_request then
			return
		end
		sbar.set("/menu\\..*/", { drawing = false })
		menu_anchor:set({ drawing = false })
		if exit_code ~= 0 or type(menus) ~= "table" or #menus == 0 then
			menus_expanded = false
			set_compact_apple(false)
			menu_watcher:set({ updates = false })
			sbar.set("front_app", { drawing = true })
			return
		end
		local aligned = false
		local first_padding = 0
		set_compact_apple(geometry ~= nil)
		if geometry then
			menu_anchor:set({ drawing = true })
			local query = menu_anchor:query()
			for _, rect in pairs(type(query) == "table" and query.bounding_rects or {}) do
				local x = rect.origin[1]
				if x >= geometry.display_x and x < geometry.display_x + geometry.display_width then
					first_padding = math.floor(menus[1].x - (x - geometry.display_x) + 0.5)
					aligned = true
					break
				end
			end
		end
		if not aligned then
			set_compact_apple(false)
		end
		menu_padding:set({ drawing = true })
		for id, menu in ipairs(menus) do
			if id <= max_items then
				local width = aligned and math.floor((menus[id + 1] and menus[id + 1].x - menu.x or menu.width) + 0.5)
				menu_items[id]:set({
					label = {
						string = menu.title,
						width = width or "dynamic",
						align = "center",
						padding_left = aligned and 0 or 6,
						padding_right = aligned and 0 or 6,
					},
					width = width or "dynamic",
					-- Fixed-width items advance independently of their left padding.
					padding_left = aligned and first_padding or settings.paddings,
					padding_right = aligned and 0 or settings.paddings,
					drawing = true,
				})
			else
				break
			end
		end
	end
	sbar.exec('"$CONFIG_DIR/helpers/menus/bin/menus" -g', function(geometry, exit_code)
		if not menus_visible or request ~= menu_request then
			return
		end
		if exit_code == 0 and type(geometry) == "table" and type(geometry.items) == "table" and #geometry.items > 0 then
			render_menus(geometry.items, 0, geometry)
		else
			-- Keep the original layout if native geometry is unavailable.
			sbar.exec('"$CONFIG_DIR/helpers/menus/bin/menus" -l', function(output, code)
				local menus = {}
				if type(output) == "string" then
					for title in output:gmatch("[^\r\n]+") do
						menus[#menus + 1] = { title = title }
					end
				end
				render_menus(menus, code)
			end)
		end
	end)
end

local function reveal_menus()
	if not menus_visible or menus_expanded then
		return
	end
	menus_expanded = true
	menu_watcher:set({ updates = true })
	sbar.set("front_app", { drawing = false })
	update_menus()
end

menu_watcher:subscribe("front_app_switched", update_menus)

menu_toggle:subscribe("swap_menus_and_spaces", function()
	menus_visible = not menus_visible
	menus_expanded = false
	menu_request = menu_request + 1
	set_compact_apple(false)
	reset_menu_styles()
	menu_anchor:set({ drawing = false })
	menu_watcher:set({ updates = false })
	sbar.set("/menu\\..*/", { drawing = false })
	sbar.set("front_app", { drawing = menus_visible })
	if not menus_visible then
		pending_open_app_menu = false
	elseif pending_open_app_menu then
		pending_open_app_menu = false
		reveal_menus()
	end
end)

menu_toggle:subscribe("reveal_app_menus", reveal_menus)

menu_toggle:subscribe("open_app_menu", function()
	if not menus_visible then
		pending_open_app_menu = true
		sbar.trigger("swap_menus_and_spaces")
		return
	end
	reveal_menus()
end)

return menu_watcher

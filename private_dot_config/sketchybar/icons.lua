local settings = require("settings")

local icons = {
	sf_symbols = {
		plus = "􀅼",
		loading = "􀖇",
		apple = "􀣺",
		gear = "􀍟",
		service = "􀍟",
		cpu = "􀫥",
		clipboard = "􀉄",
		headphones = "􀑈",

		switch = {
			on = "􁏮",
			off = "􁏯",
		},
		volume = {
			_100 = "􀊩",
			_66 = "􀊧",
			_33 = "􀊥",
			_10 = "􀊡",
			_0 = "􀊣",
		},
		battery = {
			_100 = "􀛨",
			_75 = "􀺸",
			_50 = "􀺶",
			_25 = "􀛩",
			_0 = "􀛪",
			charging = "􀢋",
		},
		wifi = {
			upload = "􀄨",
			download = "􀄩",
			connected = "􀙇",
			disconnected = "􀙈",
			router = "􁓤",
		},
		media = {
			back = "􀊊",
			forward = "􀊌",
			play_pause = "􀊈",
		},
	},

	-- Alternative NerdFont icons
	nerdfont = {
		plus = "",
		loading = "",
		apple = "",
		gear = "",
		service = "",
		cpu = "",
		clipboard = "Missing Icon",
		headphones = "",

		switch = {
			on = "󱨥",
			off = "󱨦",
		},
		volume = {
			_100 = "",
			_66 = "",
			_33 = "",
			_10 = "",
			_0 = "",
		},
		battery = {
			_100 = "",
			_75 = "",
			_50 = "",
			_25 = "",
			_0 = "",
			charging = "",
		},
		wifi = {
			upload = "",
			download = "",
			connected = "󰖩",
			disconnected = "󰖪",
			router = "Missing Icon",
		},
		media = {
			back = "",
			forward = "",
			play_pause = "",
		},
	},
}

-- App brand glyphs (Nerd Font). These are rendered with the text font in
-- aerospace.lua, so they stay the same for both icon styles in settings.icons.
local app_icons = {
	firefox = "",
	finder = "󰀶",
	intellij = "",
	obsidian = "",
	postman = "",
	slack = "",
	spotify = "",
	kitty = "",
	discord = "",
	beeper = "󰭹", -- nf-md-chat (U+F0B79)
	chrome = "",
	safari = "",
}

icons.sf_symbols.apps = app_icons
icons.nerdfont.apps = app_icons

if not (settings.icons == "NerdFont") then
	return icons.sf_symbols
else
	return icons.nerdfont
end

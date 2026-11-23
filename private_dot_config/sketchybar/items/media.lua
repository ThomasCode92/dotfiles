local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local whitelist = { ["Spotify"] = true,
                    ["Music"] = true }

local media_cover = sbar.add("item", "media.cover", {
	-- The notch's right-hand anchor grows left-to-right: cover, then details.
	position = "e",
	background = {
		image = {
			drawing = false,
			scale = 1,
			corner_radius = 9,
			border_color = colors.grey,
			border_width = 1,
		},
		color = colors.transparent,
		border_width = 0,
	},
	label = { drawing = false },
	icon = { drawing = false },
	drawing = false,
	updates = true,
	update_freq = 3,
	popup = {
		align = "center",
		horizontal = true,
	},
})

local media_artist = sbar.add("item", "media.artist", {
	position = "e",
	drawing = false,
	padding_left = 3,
	padding_right = 0,
	width = 0,
	icon = { drawing = false },
	label = {
		width = 0,
		font = { family = "SF Pro", style = "Semibold", size = 9 },
		color = colors.media.artist,
		max_chars = 18,
		y_offset = 6,
	},
})

local media_title = sbar.add("item", "media.title", {
	position = "e",
	drawing = false,
	padding_left = 3,
	padding_right = 0,
	icon = { drawing = false },
	label = {
		font = { family = "SF Pro", style = "Semibold", size = 11 },
		width = 0,
		max_chars = 16,
		y_offset = -5,
	},
})

sbar.add("item", "media.back", {
	position = "popup." .. media_cover.name,
	icon = { string = icons.media.back, font = { family = settings.font.icons } },
	label = { drawing = false },
	click_script = "nowplaying-cli previous",
})
sbar.add("item", "media.play_pause", {
	position = "popup." .. media_cover.name,
	icon = { string = icons.media.play_pause, font = { family = settings.font.icons } },
	label = { drawing = false },
	click_script = "nowplaying-cli togglePlayPause",
})
sbar.add("item", "media.forward", {
	position = "popup." .. media_cover.name,
	icon = { string = icons.media.forward, font = { family = settings.font.icons } },
	label = { drawing = false },
	click_script = "nowplaying-cli next",
})

local interrupt = 0
local function animate_detail(detail)
	if (not detail) then interrupt = interrupt - 1 end
	if interrupt > 0 and (not detail) then return end

	sbar.animate("tanh", 30, function()
		media_artist:set({ label = { width = detail and "dynamic" or 0 } })
		media_title:set({ label = { width = detail and "dynamic" or 0 } })
	end)
end

local previous = {}
local function update_media(info)
	-- Spotify sometimes omits artwork and folds the artist into the title.
	-- Only reuse the last cover when the metadata still identifies that track.
	if info.app == previous.app then
		if previous.title and previous.artist and previous.artist ~= ""
			and info.title == previous.title .. " • " .. previous.artist then
			info.title = previous.title
			info.artist = previous.artist
		end
		if info.title == previous.title and info.artist == previous.artist and not info.artwork then
			info.artwork = previous.artwork
			info.artwork_id = previous.artwork_id
		end
	end
	local playing = info.state == "playing"
	local drawing = whitelist[info.app] == true
	media_artist:set({ drawing = drawing, label = info.artist or "" })
	media_title:set({ drawing = drawing, label = info.title or "" })
	media_cover:set({ drawing = drawing })
	if info.artwork and info.artwork_id ~= previous.artwork_id then
		media_cover:set({ background = { image = { string = info.artwork, scale = 1 } } })
	end
	-- Missing artwork does not mean playback is paused.
	media_cover:set({
		icon = {
			drawing = drawing and not playing,
			string = icons.media.play_pause,
			font = { family = settings.font.icons },
			color = colors.white,
			align = "center",
			background = {
				drawing = playing and "off" or "on",
				color = playing and colors.transparent or colors.media.overlay,
				corner_radius = 6,
				padding_left = 2,
				padding_right = 2,
			},
		},
		background = { image = { drawing = info.artwork ~= nil } },
	})

	if drawing then
		if previous.state ~= info.state or previous.app ~= info.app
			or previous.title ~= info.title or previous.artist ~= info.artist then
			animate_detail(true)
			interrupt = interrupt + 1
			sbar.delay(5, animate_detail)
		end
	else
		media_cover:set({ popup = { drawing = false } })
	end
	previous = info
end

-- Native media_change/media.artwork use an API restricted on newer macOS.
-- Poll nowplaying-cli instead, including once at startup for an existing track.
local polling = false
local function refresh_media()
	if polling then return end
	polling = true
	sbar.exec('/usr/bin/python3 "$CONFIG_DIR/helpers/media/media.py"', function(info, code)
		polling = false
		if code == 0 and type(info) == "table" then update_media(info) end
	end)
end

media_cover:subscribe({ "routine", "forced", "system_woke", "media_change" }, refresh_media)
refresh_media()

media_cover:subscribe("mouse.entered", function()
	interrupt = interrupt + 1
	animate_detail(true)
end)

media_cover:subscribe("mouse.exited", function()
	animate_detail(false)
end)

media_cover:subscribe("mouse.clicked", function()
	media_cover:set({ popup = { drawing = "toggle" } })
end)

media_title:subscribe("mouse.exited.global", function()
	media_cover:set({ popup = { drawing = false } })
end)

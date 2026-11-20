-- Catppuccin Mocha: https://catppuccin.com/palette/
local mocha = {
	rosewater = 0xfff5e0dc,
	flamingo = 0xfff2cdcd,
	pink = 0xfff5c2e7,
	mauve = 0xffcba6f7,
	red = 0xfff38ba8,
	maroon = 0xffeba0ac,
	peach = 0xfffab387,
	yellow = 0xfff9e2af,
	green = 0xffa6e3a1,
	teal = 0xff94e2d5,
	sky = 0xff89dceb,
	sapphire = 0xff74c7ec,
	blue = 0xff89b4fa,
	lavender = 0xffb4befe,
	text = 0xffcdd6f4,
	subtext1 = 0xffbac2de,
	subtext0 = 0xffa6adc8,
	overlay2 = 0xff9399b2,
	overlay1 = 0xff7f849c,
	overlay0 = 0xff6c7086,
	surface2 = 0xff585b70,
	surface1 = 0xff45475a,
	surface0 = 0xff313244,
	base = 0xff1e1e2e,
	mantle = 0xff181825,
	crust = 0xff11111b,
}

local function with_alpha(color, alpha)
	-- Accept both byte values (0xc0) and fractional opacity (0.6)
	if alpha >= 0 and alpha <= 1 then alpha = alpha * 255 end
	return (color & 0x00ffffff) | (math.floor(alpha) << 24)
end

return {
	palette = mocha,

	-- Compatibility map for the upstream widgets.
	black = mocha.crust,
	white = mocha.text,
	grey = mocha.overlay1,
	transparent = 0x00000000,
	bg1 = mocha.surface0,
	bg2 = mocha.surface1,
	blue = mocha.blue,
	green = mocha.green,
	orange = mocha.peach,
	red = mocha.red,
	popup = {
		bg = with_alpha(mocha.base, 0xc0),
		border = mocha.overlay1,
	},

	bar = {
		bg = with_alpha(mocha.surface0, 0xf0),
	},

	media = {
		artist = with_alpha(mocha.text, 0.6),
		overlay = with_alpha(mocha.base, 0x99),
	},

	spaces = {
		indicator = {
			bg = with_alpha(mocha.overlay1, 0.0),
			border = with_alpha(mocha.surface0, 0.0),
		},
	},
}

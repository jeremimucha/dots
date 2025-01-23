-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
-- local mux = wezterm.mux
-- This will hold the configuration.
local config = wezterm.config_builder()
-- local gpus = wezterm.gui.enumerate_gpus()
-- config.webgpu_preferred_adapter = gpus[1]
-- config.front_end = "WebGpu"

config.front_end = "OpenGL"
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
-- config.animation_fps = 1
config.cursor_blink_rate = 500
-- config.term = "xterm-256color" -- Set the terminal type

-- config.font = wezterm.font("Iosevka Custom")
-- config.font = wezterm.font("Hasklig")
-- config.font = wezterm.font("Hasklug Nerd Font")
config.font = wezterm.font("Hasklug Nerd Font Propo")
-- config.cell_width = 0.9
-- config.window_background_opacity = 0.95
-- config.prefer_egl = true
config.font_size = 12.0

-- config.window_padding = {
-- 	left = 0,
-- 	right = 0,
-- 	top = 0,
-- 	bottom = 0,
-- }

-- tabs
config.hide_tab_bar_if_only_one_tab = true
-- config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true

config.inactive_pane_hsb = {
	saturation = 0.5,
	brightness = 1.0,
}

-- This is where you actually apply your config choices
--

-- color scheme toggling
local ColorThemes = {
	["nord"] = "rose-pine",
	["rose-pine"] = "VSCodeDark+ (Gogh)",
	["VSCodeDark+ (Gogh)"] = "nord",
}
local ColorThemesMT = {}
ColorThemesMT.__index = function(_, key)
	return "nord"
end
setmetatable(ColorThemes, ColorThemesMT)
wezterm.on("toggle-colorscheme-event", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	overrides.color_scheme = ColorThemes[overrides.color_scheme]
	window:set_config_overrides(overrides)
end)

-- keymaps

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
	local name = window:active_key_table()
	if name then
		name = 'TABLE: ' .. name
	end
	window:set_right_status(name or '')
end)

config.leader = { key = 'Space', mods = 'CTRL|SHIFT' }
config.keys = {
	-- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
	-- mode until we cancel that mode.
	{
		key = 'r',
		mods = 'LEADER',
		action = act.ActivateKeyTable {
			name = 'pane_resize',
			one_shot = false,
		},
	},
	-- CTRL+SHIFT+Space, followed by 'a' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	{
		key = 'a',
		mods = 'LEADER',
		action = act.ActivateKeyTable {
			name = 'pane_activate',
			timeout_milliseconds = 1000,
		},
	},
	-- toggle colorscheme
	{
		key = "E",
		mods = "CTRL|SHIFT|ALT",
		action = act.EmitEvent("toggle-colorscheme-event"),
	},
	-- split pane right
	{
		key = "l",
		mods = "CTRL|SHIFT|ALT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	-- split pane down
	{
		key = "j",
		mods = "CTRL|SHIFT|ALT",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 20 },
		}),
	},
	-- select pane
	{
		key = "s",
		-- mods = "CTRL|SHIFT|ALT",
		mods = "CTRL|SHIFT",
		action = act.PaneSelect
	},
	-- debug overlay
	{ key = "d", mods = "CTRL|SHIFT|ALT", action = act.ShowDebugOverlay },
	-- opacity toggle
	{
		key = "0",
		mods = "CTRL|ALT",
		-- toggling opacity
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = 0.9
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

config.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'pane_resize' here corresponds to the name="pane_resize" in
	-- the key assignments above.
	pane_resize = {
		{ key = 'LeftArrow',  action = act.AdjustPaneSize { 'Left', 1 } },
		{ key = 'h',          action = act.AdjustPaneSize { 'Left', 1 } },
		{ key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
		{ key = 'l',          action = act.AdjustPaneSize { 'Right', 1 } },
		{ key = 'UpArrow',    action = act.AdjustPaneSize { 'Up', 1 } },
		{ key = 'k',          action = act.AdjustPaneSize { 'Up', 1 } },
		{ key = 'DownArrow',  action = act.AdjustPaneSize { 'Down', 1 } },
		{ key = 'j',          action = act.AdjustPaneSize { 'Down', 1 } },
		-- Cancel the mode by pressing escape
		{ key = 'Escape',     action = 'PopKeyTable' },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'pane_activate' here corresponds to the name="pane_activate" in
	-- the key assignments above.
	pane_activate = {
		{ key = 'LeftArrow',  action = act.ActivatePaneDirection 'Left' },
		{ key = 'h',          action = act.ActivatePaneDirection 'Left' },
		{ key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
		{ key = 'l',          action = act.ActivatePaneDirection 'Right' },
		{ key = 'UpArrow',    action = act.ActivatePaneDirection 'Up' },
		{ key = 'k',          action = act.ActivatePaneDirection 'Up' },
		{ key = 'DownArrow',  action = act.ActivatePaneDirection 'Down' },
		{ key = 'j',          action = act.ActivatePaneDirection 'Down' },
	},
}


-- For example, changing the color scheme:
config.color_scheme = "VSCodeDark+ (Gogh)"

config.window_frame = {
	font = wezterm.font({ family = "Hasklig", weight = "Regular" }),
	active_titlebar_bg = "#0c0b0f",
	-- active_titlebar_bg = "#181616",
}

-- config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_decorations = "NONE | RESIZE"
config.default_prog = { "pwsh.exe", "-NoLogo" }
config.initial_cols = 100

-- and finally, return the configuration to wezterm
return config

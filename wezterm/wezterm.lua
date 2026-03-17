local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16

config.enable_tab_bar = true

config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"

config.color_scheme = 'nord'

-- config.colors = {
--   background = '#1e2030',  -- dark navy
-- }

config.window_background_opacity = 0.9
config.macos_window_background_blur = 10

return config

-- Custom key bindings
o.bind("SUPER + Q", "Close window (killactive)", hl.dsp.window.close())

hl.unbind("SUPER + S") -- was: Toggle Scratchpad
o.bind("SUPER + S", "Omarchy menu", "omarchy-menu toggle")

o.bind("SUPER + D", "Vicinae", "vicinae toggle")

o.bind("SUPER + SHIFT + K", "Keybindings", "omarchy-menu-keybindings")

-- Move focus across windows
o.bind("SUPER + H", "Move focus left", hl.dsp.focus({ direction = "l" }))

hl.unbind("SUPER + J") -- was: Toggle window split
o.bind("SUPER + J", "Move focus down", hl.dsp.focus({ direction = "d" }))

hl.unbind("SUPER + L") -- was: Toggle workspace layout
o.bind("SUPER + L", "Move focus right", hl.dsp.focus({ direction = "r" }))

hl.unbind("SUPER + K") -- was: Keybindings
o.bind("SUPER + K", "Move focus up", hl.dsp.focus({ direction = "u" }))


-- Move workspaces across monitors
hl.unbind("SUPER + SHIFT + M") -- was: Music
o.bind("SUPER + SHIFT + M", "Move workspace to DP-3", hl.dsp.workspace.move({ monitor = "DP-3" }))

hl.unbind("SUPER + SHIFT + N") -- was: Editor
o.bind("SUPER + SHIFT + N", "Move workspace to DP-2", hl.dsp.workspace.move({ monitor = "DP-2" }))

-- Handle Windows
hl.unbind("SUPER + SPACE") -- was: Omarchy menu
o.bind("SUPER + SPACE", "Toggle floating", hl.dsp.window.float({ action = "toggle" }))

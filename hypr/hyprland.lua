-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/

------------------
---- MONITORS ----
------------------
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- built-in screen

-- read lid state
local lid_handle = io.popen("cat /proc/acpi/button/lid/*/state 2>/dev/null")
local lid_state = lid_handle:read("*a") or ""
lid_handle:close()

if string.match(lid_state, "closed") then
    hl.monitor({
        output = "eDP-1",
        disabled = true,
    })
else
    hl.monitor({
        output = "eDP-1",
        mode = "1920x1200@59.95",
        position = "0x0",
        scale = 1,
    })
end

-- external monitors --

-- acer (ext monitor 1)
hl.monitor({
    output = "DP-3",
    mode = "1920x1080@75",
    position = "1920x0",
    scale = 1,
})

-- asus (ext monitor 2)
hl.monitor({
    output = "DP-2",
    mode = "1920x1080@60",
    position = "3840x0",
    scale = 1,
})

-- fallback for any other monitor
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileManager = "dolphin"
local menu = "rofi -show drun -show-icons"

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GTK_THEME", "Breeze-Dark")
hl.env("XCURSOR_THEME", "breeze_cursors")
hl.env("XCURSOR_SIZE", "24")

-------------------
---- AUTOSTART ----
-------------------
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------
-- See https://wiki.hypr.land/Configuring/Basics/Variables/
-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/

hl.config({
    general = {
        gaps_in = 0,
        gaps_out = 0,
        border_size = 0,
        layout = "dwindle",
		resize_on_border = true, -- drag window borders to resize
    },

    dwindle = {
        force_split = 2, 
        preserve_split = true,
    },

    animations = {
        enabled = false, 
    },

    misc = {
		vrr = 0,
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
		animate_manual_resizes = true,
    },

	cursor = {
        no_hardware_cursors = 1,
    },

    input = {
        kb_layout = "it",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
        },
    },
})

----------------------
---- WINDOW RULES ----
----------------------
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- network manager
hl.window_rule({
    match = { class = "nm-connection-editor" },
    float = true,
    size = {700, 500},
    center = true,
})

-- bluetooth manager
hl.window_rule({
    match = { class = "blueman-manager" },
    float = true,
    size = {700, 500},
    center = true,
})

-- volume manager
hl.window_rule({
    match = { class = "org.pulseaudio.pavucontrol" },
    float = true,
    size = {900, 700},
    center = true,
})

---------------------
---- KEYBINDINGS ----
---------------------
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod = "SUPER"

-- basic commands
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))

-- lock screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- power Menu
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.exec_cmd("~/.config/rofi/powermenu.sh"))

-- fullscreen 
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- float toggle, also centers and fits the window ==
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + W", hl.dsp.window.center())

-- focus navigation
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- window moving
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- resize windows with the keyboard
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -50, y = 0,  relative = true }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 50,  y = 0,  relative = true }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0,   y = -50, relative = true }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }))

-- workspaces 1-10
for i = 1, 10 do
    local key = i % 10 -- 10 becomes the key '0'

    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- cycle workspaces with CTRL+SHIFT+arrows ==
hl.bind("CTRL + SHIFT + right", hl.dsp.focus({ workspace = "+1" }))
hl.bind("CTRL + SHIFT + left",  hl.dsp.focus({ workspace = "-1" }))

-- mouse (drag and resize) ==
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd([[sh -c 'flock -n /tmp/vol.lock sh -c "swayosd-client --output-volume raise; sleep 0.1"']]), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd([[sh -c 'flock -n /tmp/vol.lock sh -c "swayosd-client --output-volume lower; sleep 0.1"']]), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })

-- brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[sh -c 'flock -n /tmp/bri.lock sh -c "swayosd-client --brightness raise; sleep 0.1"']]), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[sh -c 'flock -n /tmp/bri.lock sh -c "swayosd-client --brightness lower; sleep 0.1"']]), { locked = true, repeating = true })

-- clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("rofi -modi clipboard:~/.config/rofi/cliphist-rofi-img -show clipboard -show-icons"))

-- region screenshot (click & drag)
hl.bind("Print", hl.dsp.exec_cmd([[sh -c 'grim -g "$(slurp)" - | swappy -f -']]))

-- full screen screenshot (instant)
hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[sh -c 'grim - | swappy -f -']]))

-- rofi window switcher (Alt+Tab)
hl.bind("ALT + Tab", hl.dsp.exec_cmd(
	"rofi -show window -show-icons " ..
	"-kb-cancel 'Alt+Escape,Escape' " ..
	"-kb-accept-entry '!Alt-Tab,Return' " ..
	"-kb-row-down 'Alt+Tab,Down' " ..
	"-kb-row-up 'Alt+ISO_Left_Tab,Up'"
))

--------------------
---- LID SWITCH ----
--------------------

-- disable internal monitor when lid closes
hl.bind("switch:on:Lid Switch", function()
    hl.exec_cmd(
        "hyprctl eval 'hl.monitor({ output = \"eDP-1\", disabled = true })'"
    )
end, { locked = true })

-- re-enable internal monitor when lid opens
hl.bind("switch:off:Lid Switch", function()
    hl.timer(function()
        hl.exec_cmd(
            "hyprctl eval 'hl.monitor({ " ..
            "output = \"eDP-1\", " ..
            "disabled = false, " ..
            "mode = \"1920x1200@59.95\", " ..
            "position = \"0x0\", " ..
            "scale = 1 " ..
            "})'"
        )
    end, { timeout = 250, type = "oneshot" })
end, { locked = true })


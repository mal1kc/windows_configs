local wezterm = require("wezterm")
-- local catpuccin = require 'colors/catpuccin'.setup{sync=true,sync_flavours={light='latte',dark='mocha',},flavour = 'mocha'}

local act = wezterm.action

local launch_menu = {
	{
		label = "cmd",
		args = { "cmd" },
	},
	{
		label = "pwsh",
		args = { "pwsh" },
	},
}

local leader_key = { key = "a", mods = "CTRL", timeout_miliseconds = 1000 }
		or {
			key = "Space",
			mods = "CTRL|SHIFT",
			timeout_miliseconds = 1000,
		}

local success, wsl_list, wsl_err = wezterm.run_child_process({ "wsl.exe", "-l" })
wsl_list = wezterm.utf16_to_utf8(wsl_list)
local wsl_names = {}

for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
	if idx > 1 then
		local distro = (line:gsub("%(Default%)", "")):gsub("%s+", "")
		if not (string.find(distro, "podman") or string.find(distro, "docker")) then
			table.insert(wsl_names, distro)
		end
	end
end

for idx, distro in ipairs(wsl_names) do
	table.insert(launch_menu, {
		label = "wsl - " .. distro .. " - tmux",
		args = {
			"wsl.exe",
			"--distribution",
			distro,
			"-e",
			"tmux",
		},
	})
	--	local success,distro_default_shell,wsl_err = wezterm.run_child_process{'wsl.exe','-d',distro,'echo','$SHELL'}
	--	distro_default_shell = wezterm.split_by_newlines(wezterm.utf16_to_utf8(distro_default_shell))
	--	wezterm.log_info(string.format("%s",type(distro_default_shell)))

	table.insert(launch_menu, {
		label = "wsl - " .. distro .. " - default_shell",
		args = { "wsl.exe", "--distribution", distro },
	})
end

for idx, item in ipairs(launch_menu) do
	wezterm.log_info(string.format("%d - %s - %s", idx, item.label, table.concat(item.args)))
end

return {
	font = wezterm.font("Fira Code", { weight = "Medium" }),
	--   colors = catpuccin,
	-- color_scheme='Wryan',
	color_scheme = "PencilDark",
	default_prog = { "cmd" },
	default_cwd = "$HOME",
	window_background_opacity = 0.83,
	text_background_opacity = 0.98,
	default_cursor_style = "SteadyBar",

	window_decorations = "RESIZE",
	hide_tab_bar_if_only_one_tab = true,
	launch_menu = launch_menu,
	leader = leader_key,
	keys = {
		-- {key ='m',mods='CMD',action='DisableDefaultAssignment'},
		{ key = "l", mods = "ALT",    action = act.ShowLauncher },
		{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "|", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{
			key = "UpArrow",
			mods = "SHIFT",
			action = act.ScrollByLine(-1),
		},
		{
			key = "DownArrow",
			mods = "SHIFT",
			action = act.ScrollByLine(1),
		},
		{
			key = "r",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "resize_pane",
				one_shot = false,
				replace_current = true,
			}),
		},
		{
			key = "a",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				one_shot = false,
				name = "activate_pane",
				timeout_miliseconds = 1000,
				replace_current = false,
			}),
		},
	},
	key_tables = {
		-- Defines the keys that are active in our resize-pane mode.
		-- Since we're likely to want to make multiple adjustments,
		-- we made the activation one_shot=false. We therefore need
		-- to define a key assignment for getting out of this mode.
		-- 'resize_pane' here corresponds to the name="resize_pane" in
		-- the key assignments above.
		resize_pane = {
			{ key = "LeftArrow",  action = act.AdjustPaneSize({ "Left", 1 }) },
			{ key = "h",          action = act.AdjustPaneSize({ "Left", 1 }) },
			{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
			{ key = "l",          action = act.AdjustPaneSize({ "Right", 1 }) },
			{ key = "UpArrow",    action = act.AdjustPaneSize({ "Up", 1 }) },
			{ key = "k",          action = act.AdjustPaneSize({ "Up", 1 }) },
			{ key = "DownArrow",  action = act.AdjustPaneSize({ "Down", 1 }) },
			{ key = "j",          action = act.AdjustPaneSize({ "Down", 1 }) },

			-- Cancel the mode by pressing escape
			{ key = "Escape",     action = "PopKeyTable" },
		},

		-- Defines the keys that are active in our activate-pane mode.
		-- 'activate_pane' here corresponds to the name="activate_pane" in
		-- the key assignments above.
		activate_pane = {
			{ key = "LeftArrow",  action = act.ActivatePaneDirection("Left") },
			{ key = "h",          action = act.ActivatePaneDirection("Left") },
			{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
			{ key = "l",          action = act.ActivatePaneDirection("Right") },
			{ key = "UpArrow",    action = act.ActivatePaneDirection("Up") },
			{ key = "k",          action = act.ActivatePaneDirection("Up") },
			{ key = "DownArrow",  action = act.ActivatePaneDirection("Down") },
			{ key = "j",          action = act.ActivatePaneDirection("Down") },
			{ key = "Escape",     action = "PopKeyTable" },
		},
	},
}

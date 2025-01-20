local os = require("os")
local wezterm = require("wezterm")
local colors = require("custom_colors")
local config = {}
config.automatically_reload_config = true

local act = wezterm.action

local leader_key = { key = "b", mods = "CTRL", timeout_miliseconds = 1000 }
	or { key = "Space", mods = "CTRL|SHIFT", timeout_miliseconds = 1000 }

local getDevProfile = function()
	wezterm.log_info("getDevProfile called")

	local profiles = {
		{
			label = "pwsh-dev",
			-- args = { "pwsh", "-NoLogo", "-NoExit", "-Command", "cd $env:DEV_HOME; clear;" },
			args = {
				"powershell.exe",
				'-NoExit -Command "&{Import-Module """C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\Common7\\Tools\\Microsoft.VisualStudio.DevShell.dll"""; Enter-VsDevShell f5dab38b -SkipAutomaticLocation -DevCmdArguments """-arch=x64 -host_arch=x64"""}"',
			},
		},
		{
			label = "cmd-dev",
			args = {
				"cmd",
				"/k",
				"C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\Common7\\Tools\\VsDevCmd.bat",
			},
		},
	}

	return profiles
end

local function createProfiles()
	local skip_wsl = false
	local include_dev = true
	local launch_menu = {
		{
			label = "pwsh",
			args = { "pwsh" },
		},
		{
			label = "cmd",
			args = { "cmd" },
		},
	}

	if not skip_wsl then
		local wsl_list = wezterm.default_wsl_domains()
		for _, distro in ipairs(wsl_list) do
			-- example -- wsl_list:
			-- {
			--  {
			--   name = "debian",
			--   distribution = "debian",
			--  },
			--  {
			--  name = "docker-desktop",
			--  distribution = "docker-desktop",
			--  }
			--
			-- }
			wezterm.log_info(string.format("distro: %s", distro.name))

			if not (string.find(distro.name, "podman") or string.find(distro.name, "docker")) then
				table.insert(launch_menu, {
					label = distro.name .. " - tmux",
					args = {
						"wsl.exe",
						"--distribution",
						distro.distribution,
						"-e",
						"tmux",
					},
				})
				table.insert(launch_menu, {
					label = distro.name .. " - default_shell",
					args = { "wsl.exe", "--distribution", distro.distribution },
				})
			end
		end
	end

	-- local success, wsl_list, wsl_err = wezterm.run_child_process({ "wsl.exe", "--list", "--verbose" })
	-- wsl_list = wezterm.utf16_to_utf8(wsl_list)
	-- if not success then
	-- 	wezterm.log_error(string.format("wsl_list: %s", wsl_err))
	-- 	skip_wsl = true
	-- end
	--
	-- if not skip_wsl and wsl_list then
	-- 	if wsl_list:find("NAME") == nil then
	-- 		wezterm.log_error(string.format("wsl_list is not valid (output of wsl.exe --list --verbose)"))
	-- 	end
	-- 	wsl_list = wsl_list:lower()
	-- 	for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
	-- 		if idx > 1 then
	-- 			-- example -- wsl_lis:
	-- 			--   NAME                   STATE           VERSION
	-- 			--   debian                 Running         2
	-- 			--   docker-desktop         Running         2
	-- 			--   docker-desktop-data    Running         2
	-- 			--
	-- 			--  needs to caught the NAME column and trim the spaces
	-- 			--
	-- 			-- line="debian                 Running         2"
	--
	-- 			-- should be the first word exp: debian
	--
	-- 			local distro = line:match("%l+")
	-- 			if not (string.find(distro, "podman") or string.find(distro, "docker")) then
	-- 				if distro == nil then
	-- 					wezterm.log_info(string.format("distro: nil from line: %s", line))
	-- 				else
	-- 					wezterm.log_info(string.format("distro: %s from line: %s", distro, line))
	-- 				end
	-- 				table.insert(wsl_names, distro)
	-- 				table.insert(launch_menu, {
	-- 					label = "wsl - " .. distro .. " - tmux",
	-- 					args = {
	-- 						"wsl.exe",
	-- 						"--distribution",
	-- 						distro,
	-- 						"-e",
	-- 						"tmux",
	-- 					},
	-- 				})
	-- 				--	local success,distro_default_shell,wsl_err = wezterm.run_child_process{'wsl.exe','-d',distro,'echo','$SHELL'}
	-- 				--	distro_default_shell = wezterm.split_by_newlines(wezterm.utf16_to_utf8(distro_default_shell))
	-- 				--	wezterm.log_info(string.format("%s",type(distro_default_shell)))
	--
	-- 				table.insert(launch_menu, {
	-- 					label = "wsl - " .. distro .. " - default_shell",
	-- 					args = { "wsl.exe", "--distribution", distro },
	-- 				})
	-- 			end
	-- 		end
	-- 	end
	-- end

	if include_dev then
		local dev_profiles = getDevProfile()
		for _, item in ipairs(dev_profiles) do
			table.insert(launch_menu, item)
		end
	end

	for idx, item in ipairs(launch_menu) do
		if not (item.label == "pwsh-dev" or item.label == "cmd-dev") then
			wezterm.log_info(string.format("%d - %s - %s", idx, item.label, table.concat(item.args)))
		end
	end
	return launch_menu
end

local profiles_menu = createProfiles()
local wallust_colors = colors.ReadWallustColors(wezterm, config.automatically_reload_config)
if not wallust_colors then
	wallust_colors = {
		colors = nil,
		color_scheme = nil,
		color_scheme_dirs = wezterm.color.color_scheme_dirs,
	}
end

config.font = wezterm.font("Iosevka Term", { weight = "Medium" })
-- color_scheme='Wryan',
config.colors = wallust_colors.colors
config.color_scheme = wallust_colors.color_scheme
config.color_scheme_dirs = wallust_colors.color_scheme_dirs
config.default_prog = profiles_menu[1].args
config.default_cwd = os.getenv("HOME")
config.window_background_opacity = 0.96
config.text_background_opacity = 0.98
config.default_cursor_style = "SteadyBar"
config.window_frame = { font_size = 13.0 }
config.window_padding = { top = 10, bottom = 10, left = 10, right = 10 }
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.launch_menu = profiles_menu
config.leader = leader_key
config.keys = {
	-- {key ='m',mods='CMD',action='DisableDefaultAssignment'},
	{ key = "l", mods = "ALT", action = act.ShowLauncher },
	{ key = ":", mods = "LEADER|SHIFT", action = act.ActivateCommandPalette },
	{ key = "o", mods = "LEADER", action = act.ActivatePaneDirection("Next") },
	{ key = '"', mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "n",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
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
		key = "q",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			one_shot = false,
			name = "activate_pane",
			timeout_miliseconds = 1000,
			replace_current = false,
		}),
	},
	{
		key = "z",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},
}
config.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
	activate_pane = {
		{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
		{ key = "h", action = act.ActivatePaneDirection("Left") },
		{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },
		{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },
		{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
		{ key = "Escape", action = "PopKeyTable" },
	},
}
return config

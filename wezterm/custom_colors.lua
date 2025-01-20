local M = {}

local wallust_colors_file_loc = os.getenv("HOME") .. "/.cache/wallust/colors"

function M.ReadWallustColors(wezterm, is_watched)
	local wallust_colors = {}

	if is_watched then
		wezterm.add_to_config_reload_watch_list(wallust_colors_file_loc)
	end
	local wallust_cache_file = io.open(wallust_colors_file_loc, "r")
	local err = nil

	if wallust_cache_file then
		local pyfile_c = wallust_cache_file:read("*a")
		local color_lines = wezterm.split_by_newlines(pyfile_c)
		local line_count = color_lines and #color_lines or 0 -- means 0 if color_lines is nil
		wallust_cache_file:close()
		if line_count == 16 then
			wallust_colors = {
				foreground = color_lines[4],
				background = color_lines[2],

				cursor_bg = color_lines[7],
				cursor_fg = color_lines[15],
				cursor_border = color_lines[5],

				selection_fg = color_lines[2],
				selection_bg = color_lines[4],

				scrollbar_thumb = color_lines[6],
				split = color_lines[8],

				-- ansi = { table.unpack(color_lines, 1, 8) },
				--
				-- brights = { table.unpack(color_lines, 9, 16) },
			}
		elseif line_count == 18 then
			wallust_colors = {
				foreground = color_lines[2],
				background = color_lines[4],

				cursor_bg = color_lines[7],
				cursor_fg = color_lines[15],
				cursor_border = color_lines[5],

				selection_fg = color_lines[4],
				selection_bg = color_lines[2],

				scrollbar_thumb = color_lines[6],
				split = color_lines[8],
				-- ansi = { table.unpack(color_lines, 1, 8) },
				--
				-- brights = { table.unpack(color_lines, 9, 16) },
				-- indexed = { [16] = color_lines[17], [17] = color_lines[18] },
			}
		else
			err = string.format("wallust colors file has wrong number of lines %d", line_count)
		end
	else
		err = "wallust colors file not found"
	end

	if err then
		wezterm.log_error(string.format("error reading wallust colors: %s", err))
		return {}
	end
	wezterm.log_info("successfully loaded wallust colors using raw method")
	return {
		colors = wallust_colors,
	}
end

return M

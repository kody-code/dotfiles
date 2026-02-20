local awful = require("awful")
local gears = require("gears")
local basics = require("config.basics")
local my_menu = require("config.menu")
local wallpaper = require("scripts.wallpaper")
local client = client
-- 引入多语言配置
local i18n = require("config.locales")

local modkey = basics.modkey

local function get_root_buttons()
	return gears.table.join(
		awful.button({}, 3, function()
			my_menu.main_menu:toggle()
		end),
		awful.button({}, 4, awful.tag.viewnext),
		awful.button({}, 5, awful.tag.viewprev)
	)
end

local function get_global_keys()
	local globalkeys = gears.table.join(
		awful.key({ modkey }, "s", hotkeys_popup.show_help, {
			description = i18n.desc.show_help,
			group = i18n.group.awesome,
		}),
		awful.key({ modkey }, "Left", awful.tag.viewprev, {
			description = i18n.desc.view_prev,
			group = i18n.group.tag,
		}),
		awful.key({ modkey }, "Right", awful.tag.viewnext, {
			description = i18n.desc.view_next,
			group = i18n.group.tag,
		}),
		awful.key({ modkey }, "Escape", awful.tag.history.restore, {
			description = i18n.desc.go_back,
			group = i18n.group.tag,
		}),

		awful.key({ modkey }, "j", function()
			awful.client.focus.byidx(1)
		end, {
			description = i18n.desc.focus_next_idx,
			group = i18n.group.client,
		}),
		awful.key({ modkey }, "k", function()
			awful.client.focus.byidx(-1)
		end, {
			description = i18n.desc.focus_prev_idx,
			group = i18n.group.client,
		}),
		awful.key({ modkey }, "w", function()
			my_menu.main_menu:show()
		end, {
			description = i18n.desc.show_main_menu,
			group = i18n.group.awesome,
		}),

		-- Layout manipulation
		awful.key({ modkey, "Shift" }, "j", function()
			awful.client.swap.byidx(1)
		end, {
			description = i18n.desc.swap_next_client,
			group = i18n.group.client,
		}),
		awful.key({ modkey, "Shift" }, "k", function()
			awful.client.swap.byidx(-1)
		end, {
			description = i18n.desc.swap_prev_client,
			group = i18n.group.client,
		}),
		awful.key({ modkey, "Control" }, "j", function()
			awful.screen.focus_relative(1)
		end, {
			description = i18n.desc.focus_next_screen,
			group = i18n.group.screen,
		}),
		awful.key({ modkey, "Control" }, "k", function()
			awful.screen.focus_relative(-1)
		end, {
			description = i18n.desc.focus_prev_screen,
			group = i18n.group.screen,
		}),
		awful.key({ modkey }, "u", awful.client.urgent.jumpto, {
			description = i18n.desc.jump_to_urgent,
			group = i18n.group.client,
		}),
		awful.key({ modkey }, "Tab", function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end, {
			description = i18n.desc.go_back,
			group = i18n.group.client,
		}),

		-- Standard program
		awful.key({ modkey }, "Return", function()
			awful.spawn(basics.terminal)
		end, {
			description = i18n.desc.open_terminal,
			group = i18n.group.launcher,
		}),
		awful.key({ modkey, "Control" }, "r", awesome.restart, {
			description = i18n.desc.reload_awesome,
			group = i18n.group.awesome,
		}),
		awful.key({ modkey, "Shift" }, "c", awesome.quit, {
			description = i18n.desc.quit_awesome,
			group = i18n.group.awesome,
		}),

		awful.key({ modkey }, "l", function()
			awful.tag.incmwfact(0.05)
		end, {
			description = i18n.desc.inc_master_width,
			group = i18n.group.layout,
		}),
		awful.key({ modkey }, "h", function()
			awful.tag.incmwfact(-0.05)
		end, {
			description = i18n.desc.dec_master_width,
			group = i18n.group.layout,
		}),
		awful.key({ modkey, "Shift" }, "h", function()
			awful.tag.incnmaster(1, nil, true)
		end, {
			description = i18n.desc.inc_master_clients,
			group = i18n.group.layout,
		}),
		awful.key({ modkey, "Shift" }, "l", function()
			awful.tag.incnmaster(-1, nil, true)
		end, {
			description = i18n.desc.dec_master_clients,
			group = i18n.group.layout,
		}),
		awful.key({ modkey, "Control" }, "h", function()
			awful.tag.incncol(1, nil, true)
		end, {
			description = i18n.desc.inc_columns,
			group = i18n.group.layout,
		}),
		awful.key({ modkey, "Control" }, "l", function()
			awful.tag.incncol(-1, nil, true)
		end, {
			description = i18n.desc.dec_columns,
			group = i18n.group.layout,
		}),
		awful.key({ modkey }, "space", function()
			awful.layout.inc(1)
		end, {
			description = i18n.desc.select_next_layout,
			group = i18n.group.layout,
		}),
		awful.key({ modkey, "Shift" }, "space", function()
			awful.layout.inc(-1)
		end, {
			description = i18n.desc.select_prev_layout,
			group = i18n.group.layout,
		}),

		awful.key({ modkey, "Control" }, "n", function()
			local c = awful.client.restore()
			if c then
				c:emit_signal("request::activate", "key.unminimize", { raise = true })
			end
		end, {
			description = i18n.desc.restore_minimized,
			group = i18n.group.client,
		}),

		-- Prompt
		awful.key({ modkey }, "r", function()
			awful.screen.focused().mypromptbox:run()
		end, {
			description = i18n.desc.run_prompt,
			group = i18n.group.launcher,
		}),

		awful.key({ modkey }, "x", function()
			awful.prompt.run({
				prompt = "Run Lua code: ",
				textbox = awful.screen.focused().mypromptbox.widget,
				exe_callback = awful.util.eval,
				history_path = awful.util.get_cache_dir() .. "/history_eval",
			})
		end, {
			description = i18n.desc.lua_execute,
			group = i18n.group.awesome,
		}),
		-- Menubar
		awful.key({ modkey }, "p", function()
			awful.spawn("rofi -show drun")
		end, {
			description = i18n.desc.show_rofi,
			group = i18n.group.launcher,
		}),

		-- 浮动终端快捷键
		awful.key({ modkey }, "\\", floatterm.toggle, {
			description = i18n.desc.toggle_float_term,
			group = i18n.group.launcher,
		}),
		awful.key({ modkey, "Shift" }, "\\", floatterm.close, {
			description = i18n.desc.close_float_term,
			group = i18n.group.launcher,
		}),

		awful.key({ modkey }, "F5", wallpaper.switch, {
			description = i18n.desc.switch_wallpaper,
			group = i18n.group.awesome,
		})
	)

	-- 绑定数字键到标签（1-9）
	for i = 1, 9 do
		globalkeys = gears.table.join(
			globalkeys,
			-- View tag only.
			awful.key({ modkey }, "#" .. i + 9, function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					tag:view_only()
				end
			end, {
				description = string.format(i18n.desc.view_tag, i),
				group = i18n.group.tag,
			}),
			-- Toggle tag display.
			awful.key({ modkey, "Control" }, "#" .. i + 9, function()
				local screen = awful.screen.focused()
				local tag = screen.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end, {
				description = string.format(i18n.desc.toggle_tag, i),
				group = i18n.group.tag,
			}),
			-- Move client to tag.
			awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
						tag:view_only()
					end
				end
			end, {
				description = string.format(i18n.desc.move_to_tag, i),
				group = i18n.group.tag,
			}),
			-- Toggle tag on focused client.
			awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end, {
				description = string.format(i18n.desc.toggle_client_tag, i),
				group = i18n.group.tag,
			})
		)
	end

	return globalkeys
end

local function get_client_keys()
	return gears.table.join(
		awful.key({ modkey }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, {
			description = i18n.desc.toggle_fullscreen,
			group = i18n.group.client,
		}),
		awful.key({ modkey, "Shift" }, "q", function(c)
			c:kill()
		end, {
			description = i18n.desc.close_client,
			group = i18n.group.client,
		}),
		awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle, {
			description = i18n.desc.toggle_floating,
			group = i18n.group.client,
		}),
		awful.key({ modkey, "Control" }, "Return", function(c)
			c:swap(awful.client.getmaster())
		end, {
			description = i18n.desc.move_to_master,
			group = i18n.group.client,
		}),
		awful.key({ modkey }, "o", function(c)
			c:move_to_screen()
		end, {
			description = i18n.desc.move_to_screen,
			group = i18n.group.client,
		}),
		awful.key({ modkey }, "t", function(c)
			c.ontop = not c.ontop
		end, {
			description = i18n.desc.toggle_ontop,
			group = i18n.group.client,
		}),
		awful.key({ modkey }, "n", function(c)
			c.minimized = true
		end, {
			description = i18n.desc.minimize,
			group = i18n.group.client,
		}),
		awful.key({ modkey }, "m", function(c)
			c.maximized = not c.maximized
			c:raise()
		end, {
			description = i18n.desc.toggle_maximize,
			group = i18n.group.client,
		}),
		awful.key({ modkey, "Control" }, "m", function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end, {
			description = i18n.desc.toggle_maximize_v,
			group = i18n.group.client,
		}),
		awful.key({ modkey, "Shift" }, "m", function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end, {
			description = i18n.desc.toggle_maximize_h,
			group = i18n.group.client,
		})
	)
end

-- 第四步：定义客户端（窗口）鼠标绑定（clientbuttons）
local function get_client_buttons()
	return gears.table.join(
		awful.button({}, 1, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
		end),
		awful.button({ modkey }, 1, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({ modkey }, 3, function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)
end

-- 核心初始化函数（传入所有依赖，绑定所有按键/鼠标）
local function init_keys(params)
	-- 接收外部依赖参数
	floatterm = params.floatterm
	menubar = params.menubar
	hotkeys_popup = params.hotkeys_popup

	-- 1. 绑定根窗口鼠标
	root.buttons(get_root_buttons())

	-- 2. 获取全局快捷键并绑定到根窗口
	local globalkeys = get_global_keys()
	root.keys(globalkeys)

	-- 3. 返回客户端快捷键/鼠标（供 rc.lua 绑定到客户端）
	return {
		clientkeys = get_client_keys(),
		clientbuttons = get_client_buttons(),
	}
end

return {
	init = init_keys,
}

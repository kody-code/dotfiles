local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local client = client

-- 第一步：定义窗口默认规则
local function get_client_rules()
	return {
		-- 所有窗口的默认规则
		{
			rule = {},
			properties = {
				border_width = beautiful.border_width,
				border_color = beautiful.border_normal,
				focus = awful.client.focus.filter,
				raise = true,
				keys = clientkeys,
				buttons = clientbuttons,
				screen = awful.screen.preferred,
				placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			},
		},

		-- 浮动窗口规则
		{
			rule_any = {
				instance = {
					"DTA",
					"copyq",
					"pinentry",
				},
				class = {
					"Arandr",
					"Blueman-manager",
					"Gpick",
					"Kruler",
					"MessageWin",
					"Sxiv",
					"Tor Browser",
					"Wpa_gui",
					"veromix",
					"xtightvncviewer",
				},
				name = {
					"Event Tester",
				},
				role = {
					"AlarmWindow",
					"ConfigManager",
					"pop-up",
				},
			},
			properties = { floating = true },
		},

		-- 为普通窗口/对话框添加标题栏
		{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

		-- 自定义规则示例（注释保留，方便后续扩展）
		-- { rule = { class = "Firefox" }, properties = { screen = 1, tag = "2" } },
	}
end

-- 第二步：绑定窗口相关信号
local function bind_client_signals()
	-- 新窗口创建时的处理（避免超出屏幕）
	client.connect_signal("manage", function(c)
		if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_offscreen(c)
		end
	end)

	-- 标题栏构建逻辑
	client.connect_signal("request::titlebars", function(c)
		local buttons = gears.table.join(
			awful.button({}, 1, function()
				c:emit_signal("request::activate", "titlebar", { raise = true })
				awful.mouse.client.move(c)
			end),
			awful.button({}, 3, function()
				c:emit_signal("request::activate", "titlebar", { raise = true })
				awful.mouse.client.resize(c)
			end)
		)

		awful.titlebar(c):setup({
			{ -- Left: 窗口图标
				awful.titlebar.widget.iconwidget(c),
				buttons = buttons,
				layout = wibox.layout.fixed.horizontal,
			},
			{ -- Middle: 窗口标题
				{
					align = "center",
					widget = awful.titlebar.widget.titlewidget(c),
				},
				buttons = buttons,
				layout = wibox.layout.flex.horizontal,
			},
			{ -- Right: 窗口控制按钮
				awful.titlebar.widget.floatingbutton(c),
				awful.titlebar.widget.maximizedbutton(c),
				awful.titlebar.widget.stickybutton(c),
				awful.titlebar.widget.ontopbutton(c),
				awful.titlebar.widget.closebutton(c),
				layout = wibox.layout.fixed.horizontal(),
			},
			layout = wibox.layout.align.horizontal,
		})
	end)

	-- 鼠标悬浮自动聚焦（sloppy focus）
	client.connect_signal("mouse::enter", function(c)
		c:emit_signal("request::activate", "mouse_enter", { raise = false })
	end)

	-- 窗口焦点/失焦时修改边框颜色
	client.connect_signal("focus", function(c)
		c.border_color = beautiful.border_focus
	end)
	client.connect_signal("unfocus", function(c)
		c.border_color = beautiful.border_normal
	end)
end

-- 核心初始化函数
local function init_client_rules(params)
	-- 接收外部依赖（客户端快捷键/鼠标）
	clientkeys = params.clientkeys
	clientbuttons = params.clientbuttons

	-- 1. 设置窗口规则
	awful.rules.rules = get_client_rules()

	-- 2. 绑定所有客户端信号
	bind_client_signals()
end

-- 对外暴露接口
return {
	init = init_client_rules,
}

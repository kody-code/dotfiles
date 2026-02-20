local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local basics = require("config.basics")
local wallpaper = require("scripts.wallpaper")

-- 标签栏（Taglist）按钮绑定（点击/滚轮切换标签）
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

-- 任务栏（Tasklist）按钮绑定（点击最小化/右键列表/滚轮切换窗口）
local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

local function init_screens(params)
	mylauncher = params.mylauncher
	mytextclock = params.mytextclock

	screen.connect_signal("property::geometry", wallpaper.set)

	awful.screen.connect_for_each_screen(function(s)
		wallpaper.set(s)
		awful.tag(basics.tags, s, basics.layouts)

		-- 提示符控件（运行命令）
		s.mypromptbox = awful.widget.prompt()
		-- 布局切换控件（点击/滚轮切换布局）
		s.mylayoutbox = awful.widget.layoutbox(s)
		s.mylayoutbox:buttons(gears.table.join(
			awful.button({}, 1, function()
				awful.layout.inc(1)
			end),
			awful.button({}, 3, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, 4, function()
				awful.layout.inc(1)
			end),
			awful.button({}, 5, function()
				awful.layout.inc(-1)
			end)
		))

		-- 标签栏（显示所有标签）
		s.mytaglist = awful.widget.taglist({
			screen = s,
			filter = awful.widget.taglist.filter.all,
			buttons = taglist_buttons,
		})

		-- 任务栏（显示当前标签的窗口）
		s.mytasklist = awful.widget.tasklist({
			screen = s,
			filter = awful.widget.tasklist.filter.currenttags,
			buttons = tasklist_buttons,
		})

		-- 构建状态栏（顶部）
		s.mywibox = awful.wibar({ position = "top", screen = s })

		-- 状态栏布局：左（启动器+标签+提示符）、中（任务栏）、右（键盘布局+系统托盘+时钟+布局切换）
		s.mywibox:setup({
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				mylauncher,
				s.mytaglist,
				s.mypromptbox,
			},
			s.mytasklist, -- Middle widget
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				wibox.widget.systray(),
				mytextclock,
				s.mylayoutbox,
			},
		})
	end)
end

return {
	init = init_screens,
}

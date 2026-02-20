local awful = require("awful") -- 核心功能（窗口管理、布局、快捷键等）
local beautiful = require("beautiful") -- 主题管理（颜色、字体、图标等）
local hotkeys_popup = require("awful.hotkeys_popup") -- 快捷键帮助弹窗
local basics = require("config.basics")

-- Awesome 内置菜单（快捷键帮助、手册、编辑配置、重启/退出）
awesome_submenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", basics.terminal .. " -e man awesome" },
	{ "edit config", basics.editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

-- 主菜单（Awesome 菜单 + 打开终端）
main_menu = awful.menu({
	items = {
		{ "awesome", awesome_submenu, beautiful.awesome_icon },
		{ "open terminal", basics.terminal },
	},
})

return {
	main_menu = main_menu,
}

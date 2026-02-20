-- 加载 LuaRocks 包管理器
pcall(require, "luarocks.loader")

-- 加载 Awesome 核心库
local gears = require("gears") -- 通用工具（文件、桌面、几何等）
local awful = require("awful") -- 核心功能（窗口管理、布局、快捷键等）
require("awful.autofocus") -- 自动焦点管理
local wibox = require("wibox") -- 控件/状态栏（wibar）构建
local beautiful = require("beautiful") -- 主题管理（颜色、字体、图标等）
local menubar = require("menubar") -- 应用程序菜单栏
local hotkeys_popup = require("awful.hotkeys_popup") -- 快捷键帮助弹窗
local app = require("config.initialization") --
local basics = require("config.basics")
local floatterm = require("scripts.floatterm")
local autostart = require("config.autostart")
local my_menu = require("config.menu")
local screen_setup = require("config.screen_setup")
local shortcut_key = require("config.shortcut_key")
local client_rules = require("config.client_rules")
local wallpaper = require("scripts.wallpaper")

-- 启动awesome前检测
app.init()

-- 加载默认主题
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/dracula/theme.lua")

-- 布局列表（平铺/浮动等，按优先级排序）
awful.layout.layouts = {
	awful.layout.suit.floating, -- 浮动布局（无自动排列）
	awful.layout.suit.tile, -- 纵向平铺（主窗口+副窗口）
	awful.layout.suit.tile.left, -- 左侧主窗口平铺
	awful.layout.suit.tile.bottom, -- 底部主窗口平铺
	awful.layout.suit.tile.top, -- 顶部主窗口平铺
	awful.layout.suit.fair, -- 公平平铺（均分空间）
	awful.layout.suit.fair.horizontal, -- 水平公平平铺
	awful.layout.suit.spiral, -- 螺旋平铺
	awful.layout.suit.spiral.dwindle, -- 螺旋收缩平铺
	awful.layout.suit.max, -- 最大化（保留状态栏）
	awful.layout.suit.max.fullscreen, -- 全屏
	awful.layout.suit.magnifier, -- 放大镜（聚焦窗口放大）
	awful.layout.suit.corner.nw, -- 西北角主窗口
}

modkey = basics.modkey

-- 启动器控件（点击弹出主菜单）
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = my_menu.main_menu })

-- 应用菜单栏配置（指定默认终端）
menubar.utils.terminal = basics.terminal

-- 键盘布局切换控件
mykeyboardlayout = awful.widget.keyboardlayout()

-- 时钟控件
mytextclock = wibox.widget.textclock()

wallpaper.init()

-- 为每个屏幕初始化状态栏
screen_setup.init({
	mylauncher = mylauncher,
	mytextclock = mytextclock,
})

-- 快捷键
local client_bindings = shortcut_key.init({
	floatterm = floatterm,
	menubar = menubar,
	hotkeys_popup = hotkeys_popup,
})
client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings(client_bindings.clientkeys)
end)
client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings(client_bindings.clientbuttons)
end)

-- 初始化窗口规则（传入客户端快捷键/鼠标）
client_rules.init({
	clientkeys = client_bindings.clientkeys,
	clientbuttons = client_bindings.clientbuttons,
})

local autostart_programs = {
	{ cmd = "fcitx5 -d", notify = true },
	{ cmd = "picom -b", notify = true },
}

autostart.start(autostart_programs)

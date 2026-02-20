local awful = require("awful") -- 核心功能（窗口管理、布局、快捷键等）

local M = {}

-- 终端/编辑器配置
M.terminal = "alacritty"
M.editor = os.getenv("EDITOR") or "nvim"
M.editor_cmd = M.terminal .. " -e " .. M.editor

-- 修饰键（Mod4 = 键盘上的 Windows/Super 键）
M.modkey = "Mod4"

M.tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
M.layouts = {
	awful.layout.suit.spiral.dwindle, -- tag 1: dwindle 布局
	awful.layout.suit.tile, -- tag 2: 默认平铺
	awful.layout.suit.tile, -- tag 3: 默认平铺
	awful.layout.suit.tile, -- tag 4: 默认平铺
	awful.layout.suit.tile, -- tag 5: 默认平铺
	awful.layout.suit.tile, -- tag 6: 默认平铺
	awful.layout.suit.tile, -- tag 7: 默认平铺
	awful.layout.suit.tile, -- tag 8: 默认平铺
	awful.layout.suit.floating, -- tag 9: 浮动布局（保持默认）
}
return M

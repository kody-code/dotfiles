-- 多语言配置（快捷键描述/分组）
local locales = {
	-- 英文配置
	en = {
		-- 分组名
		group = {
			awesome = "awesome",
			tag = "tag",
			client = "client",
			screen = "screen",
			launcher = "launcher",
			layout = "layout",
		},
		-- 快捷键描述
		desc = {
			show_help = "show help",
			view_prev = "view previous",
			view_next = "view next",
			go_back = "go back",
			focus_next_idx = "focus next by index",
			focus_prev_idx = "focus previous by index",
			show_main_menu = "show main menu",
			swap_next_client = "swap with next client by index",
			swap_prev_client = "swap with previous client by index",
			focus_next_screen = "focus the next screen",
			focus_prev_screen = "focus the previous screen",
			jump_to_urgent = "jump to urgent client",
			open_terminal = "open a terminal",
			reload_awesome = "reload awesome",
			quit_awesome = "quit awesome",
			inc_master_width = "increase master width factor",
			dec_master_width = "decrease master width factor",
			inc_master_clients = "increase the number of master clients",
			dec_master_clients = "decrease the number of master clients",
			inc_columns = "increase the number of columns",
			dec_columns = "decrease the number of columns",
			select_next_layout = "select next",
			select_prev_layout = "select previous",
			restore_minimized = "restore minimized",
			run_prompt = "run prompt",
			lua_execute = "lua execute prompt",
			show_rofi = "show rofi launcher",
			toggle_float_term = "toggle floating terminal",
			close_float_term = "close floating terminal",
			switch_wallpaper = "manual switch wallpaper",
			view_tag = "view tag #%s",
			toggle_tag = "toggle tag #%s",
			move_to_tag = "move focused client to tag #%s and switch to it",
			toggle_client_tag = "toggle focused client on tag #%s",
			toggle_fullscreen = "toggle fullscreen",
			close_client = "close",
			toggle_floating = "toggle floating",
			move_to_master = "move to master",
			move_to_screen = "move to screen",
			toggle_ontop = "toggle keep on top",
			minimize = "minimize",
			toggle_maximize = "(un)maximize",
			toggle_maximize_v = "(un)maximize vertically",
			toggle_maximize_h = "(un)maximize horizontally",
		},
	},
	-- 中文配置
	zh = {
		-- 分组名
		group = {
			awesome = "核心功能",
			tag = "标签页",
			client = "窗口",
			screen = "显示器",
			launcher = "启动器",
			layout = "布局",
		},
		-- 快捷键描述
		desc = {
			show_help = "显示帮助",
			view_prev = "上一个标签",
			view_next = "下一个标签",
			go_back = "返回上一标签",
			focus_next_idx = "按索引聚焦下一个窗口",
			focus_prev_idx = "按索引聚焦上一个窗口",
			show_main_menu = "显示主菜单",
			swap_next_client = "与下一个窗口交换位置",
			swap_prev_client = "与上一个窗口交换位置",
			focus_next_screen = "聚焦下一个显示器",
			focus_prev_screen = "聚焦上一个显示器",
			jump_to_urgent = "跳转到紧急窗口",
			open_terminal = "打开终端",
			reload_awesome = "重启 Awesome",
			quit_awesome = "退出 Awesome",
			inc_master_width = "增加主窗口宽度比例",
			dec_master_width = "减少主窗口宽度比例",
			inc_master_clients = "增加主窗口数量",
			dec_master_clients = "减少主窗口数量",
			inc_columns = "增加列数",
			dec_columns = "减少列数",
			select_next_layout = "下一个布局",
			select_prev_layout = "上一个布局",
			restore_minimized = "恢复最小化窗口",
			run_prompt = "运行命令提示符",
			lua_execute = "执行 Lua 代码",
			show_rofi = "打开 Rofi 启动器",
			toggle_float_term = "切换浮动终端",
			close_float_term = "关闭浮动终端",
			switch_wallpaper = "手动切换壁纸",
			view_tag = "切换到标签 #%s",
			toggle_tag = "切换标签 #%s 显示",
			move_to_tag = "移动窗口到标签 #%s 并切换",
			toggle_client_tag = "切换窗口在标签 #%s 的显示",
			toggle_fullscreen = "切换全屏",
			close_client = "关闭窗口",
			toggle_floating = "切换浮动模式",
			move_to_master = "移到主窗口位置",
			move_to_screen = "移到其他显示器",
			toggle_ontop = "切换置顶",
			minimize = "最小化",
			toggle_maximize = "最大化/还原",
			toggle_maximize_v = "垂直最大化/还原",
			toggle_maximize_h = "水平最大化/还原",
		},
	},
}

-- 从环境变量检测语言（优先 LANG，兼容 zh_CN/zh_TW/en_US 等格式）
local function get_current_lang()
	local lang = os.getenv("LANG") or "en_US.UTF-8"
	-- 提取语言前缀（zh/en）
	local lang_prefix = lang:sub(1, 2):lower()
	-- 只支持 zh/en，默认 en
	if lang_prefix == "zh" then
		return "zh"
	else
		return "en"
	end
end

-- 获取当前语言的配置
local current_lang = get_current_lang()
local lang_config = locales[current_lang]

return {
	-- 对外暴露当前语言的分组/描述
	group = lang_config.group,
	desc = lang_config.desc,
	-- 暴露语言检测方法（可选）
	get_lang = get_current_lang,
	-- 暴露原始配置（可选）
	locales = locales,
}

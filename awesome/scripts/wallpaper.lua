local gears = require("gears")
local beautiful = require("beautiful")
local awful = require("awful")
local filesystem = gears.filesystem
local naughty = require("naughty")
local lfs = require("lfs")

-- 配置项（可根据需求调整）
local wallpaper_config = {
	dir = os.getenv("HOME") .. "/Picture/wallpapers/", -- 壁纸目录
	interval = 400, -- 切换间隔（秒），默认10分钟
	random = true, -- true=随机切换，false=顺序切换
	valid_extensions = { "jpg", "jpeg", "png", "gif", "webp" }, -- 支持的壁纸格式
}

-- 全局变量：存储壁纸列表、当前索引
local wallpaper_list = {}
local current_index = 1

-- 第一步：扫描壁纸目录，获取有效壁纸列表
local function scan_wallpapers()
	local wallpapers = {}
	-- 检查目录是否存在
	if not lfs.attributes(wallpaper_config.dir) then
		naughty.notify({
			preset = naughty.config.presets.warning,
			title = "壁纸目录错误",
			text = "目录不存在：" .. wallpaper_config.dir,
		})
		return wallpapers
	end

	-- 遍历目录下的文件
	for file in lfs.dir(wallpaper_config.dir) do
		-- 过滤 . 和 .. 特殊目录条目
		if file ~= "." and file ~= ".." then
			-- 拼接完整文件路径
			local full_path = wallpaper_config.dir .. file
			-- 检查当前条目是否为文件（排除子目录）
			local file_attr = lfs.attributes(full_path)
			if file_attr and file_attr.mode == "file" then
				-- 过滤有效扩展名（保留原有逻辑）
				local ext = file:match("%.(%w+)$")
				if ext then
					ext = ext:lower()
					for _, valid_ext in ipairs(wallpaper_config.valid_extensions) do
						if ext == valid_ext then
							table.insert(wallpapers, full_path)
							break
						end
					end
				end
			end
		end
	end

	-- 随机打乱列表（如果开启随机）
	if wallpaper_config.random then
		-- 方法2：通用 Lua 算法（注释掉上面，启用下面）
		math.randomseed(os.time())
		for i = #wallpapers, 2, -1 do
			local j = math.random(i)
			wallpapers[i], wallpapers[j] = wallpapers[j], wallpapers[i]
		end
	end

	return wallpapers
end

-- 第二步：设置单屏壁纸
local function set_wallpaper(s)
	-- 初始化壁纸列表（首次/列表为空时）
	if #wallpaper_list == 0 then
		wallpaper_list = scan_wallpapers()
		-- 无壁纸时使用默认主题壁纸
		if #wallpaper_list == 0 then
			if beautiful.wallpaper then
				local default_wallpaper = beautiful.wallpaper
				if type(default_wallpaper) == "function" then
					default_wallpaper = default_wallpaper(s)
				end
				gears.wallpaper.maximized(default_wallpaper, s, true)
			end
			return
		end
	end

	-- 选择当前要显示的壁纸
	local wallpaper_path = wallpaper_list[current_index]
	-- 设置壁纸（最大化填充，保持比例）
	gears.wallpaper.maximized(wallpaper_path, s, true)

	-- 更新索引（顺序/随机逻辑）
	if wallpaper_config.random then
		current_index = math.random(1, #wallpaper_list)
	else
		current_index = current_index + 1
		if current_index > #wallpaper_list then
			current_index = 1
		end
	end
end

-- 第三步：启动定时切换定时器
local function start_wallpaper_timer()
	-- 避免重复启动定时器
	if wallpaper_timer then
		wallpaper_timer:stop()
	end

	wallpaper_timer = gears.timer({
		timeout = wallpaper_config.interval,
		autostart = true,
		call_now = true, -- 立即执行一次
		callback = function()
			-- 遍历所有屏幕更新壁纸
			for s in screen do
				set_wallpaper(s)
			end
		end,
	})
end

-- 初始化：启动定时器 + 监听屏幕分辨率变化
local function init()
	start_wallpaper_timer()
	-- 屏幕分辨率变化时重新设置壁纸
	screen.connect_signal("property::geometry", function(s)
		set_wallpaper(s)
	end)
end

-- 对外暴露接口
return {
	set = set_wallpaper,
	init = init,
	-- 可选：手动切换壁纸的接口（可绑定快捷键）
	switch = function()
		for s in screen do
			set_wallpaper(s)
		end
	end,
}

local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")

-- 核心函数：接收程序列表，循环启动（支持两种启动方式：once/with_shell）
-- 参数说明：
--   programs: 数组，每个元素是 {cmd = "命令", type = "once"/"shell"}（type 默认 "once"）
local function start_programs(programs)
	-- 先校验参数是否为有效列表
	if type(programs) ~= "table" or #programs == 0 then
		naughty.notify({
			preset = naughty.config.presets.warning,
			title = "自启程序错误",
			text = "参数必须是非空的程序列表（数组）",
		})
		return
	end

	for _, prog in ipairs(programs) do
		-- 校验必要参数（cmd 不能为空）
		if not prog or not prog.cmd then
			naughty.notify({
				preset = naughty.config.presets.warning,
				title = "自启程序错误",
				text = "发现无效的程序配置：缺少 cmd 参数",
			})
			goto continue
		end

		local launch = function()
			if prog.type == "shell" then
				awful.spawn.with_shell(prog.cmd)
			else
				awful.spawn.once(prog.cmd)
			end
		end

		-- 可选：输出启动成功的通知（调试用）
		if prog.notify then
			naughty.notify({
				title = "自启程序",
				text = "成功启动：" .. prog.cmd,
				timeout = 2, -- 2 秒后自动消失
			})
		end

		if prog.delay and type(prog.delay) == "number" then
			gears.timer.start_new(prog.delay, launch)
		else
			launch()
		end
		::continue::
	end
end

return {
	start = start_programs,
}

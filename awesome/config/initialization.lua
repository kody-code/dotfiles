local naughty = require("naughty") -- 通知系统

local function initialization()
	-- 启动时错误提示
	if awesome.startup_errors then
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, there were errors during startup!",
			text = awesome.startup_errors,
		})
	end

	-- 运行时错误提示（避免无限循环）
	do
		local in_error = false
		awesome.connect_signal("debug::error", function(err)
			if in_error then
				return
			end
			in_error = true

			naughty.notify({
				preset = naughty.config.presets.critical,
				title = "Oops, an error happened!",
				text = tostring(err),
			})
			in_error = false
		end)
	end
end

return {
	init = initialization,
}

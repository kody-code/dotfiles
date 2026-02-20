local awful = require("awful")
local gears = require("gears")

local config = {
	cmd = "alacritty --class float-term",
	width = 800,
	height = 500,
	x = 0,
	y = 0,
	sticky = true,
	ontop = true,
	skip_taskbar = true,
	border_width = 0,
}

local float_term_client = nil

local function toggle()
	if float_term_client and float_term_client.valid then
		-- 切换显示/隐藏
		float_term_client.hidden = not float_term_client.hidden
		if not float_term_client.hidden then
			float_term_client:raise()
			client.focus = float_term_client
		end
	else
		awful.spawn.spawn(config.cmd, {
			callback = function(c)
				float_term_client = c
				-- 设置浮动属性
				c.floating = true
				c.sticky = config.sticky
				c.ontop = config.ontop
				c.skip_taskbar = config.skip_taskbar
				c.border_width = config.border_width

				-- 计算位置（屏幕中心）
				local s = awful.screen.focused()
				local geom = s.geometry
				c:geometry({
					x = geom.x + (geom.width - config.width) / 2 + config.x,
					y = geom.y + (geom.height - config.height) / 2 + config.y,
					width = config.width,
					height = config.height,
				})

				client.focus = c
			end,
		})
	end
end

local function close()
	if float_term_client and float_term_client.valid then
		float_term_client:kill()
		float_term_client = nil
	end
end

return {
	toggle = toggle,
	close = close,
	config = config,
}

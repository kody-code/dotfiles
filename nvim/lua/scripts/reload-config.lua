-- 重新加载配置
vim.api.nvim_create_user_command("ReloadConfig", function()
	vim.cmd("source $MYVIMRC")
	vim.notify("配置已重新加载", "info")
end, {})

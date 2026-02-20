-- 快速编辑配置
vim.api.nvim_create_user_command("EditConfig", function()
	vim.cmd("e $MYVIMRC")
end, {})

-- ===== 基本设置 =====
-- 全局UTF-8编码
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8,gbk,gb2312"

-- 行号
vim.opt.number = true
vim.opt.relativenumber = true

-- 缩进
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- 搜索
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- 外观
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.colorcolumn = "80" -- 在第80列显示参考线

-- 文件和备份
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = false

-- 分割窗口
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 其他
vim.opt.mouse = "a" -- 启用鼠标
vim.opt.updatetime = 50 -- 更快的响应时间
vim.opt.timeoutlen = 300 -- 快捷键响应时间
vim.opt.scrolloff = 8 -- 光标距离边界8行时滚动
vim.opt.wrap = false -- 不自动换行
vim.opt.errorbells = false -- 不发出错误声音
vim.opt.visualbell = false -- 不使用视觉提示

-- 领导键
vim.g.mapleader = " "
vim.g.localleader = "\\"

-- 剪切板
vim.g.clipboard = {
	name = "xclip",
	copy = {
		["+"] = { "xclip", "-selection", "clipboard" },
		["*"] = { "xclip", "-selection", "primary" },
	},
	paste = {
		["+"] = { "xclip", "-o", "-selection", "clipboard" },
		["*"] = { "xclip", "-o", "-selection", "primary" },
	},
	cache_enabled = 0,
}
vim.opt.clipboard = "unnamedplus"

vim.opt.shell = "zsh"
vim.api.nvim_create_user_command("Term", "terminal", { desc = "打开终端" })
vim.keymap.set("n", "<leader>t", "<cmd>Term<cr>", { desc = "打开终端" })

-- 终端模式快捷键
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { buffer = true, desc = "退出终端模式" })
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

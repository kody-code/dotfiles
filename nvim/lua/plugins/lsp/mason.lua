return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			max_concurrent_installers = 10,
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				-- LSP 服务器
				"lua-language-server",
				"pyright",
				"vim-language-server",

				-- 格式化工具
				"stylua",
				"prettier",
				"eslint_d",
				"black",
				"isort",
				"shfmt",
			},
			auto_update = true, -- 自动更新已安装的工具
			run_on_start = true, -- 启动时运行安装
		})
	end,
}

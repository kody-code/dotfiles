return {
	"CRAG666/code_runner.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("code_runner").setup({
			mode = "float",
			term = {
				position = "bot",
				size = 12,
			},
			float = {
				close_key = "<ESC>",
				border = "rounded",

				height = 0.8,
				width = 0.8,
				x = 0.5,
				y = 0.5,
				border_hl = "FloatBorder",
				float_hl = "Normal",
				blend = 0,
			},
			filetype = {
				python = "python -u",
				lua = "lua",
				sh = "bash",
				go = "go run",
				rust = "cargo run",
			},
		})
		-- 添加快捷键
		vim.keymap.set("n", "<leader>rr", "<cmd>RunCode<cr>", { desc = "一键运行当前文件" })
		vim.keymap.set("n", "<F5>", "<cmd>RunFile<cr>", { desc = "运行当前文件" })
	end,
}

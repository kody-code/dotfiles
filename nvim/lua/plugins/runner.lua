return {
	"CRAG666/code_runner.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("code_runner").setup({
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
		vim.keymap.set("n", "<leader>rf", "<cmd>RunFile<cr>", { desc = "运行当前文件" })
		vim.keymap.set("n", "<F5>", "<cmd>RunFile tab<cr>", { desc = "在新标签页运行" })
	end,
}

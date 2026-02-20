return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "查找文件" })
		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "全局搜索" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "切换缓冲区" })
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "搜索帮助" })

		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "node_modules", ".git" },
				mappings = {
					i = {
						["<C-u>"] = false,
						["<C-d>"] = false,
					},
				},
			},
		})
	end,
}

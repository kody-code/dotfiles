return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		vim.g.ts_context_commentstring_conceal = 0
		vim.g.nvim_treesitter_compiler = {
			cmd = "clang",
			args = {
				"-O2",
				"-march=native",
				"-j" .. tostring(vim.fn.system("nproc")),
			},
		}
		require("nvim-treesitter").install({
			"vim",
			"lua",
			"javascript",
			"typescript",
			"python",
			"html",
			"css",
			"markdown",
		})
	end,
}

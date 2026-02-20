return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install({
			"c",
			"vim",
			"lua",
			"javascript",
			"typescript",
			"python",
			"html",
			"css",
			"markdown",
			"go",
			"rust",
		})
	end,
}

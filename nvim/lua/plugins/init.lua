local opts = {
	git = {
		log = { "-1" },
		timeout = 120,
		url_format = "https://github.com/%s.git",
		filter = true,
		throttle = {
			enabled = false,
			rate = 2,
			duration = 5 * 1000,
		},
		cooldown = 0,
	},
}

require("lazy").setup({
	require("plugins.nvim-tree"),
	require("plugins.lualine"),
	require("plugins.theme"),
	require("plugins.telescope"),
	require("plugins.treesitter"),
	require("plugins.notify"),
	require("plugins.gitsigns"),
	require("plugins.autopairs"),
	require("plugins.comment"),
	require("plugins.project"),
	require("plugins.runner"),
	require("plugins.rustaceanvim"),
	-- LSP
	require("plugins.lsp.mason"),
	require("plugins.lsp.lspconfig"),
	require("plugins.lsp.cmp"),
	require("plugins.lsp.dap"),
	require("plugins.lsp.conform"),
}, opts)

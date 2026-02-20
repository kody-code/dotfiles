return {
	"mrcjkb/rustaceanvim",
	version = "^3", -- 推荐使用稳定版本
	ft = { "rust" },
	dependencies = {
		"mfussenegger/nvim-dap", -- 依赖已有的 DAP 框架
		"rcarriga/nvim-dap-ui",
	},
	config = function()
		vim.g.rustaceanvim = {
			server = {
				on_attach = function(client, bufnr)
					-- 保持与现有 LSP 快捷键一致
					local opts = { buffer = bufnr, desc = "Rust LSP 操作" }
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
				end,
			},
			dap = {
				adapter = {
					type = "executable",
					command = "lldb-vscode", -- 需要安装 lldb-vscode
					name = "lldb",
				},
			},
		}

		-- 调试快捷键（与现有 DAP 快捷键保持一致）
		local opts = { noremap = true, silent = true, buffer = 0 }
		vim.keymap.set("n", "<F6>", function()
			require("dap").continue()
		end, opts)
		vim.keymap.set("n", "<F10>", function()
			require("dap").step_over()
		end, opts)
		vim.keymap.set("n", "<F11>", function()
			require("dap").step_into()
		end, opts)
		vim.keymap.set("n", "<F12>", function()
			require("dap").step_out()
		end, opts)
		vim.keymap.set("n", "<leader>b", function()
			require("dap").toggle_breakpoint()
		end, opts)
	end,
}

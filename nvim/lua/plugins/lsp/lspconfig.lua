return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"ray-x/lsp_signature.nvim",
	},
	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local function on_attach(client, bufnr)
			-- 格式化配置保持不变
			if client.supports_method("textDocument/formatting") then
				local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ async = false })
					end,
				})
			end
		end

		local server_configs = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
							},
						},
						telemetry = { enable = false },
					},
				},
			},
			gopls = {
				settings = {
					gopls = {
						gofumpt = true, -- 使用 gofumpt 格式化
						usePlaceholders = true,
						completeUnimported = true,
						analyses = {
							unusedparams = true,
							shadow = true,
						},
					},
				},
			},
			rust_analyzer = {
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
						},
						checkOnSave = {
							command = "clippy", -- 使用 clippy 进行代码检查
						},
					},
				},
			},
		}

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"pyright",
				"jsonls",
				"vimls",
			},
			handlers = {
				function(server_name)
					vim.lsp.config({
						servers = {
							[server_name] = {
								cmd = require("lspconfig")[server_name].document_config.default_config.cmd,
								capabilities = capabilities,
								on_attach = on_attach,
								settings = server_configs[server_name] and server_configs[server_name].settings or {},
							},
						},
					})
				end,
			},
		})
	end,
}

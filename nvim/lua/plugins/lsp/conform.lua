return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	config = function()
		local conform = require("conform")

		conform.setup({
			-- 定义格式化工具 - 每个工具都有正确的参数配置
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier" }, -- 优先使用prettierd(守护进程版本)
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				jsonc = { "prettierd", "prettier" },
				yaml = { "prettierd", "prettier" },
				markdown = { "prettierd", "prettier" },
				graphql = { "prettierd", "prettier" },
				scss = { "prettierd", "prettier" },
				less = { "prettierd", "prettier" },
				sh = { "shfmt" },
				go = { "gofumpt", "golines" },
				rust = { "rustfmt" },
			},

			-- 精确配置每个格式化工具
			formatters = {
				-- 修正Stylua配置
				stylua = {
					command = "stylua",
					args = { "--stdin-filepath", "$FILENAME", "-" }, -- 关键修正：添加"-"表示从stdin读取
					stdin = true,
				},

				-- Prettier配置
				prettier = {
					command = "prettier",
					args = { "--stdin-filepath", "$FILENAME" },
					stdin = true,
				},

				-- Prettier守护进程版本(更快)
				prettierd = {
					command = "prettierd",
					args = { "$FILENAME" },
					stdin = true,
				},

				-- Black (Python)
				black = {
					command = "black",
					args = { "--quiet", "-" },
					stdin = true,
				},

				-- isort (Python导入排序)
				isort = {
					command = "isort",
					args = { "--quiet", "-" },
					stdin = true,
				},

				-- shfmt (Shell脚本)
				shfmt = {
					command = "shfmt",
					args = { "-i", "2", "-ci", "-bn" }, -- 2空格缩进，case缩进，二元运算符换行
					stdin = true,
				},

				gofumpt = {
					command = "gofumpt",
					stdin = true,
				},
				golines = {
					command = "golines",
					args = { "--max-len=120", "-w" },
					stdin = false,
				},

				rustfmt = {
					command = "rustfmt",
					stdin = true,
				},
			},

			-- 保存时自动格式化
			format_on_save = {
				-- 可以排除特定文件类型
				ignore_filetypes = { "gitcommit", "markdown", "help", "txt" },
				-- 延迟毫秒数，避免在输入时频繁触发
				-- delay_ms = 200,
				-- 回退到LSP格式化
				lsp_fallback = true,
			},

			-- 异步格式化
			async = true,
			timeout_ms = 1000, -- 1秒超时
			log_level = vim.log.levels.WARN,

			-- 格式化后显示通知
			notify_on_error = true,
		})

		-- 添加一个命令来检查格式化工具状态
		vim.api.nvim_create_user_command("FormatToolsCheck", function()
			local tools = {
				"stylua",
				"prettier",
				"prettierd",
				"black",
				"isort",
				"shfmt",

				"gofumpt",
				"golines",
				"rustfmt",
			}

			local status = {}
			for _, tool in ipairs(tools) do
				local found = vim.fn.executable(tool) == 1
				table.insert(status, string.format("%s: %s", tool, found and "✓ installed" or "✗ not found"))
			end

			vim.notify(table.concat(status, "\n"), found and "info" or "warn", {
				title = "Formatting Tools Status",
				timeout = 5000,
			})
		end, {})

		-- 添加一个键映射来检查工具
		vim.keymap.set("n", "<leader>ft", "<cmd>FormatToolsCheck<cr>", { desc = "Check formatting tools" })
	end,
}

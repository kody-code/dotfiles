-- 完整的 DAP 配置 (保存为 lua/plugins/dap.lua 或类似路径)
return {
	-- 1. 必须首先加载 nvim-nio
	{
		"nvim-neotest/nvim-nio",
		lazy = true,
	},

	-- 2. 核心 DAP 插件
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- 3. DAP UI (依赖 nvim-nio)
			"rcarriga/nvim-dap-ui",
			-- 4. 虚拟文本显示
			"theHamsta/nvim-dap-virtual-text",
			-- 5. Mason 集成
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			-- 调试适配器安装
			-- Python
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Python 调试配置
			require("dap-python").setup("python", {
				console = "integratedTerminal",
			})

			-- Rust 调试配置
			local rust_lsp_config = {
				name = "rust_analyzer",
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- 保留原有的 on_attach 逻辑
					on_attach(client, bufnr)

					-- Rust 特定快捷键
					vim.keymap.set(
						"n",
						"<leader>rr",
						"<cmd>RustRunnables<CR>",
						{ buffer = bufnr, desc = "Rust 运行选项" }
					)
					vim.keymap.set(
						"n",
						"<leader>rc",
						"<cmd>RustOpenCargo<CR>",
						{ buffer = bufnr, desc = "打开 Cargo.toml" }
					)
				end,
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
			}

			-- Golang 调试配置
			dap.adapters.go = {
				type = "server",
				port = "${port}",
				executable = {
					command = "dlv",
					args = { "dap", "-l", "127.0.0.1:${port}" },
				},
			}
			dap.configurations.go = {
				{
					type = "go",
					name = "Launch",
					request = "launch",
					program = "${file}",
				},
				{
					type = "go",
					name = "Launch test",
					request = "launch",
					mode = "test",
					program = "${file}",
				},
				{
					type = "go",
					name = "Launch test (package)",
					request = "launch",
					mode = "test",
					program = "${workspaceFolder}",
				},
			}

			-- 虚拟文本配置
			require("nvim-dap-virtual-text").setup({
				highlight_changed_variables = true,
				highlight_new_as_changed = true,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
			})

			-- DAP UI 配置
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.33 },
							{ id = "breakpoints", size = 0.17 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.45 },
							{ id = "console", size = 0.55 },
						},
						size = 0.25,
						position = "bottom",
					},
				},
			})

			-- 自动打开/关闭 UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Mason DAP 配置
			require("mason-nvim-dap").setup({
				ensure_installed = { "python", "delve", "codelldb" },
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})

			-- Python 调试配置
			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						-- 智能检测 Python 路径
						local cwd = vim.fn.getcwd()
						local paths = {
							cwd .. "/venv/bin/python",
							cwd .. "/.venv/bin/python",
							vim.fn.expand("~/.virtualenvs") .. "/*/bin/python",
							vim.fn.expand("~/.pyenv/shims/python"),
							"/usr/bin/python3",
							"/usr/local/bin/python3",
						}

						for _, path in ipairs(paths) do
							if vim.fn.executable(path:gsub("%*", "")) == 1 then
								return path:gsub("%*", "")
							end
						end

						return "python"
					end,
					console = "integratedTerminal",
					justMyCode = true,
				},
				{
					type = "python",
					request = "attach",
					name = "Attach to remote",
					host = "127.0.0.1",
					port = 5678,
					pathMappings = {
						{
							localRoot = "${workspaceFolder}",
							remoteRoot = ".",
						},
					},
				},
			}

			-- 调试快捷键
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<F6>", function()
				dap.continue()
			end, opts)
			vim.keymap.set("n", "<F10>", function()
				dap.step_over()
			end, opts)
			vim.keymap.set("n", "<F11>", function()
				dap.step_into()
			end, opts)
			vim.keymap.set("n", "<F12>", function()
				dap.step_out()
			end, opts)
			vim.keymap.set("n", "<leader>b", function()
				dap.toggle_breakpoint()
			end, opts)
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, opts)
			vim.keymap.set("n", "<leader>lp", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, opts)
			vim.keymap.set("n", "<leader>dr", function()
				dap.repl.open()
			end, opts)
			vim.keymap.set("n", "<leader>dl", function()
				dap.run_last()
			end, opts)
			vim.keymap.set({ "n", "v" }, "<leader>dh", function()
				require("dap.ui.widgets").hover()
			end, opts)
			vim.keymap.set({ "n", "v" }, "<leader>dp", function()
				require("dap.ui.widgets").preview()
			end, opts)
			vim.keymap.set("n", "<leader>di", function()
				dapui.toggle()
			end, opts)

			-- 增强的变量检查
			vim.keymap.set("n", "<leader>de", function()
				local widget = require("dap.ui.widgets")
				widget.centered_float(widget.scopes)
			end, opts)
		end,
	},

	-- 3. 可选：DAP 安装助手
	{
		"ravenxrz/DAPInstall.nvim",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dap-install").setup({})
		end,
		cmd = { "DAPInstall", "DAPInstallConfig" },
	},
}

return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- LSP 补全源
		"hrsh7th/cmp-buffer", -- 缓冲区补全源
		"hrsh7th/cmp-path", -- 路径补全源
		"hrsh7th/cmp-cmdline", -- 命令行补全
		"saadparwaiz1/cmp_luasnip", -- snippet 补全
		"L3MON4D3/LuaSnip", -- snippet 引擎
		"rafamadriz/friendly-snippets", -- 预设 snippets
	},
	config = function()
		-- 加载友好 snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(), -- 上一个补全项
				["<C-n>"] = cmp.mapping.select_next_item(), -- 下一个补全项
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- 触发补全
				["<C-e>"] = cmp.mapping.abort(), -- 退出补全
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- 确认选择

				-- 使用 Tab 和 Shift+Tab 在补全项间导航
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- LSP
				{ name = "luasnip" }, -- Snippets
				{ name = "buffer" }, -- 缓冲区
				{ name = "path" }, -- 路径
			}),
			formatting = {
				format = function(entry, item)
					-- 为不同类型的补全项添加图标
					local kind_icons = {
						Text = "",
						Method = "",
						Function = "",
						Constructor = "",
						Field = "",
						Variable = "",
						Class = "",
						Interface = "",
						Module = "",
						Property = "",
						Unit = "",
						Value = "",
						Enum = "",
						Keyword = "",
						Snippet = "",
						Color = "",
						File = "",
						Reference = "",
						Folder = "",
						EnumMember = "",
						Constant = "",
						Struct = "",
						Event = "",
						Operator = "",
						TypeParameter = "",
					}
					item.kind = kind_icons[item.kind] .. " " .. item.kind
					item.menu = ({
						nvim_lsp = "[LSP]",
						luasnip = "[Snippet]",
						buffer = "[Buffer]",
						path = "[Path]",
					})[entry.source.name]
					return item
				end,
			},
			experimental = {
				ghost_text = true, -- 显示灰色的建议文本
			},
		})

		-- 命令行补全
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})
	end,
}

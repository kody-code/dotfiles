# Neovim 配置文档

## 简介

这是一个基于 Neovim 的现代化开发环境配置，集成了 LSP、代码补全、调试工具、文件管理等功能，适用于多种编程语言开发。

## 功能特点

- 完整的 LSP 支持，提供代码补全、定义跳转、重构等功能
- 强大的调试工具集成（DAP）
- 自动化代码格式化
- 美观的界面主题与状态栏
- 便捷的文件浏览与搜索
- Git 版本控制集成
- 自定义快捷键，提升操作效率

## 安装要求

- Neovim 0.8.0 或更高版本
- Git
- 适当的包管理器（根据系统不同）
- 所需的 LSP 服务器和格式化工具（会通过 Mason 自动安装）

## 安装步骤

1. 克隆本配置仓库到你的 Neovim 配置目录：

   ```bash
   git clone https://github.com/kody-code/NeoVim.git ~/.config/nvim
   ```

2. 启动 Neovim，Lazy 包管理器会自动安装所需插件：

   ```bash
   nvim
   ```

3. 插件安装完成后，Mason 会自动安装配置好的 LSP 服务器和工具

## 目录结构

```
nvim/
├── init.lua               # 入口文件
├── lazy-lock.json         # 插件版本锁定
├── lua/
│   ├── config/            # 基础配置
│   │   ├── basic.lua      # 基本设置
│   │   └── lazy.lua       # Lazy 包管理器配置
│   ├── plugins/           # 插件配置
│   │   ├── lsp/           # LSP 相关配置
│   │   └── ...            # 其他插件配置
│   └── scripts/           # 辅助脚本
└── README.md              # 本说明文档
```

## 核心插件

1. **LSP 相关**
   - `neovim/nvim-lspconfig`：LSP 客户端配置
   - `williamboman/mason.nvim`：LSP 服务器安装管理
   - `hrsh7th/nvim-cmp`：自动补全框架

2. **调试工具**
   - `mfussenegger/nvim-dap`：调试适配器协议客户端
   - `rcarriga/nvim-dap-ui`：调试 UI 界面

3. **代码格式化**
   - `stevearc/conform.nvim`：代码格式化框架

4. **文件管理**
   - `nvim-tree/nvim-tree.lua`：文件树
   - `nvim-telescope/telescope.nvim`：模糊搜索

5. **外观**
   - `folke/tokyonight.nvim`：主题
   - `nvim-lualine/lualine.nvim`：状态栏

6. **其他工具**
   - `numToStr/Comment.nvim`：代码注释
   - `lewis6991/gitsigns.nvim`：Git 集成

## 快捷键说明

### 基础操作

| 快捷键              | 功能描述             |
| ------------------- | -------------------- |
| `<leader>t`         | 打开终端             |
| `<ESC>`（终端模式） | 退出终端模式         |
| `:EditConfig`       | 编辑 Neovim 配置文件 |
| `:ReloadConfig`     | 重新加载配置         |

### 文件管理

| 快捷键       | 功能描述                |
| ------------ | ----------------------- |
| `<leader>e`  | 切换文件树（nvim-tree） |
| `<leader>ff` | 查找文件                |
| `<leader>fg` | 全局搜索文本            |
| `<leader>fb` | 切换缓冲区              |
| `<leader>fh` | 搜索帮助文档            |
| `<leader>fp` | 查找项目                |

### LSP 相关

| 快捷键       | 功能描述             |
| ------------ | -------------------- |
| `gd`         | 跳转到定义           |
| `gD`         | 跳转到声明           |
| `gi`         | 跳转到实现           |
| `gr`         | 查找引用             |
| `K`          | 显示悬浮信息         |
| `<leader>rn` | 重命名变量/函数      |
| `<leader>ca` | 代码操作（重构等）   |
| `<leader>so` | 显示签名帮助         |
| `[d`         | 跳转到上一个诊断错误 |
| `]d`         | 跳转到下一个诊断错误 |
| `<leader>q`  | 打开快速修复列表     |
| `<leader>f`  | 格式化当前缓冲区     |
| `<leader>ft` | 检查格式化工具状态   |

### 调试（DAP）相关

| 快捷键       | 功能描述             |
| ------------ | -------------------- |
| `<F6>`       | 开始/继续调试        |
| `<F10>`      | 单步跳过             |
| `<F11>`      | 单步进入             |
| `<F12>`      | 单步退出             |
| `<leader>b`  | 切换断点             |
| `<leader>B`  | 设置条件断点         |
| `<leader>lp` | 设置日志断点         |
| `<leader>dr` | 打开调试终端         |
| `<leader>dl` | 重新运行最后一次调试 |
| `<leader>dh` | 悬停查看变量信息     |
| `<leader>dp` | 预览变量信息         |
| `<leader>di` | 切换调试UI显示       |
| `<leader>de` | 显示作用域内变量     |

### 自动补全与括号

| 快捷键                  | 功能描述                   |
| ----------------------- | -------------------------- |
| `<CR>`（插入模式）      | 智能回车（处理补全和括号） |
| `)`/`}`/`]`（插入模式） | 跳过右侧括号               |
| `<BS>`（插入模式）      | 智能退格（删除配对括号）   |
| `<M-e>`（可视模式）     | 快速包裹选中内容           |
| `<Tab>`                 | 补全项导航/展开代码片段    |
| `<S-Tab>`               | 补全项反向导航             |
| `<C-Space>`             | 触发补全                   |
| `<C-e>`                 | 退出补全                   |

### 代码注释

| 快捷键 | 功能描述   |
| ------ | ---------- |
| `gcc`  | 注释当前行 |

## 自定义配置

你可以通过以下方式自定义配置：

1. 修改 `lua/config/basic.lua` 调整基础设置
2. 在 `lua/plugins/` 目录下添加或修改插件配置
3. 通过 `:EditConfig` 快速编辑配置文件
4. 修改配置后使用 `:ReloadConfig` 重新加载

## 常见问题

1. **格式化工具无法工作**
   - 运行 `:FormatToolsCheck` 检查工具是否安装
   - 确保 Mason 已正确安装所需工具

2. **LSP 服务器未启动**
   - 检查 `:Mason` 确认服务器已安装
   - 检查语言服务器配置是否正确

3. **剪贴板无法工作**
   - 确保系统中安装了合适的剪贴板工具（如 xclip、wl-copy 等）

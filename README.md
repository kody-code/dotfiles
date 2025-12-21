# dotfiles

个人的Linux工具配置文件集合，用于维护一致且高效的开发环境。此仓库包含文件管理器、终端模拟器、状态栏等多种工具的配置。

## 包含内容

### 1. Ranger（文件管理器）

- **插件**：`devicons2` 用于文件类型图标和视觉增强（需使用Nerd字体）。
- **自定义命令**：扩展文件操作命令（例如 `my_edit` 用于快速编辑）。
- **预览配置**：`scope.sh` 用于处理文件预览（压缩包、PDF等）。
- **行模式**：配置为使用 `devicons2` 实现更直观的文件列表显示。

### 2. Waybar（状态栏）

- **主题**：Catppuccin（Mocha和Latte），配色方案保持一致。
- **模块**：
  - 系统监控（CPU、内存、温度）。
  - 日期/时间、工作区、窗口标题。
  - 网络、蓝牙和系统更新。
  - 音量和电池状态。
- **脚本**：
  - `system-update.sh`：检查并安装软件包更新（支持AUR助手）。
  - `power-menu.sh`：模糊搜索电源选项（锁定、关机、重启等）。
  - `volume.sh`：调节音量并显示通知。
- **样式**：自定义CSS用于模块布局、颜色和悬停效果。

### 3. Alacritty（终端模拟器）

- **主题**：Dracula配色方案，保证终端美观一致。
- **字体**：配置为使用JetBrains Mono Nerd Font，以更好地支持图标。
- **窗口设置**：包含内边距、透明度和动态缩放。

## 安装

### 前置要求

- **Nerd字体**：安装一款Nerd字体（例如Commit Mono Nerd Font、JetBrains Mono Nerd Font）以支持图标显示。
- **依赖工具**：
  - 对于Ranger：`ranger`、`atool`、`bsdtar`、`unrar`、`7z`（用于文件预览）。
  - 对于Waybar：`waybar`、`fzf`、`pactl`（PulseAudio）、`libnotify`、`pacman-contrib`（用于更新检查）。
  - 对于Alacritty：`alacritty`。

### 步骤

1. 克隆仓库：

   ```bash
   git clone https://mygit.site/kody/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. 将配置文件符号链接到相应目录（使用`stow`简化操作）：

   ```bash
   # 若未安装stow，请先安装（例如Arch系统：sudo pacman -S stow）
   stow ranger waybar alacritty
   ```

3. **安装后操作**：
   - 对于Ranger的`devicons2`：确保`~/.config/ranger/rc.conf`中包含`default_linemode devicons2`（使用stow时会自动设置）。
   - 对于Waybar：重启Waybar以应用更改（`pkill waybar && waybar &`）。
   - 对于Alacritty：重启后会自动加载配置。

## 自定义

### 主题

- **Waybar**：通过修改`~/.config/waybar/current-theme.css`切换主题（从`themes/`目录导入，例如`catppuccin-latte.css`）。
- **Alacritty**：通过编辑`~/.config/alacritty/alacritty.toml`更改主题（添加/修改`import`指向主题文件）。

### 字体

- 修改字体设置的位置：
  - Waybar：`~/.config/waybar/styles/fonts.css`
  - Alacritty：`~/.config/alacritty/alacritty.toml`


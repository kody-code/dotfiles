# Dotfiles 配置管理工具

一个专为 `dotfiles` 仓库设计的配置管理脚本，用于快速备份、链接、恢复 Linux 系统的配置文件（dotfiles），简化多环境下的配置同步与管理流程。

## 项目背景

`dotfiles` 仓库用于集中管理个人 Linux 系统的各类配置文件（如终端、窗口管理器、Shell 等），本脚本实现了配置文件与系统路径的自动关联，无需手动创建/删除符号链接，也能安全备份原有配置，避免覆盖丢失。

## 功能特性

- 📦 **一键备份**：自动将系统原有配置备份到 `dotfiles/backup` 目录，避免覆盖
- 🔗 **符号链接**：快速为 `dotfiles` 仓库中的配置创建系统级符号链接
- 🗑️ **备份清理**：按需删除指定配置的备份文件，释放空间
- 🔙 **安全恢复**：清除符号链接并自动恢复备份（无备份时需手动确认，防止误操作）
- 🎨 **彩色终端**：清晰的彩色输出，操作流程可视化
- ✨ **灵活选择**：支持单个/多个/全部配置项的批量操作

## 前置要求

- Python 3.6+
- Linux 系统（依赖 `~/.config`、符号链接等 Linux 特有路径/特性）
- `dotfiles` 仓库已克隆到本地（脚本需放在仓库根目录）
- 对 `~/.config`、`~/.zshrc` 等路径有读写权限

## 目录结构

```
dotfiles/
├── setup.py          # 本配置管理脚本
├── alacritty/        # alacritty 配置目录
├── awesome/          # awesome 窗口管理器配置目录
├── ranger/           # ranger 终端文件管理器配置目录
├── rofi/             # rofi 启动器配置目录
├── zsh/zshrc         # zsh 配置文件
└── backup/           # 自动生成的配置备份目录（执行备份后创建）
```

## 使用方法

### 1. 克隆 dotfiles 仓库

```bash
git clone https://github.com/kody-code/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. 运行脚本

```bash
python setup.py
```

### 3. 操作流程

1. 脚本启动后，先显示支持的配置项列表；
2. 选择操作类型（输入 `1`/`2`/`3`）：
   - `1`：备份系统原有配置 + 为仓库配置创建符号链接（核心功能）
   - `2`：删除 `backup` 目录下的指定配置备份
   - `3`：清除系统路径的符号链接（有备份则自动恢复）
3. 选择要处理的配置项：
   - 输入 `all` 或直接回车：处理全部配置项
   - 输入数字（空格分隔）：处理指定配置项（如 `1 3 5` 处理第1、3、5项）

## 核心操作说明

### 🔧 操作1：备份 + 创建符号链接（推荐首次使用）

- 自动检测系统原有配置（如 `~/.config/alacritty`），并移动到 `dotfiles/backup` 目录；
- 从 `dotfiles` 仓库根目录读取配置文件/目录，为系统路径创建符号链接；
- 示例：`~/.config/alacritty` → `~/dotfiles/alacritty`（修改仓库内配置即时生效）。

### 🗑️ 操作2：删除备份

- 仅删除 `dotfiles/backup` 下指定配置的备份文件/目录；
- 不影响当前系统的符号链接和配置，适合确认配置无误后清理备份。

### 🔙 操作3：清除链接 + 恢复备份

- 仅删除系统路径的符号链接（不删除仓库内的配置文件）；
- 若 `backup` 目录有对应备份，自动将备份恢复到系统原路径；
- 无备份时会提示确认，防止误操作导致配置丢失。

## 支持的配置项

| 序号 | 配置项    | 系统路径            | 仓库路径            |
| ---- | --------- | ------------------- | ------------------- |
| 1    | alacritty | ~/.config/alacritty | dotfiles/alacritty/ |
| 2    | awesome   | ~/.config/awesome   | dotfiles/awesome/   |
| 3    | ranger    | ~/.config/ranger    | dotfiles/ranger/    |
| 4    | rofi      | ~/.config/rofi      | dotfiles/rofi/      |
| 5    | zsh/zshrc | ~/.zshrc            | dotfiles/zsh/zshrc  |

## 自定义扩展（添加新配置项）

若需管理更多 dotfiles（如 neovim、tmux 等），只需修改 `setup.py` 中的 `all_configs` 字典：

```python
all_configs: dict = {
    "alacritty": os.path.expanduser("~/.config/alacritty"),
    "awesome": os.path.expanduser("~/.config/awesome"),
    "ranger": os.path.expanduser("~/.config/ranger"),
    "rofi": os.path.expanduser("~/.config/rofi"),
    "zsh/zshrc": os.path.expanduser("~/.zshrc"),
    # 新增配置项示例
    "nvim": os.path.expanduser("~/.config/nvim"),       # neovim 配置
    "tmux": os.path.expanduser("~/.tmux.conf"),         # tmux 配置
}
```

修改后将新配置文件/目录放到 `dotfiles` 仓库根目录，重新运行脚本即可识别。

## 注意事项

1. **首次运行**：建议先确认系统原有配置是否需要手动备份（脚本会自动备份，但多一层保障更安全）；
2. **权限问题**：若提示权限不足，可尝试 `sudo python setup.py`（注意 `~` 在 sudo 下指向 root 目录，需确认路径正确性）；
3. **符号链接特性**：创建链接后，修改 `dotfiles` 仓库内的配置文件会直接生效，无需重新运行脚本；
4. **备份目录**：`backup` 目录由脚本自动创建，请勿手动删除（除非确认不再需要恢复配置）；
5. **zshrc 特殊说明**：`zsh/zshrc` 是文件而非目录，脚本已适配文件/目录两种类型的处理逻辑。

## 常见问题

### Q1：执行后提示“源文件不存在”？

A：`dotfiles` 仓库根目录缺少对应配置项的文件/目录（如选择 `alacritty` 但无 `alacritty` 目录），请将配置文件放到仓库对应路径。

### Q2：清除链接后恢复的配置不对？

A：确认 `dotfiles/backup` 目录下的备份文件是正确版本，脚本仅恢复备份中保存的内容。

### Q3：多台机器同步配置？

A：在新机器上克隆 `dotfiles` 仓库，运行 `python setup.py` 选择操作1，即可一键同步所有配置。

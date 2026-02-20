import os
import shutil
from pathlib import Path


class Color:
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    CYAN = "\033[36m"
    MAGENTA = "\033[35m"
    RESET = "\033[0m"


all_configs: dict = {
    "alacritty": os.path.expanduser("~/.config/alacritty"),
    "awesome": os.path.expanduser("~/.config/awesome"),
    "ranger": os.path.expanduser("~/.config/ranger"),
    "rofi": os.path.expanduser("~/.config/rofi"),
    "nvim": os.path.expanduser("~/.config/nvim"),
    "zsh/zshrc": os.path.expanduser("~/.zshrc"),
}

source_path = Path(os.getcwd())
backup_path = source_path / "backup"


def get_all_config() -> list:
    """获取所有可配置的项列表"""
    return list(all_configs.keys())


def choose_config() -> list:
    """让用户选择要处理的配置项"""
    configs = get_all_config()
    print(
        f"\n{Color.CYAN}请选择要处理的配置项（输入数字，空格分隔；输入'all'或直接回车选择全部）：{Color.RESET}"
    )
    num = input(f"{Color.GREEN}>> {Color.RESET}")

    if num == "all" or num == "":
        return configs
    try:
        num_list = [int(num.strip()) for num in num.split() if num.strip()]
        for i in num_list:
            if i < 1 or i > len(configs):
                raise IndexError
        selected = [configs[i - 1] for i in num_list]
        return selected
    except (ValueError, IndexError):
        print(
            f"{Color.RED}错误：请输入有效的数字（范围1-{len(configs)}），且以空格分隔！{Color.RESET}"
        )
        return []


def choose_operation() -> str:
    """让用户选择要执行的操作"""
    print(f"\n{Color.CYAN}===== 请选择要执行的操作 ====={Color.RESET}")
    print(f"  1: {Color.BLUE}备份配置并创建符号链接{Color.RESET}")
    print(f"  2: {Color.BLUE}删除备份文件{Color.RESET}")
    print(f"  3: {Color.BLUE}清除符号链接{Color.RESET}")
    op = input(f"\n{Color.GREEN}请输入操作编号（1/2/3）：{Color.RESET}")

    if op not in ["1", "2", "3"]:
        print(f"{Color.RED}错误：请输入有效的操作编号（1/2/3）！{Color.RESET}")
        return ""
    return op


def backup_config(configs: list):
    """备份指定的配置文件/目录"""
    if not configs:
        return

    backup_path.mkdir(exist_ok=True)
    print(f"\n{Color.YELLOW}开始备份现有配置...{Color.RESET}")

    for config in configs:
        target = Path(all_configs[config])
        if target.exists():
            # 处理目标路径已存在的情况（避免move失败）
            backup_target = backup_path / config
            if backup_target.exists():
                if backup_target.is_dir():
                    shutil.rmtree(backup_target)
                else:
                    backup_target.unlink()

            shutil.move(target, backup_path / config)
            print(f"  {Color.BLUE}已备份：{config}{Color.RESET}")

    print(f"{Color.GREEN}✓ 备份完成{Color.RESET}")


def ln_config(configs: list):
    """为指定配置创建符号链接"""
    if not configs:
        return

    print(f"\n{Color.YELLOW}开始创建符号链接...{Color.RESET}")
    for config in configs:
        source = source_path / config
        target = Path(all_configs[config])

        # 确保源文件/目录存在
        if not source.exists():
            print(
                f"  {Color.RED}警告：源文件不存在，跳过创建链接：{config}{Color.RESET}"
            )
            continue

        # 如果目标链接已存在，先删除
        if target.exists() or target.is_symlink():
            if target.is_dir() and not target.is_symlink():
                shutil.rmtree(target)
            else:
                target.unlink()

        os.symlink(source, target)
        print(f"  {Color.MAGENTA}已创建链接：{config}{Color.RESET}")
    print(f"{Color.GREEN}✓ 所有链接创建完成{Color.RESET}")


def delete_backup(configs: list):
    """删除指定配置的备份文件"""
    if not configs:
        return

    if not backup_path.exists():
        print(f"\n{Color.YELLOW}备份目录不存在，无需删除{Color.RESET}")
        return

    print(f"\n{Color.YELLOW}开始删除备份文件...{Color.RESET}")
    deleted_count = 0
    for config in configs:
        backup_target = backup_path / config
        if backup_target.exists():
            if backup_target.is_dir():
                shutil.rmtree(backup_target)
            else:
                backup_target.unlink()
            print(f"  {Color.BLUE}已删除备份：{config}{Color.RESET}")
            deleted_count += 1

    if deleted_count == 0:
        print(f"  {Color.YELLOW}未找到指定配置的备份文件{Color.RESET}")
    else:
        print(f"{Color.GREEN}✓ 备份删除完成{Color.RESET}")


def clear_symlink(configs: list):
    """清除指定配置的符号链接，并恢复备份（如果有），无备份时询问确认"""
    if not configs:
        return

    print(f"\n{Color.YELLOW}开始清除符号链接...{Color.RESET}")
    cleared_count = 0
    for config in configs:
        target = Path(all_configs[config])

        # 只删除符号链接，不删除真实文件/目录
        if target.is_symlink():
            # 检查是否有对应备份
            backup_target = backup_path / config
            if not backup_target.exists():
                # 无备份，询问用户是否继续清除
                confirm = input(
                    f"  {Color.YELLOW}警告：{config} 无备份文件，清除链接后无法恢复，是否继续？(y/n)：{Color.RESET}"
                )
                if confirm.lower() != "y":
                    print(f"  {Color.BLUE}跳过清除：{config}{Color.RESET}")
                    continue

            # 确认继续，删除符号链接
            target.unlink()
            print(f"  {Color.BLUE}已清除链接：{config}{Color.RESET}")
            cleared_count += 1

            # 有备份则恢复
            if backup_target.exists():
                shutil.move(backup_target, target)
                print(f"  {Color.MAGENTA}已恢复备份：{config}{Color.RESET}")
            else:
                # 无备份，提示用户
                print(
                    f"  {Color.YELLOW}提示：{config} 无备份，未恢复任何文件{Color.RESET}"
                )
        else:
            print(f"  {Color.YELLOW}跳过：{config} 不是符号链接{Color.RESET}")

    if cleared_count == 0:
        print(f"  {Color.YELLOW}未找到需要清除的符号链接{Color.RESET}")
    else:
        print(f"{Color.GREEN}✓ 链接清除完成{Color.RESET}")


if __name__ == "__main__":
    print(f"{Color.CYAN}===== 配置管理工具 ====={Color.RESET}")
    configs = get_all_config()

    if not configs:
        print(f"{Color.RED}错误：未找到可配置的项{Color.RESET}")
        exit(1)

    # 显示可配置的项列表
    print(f"\n{Color.CYAN}可配置项列表：{Color.RESET}")
    for index, item in enumerate(configs):
        print(f"  {index + 1}: {Color.BLUE}{item}{Color.RESET}")

    # 选择操作类型
    operation = choose_operation()
    if not operation:
        exit(1)

    # 选择要处理的配置项
    selected_configs = choose_config()
    if not selected_configs:
        print(f"{Color.RED}未选择有效的配置项，程序退出{Color.RESET}")
        exit(1)

    # 执行对应的操作
    if operation == "1":
        backup_config(selected_configs)
        ln_config(selected_configs)
    elif operation == "2":
        delete_backup(selected_configs)
    elif operation == "3":
        clear_symlink(selected_configs)

    print(f"\n{Color.GREEN}===== 操作完成 ====={Color.RESET}")

import os
import shutil
from pathlib import Path


# ANSI 颜色转义序列
class Color:
    RED = "\033[31m"
    GREEN = "\033[32m"
    YELLOW = "\033[33m"
    BLUE = "\033[34m"
    CYAN = "\033[36m"
    MAGENTA = "\033[35m"
    RESET = "\033[0m"


# 源文件路径
source_path = Path(os.getcwd())

# 连接路径
link_path = Path(os.path.expanduser("~/.config"))


def get_all_config() -> list:
    parent_path = Path(source_path)
    dirs = []
    if parent_path.is_dir():
        for item in parent_path.iterdir():
            if item.is_dir() and item.name != ".git":
                dirs.append(str(item.name))
    return dirs


def choose_config() -> list:
    configs = get_all_config()
    print(
        f"\n{Color.CYAN}请选择要处理的配置项（输入数字，空格分隔；输入'all'或直接回车选择全部）：{Color.RESET}"
    )
    num = input(f"{Color.GREEN}>> {Color.RESET}")

    if num == "all" or num == "":
        return configs

    try:
        num_list = [int(num.strip()) for num in num.split() if num.strip()]
        # 检查数字有效性
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


def backup_config(configs: list):
    if not configs:
        return

    backup_path = source_path / "backup"
    backup_path.mkdir(exist_ok=True)
    print(f"\n{Color.YELLOW}开始备份现有配置...{Color.RESET}")

    for config in configs:
        target = link_path / config
        if target.exists():
            shutil.move(target, backup_path)
            print(f"  {Color.BLUE}已备份：{config}{Color.RESET}")

    print(f"{Color.GREEN}✓ 备份完成{Color.RESET}")


def ln_config(configs: list):
    if not configs:
        return

    print(f"\n{Color.YELLOW}开始创建符号链接...{Color.RESET}")
    for config in configs:
        source = source_path / config
        target = link_path / config
        os.symlink(source, target)
        print(f"  {Color.MAGENTA}已创建链接：{config}{Color.RESET}")

    print(f"{Color.GREEN}✓ 所有链接创建完成{Color.RESET}")


if __name__ == "__main__":
    print(f"{Color.CYAN}===== 配置管理工具 ====={Color.RESET}")
    configs = get_all_config()

    if not configs:
        print(f"{Color.RED}错误：未找到可配置的文件夹（排除.git目录）{Color.RESET}")
        exit(1)

    print(f"\n{Color.YELLOW}检测到以下可配置项：{Color.RESET}")
    for index, item in enumerate(configs):
        print(f"  {index + 1}: {Color.BLUE}{item}{Color.RESET}")

    selected_configs = choose_config()
    if not selected_configs:
        print(f"{Color.RED}未选择有效的配置项，程序退出{Color.RESET}")
        exit(1)

    backup_config(selected_configs)
    ln_config(selected_configs)

    print(f"\n{Color.GREEN}===== 操作完成 ====={Color.RESET}")

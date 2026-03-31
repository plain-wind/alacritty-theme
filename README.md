# alacritty-theme

一个用于切换 Alacritty 主题的 Rust 命令行工具。

## 功能

- 设置主题：将 `~/.config/alacritty/alacritty.toml` 覆盖为固定 `import` 配置
- 列出主题：读取 `~/.config/alacritty/themes/themes/` 下的 `*.toml` 主题文件

## 前置准备

确保已安装 Rust 工具链：

```bash
rustc --version
cargo --version
```

## 克隆官方主题

按以下命令准备官方主题仓库：

```bash
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
```

克隆后主题文件目录应为：

`~/.config/alacritty/themes/themes/`

## 构建

在项目根目录执行：

```bash
cargo build --release
```

生成的可执行文件：

`./target/release/alacritty-theme`

## 安装到 ~/.local/bin

项目包含安装脚本，会自动构建 release 并安装到 `~/.local/bin`：

```bash
./scripts/install.sh
```

安装完成后可验证：

```bash
~/.local/bin/alacritty-theme --help
```

如果终端提示找不到命令，请把 `~/.local/bin` 加入 PATH（例如写入 `~/.zshrc`）：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

然后执行：

```bash
source ~/.zshrc
```

安装脚本也会同时安装补全文件：

- Bash: `~/.local/share/bash-completion/completions/alacritty-theme`
- Zsh: `~/.zsh/completions/_alacritty-theme`

## Tab 补全

### Bash

安装后可在当前 shell 直接启用：

```bash
source ~/.local/share/bash-completion/completions/alacritty-theme
```

之后支持：

- `alacritty-theme <TAB>` 补全命令（`set/list/ls`）
- `alacritty-theme set <TAB>` 补全主题名（动态读取 `alacritty-theme list`）

如果希望每次新开终端自动生效，请把上面的 `source` 命令加入 `~/.bashrc`。

### Zsh

把补全目录加入 `fpath` 并初始化补全系统：

```bash
echo 'fpath=("$HOME/.zsh/completions" $fpath)' >> ~/.zshrc
echo 'autoload -Uz compinit && compinit' >> ~/.zshrc
source ~/.zshrc
```

之后支持：

- `alacritty-theme <TAB>` 补全命令（`set/list/ls`）
- `alacritty-theme set <TAB>` 补全主题名（动态读取 `alacritty-theme list`）

## 卸载

项目包含卸载脚本，会从 `~/.local/bin` 删除 `alacritty-theme`：

```bash
./scripts/uninstall.sh
```

如果你安装到了自定义目录，可通过 `INSTALL_DIR` 指定：

```bash
INSTALL_DIR="$HOME/bin" ./scripts/uninstall.sh
```

卸载脚本也会移除补全文件：

- `~/.local/share/bash-completion/completions/alacritty-theme`
- `~/.zsh/completions/_alacritty-theme`

## 使用

### 1. 列出可用主题

```bash
alacritty-theme list
```

或简写：

```bash
alacritty-theme ls
```

### 2. 设置主题

```bash
alacritty-theme set gruvbox_dark
```

执行后会把 `~/.config/alacritty/alacritty.toml` 写成：

```toml
import = [
    "~/.config/alacritty/themes/themes/gruvbox_dark.toml",
    "~/.config/alacritty/default.toml"
]
```

你只需要把 `gruvbox_dark` 换成任意实际存在的主题名。

## 开发模式运行

不构建 release 也可以直接运行：

```bash
cargo run -- list
cargo run -- set gruvbox_dark
```

## 常见问题

- 提示 `Theme directory does not exist`
  - 检查是否已完成官方主题克隆步骤
- 提示 `Theme does not exist`
  - 先运行 `list` 或 `ls` 确认主题名拼写

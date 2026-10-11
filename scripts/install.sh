#!/bin/bash
# Debate Agent Toolkit 通用安装脚本 (macOS/Linux)
# 版本：v0.1.0-refactor

set -e

echo "=================================="
echo "  Debate Agent Toolkit 安装程序"
echo "=================================="
echo ""

# 检测安装位置
TOOLKIT_HOME="${DEBATE_TOOLKIT_HOME}"
if [ -z "$TOOLKIT_HOME" ]; then
    if [ "$(uname)" = "Darwin" ]; then
        TOOLKIT_HOME="$HOME/Library/Application Support/debate-agent-toolkit"
    else
        TOOLKIT_HOME="$HOME/.local/share/debate-agent-toolkit"
    fi
    echo "使用默认安装位置: $TOOLKIT_HOME"
else
    echo "使用自定义安装位置: $TOOLKIT_HOME"
fi

# 检测平台
echo ""
echo "[1/6] 检测平台..."
PLATFORM="generic"
if [ -d "$HOME/.claude/skills" ]; then
    PLATFORM="claude-code"
    echo "  检测到 Claude Code"
elif [ -d "$HOME/.cursor" ]; then
    PLATFORM="cursor"
    echo "  检测到 Cursor"
else
    echo "  未检测到特定平台，使用通用模式"
fi

# 创建目录
echo ""
echo "[2/6] 创建目录结构..."
mkdir -p "$TOOLKIT_HOME/prompts"
mkdir -p "$TOOLKIT_HOME/knowledge"
mkdir -p "$TOOLKIT_HOME/profiles"
mkdir -p "$TOOLKIT_HOME/.cache"
echo "  已创建 $TOOLKIT_HOME"

# 安装 Prompts
echo ""
echo "[3/6] 安装 Prompts..."
PROMPTS=("prep" "script-writer" "material-pack" "match-review" "style-learner")

for prompt in "${PROMPTS[@]}"; do
    src="prompts/debate-$prompt"
    dest="$TOOLKIT_HOME/prompts/debate-$prompt"

    if [ -d "$dest" ]; then
        echo -n "  debate-$prompt 已存在，是否覆盖？(y/n): "
        read -r answer
        if [ "$answer" != "y" ]; then
            echo "  跳过 debate-$prompt"
            continue
        fi
        rm -rf "$dest"
    fi

    cp -r "$src" "$dest"
    echo "  已安装 debate-$prompt"
done

# 安装 Knowledge
echo ""
echo "[4/6] 安装 Knowledge..."
if [ ! -f "$TOOLKIT_HOME/knowledge/topics-index.md" ]; then
    cp -r knowledge/* "$TOOLKIT_HOME/knowledge/"
    echo "  已安装 Knowledge 库"
else
    echo "  Knowledge 已存在，跳过"
fi

# 安装示例 Profile
echo ""
echo "[5/6] 安装示例 Profile..."
if [ ! -d "$TOOLKIT_HOME/profiles/example" ]; then
    cp -r profiles/example "$TOOLKIT_HOME/profiles/"
    echo "  已安装示例 Profile"
else
    echo "  示例 Profile 已存在，跳过"
fi

# 复制配置文件
if [ ! -f "$TOOLKIT_HOME/config.yaml" ]; then
    cp config.yaml "$TOOLKIT_HOME/config.yaml"
    echo "  已安装配置文件"
fi

# 平台特定配置
echo ""
echo "[6/6] 平台适配..."

if [ "$PLATFORM" = "claude-code" ]; then
    echo -n "  检测到 Claude Code，是否创建软链接？(y/n): "
    read -r answer
    if [ "$answer" = "y" ]; then
        SKILLS_DIR="$HOME/.claude/skills"
        for prompt in "${PROMPTS[@]}"; do
            target="$TOOLKIT_HOME/prompts/debate-$prompt"
            link="$SKILLS_DIR/debate-$prompt"

            if [ -L "$link" ] || [ -d "$link" ]; then
                rm -rf "$link"
            fi

            ln -s "$target" "$link"
            echo "  已链接 debate-$prompt 到 Claude Code"
        done
    fi
elif [ "$PLATFORM" = "cursor" ]; then
    echo "  Cursor 支持开发中，请手动配置"
fi

echo ""
echo "================================"
echo "  安装成功！"
echo "================================"
echo ""
echo "安装位置: $TOOLKIT_HOME"
echo ""
echo "环境变量（可选）："
echo "  export DEBATE_TOOLKIT_HOME=\"$TOOLKIT_HOME\""
echo "  # 添加到 ~/.bashrc 或 ~/.zshrc"
echo ""
echo "下一步："
if [ "$PLATFORM" = "claude-code" ]; then
    echo "  1. 打开 Claude Code"
    echo "  2. 对话：'我要准备辩题...'"
else
    echo "  1. 查看 README.md 中的平台使用指南"
    echo "  2. 配置您的 AI Agent 加载 $TOOLKIT_HOME/prompts"
fi
echo ""
echo "详细文档: README.md"

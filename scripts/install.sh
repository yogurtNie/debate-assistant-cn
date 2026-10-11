#!/bin/bash
# Debate Skills 安装脚本 (macOS/Linux)
# 版本：v0.1.0

set -e

echo "=================================="
echo "  Debate Skills v0.1.0 安装程序"
echo "=================================="
echo ""

# 检测 Claude skills 目录
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
PROFILES_DIR="$CLAUDE_DIR/debate-profiles"
KNOWLEDGE_DIR="$CLAUDE_DIR/debate-knowledge"

# 创建目录
echo "[1/5] 检查 Claude 目录..."
mkdir -p "$CLAUDE_DIR"
mkdir -p "$SKILLS_DIR"
echo "  已确认目录存在"

# 安装 Skills
echo "[2/5] 安装 Skills..."
SKILLS=("debate-prep" "debate-script-writer" "debate-material-pack" "debate-match-review" "debate-style-learner")

for skill in "${SKILLS[@]}"; do
    src="skills/$skill"
    dest="$SKILLS_DIR/$skill"

    if [ -d "$dest" ]; then
        echo -n "  $skill 已存在，是否覆盖？(y/n): "
        read -r answer
        if [ "$answer" != "y" ]; then
            echo "  跳过 $skill"
            continue
        fi
        rm -rf "$dest"
    fi

    cp -r "$src" "$dest"
    echo "  已安装 $skill"
done

# 安装 Knowledge
echo "[3/5] 安装 Knowledge 库..."
if [ ! -d "$KNOWLEDGE_DIR" ]; then
    cp -r "debate-knowledge" "$KNOWLEDGE_DIR"
    echo "  已安装到 $KNOWLEDGE_DIR"
else
    echo "  Knowledge 目录已存在，跳过"
fi

# 安装示例 Profile
echo "[4/5] 安装示例 Profile..."
mkdir -p "$PROFILES_DIR"
example_dest="$PROFILES_DIR/example"
if [ ! -d "$example_dest" ]; then
    cp -r "debate-profiles/example" "$example_dest"
    echo "  已安装示例 Profile"
else
    echo "  示例 Profile 已存在，跳过"
fi

# 验证安装
echo "[5/5] 验证安装..."
all_ok=true
for skill in "${SKILLS[@]}"; do
    skill_md="$SKILLS_DIR/$skill/SKILL.md"
    if [ ! -f "$skill_md" ]; then
        echo "  错误: $skill/SKILL.md 未找到"
        all_ok=false
    fi
done

echo ""
if [ "$all_ok" = true ]; then
    echo "================================"
    echo "  安装成功！"
    echo "================================"
    echo ""
    echo "下一步："
    echo "  1. 打开 Claude Code"
    echo "  2. 对话：'我要准备辩题...'"
    echo ""
    echo "可选配置："
    echo "  - Profile 位置: $PROFILES_DIR"
    echo "  - Knowledge 位置: $KNOWLEDGE_DIR"
    echo ""
    echo "详细文档请查看 README.md"
else
    echo "安装过程中出现错误，请检查"
    exit 1
fi

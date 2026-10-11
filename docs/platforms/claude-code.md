# Claude Code 平台使用指南

## 概述

Claude Code是Anthropic官方的AI编程助手，支持skills机制。本工具包为Claude Code提供完整支持。

---

## 安装

### 自动安装（推荐）

```bash
# macOS/Linux
bash scripts/install.sh

# Windows PowerShell
.\scripts\install.ps1
```

安装脚本会：
1. 检测Claude Code环境
2. 安装到`$DEBATE_TOOLKIT_HOME`
3. 询问是否创建软链接到`~/.claude/skills/`

### 手动安装

```bash
# 1. 安装到toolkit home
export DEBATE_TOOLKIT_HOME="$HOME/.local/share/debate-agent-toolkit"
mkdir -p $DEBATE_TOOLKIT_HOME
cp -r prompts knowledge profiles config.yaml $DEBATE_TOOLKIT_HOME/

# 2. 创建软链接到Claude Code
cd ~/.claude/skills
ln -s $DEBATE_TOOLKIT_HOME/prompts/debate-prep ./debate-prep
ln -s $DEBATE_TOOLKIT_HOME/prompts/debate-script-writer ./debate-script-writer
ln -s $DEBATE_TOOLKIT_HOME/prompts/debate-material-pack ./debate-material-pack
ln -s $DEBATE_TOOLKIT_HOME/prompts/debate-match-review ./debate-match-review
ln -s $DEBATE_TOOLKIT_HOME/prompts/debate-style-learner ./debate-style-learner
```

---

## 使用

### 基础用法

在Claude Code中直接对话：

```
"我要准备辩题：诚信比智慧更重要，正方，经典赛制，请帮我写框架稿"
```

Claude会自动调用`debate-prep`路由到`debate-script-writer`。

### 直接调用特定Skill

```
"使用 debate-script-writer 写一篇立论稿"
```

### Profile配置

第一次使用时会检测profile：
- 如果存在`$DEBATE_TOOLKIT_HOME/profiles/me-default/`，自动使用
- 否则使用内置默认风格

生成个人profile：
```
"使用 debate-style-learner 从我的历史稿件学习风格，
路径：/path/to/my/debates/"
```

---

## 目录结构

```
~/.local/share/debate-agent-toolkit/  (或$DEBATE_TOOLKIT_HOME)
├── prompts/
├── knowledge/
├── profiles/
└── config.yaml

~/.claude/skills/  (软链接)
├── debate-prep -> $DEBATE_TOOLKIT_HOME/prompts/debate-prep
├── debate-script-writer -> ...
└── ...
```

---

## 环境变量

```bash
# 自定义安装位置
export DEBATE_TOOLKIT_HOME="/custom/path"

# ASR功能（可选）
export DEBATE_ASR_API_KEY="your-key"

# 添加到 ~/.bashrc 或 ~/.zshrc
echo 'export DEBATE_TOOLKIT_HOME="$HOME/.local/share/debate-agent-toolkit"' >> ~/.bashrc
```

---

## 验证安装

```bash
# 检查软链接
ls -la ~/.claude/skills/ | grep debate

# 应该看到：
# debate-prep -> /path/to/toolkit/prompts/debate-prep
# debate-script-writer -> ...
```

在Claude Code中测试：
```
"列出可用的辩论相关skills"
```

---

## 故障排除

### Skills未显示

1. 检查软链接是否正确：
   ```bash
   ls -la ~/.claude/skills/debate-*
   ```

2. 检查SKILL.md是否存在：
   ```bash
   cat ~/.claude/skills/debate-prep/SKILL.md
   ```

3. 重启Claude Code

### Profile未加载

1. 检查profile目录：
   ```bash
   ls -la $DEBATE_TOOLKIT_HOME/profiles/
   ```

2. 检查me-default是否存在（如果想使用个人风格）

3. 查看配置文件：
   ```bash
   cat $DEBATE_TOOLKIT_HOME/config.yaml
   ```

---

## 卸载

```bash
# 删除软链接
rm ~/.claude/skills/debate-*

# 删除toolkit（可选，会删除个人配置）
rm -rf $DEBATE_TOOLKIT_HOME
```

---

## 升级

```bash
# 1. 备份个人配置
cp -r $DEBATE_TOOLKIT_HOME/profiles/me-default /path/to/backup/

# 2. 重新安装
cd debate-agent-toolkit
git pull
bash scripts/install.sh

# 3. 恢复个人配置
cp -r /path/to/backup/me-default $DEBATE_TOOLKIT_HOME/profiles/
```

---

## 更多帮助

- 主文档：[README.md](../../README.md)
- 问题反馈：[GitHub Issues](https://github.com/YOUR_USERNAME/debate-agent-toolkit/issues)

# CHANGELOG

## [Unreleased]

### 重大变更：通用Agent适配
- 重构为通用Agent框架，支持多平台
- 目录结构从Claude Code专用改为平台无关
- 支持自定义安装位置

---

## [0.1.0] - 2026-10-11

### 首次发布

#### 架构设计
- 🏗️ **通用Agent架构**：支持Claude Code、Cursor及任何LLM Agent
- 📁 **平台无关目录**：`$DEBATE_TOOLKIT_HOME`（可配置）
- 🔗 **自动适配**：检测平台并创建软链接（Claude Code）

#### 核心Prompts（5个）
1. **debate-prep** (37行) - 路由入口
2. **debate-script-writer** (60行, 10个references) - 写稿核心
3. **debate-material-pack** (47行, 4个references) - 资料整理
4. **debate-match-review** (60行) - 比赛复盘
5. **debate-style-learner** (60行) - 风格学习

#### 规则体系
- **比较型价值辩**：四要点ABCD + 五步流程 + 缺失性比较方法
- **事实辩**：可验证判准标准（是否存在反例）
- **判断型价值辩**：是/不是的判定依据
- **政策辩**：需根解损框架
- **所有规则标注来源和等级**

#### 知识库
- topics-index.md - 辩题索引
- books-index.md - 书籍要点
- philosophy-index.md - 理念索引
- value-debate-theory.md - 价值辩理论
- 3个理论文档（让渡竞争、评委视角、反驳语境）

#### Profile系统
- example/ - 完整示例结构
- preferences.md - 风格偏好
- style-rules.md - 风格规则
- exemplars/ - 范例稿件

#### 测试记录
- 2轮迭代测试
- 10个测试辩题
- 检查清单和回归测试说明

#### 文档
- README.md - 多平台使用文档
- LICENSE - MIT License
- config.yaml - 配置文件模板
- 安装脚本（支持平台检测和软链接）

---

## 平台支持

### v0.1.0
- ✅ Claude Code - 完整支持
- ✅ 通用LLM/API - 完整支持
- 🚧 Cursor - 开发中
- 🚧 OpenAI GPTs - 开发中
- 📋 LangChain/AutoGPT - 计划中

---

## 已知限制

### v0.1.0
- ASR功能为可选，未配置时需用户提供转录稿
- 基于有限样本测试（10个辩题）
- 部分书籍要点提炼未完成
- 部分规则标注"待验证"

---

## 规则来源

- 超辩学院课程（教材/课程级 - 最高）
- 辩论咨询群资料（中等级）
- 名家文章（中等级）
- 实践总结（低等级，待验证）

---

## 目录结构变更

### v0.1.0
```
OLD (Claude Code专用):
~/.claude/skills/
~/.claude/debate-profiles/
~/.claude/debate-knowledge/

NEW (通用Agent):
$DEBATE_TOOLKIT_HOME/
├── prompts/          # 原skills/
├── knowledge/        # 原debate-knowledge/
├── profiles/         # 原debate-profiles/
└── config.yaml       # 新增配置文件
```

---

## 升级指南

### 从预发布版本升级

如果您之前安装了预发布版本（仅限Claude Code），建议重新安装：

1. 备份个人profile（如有）：
   ```bash
   cp -r ~/.claude/debate-profiles/me-default /path/to/backup/
   ```

2. 卸载旧版本：
   ```bash
   rm -rf ~/.claude/skills/debate-*
   rm -rf ~/.claude/debate-*
   ```

3. 安装新版本：
   ```bash
   bash scripts/install.sh
   ```

4. 恢复个人profile：
   ```bash
   cp -r /path/to/backup/me-default $DEBATE_TOOLKIT_HOME/profiles/
   ```

---

## 版本号说明

本项目遵循语义化版本号(Semantic Versioning):
- MAJOR: 不兼容的重大变更
- MINOR: 向后兼容的新功能
- PATCH: 向后兼容的问题修复

---

## 贡献者

感谢所有贡献者和测试者。

特别感谢Claude Opus 5.5在规则整理和测试中的协助。

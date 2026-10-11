# Debate Agent Toolkit

**中文辩论备赛的AI Agent工具包 — 支持多平台、开箱即用**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/YOUR_USERNAME/debate-agent-toolkit)

---

## 一句话介绍

五个专项prompt帮助AI Agent写辩论稿、整理资料、复盘比赛、学习风格。通用内核与个人配置分离，支持Claude Code、Cursor及任何LLM Agent。

---

## ✨ 特性

- 🤖 **多平台支持**：Claude Code、Cursor、OpenAI GPTs、通用LLM Agent
- 📚 **规则体系**：比较型/事实/判断型/政策辩论方法论，带来源和等级
- 🎯 **按需加载**：智能路由，只加载当前任务需要的规则（节省token）
- 🎨 **风格分离**：通用规则与个人风格独立配置
- 📊 **数据真实**：所有数据必须有来源和年份，禁止编造
- 🔄 **持续迭代**：基于实战测试，规则可验证可追溯

---

## 🚀 快速开始

### 安装

**方法1：自动安装（推荐）**

```bash
# macOS/Linux
bash scripts/install.sh

# Windows PowerShell
.\scripts\install.ps1
```

**方法2：手动安装**

```bash
# 1. 克隆仓库
git clone https://github.com/YOUR_USERNAME/debate-agent-toolkit.git
cd debate-agent-toolkit

# 2. 设置环境变量（可选）
export DEBATE_TOOLKIT_HOME="$HOME/.local/share/debate-agent-toolkit"

# 3. 复制文件
mkdir -p $DEBATE_TOOLKIT_HOME
cp -r prompts knowledge profiles config.yaml $DEBATE_TOOLKIT_HOME/
```

### 平台配置

#### Claude Code
安装脚本会自动创建软链接到`~/.claude/skills/`

#### Cursor
将`prompts/`中的内容添加到Cursor的Rules（开发中）

#### OpenAI GPTs
将prompt内容作为Custom Instructions使用

#### 通用LLM/API
```python
# 示例：加载prompt并调用
with open('prompts/debate-script-writer/SKILL.md') as f:
    system_prompt = f.read()

# 加载需要的规则
with open('prompts/debate-script-writer/references/debate-types.md') as f:
    rules = f.read()

# 调用LLM
response = llm.chat(
    system=system_prompt + "\n\n" + rules,
    user="我要写一篇关于'诚信比智慧更重要'的立论稿"
)
```

---

## 📖 使用示例

### 场景1：写框架稿
```
对AI说：
"我要准备辩题：诚信比智慧更重要，正方，经典赛制，请帮我写框架稿"
```

### 场景2：整理资料包
```
"我要为'时间能改变一切'这个辩题整理资料包，
包括论点卡片和数据表"
```

### 场景3：复盘比赛
```
"我有一场比赛的转录文本，想做复盘分析"
[提供转录文本]
```

### 场景4：学习个人风格
```
"我想用 debate-style-learner 生成我的个人风格，
我的历史稿件在 /path/to/my/debates/"
```

---

## 🛠️ 五个核心Prompts

| Prompt | 功能 | 何时使用 |
|--------|------|---------|
| **debate-prep** | 路由入口，判断阶段并推荐prompt | 说"准备辩论"、不确定从哪开始 |
| **debate-script-writer** | 写框架稿、逐字稿、质询稿、结辩稿 | 说"写稿"、"立论"、"质询" |
| **debate-material-pack** | 整理资料包（论点卡片+数据表） | 说"收集资料"、"整理论点" |
| **debate-match-review** | 复盘比赛录音/转录稿 | 说"复盘"、提供转录文本 |
| **debate-style-learner** | 从历史稿件学习个人风格 | 说"学习风格"、"生成profile" |

---

## 🎨 个性化配置

### 自动生成个人风格

使用`debate-style-learner`从历史稿件自动生成profile：

```bash
# 提供历史稿件路径
对AI说："我想生成我的个人风格，历史稿件在 /path/to/debates/"
```

生成的profile包含：
- 论证风格偏好
- 语言习惯
- 数据使用密度
- 范例稿件

### Profile存放位置

- 默认：`$DEBATE_TOOLKIT_HOME/profiles/`
- 示例：`$DEBATE_TOOLKIT_HOME/profiles/example/`
- 自定义：`$DEBATE_TOOLKIT_HOME/profiles/my-style/`

### 多Profile管理

```
profiles/
  example/          # 示例profile
  formal-style/     # 正式风格
  creative-style/   # 创新风格
  me-default/       # 您的默认风格
```

使用时指定：
```
"使用 formal-style 写一篇关于XXX的立论稿"
```

---

## 🏗️ 设计原则

### 1. 通用内核与个人配置分离
- **通用内核**：辩论规则、辩题类型、论证方法（在`prompts/*/references/`）
- **个人配置**：风格偏好、语言习惯（在`profiles/`）
- **好处**：规则可共享和迭代，风格可个性化

### 2. 规则带来源与来源等级
所有规则标注来源和等级：
- **教材/课程级**（最高）：超辩学院、系统课程
- **咨询群资料**（中）：辩论社群整理的方法论
- **名家文章**（中）：知名辩手的经验分享
- **实践总结**（低）：团队实战总结，待验证

### 3. 数据真实性硬规则
- 所有数据必须有来源和年份
- 查不到的标注**【待核实】**
- **禁止编造数据**

### 4. 按需加载，节省Token
- 路由设计：只加载当前任务需要的规则
- 价值辩不加载政策辩规则，立论不加载质询规则
- 平均每次对话加载<500行规则

---

## 🌍 平台支持

### 当前支持

| 平台 | 状态 | 说明 |
|------|------|------|
| **Claude Code** | ✅ 完整支持 | 自动安装到`~/.claude/skills/` |
| **通用LLM/API** | ✅ 完整支持 | 手动加载prompt和规则 |
| **Cursor** | 🚧 开发中 | 手动配置Rules |
| **OpenAI GPTs** | 🚧 开发中 | 作为Custom Instructions |
| **LangChain/AutoGPT** | 📋 计划中 | Agent Tools适配 |

### 通用使用方式

即使不使用特定平台，您也可以：
1. 将`prompts/*/references/`中的规则作为system prompt
2. 手动组合规则文件发送给任何LLM
3. 通过API调用（见`docs/api-usage.md`，开发中）

---

## 📂 目录结构

```
debate-agent-toolkit/
├── README.md                    # 本文档
├── LICENSE                      # MIT License
├── CHANGELOG.md                 # 版本更新日志
├── config.yaml                  # 配置文件模板
│
├── prompts/                     # 核心Prompts（原skills）
│   ├── debate-prep/
│   ├── debate-script-writer/
│   ├── debate-material-pack/
│   ├── debate-match-review/
│   └── debate-style-learner/
│
├── knowledge/                   # 知识库索引
│   ├── topics-index.md
│   ├── books-index.md
│   └── *-theory.md
│
├── profiles/                    # Profile配置
│   └── example/                 # 示例profile
│
├── tests/                       # 测试记录
│   └── README.md
│
├── scripts/                     # 安装脚本
│   ├── install.sh              # macOS/Linux
│   └── install.ps1             # Windows
│
└── docs/                        # 文档（开发中）
    ├── platforms/              # 各平台使用指南
    └── api-usage.md            # API调用示例
```

---

## 🔧 配置

### 环境变量

```bash
# 安装位置（可选，默认值见下）
export DEBATE_TOOLKIT_HOME="/custom/path"

# 默认值：
# Linux/macOS: ~/.local/share/debate-agent-toolkit/
# Windows: %APPDATA%\debate-agent-toolkit\

# ASR API密钥（可选，match-review使用）
export DEBATE_ASR_API_KEY="your-api-key"
```

### 配置文件

编辑`$DEBATE_TOOLKIT_HOME/config.yaml`：

```yaml
# 平台适配
platform: auto  # auto / claude-code / cursor / generic

# 目录配置
knowledge_dir: ${DEBATE_TOOLKIT_HOME}/knowledge
profiles_dir: ${DEBATE_TOOLKIT_HOME}/profiles

# 功能开关
features:
  asr_enabled: false  # 语音识别功能
```

---

## 📊 数据与来源说明

### 规则来源
本工具包中的规则为对公开辩论资料的要点提炼，均注明出处：
- 超辩学院课程
- 辩论咨询群整理资料
- 名家公开文章和书籍

### 资料使用
- 本仓库**不含原始资料文件**（书籍、课程视频、PDF等）
- 用户自己的资料**只在本地读取**，不上传
- 生成的profile和稿件**仅存储在用户本地**

### 版权说明
- 提炼的要点和规则遵循合理使用原则
- 原始资料版权归原作者所有
- 如有版权异议，请通过GitHub Issues联系我们

---

## ⚠️ 已知局限

### v0.1.0

1. **平台支持**
   - Claude Code：✅ 完整支持
   - 其他平台：🚧 部分支持或开发中

2. **测试样本**
   - 基于有限样本测试（2轮，10个辩题）
   - 部分规则标注"待验证"

3. **书籍要点**
   - 部分辩论书籍的详细要点提炼尚未完成
   - 当前主要依赖课程和文章类资料

4. **ASR功能**
   - `debate-match-review`的语音识别为可选功能
   - 未配置时需用户提供转录文本

---

## 🗺️ 路线图

### v0.2.0（开发中）
- [ ] Cursor完整支持
- [ ] OpenAI GPTs适配
- [ ] 完善事实辩和政策辩规则
- [ ] 更多辩题测试

### v0.3.0（计划）
- [ ] LangChain/AutoGPT适配
- [ ] Web UI（可选）
- [ ] API服务封装
- [ ] 团队协作支持

### v1.0.0（长期）
- [ ] 完整的多平台支持
- [ ] 移动端支持
- [ ] 多语言支持（英文辩论）

---

## 🤝 贡献

欢迎贡献！请查看[贡献指南](CONTRIBUTING.md)（开发中）

### 报告问题
- 使用GitHub Issues报告bug或提出功能建议
- 提供复现步骤和相关日志

### 贡献代码
1. Fork本仓库
2. 创建特性分支（`git checkout -b feature/your-feature`）
3. 提交改动（`git commit -m 'Add some feature'`）
4. 推送到分支（`git push origin feature/your-feature`）
5. 创建Pull Request

### 贡献规则
- 新增规则需标注来源和来源等级
- 数据必须有来源，查不到标注【待核实】
- 遵循现有代码风格和目录结构

---

## 📄 License

MIT License - 详见[LICENSE](LICENSE)文件

---

## 🙏 致谢

感谢以下资源和社群：
- 超辩学院系列课程
- 各辩论咨询群的资料整理者
- 名家辩手的公开分享
- 所有参与测试和反馈的用户

---

## 📞 联系方式

- **GitHub Issues**: [项目地址]/issues
- **讨论区**: [项目地址]/discussions

---

**版本**: v0.1.0  
**最后更新**: 2026-10-11

开始使用：运行安装脚本，然后对AI说"我要准备辩题"即可！

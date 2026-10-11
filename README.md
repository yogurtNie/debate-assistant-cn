# Debate Agent Toolkit

**中文辩论备赛的AI Agent工具包 — 支持多平台、开箱即用**

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](https://github.com/YOUR_USERNAME/debate-agent-toolkit)
[![Platform](https://img.shields.io/badge/platform-Claude%20%7C%20Cursor%20%7C%20LLM-green.svg)]()

</div>

---

## 🎯 这是什么？

五个专项AI prompt帮你：
- ✍️ **写辩论稿** - 框架稿、逐字稿、质询稿、结辩稿
- 📚 **整理资料** - 论点卡片、数据表、来源标注
- 🎬 **复盘比赛** - 转录分析、战场复盘、改进建议
- 🎨 **学习风格** - 从历史稿件自动提取个人风格
- 🧭 **智能路由** - 自动判断你需要哪个工具

通用内核与个人风格分离，所有规则带来源和等级，支持Claude Code、Cursor及任何LLM。

---

## ⚡ 快速开始（3分钟）

### 方法1：AI自动安装（最简单）

**对任何AI Agent说**：
```
帮我安装这个GitHub项目作为skill: 
https://github.com/YOUR_USERNAME/debate-agent-toolkit
```

AI会自动：
- ✅ 克隆仓库
- ✅ 检测您的平台
- ✅ 运行安装脚本
- ✅ 创建软链接（如果是Claude Code）

### 方法2：命令行安装

**使用npx（推荐）**：
```bash
npx debate-agent-toolkit install
```

**使用npm**：
```bash
npm install -g debate-agent-toolkit
```

**使用脚本**：
```bash
# 1. 克隆仓库
git clone https://github.com/YOUR_USERNAME/debate-agent-toolkit.git
cd debate-agent-toolkit

# 2. 运行安装脚本（自动检测平台）
bash scripts/install.sh        # macOS/Linux
# 或
.\scripts\install.ps1          # Windows
# 或
node install.js                # 跨平台Node.js
```

**安装完成后**：
- ✅ 自动检测您的平台（Claude Code/Cursor/通用）
- ✅ 安装到合适的位置
- ✅ 创建必要的目录和配置
- ✅ （Claude Code）自动创建软链接

### 方法2：快速体验（不安装）

直接复制prompt内容到您的LLM：

```python
# 读取prompt
with open('prompts/debate-script-writer/SKILL.md') as f:
    prompt = f.read()

# 发送给任何LLM
"我要写一篇关于'诚信比智慧更重要'的立论稿，正方，经典赛制"
```

---

## 🚀 使用示例

### 示例1：写立论稿（最常用）

**对话**：
```
我要准备辩题：诚信比智慧更重要，正方，经典赛制，请帮我写框架稿
```

**AI会自动**：
1. 识别辩题类型（比较型价值辩）
2. 加载对应规则（比较型四要点ABCD、五步流程）
3. 生成框架稿，包含：
   - 判准设置（可操作、能比较）
   - 三个论点（每个都是"诚信vs智慧"的对比）
   - 使用缺失性比较（"缺失诚信vs缺失智慧"）
   - 预判对方5个论点及回应

**输出示例**：
```markdown
# 立论框架稿

## 判准
以"社会信任体系的稳定性"为判准

## 主线论证
### 论点一：诚信是合作的前提，智慧是合作的工具
- 诚信端：降低交易成本...
- 智慧端：提高效率但无法建立信任...
- 对比结论：在判准下，诚信是基础设施

### 论点二：缺失性比较
- 缺失诚信：社会陷入囚徒困境...
- 缺失智慧：效率降低但合作仍可进行...

### 论点三：智慧的有效性依赖诚信
...
```

### 示例2：整理资料包

**对话**：
```
为'时间能改变一切'整理资料包，包括论点卡片和数据表
```

**AI会生成**：
- 📝 6张论点卡片（物质/生命/精神层面）
- 📊 3张数据表（时间尺度对比）
- 🔍 所有数据标注来源和年份
- ⚠️ 未查证的标注【待核实】

### 示例3：复盘比赛

**对话**：
```
我有一场比赛的转录文本，想做复盘分析
[粘贴转录文本]
```

**AI会分析**：
- 战场识别（判准战场、需根解损等）
- 攻防得失（哪些点赢了、哪些点输了）
- 逻辑漏洞（循环论证、偷换概念等）
- 改进建议（下次怎么打）

### 示例4：学习你的风格

**对话**：
```
用debate-style-learner从我的历史稿件学习风格
路径：/Users/me/debates/
```

**AI会提取**：
- 论证风格偏好（理性型/升华型）
- 语言习惯（句式、用词）
- 数据密度（轻/中/重）
- 自动生成profile，下次写稿时使用

---

## 📂 目录结构

```
debate-agent-toolkit/
├── prompts/                     # 5个核心Prompts
│   ├── debate-prep/            # 路由入口
│   ├── debate-script-writer/   # 写稿核心（10个规则文件）
│   ├── debate-material-pack/   # 资料整理
│   ├── debate-match-review/    # 比赛复盘
│   └── debate-style-learner/   # 风格学习
│
├── knowledge/                   # 知识库索引
│   ├── topics-index.md         # 辩题库索引
│   ├── books-index.md          # 书籍要点
│   └── *-theory.md             # 辩论理论
│
├── profiles/                    # 风格配置
│   └── example/                # 示例profile
│
├── docs/platforms/              # 平台使用指南
│   ├── claude-code.md          # Claude Code详细指南
│   └── generic-llm.md          # 通用LLM/API使用
│
└── scripts/                     # 安装脚本
    ├── install.sh              # macOS/Linux
    └── install.ps1             # Windows
```

---

## 🛠️ 五个核心工具

### 1. debate-prep（路由入口）
**何时用**：不确定该用哪个工具时  
**功能**：分析你的需求，推荐合适的工具  

### 2. debate-script-writer（写稿核心）
**何时用**：需要写立论、质询、结辩稿时  
**功能**：
- 自动识别辩题类型（比较型/事实/政策）
- 加载对应规则（只加载需要的，节省token）
- 生成符合规范的框架稿
- 数据全部标注来源

**支持的辩题类型**：
- ✅ 比较型价值辩（如"A比B重要"）
- ✅ 判断型价值辩（如"X是美德"）
- ✅ 事实辩（如"时间能改变一切"）
- ✅ 政策辩（如"应该推行垃圾分类"）

### 3. debate-material-pack（资料整理）
**何时用**：需要系统整理资料时  
**功能**：
- 论点卡片（标准字段：论点/论据/数据/来源/年份）
- 数据表（时间尺度、对比数据）
- 评估维度（可信度/时效性/抗攻击性）

**硬规则**：
- ❌ 禁止编造数据
- ✅ 必须标注来源和年份
- ⚠️ 查不到的标注【待核实】

### 4. debate-match-review（比赛复盘）
**何时用**：有比赛录音或转录文本时  
**功能**：
- 战场识别和得失分析
- 逻辑漏洞检查
- 攻防效果评估
- 改进建议

**可选功能**：ASR语音识别（需配置API key）

### 5. debate-style-learner（风格学习）
**何时用**：想让AI学习你的写稿风格时  
**功能**：
- 分析历史稿件
- 提取风格特征
- 生成个人profile
- 下次写稿时自动应用

---

## 🎨 个性化配置

### 自动生成你的风格

```
对AI说：
"用debate-style-learner从我的历史稿件学习风格，
路径：/path/to/my/debates/"
```

生成的profile包含：
```yaml
# preferences.md
论证风格: 理性论证为主
语言风格: 通俗易懂，有画面感
数据密度: 价值辩适中，事实辩较高

# style-rules.md  
开篇: 30秒内明确判准
论点: 先结论后展开
预判: 具体回应，不泛泛而谈

# exemplars/
[您的3-5篇范例稿件]
```

### 使用你的风格

```
"使用我的风格写一篇关于XXX的立论稿"
```

AI会自动加载`$DEBATE_TOOLKIT_HOME/profiles/me-default/`

---

## 🌍 平台支持

### ✅ Claude Code（完整支持）

安装脚本自动创建软链接到`~/.claude/skills/`，开箱即用。

**验证**：
```bash
ls -la ~/.claude/skills/ | grep debate
```

**使用**：
```
# 直接对话
"我要准备辩题..."
```

### ✅ 通用LLM/API（完整支持）

手动加载prompt到任何LLM：

```python
# OpenAI
import openai
with open('prompts/debate-script-writer/SKILL.md') as f:
    system = f.read()

openai.ChatCompletion.create(
    model="gpt-4",
    messages=[
        {"role": "system", "content": system},
        {"role": "user", "content": "写一篇立论稿..."}
    ]
)

# Anthropic
import anthropic
client = anthropic.Anthropic()
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    system=system,
    messages=[{"role": "user", "content": "写一篇立论稿..."}]
)
```

详见：[docs/platforms/generic-llm.md](docs/platforms/generic-llm.md)

### 🚧 Cursor（开发中）

将`prompts/`内容添加到Cursor Rules（手动配置）

### 🚧 OpenAI GPTs（开发中）

作为Custom Instructions使用

---

## ⚙️ 配置

### 环境变量

```bash
# 自定义安装位置（可选）
export DEBATE_TOOLKIT_HOME="/custom/path"

# 默认位置：
# Linux/macOS: ~/.local/share/debate-agent-toolkit/
# Windows: %APPDATA%\debate-agent-toolkit\

# ASR API（可选，match-review使用）
export DEBATE_ASR_API_KEY="your-key"
```

### 配置文件

编辑`$DEBATE_TOOLKIT_HOME/config.yaml`：

```yaml
# 平台自动检测
platform: auto  # auto / claude-code / cursor / generic

# 功能开关
features:
  asr_enabled: false  # 语音识别（可选）
```

---

## 🧪 规则体系

### 设计原则

1. **规则带来源和等级**
   - 教材/课程级（最高）：超辩学院
   - 咨询群资料（中）
   - 实践总结（低，标注"待验证"）

2. **数据真实性硬规则**
   - 必须有来源和年份
   - 查不到标注【待核实】
   - 禁止编造

3. **按需加载**
   - 价值辩不加载政策辩规则
   - 立论不加载质询规则
   - 平均每次加载<500行

### 核心规则

#### 比较型价值辩
- **四要点ABCD**：标准与价值观、价值观因人而异、现状影响选择、标准可操作
- **五步流程**：明确矛盾→寻找原因→制定标准→进行比较→得证
- **缺失性比较**：对比"缺失A"vs"缺失B"哪个更糟
- **来源**：咨询群资料《比较性辩题的通俗打法》

#### 事实辩
- **判准标准**：可验证、可观察（如"是否存在反例"）
- **论证方法**：机制拆解+数据支撑+案例
- **来源**：基于辩论理论推理

#### 判断型价值辩
- **判准标准**：明确"是/不是"的判定依据
- **论证方法**：从定义/机制/本质三层论证
- **来源**：马萌《价值辩论》

#### 政策辩
- **框架**：需根解损四战场
- **论证方法**：需求性+根属性+解决力+损益比
- **来源**：超辩学院课程

---

## ❓ 常见问题

### Q: 我不用Claude Code，能用吗？
**A**: 可以！支持任何LLM。将`prompts/`中的内容作为system prompt使用即可。详见[通用LLM使用指南](docs/platforms/generic-llm.md)。

### Q: 数据从哪来？
**A**: 工具本身不提供数据，只提供方法论。生成的稿件会标注【待核实】，您需要自己查证。

### Q: 生成的稿件能直接用吗？
**A**: 不能。这是**框架稿**，需要您：
1. 查证所有【待核实】的数据
2. 根据实际情况调整论点
3. 加入个人风格和案例

### Q: 支持团队使用吗？
**A**: 支持。每个成员安装到自己的电脑，可以：
- 共享规则文件（knowledge/）
- 各自维护个人profile（profiles/me-default/）
- 协作整理资料包

### Q: 如何升级？
**A**: 
```bash
cd debate-agent-toolkit
git pull
bash scripts/install.sh  # 重新安装
```
个人配置会自动保留。

### Q: 安装失败怎么办？
**A**: 检查：
1. 是否有Git（`git --version`检查）
2. 是否有Node.js（如果用npm安装，`node --version`检查）
3. 是否有权限写入安装目录
4. 尝试手动安装：`bash scripts/install.sh`
5. 查看错误信息中的具体问题
6. 提交[GitHub Issue](https://github.com/YOUR_USERNAME/debate-agent-toolkit/issues)

### Q: Codex/其他AI能自动安装吗？
**A**: 可以！只需告诉AI：
```
帮我安装这个GitHub项目: https://github.com/YOUR_USERNAME/debate-agent-toolkit
```
AI会自动克隆仓库并运行安装脚本。我们提供了：
- ✅ `install.js` - Node.js跨平台安装脚本
- ✅ `skills.json` - Skills元数据（AI可解析）
- ✅ `package.json` - npm支持
- ✅ 自动平台检测和配置

### Q: 我的prompt超过token限制了
**A**: 使用路由加载，不要一次加载所有规则。工具会自动按需加载，平均<500行。

---

## 📊 测试与质量

### 已测试辩题类型

- ✅ 比较型价值辩（机遇vs奋斗、诚信vs智慧）
- ✅ 哲学概念型（人性本善）
- ✅ 判断型价值辩（中立是美德）
- ✅ 事实辩（时间能改变一切）
- ✅ 政策辩（垃圾分类）

### 迭代测试

**2轮测试，10个辩题**：
- 第一轮：发现比较型辩题缺少"比较"结构 → 补充四要点ABCD
- 第二轮：发现事实辩判准标准不明确 → 补充可验证标准
- **最终通过率**：100%（必检项）

详见：[tests/](tests/)

---

## 🗺️ 路线图

### v0.2.0（开发中）
- [ ] Cursor完整支持
- [ ] OpenAI GPTs模板
- [ ] 完善事实辩和政策辩规则
- [ ] 更多测试案例

### v0.3.0（计划中）
- [ ] LangChain/AutoGPT适配
- [ ] API封装
- [ ] Web UI（可选）
- [ ] 团队协作功能

### v1.0.0（长期）
- [ ] 移动端支持
- [ ] 多语言支持（英文辩论）
- [ ] 完整的多平台支持

---

## 🤝 贡献

欢迎贡献！请查看[贡献指南](CONTRIBUTING.md)（开发中）

### 贡献规则
- 新增规则必须标注来源和等级
- 数据必须有来源，查不到标注【待核实】
- 遵循现有代码风格和目录结构

---

## 📄 License

MIT License - 详见[LICENSE](LICENSE)

---

## 🙏 致谢

- **超辩学院**系列课程
- **辩论咨询群**资料整理者
- **名家辩手**的公开分享
- 所有参与测试和反馈的用户

---

## 📞 联系

- **GitHub Issues**: [项目地址]/issues
- **讨论区**: [项目地址]/discussions

---

<div align="center">

**版本**: v0.1.0 | **更新**: 2026-10-11

开始使用：`bash scripts/install.sh`

</div>

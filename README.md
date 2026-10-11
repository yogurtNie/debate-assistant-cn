# 辩论技能包 (Debate Skills)

中文辩论备赛的 AI 协作工具集，适用于 Claude Code。

## 一句话介绍

五个专项 skill 帮助你写辩论稿、整理资料包、复盘比赛、学习个人风格，通用内核与个人配置分离，开箱即用。

---

## 快速开始

### 安装

**方法1：自动安装（推荐）**

Windows (PowerShell):
```powershell
.\scripts\install.ps1
```

macOS/Linux:
```bash
bash scripts/install.sh
```

**方法2：手动安装**

1. 复制 `skills/` 目录下的5个文件夹到 Claude skills 目录：
   - Windows: `C:\Users\<用户名>\.claude\skills\`
   - macOS/Linux: `~/.claude/skills/`

2. 复制 `debate-knowledge/` 到 `~/.claude/debate-knowledge/`
3. 复制 `debate-profiles/example/` 到 `~/.claude/debate-profiles/example/`

### 第一次使用

**场景1：写框架稿**
```
与Claude对话：
"我要准备辩题：诚信比智慧更重要，正方，经典赛制，请帮我写框架稿"
```

**场景2：整理资料包**
```
"我要为'时间能改变一切'这个辩题整理资料包，
包括论点卡片和数据表"
```

**场景3：复盘比赛**
```
"我有一场比赛的转录文本，想做复盘分析"
[提供转录文本或文件路径]
```

---

## 五个Skills功能表

| Skill | 做什么 | 何时触发 |
|-------|--------|----------|
| **debate-prep** | 路由入口，判断阶段并推荐对应skill | 说"准备辩论"、"辩题"、不确定从哪开始 |
| **debate-script-writer** | 写框架稿、逐字稿、质询稿、结辩稿 | 说"写稿"、"立论"、"质询"、"结辩" |
| **debate-material-pack** | 整理资料包（论点卡片+数据表） | 说"收集资料"、"整理论点"、"数据表" |
| **debate-match-review** | 复盘比赛录音/转录稿 | 说"复盘"、"比赛录音"、提供转录文本 |
| **debate-style-learner** | 从历史稿件学习个人风格 | 说"学习风格"、"生成profile"、提供历史稿件路径 |

---

## 个性化配置

### 自动生成个人风格

使用 `debate-style-learner` 从您以前的稿子自动生成 profile：

```
与Claude对话：
"我想用 debate-style-learner 生成我的个人风格，
我的历史稿件在 /path/to/my/debates/"
```

生成的 profile 包含：
- 论证风格偏好
- 语言习惯
- 数据使用密度
- 范例稿件

### Profile 存放位置

- 默认位置：`~/.claude/debate-profiles/`
- 可通过环境变量配置：`DEBATE_PROFILES_DIR`

### 多 Profile 管理

```
~/.claude/debate-profiles/
  example/          - 示例profile
  me-default/       - 您的默认风格
  formal-style/     - 正式风格
  creative-style/   - 创新风格
```

使用时指定：
```
"使用 formal-style 写一篇关于XXX的立论稿"
```

---

## 设计原则

### 1. 通用内核与个人配置分离
- **通用内核**：辩论规则、辩题类型、论证方法（在 skills/references/ 中）
- **个人配置**：风格偏好、语言习惯（在 debate-profiles/ 中）
- 好处：规则可共享和迭代，风格可个性化

### 2. 规则带来源与来源等级
所有规则标注来源和等级：
- **教材/课程级**（最高）：超辩学院、系统课程
- **咨询群资料**（中）：辩论社群整理的方法论
- **名家文章**（中）：知名辩手的经验分享
- **实践总结**（低）：团队实战总结，待验证

### 3. 数据真实性硬规则
- 所有数据必须有来源和年份
- 查不到的标注 **【待核实】**
- **禁止编造数据**

### 4. 按需加载，节省 Token
- 路由表设计：只加载当前任务需要的规则文件
- 价值辩不加载政策辩规则，立论不加载质询规则
- 平均每次对话加载 <500 行规则

---

## 数据与来源说明

### 规则来源
本仓库中的规则为对公开辩论资料的要点提炼，均注明出处：
- 超辩学院课程
- 辩论咨询群整理资料
- 名家公开文章和书籍

### 资料使用
- 本仓库**不含原始资料文件**（书籍、课程视频、PDF等）
- 用户自己的资料**只在本地读取**，不上传
- 生成的 profile 和稿件**仅存储在用户本地**

### 版权说明
- 提炼的要点和规则遵循合理使用原则
- 原始资料版权归原作者所有
- 如有版权异议，请联系删除：[提供联系方式]

---

## 已知局限

### 当前版本 (v0.1.0)

1. **ASR 功能**
   - `debate-match-review` 的语音识别功能为可选
   - 未配置 ASR API 时，需用户提供转录文本
   - 降级方案：只处理用户提供的文字稿

2. **迭代测试**
   - 基于有限样本测试（3轮，约10个辩题）
   - 规则覆盖：比较型价值辩 > 事实辩/判断型价值辩 > 政策辩
   - 部分规则标注"待验证"，等待更多实战反馈

3. **书籍教材要点**
   - 部分辩论书籍的详细要点提炼尚未完成
   - 当前主要依赖课程和文章类资料

4. **文件格式支持**
   - 输出为 Markdown 格式
   - 暂不支持直接生成 docx（可通过工具转换）

---

## 环境变量配置

### 可选配置

```bash
# Profile 存放位置（默认：~/.claude/debate-profiles/）
export DEBATE_PROFILES_DIR="/custom/path/to/profiles"

# Knowledge 存放位置（默认：~/.claude/debate-knowledge/）
export DEBATE_KNOWLEDGE_DIR="/custom/path/to/knowledge"

# ASR API 密钥（可选，debate-match-review 使用）
export DEBATE_ASR_API_KEY="your-api-key"
```

---

## 路线图

### v0.2.0（计划中）
- [ ] 完善事实辩和政策辩规则
- [ ] 增加更多辩题测试
- [ ] 完善 ASR 流水线
- [ ] 提炼更多书籍要点

### v0.3.0（计划中）
- [ ] 支持团队协作（多人 profile 管理）
- [ ] 辩题分析工具
- [ ] 对方立论预判工具

### 长期
- [ ] Web UI（可选）
- [ ] 移动端支持
- [ ] 多语言支持（英文辩论）

---

## 贡献方式

### 报告问题
- 使用 GitHub Issues 报告 bug 或提出功能建议
- 提供复现步骤和相关日志

### 贡献代码
1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/your-feature`)
3. 提交改动 (`git commit -m 'Add some feature'`)
4. 推送到分支 (`git push origin feature/your-feature`)
5. 创建 Pull Request

### 贡献规则
- 新增规则需标注来源和来源等级
- 数据必须有来源，查不到标注【待核实】
- 遵循现有代码风格和目录结构

---

## 致谢

感谢以下资源和社群对本项目的启发：
- 超辩学院系列课程
- 各辩论咨询群的资料整理者
- 名家辩手的公开分享
- 所有参与测试和反馈的用户

---

## License

MIT License - 详见 [LICENSE](LICENSE) 文件

---

## 版本

**当前版本**: v0.1.0  
**发布日期**: 2026-10-11  
**更新日志**: 见 [CHANGELOG.md](CHANGELOG.md)

---

## 联系方式

- GitHub Issues: [项目地址]/issues
- 邮件: [待补充]

---

**开始使用**: 运行安装脚本，然后对 Claude 说"我要准备辩题"即可开始！

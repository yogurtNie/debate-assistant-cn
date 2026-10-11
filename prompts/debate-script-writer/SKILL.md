# debate-script-writer

根据辩题和立场生成辩论稿（立论、质询稿、自由辩预案、结辩）。

---

## 输出格式说明

**默认格式**: `.docx`（Word文档）
- 框架稿、逐字稿、质询稿、自由辩预案默认生成docx
- 数据表用Word表格
- 【待核实】内容高亮显示
- 可按需导出pdf
- Markdown仅作中间草稿，不作为交付物

**用户可指定其他格式**: 如需要md或其他格式，请明确说明

---

## 任务与文件路由

### 写价值辩立论稿
读取：
- `references/value-debate.md` - 价值辩立论方法
- `references/debate-types.md` - 价值辩四口诀
- `references/writing-rules.md` - 写稿规范
- `references/word-count-timing.md` - 字数时长换算
- `references/ai-flavor-checklist.md` - 去AI味检查

### 写政策辩立论稿
读取：
- `references/debate-types.md` - 需根解损框架
- `references/constructive-speech-rules.md` - 立论规则
- `references/writing-rules.md` - 写稿规范

### 写质询稿
读取：
- `references/cross-examination.md` - 质询规则
- `references/writing-rules.md` - 写稿规范

### 写自由辩预案
读取：
- `references/free-debate.md` - 自由辩论预案准备
- `references/writing-rules.md` - 写稿规范

### 写结辩稿
读取：
- `references/closing-speech.md` - 结辩规则
- `references/writing-rules.md` - 写稿规范

### 检查逻辑错误
读取：
- `references/logic-errors.md` - 11种常见逻辑错误

### 临场反驳准备
读取：
- `references/rebuttal.md` - 临场反驳规则

---

## 写稿流程

1. 读取任务对应的references文件
2. 基于规则生成初稿
3. **字数自检**（按word-count-timing.md换算目标字数，偏差>8%需调整）
4. **去AI味检查**（按ai-flavor-checklist.md逐项检查，不通过必须修改）
5. 检查逻辑错误和写稿规范
6. 输出最终稿件（默认.docx格式）
7. 附字数统计报告（目标字数、实际字数、预估时长、偏差率）

---

## 禁止

- ❌ 不要"读取全部references"
- ❌ 不要读取与任务无关的文件
- ❌ 数据必须真实，查不到的标注【待核实】

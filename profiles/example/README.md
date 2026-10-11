# README.md

这是一个示例profile目录，展示个人辩论风格配置的结构。

## 目录结构

```
example/
  preferences.md      - 风格偏好
  style-rules.md      - 风格规则
  exemplars/          - 范例稿件
    example-constructive.md  - 立论示例
```

## 如何创建自己的profile

### 方法1：自动生成（推荐）
使用`debate-style-learner`从您的历史稿件自动生成：

```
与Claude对话：
"我想用 debate-style-learner 生成我的个人风格，
我的历史稿件在 /path/to/my/debates/"
```

### 方法2：手动创建
1. 复制这个example目录
2. 修改`preferences.md`和`style-rules.md`
3. 在`exemplars/`中放入您自己的范例稿件（3-5篇）

## 使用profile
在写稿时告诉Claude：
"使用我的profile写一篇关于XXX的立论稿"

profile默认位置：`~/.claude/debate-profiles/`

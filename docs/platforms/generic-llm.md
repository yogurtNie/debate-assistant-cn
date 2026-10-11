# 通用LLM/API使用指南

## 概述

即使不使用特定平台（Claude Code、Cursor等），您也可以将本工具包作为prompt库使用，配合任何LLM使用。

---

## 使用方式

### 方法1：直接拼接Prompt

```python
import os

# 1. 加载SKILL.md（任务定义）
with open('prompts/debate-script-writer/SKILL.md', 'r', encoding='utf-8') as f:
    skill = f.read()

# 2. 加载需要的规则
with open('prompts/debate-script-writer/references/debate-types.md', 'r', encoding='utf-8') as f:
    debate_types = f.read()

with open('prompts/debate-script-writer/references/writing-rules.md', 'r', encoding='utf-8') as f:
    writing_rules = f.read()

# 3. 组合为system prompt
system_prompt = f"""
{skill}

---

## 加载的规则

{debate_types}

---

{writing_rules}
"""

# 4. 调用LLM
user_message = "我要写一篇关于'诚信比智慧更重要'的立论稿，正方"

# OpenAI
import openai
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_message}
    ]
)

# Anthropic
import anthropic
client = anthropic.Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))
response = client.messages.create(
    model="claude-3-5-sonnet-20241022",
    max_tokens=4096,
    system=system_prompt,
    messages=[
        {"role": "user", "content": user_message}
    ]
)
```

### 方法2：路由加载（推荐）

根据任务类型只加载需要的规则：

```python
def load_prompt_for_task(task_type, debate_type=None):
    """
    根据任务类型加载对应的prompt和规则
    
    task_type: 'prep', 'script-writer', 'material-pack', 'match-review', 'style-learner'
    debate_type: 'value', 'fact', 'policy' (仅script-writer需要)
    """
    base_path = f"prompts/debate-{task_type}"
    
    # 加载SKILL.md
    with open(f"{base_path}/SKILL.md", 'r', encoding='utf-8') as f:
        skill = f.read()
    
    rules = []
    
    if task_type == 'script-writer':
        # 按需加载规则
        rules_to_load = [
            'references/debate-types.md',
            'references/writing-rules.md',
            'references/checklist.md'
        ]
        
        if debate_type == 'value':
            rules_to_load.append('references/value-debate.md')
            rules_to_load.append('references/constructive-speech-rules.md')
        elif debate_type == 'policy':
            # 加载政策辩规则
            pass
        
        for rule_path in rules_to_load:
            with open(f"{base_path}/{rule_path}", 'r', encoding='utf-8') as f:
                rules.append(f.read())
    
    # 组合
    return skill + "\n\n---\n\n" + "\n\n---\n\n".join(rules)

# 使用
system_prompt = load_prompt_for_task('script-writer', 'value')
```

---

## OpenAI GPTs配置

### 创建Custom GPT

1. 进入OpenAI GPTs创建页面
2. 配置Instructions：

```
你是一个中文辩论备赛助手。

[复制 prompts/debate-prep/SKILL.md 的内容]

---

## 加载的规则

[根据需要复制 references/ 中的规则]
```

3. 上传知识文件：
   - 上传`knowledge/`中的文件
   - 上传`profiles/example/`作为示例

### 使用

在GPT对话中：
```
"我要准备辩题：时间能改变一切，正方"
```

---

## LangChain集成

```python
from langchain.prompts import PromptTemplate
from langchain.chat_models import ChatOpenAI
from langchain.schema import SystemMessage, HumanMessage

# 加载prompt
def load_debate_prompt(task_type):
    # ... (同上load_prompt_for_task)
    pass

# 创建chain
from langchain.chains import LLMChain

system_prompt = load_debate_prompt('script-writer')
llm = ChatOpenAI(model="gpt-4", temperature=0.7)

# 使用
messages = [
    SystemMessage(content=system_prompt),
    HumanMessage(content="写一篇关于'诚信比智慧更重要'的立论稿")
]

response = llm(messages)
```

---

## API封装（开发中）

未来版本将提供：

```python
from debate_toolkit import DebateAgent

# 初始化
agent = DebateAgent(
    llm="openai/gpt-4",  # 或 "anthropic/claude-3-5-sonnet"
    toolkit_home="/path/to/toolkit"
)

# 使用
response = agent.write_script(
    topic="诚信比智慧更重要",
    stance="affirmative",
    debate_type="value-comparison"
)

print(response.framework)
```

---

## 批量处理

```python
import os
import json

def batch_generate_scripts(topics, llm_api):
    """批量生成框架稿"""
    results = []
    
    system_prompt = load_debate_prompt('script-writer')
    
    for topic in topics:
        user_message = f"我要写一篇关于'{topic['title']}'的立论稿，{topic['stance']}"
        
        response = llm_api.chat(
            system=system_prompt,
            user=user_message
        )
        
        results.append({
            'topic': topic,
            'script': response
        })
    
    return results

# 使用
topics = [
    {'title': '诚信比智慧更重要', 'stance': '正方'},
    {'title': '时间能改变一切', 'stance': '正方'},
]

scripts = batch_generate_scripts(topics, your_llm_api)
```

---

## 最佳实践

### 1. Token优化

只加载需要的规则：
```python
# 不好：加载所有规则
all_rules = load_all_rules()  # 可能3000+行

# 好：按需加载
rules = load_rules_for_value_debate()  # 只有500行
```

### 2. 缓存System Prompt

```python
import functools

@functools.lru_cache(maxsize=10)
def get_system_prompt(task_type, debate_type):
    return load_prompt_for_task(task_type, debate_type)
```

### 3. 流式输出

```python
# OpenAI
for chunk in openai.ChatCompletion.create(
    model="gpt-4",
    messages=[...],
    stream=True
):
    print(chunk.choices[0].delta.get("content", ""), end="")
```

---

## 故障排除

### 文件编码问题

```python
# 确保使用UTF-8编码
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()
```

### Prompt过长

如果system prompt超过token限制：
1. 只加载必要的规则
2. 使用向量数据库存储规则，按需检索
3. 考虑使用支持更长context的模型

---

## 更多帮助

- 主文档：[README.md](../../README.md)
- API参考：[api-reference.md](../api-reference.md)（开发中）
- 问题反馈：[GitHub Issues](https://github.com/YOUR_USERNAME/debate-agent-toolkit/issues)

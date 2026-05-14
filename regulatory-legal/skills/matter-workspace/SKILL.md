---
name: matter-workspace
description: 管理事项工作区 — 创建、列表、切换、关闭或分离活跃事项（执业级）。当跨多个客户或事项工作时，需将一个委托的上下文与另一个分开。子命令：new | list | switch | close | none。
argument-hint: "<new | list | switch | close | none> [slug]"
---

# 事项工作区

从业者在多个客户和事项之间工作。事项工作区将一个客户或委托的上下文与其他每个上下文分离。本技能管理这些工作区。

中国法律执业场景：律所律师服务于多个企业客户；企业法务服务于集团内多家子公司或业务线；合规顾问服务于不同行业的合规项目。事项工作区确保每个客户/项目的数据隔离。

## 子命令

- `/matter-workspace new <slug>` — 创建新事项工作区，运行信息采集，写入 `matter.md`
- `/matter-workspace list` — 列出现有事项，含状态和活跃标记
- `/matter-workspace switch <slug>` — 设置活跃事项
- `/matter-workspace close <slug>` — 归档事项（移至 `_archived/`，绝不删除）
- `/matter-workspace none` — 脱离任何活跃事项，仅在执业级工作

## 存储布局

```
~/.claude/plugins/config/claude-for-legal-cn/regulatory-legal/
├── CLAUDE.md                       # 执业级执业档案
└── matters/
    ├── <slug>/
    │   ├── matter.md               # 客户/事项信息
    │   ├── history.md              # 事件日志
    │   ├── notes.md                # 自由形式工作笔记
    │   └── outputs/                # 该事项的技能输出
    └── _archived/
        └── <slug>/                 # 已关闭事项 — 可读但非活跃
```

Slug 使用小写连字符。示例：`alibaba-datacompliance-2026`、`baidu-merger-review`。

## 活跃事项

执业级 CLAUDE.md 中 `## 事项工作区` 下的 `Active matter:` 行是唯一真相来源。

## 子命令逻辑

### `new <slug>`
1. 确认 slug 未重复。
2. 运行信息采集访谈：客户、对方当事人、事项类型（法规制定/征求意见期/合规差距整改/监管问询/执法回应/常设议题/其他）、保密级别、关键事实、事项特定覆盖。
3. 写入 `matter.md`。
4. 不自动切换。询问是否切换。

### `list`
枚举所有事项，打印表格，标注活跃事项。已归档事项单独列出。

### `switch <slug>`
编辑活跃事项行。展示事项摘要以确认。

### `close <slug>`
归档事项。如关闭的为活跃事项，设置为仅执业级。

### `none`
设置为仅执业级上下文。

## 跨事项上下文

默认为关。当为`关`时，在一个事项中工作的技能绝不读取另一事项的文件。当为`开`时，仅在用户明确要求时读取跨事项文件。

## 中国执业特别注意

- 中国律所和企业的保密义务依据《律师法》和《民法典》合同编 — 事项隔离是合规要求
- 利益冲突检查是本技能不覆盖的领域，需人工判断
- 律师工作成果保护 — 事项文件中的分析和建议需考虑律师保密义务、委托合同保密、商业秘密与个人信息保护要求，以及证据或监管调取风险

## 本技能不做的事

- 运行利益冲突检查
- 执行文件保留政策
- 自动路由输出
- 决定跨事项读取是否适当

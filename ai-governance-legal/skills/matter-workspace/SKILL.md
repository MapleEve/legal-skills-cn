---
name: matter-workspace
description: >
  管理事项工作区——新建、列出、切换、关闭或解除（实践级别）。
  用于将不同客户或委托事务的上下文相互隔离。
  当跨多个客户或事务工作时，当用户说"新建事项"、"切换事项"、
  "列出事项"、"关闭事项"时使用。
argument-hint: "<new | list | switch | close | none> [slug]"
---

# /matter-workspace

执业者跨多个客户和事务工作。事项工作区将不同客户或委托事务的上下文相互隔离。

## 子命令

- `/ai-governance-legal:matter-workspace new <slug>` — 创建新事项工作区，运行简短的信息采集，写入 `matter.md`
- `/ai-governance-legal:matter-workspace list` — 列出事项及其状态和活跃标注
- `/ai-governance-legal:matter-workspace switch <slug>` — 设置当前活跃事项
- `/ai-governance-legal:matter-workspace close <slug>` — 归档事项（移至 `_archived/`，永不删除）
- `/ai-governance-legal:matter-workspace none` — 解除任何活跃事项的关联，仅在实践级别工作

## 操作说明

1. 读取实践配置 — 确认 `## 事项工作区` 章节已填写。如果 `启用` 为 `✗`，告知用户事项工作区已关闭——法务部内部用户的默认状态。
2. 使用以下工作流。
3. 根据 `$ARGUMENTS` 的首个词分派：
   - `new` → 运行信息采集访谈，写入 `matters/<slug>/matter.md`，初始化 `history.md` 和 `notes.md`。
   - `list` → 枚举 `matters/*/matter.md`，打印表格，标注活跃事项。
   - `switch` → 更新实践级别 CLAUDE.md 中的 `活跃事项:` 行。
   - `close` → 移至 `_archived/<slug>/`，在 `history.md` 中记录关闭日期。
   - `none` → 将 `活跃事项:` 设为 `无 — 仅实践级别上下文`。
4. 向用户展示变更内容，在写入前确认。

## 注意事项

- 除非实践级别 CLAUDE.md 中的 `跨事项上下文` 为 `开启`，否则本技能绝不跨事项读取。
- 归档不是删除——已关闭的事项保持可读以用于保存记录/利益冲突检查目的。
- 标识使用小写字母加连字符。

---

## 功能目的

多客户执业者跨多个事务工作。一个事务的上下文不能泄露到另一个。本技能是实现这一点的轻量级文件管理层。

**默认状态为关闭。** 法务部内部用户永远不会看到此功能——他们仅在实践级别运行。事项工作区在冷启动时对私人执业用户启用。

## 存储结构

```
~/.claude/plugins/config/claude-for-legal-cn/ai-governance-legal/
├── CLAUDE.md                       # 实践级别配置
└── matters/
    ├── <slug>/
    │   ├── matter.md               # 客户、对方当事人、事项类型、关键事实、覆盖项
    │   ├── history.md              # 带日期的事件、决策、草稿、审查日志
    │   ├── notes.md                # 自由格式工作笔记
    │   └── outputs/                # 本事项的技能输出
    └── _archived/
        └── <slug>/                 # 已关闭事项 — 可读但非活跃
```

标识使用小写字母加连字符。

## 活跃事项在实践级 CLAUDE.md 中

实践级别 CLAUDE.md 中 `## 事项工作区` 下的 `活跃事项:` 行是唯一的事实来源。切换事项即编辑该行。

## 子命令逻辑

### `new <slug>`
确认标识未重复 → 运行信息采集访谈（客户、对方当事人、事项类型、保密级别、关键事实、事项特定覆盖）→ 写入 `matter.md` → 初始化 `history.md` 和 `notes.md` → 不自动切换。

AI治理的事项类型：用例（内部）| 供应商AI审查 | AI影响评估 | 法规变化 | 政策项目 | 算法备案 | 其他。

### `list`
枚举 `matters/*/matter.md`，打印表格（标识 | 客户 | 事项类型 | 状态 | 开启日期 | 活跃），标注活跃事项。

### `switch <slug>`
确认存在 → 编辑 `活跃事项:` 行 → 展示摘要。

### `close <slug>`
追加关闭记录 → 移至 `_archived/` → 如是活跃事项则解除。

### `none`
设置 `活跃事项:` 为 `无 — 仅实践级别上下文`。

## 跨事项上下文

默认关闭。关闭时技能绝不跨事项读取。开启时仅当用户明确要求才跨事项查看。

## 本技能不做的事

- 不运行利益冲突检查
- 不强制执行保存期限
- 不自动路由输出
- 不决定跨事项是否合适

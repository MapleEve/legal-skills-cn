---
name: matter-workspace
description: >
  管理事项工作区——新建、列出、切换、关闭或脱离（实践级）。
  当跨多个客户或事务工作时使用，或当用户说"新建事项"、"切换事项"、"列出事项"、"关闭事项"时使用。
argument-hint: "<new | list | switch | close | none> [slug]"
---

# /matter-workspace

执业者跨多个客户和事务工作。事项工作区将不同客户或委托事务的上下文相互隔离。

## 子命令

- `/product-legal:matter-workspace new <slug>` — 创建新事项工作区，运行简短信息采集，写入 `matter.md`
- `/product-legal:matter-workspace list` — 列出事项及状态
- `/product-legal:matter-workspace switch <slug>` — 设置活跃事项
- `/product-legal:matter-workspace close <slug>` — 归档事项（移至 `_archived/`，永不删除）
- `/product-legal:matter-workspace none` — 脱离任何活跃事项，仅实践级工作

## 操作说明

1. 读取实践配置 — 确认 `## 事项工作区` 已填充。如 `启用` 为 `✗`，告知用户事项工作区已关闭——法务部内部用户的默认状态。
2. 根据 `$ARGUMENTS` 首个词分派相应子命令。
3. 存储结构：`~/.claude/plugins/config/claude-for-legal-cn/product-legal/matters/<slug>/`
4. 标识使用小写字母加连字符。

## 子命令逻辑

### `new <slug>`
确认标识未重复 → 运行信息采集访谈（客户、对方当事人、事项类型、保密级别、关键事实、事项特定覆盖）→ 写入 `matter.md` → 初始化 `history.md` 和 `notes.md` → 不自动切换。

### `list`
枚举 `matters/*/matter.md`，打印表格（标识 | 客户 | 事项类型 | 状态 | 开启日期 | 活跃），标注活跃事项。

### `switch <slug>`
确认存在 → 编辑 `活跃事项:` 行 → 展示摘要。

### `close <slug>`
追加关闭记录 → 移至 `_archived/` → 如是活跃事项则解除。

### `none`
设置 `活跃事项:` 为 `无 — 仅实践级上下文`。

## 跨事项上下文

默认关闭。关闭时技能绝不跨事项读取。开启时仅当用户明确要求才跨事项查看。

## 本技能不做的事

- 不运行利益冲突检查
- 不强制执行保存期限
- 不自动路由输出
- 不决定跨事项是否合适

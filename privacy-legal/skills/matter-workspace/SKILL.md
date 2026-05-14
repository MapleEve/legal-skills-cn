---
name: matter-workspace
description: >
  管理事项工作区——创建、列出、切换、关闭或分离（执业级别）。
  将每个客户或事项的上下文相互隔离，适用于多客户执业的法务人员。
  适用场景：用户需要创建新事项、切换事项、列出事项、
  关闭/归档事项，或仅在执业级别工作。
argument-hint: "<new | list | switch | close | none> [slug]"
---

# /matter-workspace

法务人员同时处理多个客户和事项。事项工作区将每个客户或事项的上下文相互隔离。本技能管理这些工作区。

## 子命令

- `/privacy-legal:matter-workspace new <slug>` —— 创建一个新的事项工作区，运行简短立案访谈，写入`matter.md`
- `/privacy-legal:matter-workspace list` —— 列出事项及状态和活跃标记
- `/privacy-legal:matter-workspace switch <slug>` —— 设置活跃事项
- `/privacy-legal:matter-workspace close <slug>` —— 归档事项（移至 `~/.claude/plugins/config/claude-for-legal-cn/privacy-legal/matters/_archived/`，永不删除）
- `/privacy-legal:matter-workspace none` —— 脱离任何活跃事项，仅在执业级别工作

## 指令

1. 读取 `~/.claude/plugins/config/claude-for-legal-cn/privacy-legal/CLAUDE.md` —— 确认 `## 事项工作区` 节已填充。如果 `Enabled` 为 `✗`，告知用户："事项工作区已关闭——您配置为法务内部执业，含单一客户，因此插件自动从执业级别上下文工作。如果您实际处理多个客户的工作，重新运行 `/privacy-legal:cold-start-interview --redo` 并选择私人执业设置。否则，您不需要 `/matter-workspace`。"不要报错——关闭状态是法务内部用户的预期状态。
2. 使用以下子命令逻辑。
3. 按 `$ARGUMENTS` 的第一个标记派发：
   - `new` → 运行立案访谈，写入 `~/.claude/plugins/config/claude-for-legal-cn/privacy-legal/matters/<slug>/matter.md`，生成 `history.md` 和 `notes.md`。
   - `list` → 枚举 `~/.claude/plugins/config/claude-for-legal-cn/privacy-legal/matters/*/matter.md`，打印表格，标记活跃事项。
   - `switch` → 更新执业级别 CLAUDE.md 中的 `Active matter:` 行。
   - `close` → 将 `~/.claude/plugins/config/claude-for-legal-cn/privacy-legal/matters/<slug>/` 移至 `~/.claude/plugins/config/claude-for-legal-cn/privacy-legal/matters/_archived/<slug>/`，在 `history.md` 中记录关闭日期。
   - `none` → 将 `Active matter:` 设置为 `none — practice-level context only`。
4. 向用户展示变更内容，写入前确认。

## 注意事项

- 除非执业级别 CLAUDE.md 中 `Cross-matter context` 为 `on`，否则技能绝不跨事项读取。
- 归档不是删除——已关闭事项保持可读，用于留存/利益冲突目的。
- 标识为小写字母加连字符。如果标识在归档区和活跃区重复使用，归档版保留在 `_archived/<slug>/` 下。

---

# 事项工作区

多客户执业的法务人员（私人执业——独立律师、小型律所、大型律所）处理多个事项。一个事项的上下文不得泄露到另一个事项。本技能是使这一点成真的薄文件管理层。

**默认状态为关闭。** 法务内部用户永远不会看到这个——他们仅在执业级别运行。事项工作区在冷启动时对私人执业用户启用，或通过编辑执业级别 CLAUDE.md 中的 `## 事项工作区` 启用。如果 `Enabled` 为 `✗`，本技能不运行；以上工作流程解释关闭状态，并建议实际需要事项隔离的用户运行 `/privacy-legal:cold-start-interview --redo`。

## 存储布局

所有事项数据存放于：

```
~/.claude/plugins/config/claude-for-legal-cn/privacy-legal/
├── CLAUDE.md                       # 执业级别执业画像
└── matters/
    ├── <slug>/
    │   ├── matter.md               # 客户、相对方、事项类型、关键事实、替代规则
    │   ├── history.md              # 日期记录：事件、决策、草稿、审查
    │   ├── notes.md              # 自由格式工作笔记
    │   └── 输出/                # 本事项的技能输出（可选子文件夹）
    └── _archived/
        └── <slug>/                 # 已关闭事项——可读但不活跃
```

标识为小写字母加连字符。示例：`acme-msa-2026`、`zenith-renewal`、`vendor-xyz-nda`。

## 活跃事项在执业 CLAUDE.md 中

执业级别 CLAUDE.md 中 `## 事项工作区` 下的 `Active matter:` 行是唯一真实来源。切换事项即编辑该行。无单独状态文件。

## 子命令逻辑

### `new <slug>`

1. 确认标识尚未出现在 `matters/<slug>/` 或 `matters/_archived/<slug>/` 中。如重复使用，请用户选择不同标识。
2. 运行立案访谈：
   - **客户**（我方代理的一方，或法务内部则为内部业务单位）
   - **相对方**（对方——可能是多个）
   - **事项类型**（读取插件的执业画像获取典型类别；privacy-legal 类别：PIPIA（个人信息处理活动）| 委托处理协议审查 | 权利请求 | 监管询问 | 个人信息出境机制审查 | 安全事件 | 其他）
   - **保密级别**（标准 | 高度 | 清洁团队——高度在跨事项场景中提示额外注意）
   - **关键事实**（2-5句话：本事项关于什么、利益相关方是谁、利害所在）
   - **对本执业手册的事项特定替代**（例如："责任上限：客户要求24个月而非内部标准12个月"、"语气：维护关系——相对方为战略合作伙伴"、"适用法律：须为中国法律"）
   - **关联事项**（任何关联事项的标识）
3. 按以下模板写入 `matters/<slug>/matter.md`。
4. 生成 `matters/<slug>/history.md`，含一条"已立案"条目。
5. 创建空文件 `matters/<slug>/notes.md`。
6. **不**自动切换到新事项。询问："要现在切换到 `<slug>` 吗？（`/privacy-legal:matter-workspace switch <slug>`）"

### `list`

枚举 `matters/*/matter.md`。读取每个文件的前几行以提取状态。打印表格：

| 标识 | 客户 | 事项类型 | 状态 | 立案日期 | 活跃？ |
|---|---|---|---|---|---|

用 `*` 标记当前活跃事项。如有归档事项，在单独的"已归档"标题下列出 `_archived/*`。

### `switch <slug>`

1. 确认 `matters/<slug>/matter.md` 存在。如不存在，建议 `/privacy-legal:matter-workspace new <slug>`。
2. 编辑执业级别 CLAUDE.md 中的 `Active matter:` 行为 `Active matter: <slug>`。
3. 向用户展示matter.md 摘要，确认事项正确。

### `close <slug>`

1. 确认 `matters/<slug>/` 存在。
2. 在 `matters/<slug>/history.md` 中追加一条"已关闭"条目，日期为当日。
3. 将 `matters/<slug>/` 移至 `matters/_archived/<slug>/`。
4. 如果已关闭事项为活跃事项，将 `Active matter:` 设置为 `none — practice-level context only`。

### `none`

将执业级别 CLAUDE.md 中的 `Active matter:` 设置为 `none — practice-level context only`。与用户确认。

## `matter.md` 模板

```markdown
[工作成果抬头——根据插件配置 ## 输出——因角色不同；见执业级别 CLAUDE.md 中的 `## 使用人身份`]

# 事项：[客户] —— [简述]

**标识：** [slug]
**立案日期：** [YYYY-MM-DD]
**状态：** 活跃
**保密级别：** [标准 / 高度 / 清洁团队]

---

## 各方

**客户：** [名称]
**相对方：** [名称]

## 事项类型

[PIPIA（个人信息处理活动）| 委托处理协议审查 | 权利请求 | 监管询问 | 个人信息出境机制审查 | 安全事件 | 其他 —— 附一行理由]

## 关键事实

[2-5句话。本事项关于什么。利益相关方是谁。利害所在。与默认执业手册的差异之处。]

## 事项特定替代规则

*与执业级别手册的任何偏离，仅适用于本事项。*

- [例如："责任上限：客户要求24个月而非内部标准12个月"]
- [例如："语气：维护关系——相对方为战略合作伙伴"]
- [例如："适用法律：须为中国法律"]

## 关联事项

- [标识 —— 一行说明关联原因]

## 保密注意事项

[如为高度或清洁团队，说明原因。谁可查看事项文件。即使全局开启，跨事项上下文是否允许。]
```

## `history.md` 生成

```markdown
# 历史记录：[客户] —— [简述]

仅追加的事件日志。最新在最前。

---

## [YYYY-MM-DD] —— 事项立案

立案访谈完成。标识：`[slug]`。状态：活跃。
[任何值得在事项档案之外保留的初始上下文——例如："因收到[相对方]发来的委托处理协议草案而立案。" ]
```

## 跨事项上下文

执业级别 CLAUDE.md 有一个 `Cross-matter context:` 标志。当其为 `off`（默认），在某事项 A 中工作的技能**绝不**读取任何其他 B 事项文件夹中的文件。期间。这是该设置存在的保密保障。

当其为 `on`，技能仅在用户明确要求时方可跨事项文件夹读取文件（例如："比较我们最近五个个人信息处理活动事项中关于责任上限的立场"）。即使 `on`，默认仍仅加载活跃事项，除非用户要求跨事项视图。

## 本技能不做什么

- **不执行利益冲突审查。** 利益冲突是执业者/律所的工作；立案访谈仅捕获用户声明的内容。
- **不执行留存期限。** 关闭是归档，不是删除。留存策略不在范围内。
- **不自动分发输出。** 实质性技能决定写入何处；本技能告诉它*哪个文件夹*是活跃的，不决定写入什么。
- **不决定跨事项是否合适。** 它读取标志并遵守。

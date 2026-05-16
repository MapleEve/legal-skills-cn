---
name: legal-skills-cn-maintenance
description: 维护本仓 Claude Code 插件市场、插件 manifest、skills、references、MCP、cookbook、版本、中国法/本地流程口径和提交前复核时使用的项目内 Codex skill。
---

# Legal Skills CN Maintenance

这是本仓维护用的项目内 Codex skill，只适用于本仓的维护、审计和提交前复核。不要将本文件复制到 Claude Code 插件包，也不要放入任一业务插件的 `skills/` 目录。

## 使用时机

在新增或修改以下内容前使用：

- 插件市场注册表、插件 manifest、版本号或公开安装说明
- 任一插件 `SKILL.md`、插件级 `CLAUDE.md`、插件内 `references/` 或共享 `references/`
- MCP 配置、连接器说明、cookbook、自动化工作流或脚本入口
- 中国法、本地法律检索、本地业务流程、涉外兼容说明或提交前复核规则

## 工作流

### 1. 先做关系定位

读取 `CONTEXT-MAP.md` 和 `CONTRIBUTING.md`，列出本次改动会影响的入口、插件、skill、reference、MCP、cookbook、README 或 manifest。不要只用关键词命中替代关系审计；关键词只能用来定位线索。

每个新增或移动的文件都要回答：谁读取它、何时读取、未配置时如何降级、是否需要 slash command、是否需要版本同步。

### 2. 判断正确落点

- 跨插件关系、读取链、命令链、MCP、cookbook、marketplace 规则：更新 `CONTEXT-MAP.md`。
- 贡献者提交前规则：必要时更新 `CONTRIBUTING.md`。
- 用户安装、使用、总览说明：必要时更新 `README.md` 或 `docs/AI_INSTALL.md`。
- 单个法律业务技能行为：更新对应 `<plugin>/skills/<skill>/SKILL.md`。
- 插件共享护栏和业务画像：更新对应 `<plugin>/CLAUDE.md`。
- 根级项目维护规则只放在本项目内 `.codex/skills/`；不要新增根级 `CLAUDE.md`，不要放入任一可安装业务插件的 `skills/`。

### 3. 保持中国本地法律口径

默认按中国法、中国律师审查、中国本地法律检索和本地业务流程表达。境外法律、境外监管、海外 SaaS、英美 privilege、州规则、国外考试术语只在明确涉外或兼容说明中出现。

不要把境外 SaaS 写成默认生产服务。本地自动化工作流应表述为用户自己的调度器、连接器或本地/内网工作流运行。

法律结论保持草稿属性：来源标注、管辖地假设、保密义务、去向检查和执业律师审查闸门不能被移除。

### 4. 处理 MCP 与连接器

`.mcp.json` 中的 `TBD`、`example.invalid`、空 server 或推荐 server name 在模板占位语境下不报错。真正问题是写成美国、境外或海外 SaaS 默认口径，或把占位符描述成已启用服务、权威列表、默认生产连接器、真实服务。

新增 MCP server 时，同步检查对应 `<plugin>/.mcp.json`、`<plugin>/CLAUDE.md`、相关 `SKILL.md` 的读取和降级逻辑，以及需要使用它的 cookbook manifest。用户可见文案应说明连接器需要用户账户、订阅、访问授权或本地配置；未配置时必须优雅降级。

### 5. 维护 reference 读取链

新增或修改 reference 后，必须同步到消费它的 `SKILL.md` 前置读取链。`references/` 下的文件不会自动加载；还要在 `CONTEXT-MAP.md` 登记 reference -> `SKILL.md` 强制读取链。

有 runtime 副本的 seed 必须写明读取顺序：先读 runtime；runtime 不存在时读打包 seed；不得把用户数据写回 seed。无 references 的插件要登记上下文来源，例如 `CLAUDE.md`、matter/session 状态、MCP 或命令链；不得硬造 reference。

### 6. 校准命令与 frontmatter

Slash command 必须使用 `/<plugin>:<skill>`，不要写成裸命令 `/<skill>`。`SKILL.md` frontmatter 的 `name` 必须等于技能目录名。

README 命令表、技能目录、frontmatter `name`、`user-invocable` 设置必须一致。机器字段、路径、slug、frontmatter key、JSON/YAML key、MCP server name、status enum 保持英文/ASCII；中文只用于用户可读说明。

### 7. 同步版本与 marketplace

插件内容变化要 bump 对应 `<plugin>/.claude-plugin/plugin.json` 的 patch version。新增 skill、新必填输入或明显能力扩展按项目版本规则判断是否需要 minor version。

如果项目要求 marketplace 展示 version，也同步 `.claude-plugin/marketplace.json` 的展示版本；但官方实际优先读取对应插件的 `plugin.json`。

版本变更后检查 README 当前版本、marketplace 展示、插件 manifest 和 changelog 是否需要同步。

### 8. 提交前复核

提交前完成以下检查，并确认结果可解释：

- `git status --short --branch`：确认只包含本次预期文件。
- `git rev-list --left-right --count HEAD...@{upstream}`：确认 ahead/behind 状态。
- 官方或项目要求的插件 validate。
- `python3 scripts/lint-tool-scope.py`：检查 cookbook 工具范围。
- `bash scripts/test-cookbooks.sh`：dry-run 全部 cookbook。
- `git diff --check`：检查空白和 diff 格式。
- Diff check：逐项确认没有误改业务插件 `skills/`、没有新增 `.claude/`、没有断链引用。
- 敏感信息检查：不得包含可识别个人、环境、会话、内部系统、客户材料、访问密钥、网络位置或完整转写的信息。

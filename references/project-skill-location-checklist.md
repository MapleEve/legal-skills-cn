# 项目级 skill / reference 落点检查清单

用于新增或修改 `skill`、`reference`、`marketplace`、MCP、cookbook、公开维护说明前的项目级自检。它是仓库维护清单，不是可安装业务 skill；不要放入任一 `<plugin>/skills/` 目录。

## 0. 脱敏闸门

- [ ] 只使用仓库相对路径，例如 `CONTEXT-MAP.md`、`references/...`、`<plugin>/skills/<skill>/SKILL.md`、`managed-agent-cookbooks/...`。
- [ ] 不写用户原话、情绪内容、个人路径、外部仓库名、commit hash、agent 名、具体会话时间、私有平台、凭据或内部验证日志。
- [ ] 示例只保留通用占位：`<plugin>`、`<skill>`、`<output.json>`、`<schema.json|schema.yaml>`。
- [ ] 公开文档不包含 token、API key、cookie、数据库连接、服务器地址、内网 URL、客户材料或完整转写。

## 1. 覆盖范围

- [ ] 先做全量覆盖：列出受影响的 `README.md`、`CONTEXT-MAP.md`、`CONTRIBUTING.md`、`.claude-plugin/marketplace.json`、`<plugin>/.claude-plugin/plugin.json`、`<plugin>/.mcp.json`、`<plugin>/CLAUDE.md`、`<plugin>/skills/**/SKILL.md`、`<plugin>/references/**`、`managed-agent-cookbooks/**`。
- [ ] 不以关键词扫描替代逐文件关系审计；关键词只用于定位线索，不能作为 PASS 结论。
- [ ] 每个新增或移动文件都能回答：谁读取、何时读取、未配置时如何降级、是否需要命令入口、是否需要版本同步。

## 2. 落点判断

- [ ] 跨插件关系、读取链、命令链、MCP、cookbook、marketplace 规则：更新 `CONTEXT-MAP.md`。
- [ ] 贡献者提交前规则：必要时更新 `CONTRIBUTING.md`。
- [ ] 用户安装、使用、总览说明：必要时更新 `README.md` 或 `docs/AI_INSTALL.md`。
- [ ] 单个法律业务技能行为：更新对应 `<plugin>/skills/<skill>/SKILL.md`。
- [ ] 插件共享护栏和业务画像：更新对应 `<plugin>/CLAUDE.md`。
- [ ] 不新增根级 `CLAUDE.md`；根级项目维护规则不放入任一可安装业务插件的 `skills/` 目录。

## 3. 中国法律实务口径

- [ ] 默认按中国法、中国律师审查、中国本地法律检索和本地业务流程表达。
- [ ] 境外法律、境外监管、海外 SaaS、英美 privilege、州规则、国外考试术语只在明确涉外或兼容说明中出现。
- [ ] 不把境外 SaaS 写成默认生产服务；本地自动化工作流应表述为用户自己的调度器、连接器或本地/内网工作流运行。
- [ ] 法律结论保持草稿属性：来源标注、管辖地假设、保密义务、去向检查和执业律师审查闸门不能被移除。

## 4. `.mcp.json` 与连接器

- [ ] 区分模板占位和真实默认服务：`TBD`、`example.invalid`、空 server 或推荐 server name 在模板语境下不是问题。
- [ ] 真正问题是把占位符写成已启用服务、权威列表、默认生产连接器或默认可用的境外 SaaS。
- [ ] 新增 MCP server 时，同步检查 `<plugin>/.mcp.json`、`<plugin>/CLAUDE.md`、相关 `SKILL.md` 的读取/降级逻辑，以及需要使用它的 cookbook manifest。
- [ ] 用户可见文案应说明连接器需要用户账户、订阅、API key 或本地配置；未配置时必须优雅降级。

## 5. `reference -> SKILL.md` 读取链

- [ ] 新增 reference 或 seed 后，必须写入消费它的 `SKILL.md` 前置读取步骤。
- [ ] `references/` 下的文件不会自动加载；必须在 `CONTEXT-MAP.md` 登记 reference -> `SKILL.md` 强制读取链。
- [ ] 有 runtime 副本的 seed 必须写明读取顺序：先读 runtime；runtime 不存在时读打包 seed；不得把用户数据写回 seed。
- [ ] 无 references 的插件要登记上下文来源，例如 `CLAUDE.md`、matter/session 状态、MCP、命令链；不得硬造 reference。

## 6. 命令与 frontmatter

- [ ] Slash command 必须使用 `/<plugin>:<skill>`；禁止写成裸命令 `/<skill>`。
- [ ] `SKILL.md` frontmatter 的 `name` 必须等于技能目录名。
- [ ] README 命令表、技能目录、frontmatter `name`、`user-invocable` 设置必须一致。
- [ ] 机器字段、路径、slug、frontmatter key、JSON/YAML key、MCP server name、status enum 保持英文/ASCII；中文只用于用户可读说明。

## 7. 版本与 marketplace

- [ ] 插件实际版本以 `<plugin>/.claude-plugin/plugin.json` 的 `version` 优先。
- [ ] `.claude-plugin/marketplace.json` 中的 marketplace 版本或展示版本为可选展示信息；若项目规范要求同步展示版本，必须与对应插件内容变更保持一致。
- [ ] 修改插件内容时，至少 bump 对应单体插件 patch version；新增 skill、新必填输入或明显能力扩展按项目版本规则判断是否需要 minor version。
- [ ] 版本变更后检查 README 当前版本、marketplace 展示、插件 manifest 和 changelog 是否需要同步。

## 8. 分阶段审计流程

- [ ] 阶段 A：只读审计。全量读取相关文件，列出断链、误导文案、版本不一致、命令不一致和脱敏风险。
- [ ] 阶段 B：判断与修复。只处理确认属于项目级、可提交、已脱敏的稳定规则。
- [ ] 阶段 C：复核。重新检查读取链、命令链、MCP 口径、版本、cookbook、README/CONTRIBUTING 指针和敏感信息。
- [ ] 阶段 D：提交前验证。所有命令通过后再提交；不要把一次性审计报告或临时路径提交到仓库。

## 9. 提交前验证

- [ ] `git status --short --branch`：确认只包含本次预期文件。
- [ ] `git rev-list --left-right --count HEAD...@{upstream}`：确认 ahead/behind 状态可解释。
- [ ] `python3 scripts/lint-tool-scope.py`：检查 cookbook 工具范围。
- [ ] `bash scripts/test-cookbooks.sh`：dry-run 全部 cookbook。
- [ ] 如有结构化 worker 输出样例：`python3 scripts/validate.py <output.json> <schema.json|schema.yaml>`。
- [ ] `git diff --check`：检查空白和 diff 格式。
- [ ] Markdown/path sanity：确认新增链接、相对路径、命令和文件名实际存在或为明确占位。
- [ ] 敏感信息扫描：覆盖 `AGENTS.md`、`CONTEXT-MAP.md`、`CONTRIBUTING.md`、`README.md`、`docs/`、`references/`、`.claude-plugin/`、各插件 manifest 与公开说明。

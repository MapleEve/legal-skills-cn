# CONTEXT-MAP

本文件是本仓库的**关系链条 / 上下文地图**，用于审查 12 个插件、150 个 skills、references、模板/seed、MCP、cookbook 和 slash command 之间的依赖。它不是使用教程，也不替代 `README.md` 或各插件 `README.md`。

维护 skill、reference、MCP、cookbook 或 slash command 时，先读本文件确认关系链，再改对应 `SKILL.md`、reference 或 manifest。

## 全局入口关系

| 入口 | 用途 | 下游关系 |
|---|---|---|
| `README.md` | 面向用户的总览、安装方式、插件分类、命令入口、连接器和本地自动化工作流说明。 | 列出 12 个插件、slash command 形态、本地自动化工作流和安全边界。 |
| 根级 Claude 指令入口 | 当前根目录未设置；已存在的 Claude 指令入口均在各插件目录。 | 插件级 `CLAUDE.md` 是各领域的实务画像、共享护栏、输出规范和冷启动目标。 |
| `CONTRIBUTING.md` | 贡献规则，强调 `SKILL.md` 应编码正确行为，`CLAUDE.md` 只作安全网。 | 编辑任何插件技能前先读对应插件 `CLAUDE.md`；实质变更后运行校验器。 |
| `.claude-plugin/marketplace.json` | marketplace 注册表，登记 12 个插件的 `name`、`source`、`version`、`description`。 | 每个 `source` 指向一个插件目录；插件目录再通过插件 manifest、MCP 配置和 skills 发布。 |
| `managed-agent-cookbooks/README.md` | 本地自动化工作流 cookbook 总入口。 | `reg-monitor`、`renewal-watcher`、`diligence-grid`、`launch-radar`、`docket-watcher` 分别引用对应插件能力。 |
| `scripts/deploy-managed-agent.sh` | 解析 cookbook manifest，展开 skills，创建本地自动化工作流请求体。 | 读取各 cookbook 的 manifest、子 worker yaml 和插件 skills。 |
| `scripts/orchestrate.py` | 本地工作流交接参考事件循环。 | 校验 `handoff_request`，只允许 allowlist 中的 cookbook 目标。 |
| `scripts/lint-tool-scope.py` | 校验 cookbook 编排器工具权限收窄。 | 禁止编排器携带 MCP、Write 或企业协作投递工具。 |
| `scripts/test-cookbooks.sh` | 对全部 cookbook dry-run 并检查请求体结构。 | 调用 `scripts/lint-tool-scope.py` 和 `scripts/deploy-managed-agent.sh`。 |
| `scripts/validate.py` | 校验 worker 输出 JSON/schema。 | 配合 cookbook 读取型 worker 的 `output_schema` 使用。 |

## 插件级关系矩阵

| 插件 | 入口文件 | MCP 配置 | skills 数 | 核心 references / seed | 强制读取链摘要 |
|---|---|---|---:|---|---|
| `ai-governance-legal` | `ai-governance-legal/.claude-plugin/plugin.json`；`ai-governance-legal/CLAUDE.md` | `ai-governance-legal/.mcp.json`：当前无具体 server，推荐 documents/chat。 | 10 | `ai-governance-legal/references/ai-governance-core.md`；`ai-governance-legal/references/currency-watch.md` | `aia-generation`、`policy-starter`、`reg-gap-analysis`、`use-case-triage`、`vendor-ai-review` 先读 AI core；`policy-monitor`、`reg-gap-analysis`、`use-case-triage` 读 currency-watch 并核验动态项。 |
| `commercial-legal` | `commercial-legal/.claude-plugin/plugin.json`；`commercial-legal/CLAUDE.md` | `commercial-legal/.mcp.json`：CLM、e-signature、document-management、outside-counsel-network、contract-structure-analyzer、wecom、enterprise-drive。 | 12 | `commercial-legal/references/contract-law-core.md`；`commercial-legal/references/currency-watch.md`；`commercial-legal/skills/renewal-tracker/references/renewal-register.yaml` | 合同审查类 `nda-review`、`review`、`review-proposals`、`saas-msa-review`、`vendor-agreement-review` 读 contract core；含近期规则/期限判断的 `review`、`saas-msa-review`、`vendor-agreement-review` 读 currency-watch；`renewal-tracker` 读 renewal register seed。 |
| `corporate-legal` | `corporate-legal/.claude-plugin/plugin.json`；`corporate-legal/CLAUDE.md` | `corporate-legal/.mcp.json`：collaboration-platform、enterprise-drive、diligence-data-room、legal-document-management、business-registry-search、securities-disclosure、outside-counsel-network、contract-structure-analyzer。 | 13 | `corporate-legal/references/company-law-2024-core.md`；`corporate-legal/references/currency-watch.md`；`corporate-legal/skills/tabular-review/references/ma-diligence-columns.md`；`corporate-legal/skills/tabular-review/references/excel-output.md`；`corporate-legal/skills/tabular-review/references/gsheets-output.md` | 公司治理、尽调和主体合规类读 company-law core；`closing-checklist`、`diligence-issue-extraction`、`entity-compliance` 同时读 currency-watch；`tabular-review` 读三份表格输出/列定义 reference。 |
| `employment-legal` | `employment-legal/.claude-plugin/plugin.json`；`employment-legal/CLAUDE.md` | `employment-legal/.mcp.json`：feishu、wecom、pkulaw、chinacourt。 | 20 | `employment-legal/references/labor-core-rules.md`；`employment-legal/references/currency-watch.md`；`references/company-profile-template.md` | `hiring-review`、`handbook-updates`、`termination-review`、`wage-hour-qa`、`worker-classification` 读 labor core；`international-expansion`、`policy-drafting`、`termination-review`、`wage-hour-qa` 读 currency-watch；冷启动读 company profile 模板。 |
| `ip-legal` | `ip-legal/.claude-plugin/plugin.json`；`ip-legal/CLAUDE.md` | `ip-legal/.mcp.json`：当前无具体 server，建议接入中国知识产权和法律检索数据源。 | 12 | `ip-legal/references/ip-core-rules.md`；`ip-legal/references/currency-watch.md` | `clearance`、`fto-triage`、`infringement-triage`、`ip-clause-review`、`oss-review`、`takedown` 读 ip core；`clearance`、`infringement-triage`、`oss-review`、`portfolio` 读 currency-watch。 |
| `law-student` | `law-student/.claude-plugin/plugin.json`；`law-student/CLAUDE.md` | `law-student/.mcp.json`：feishu_wecom、enterprise_drive、pkulaw、wenshu。 | 13 | 无本地 references；不维护额外法条 seed。 | 上下文链主要来自 `law-student/CLAUDE.md`、matter/session 状态、技能间命令链和检索 MCP；不硬造 reference -> `SKILL.md` 强制读取链。 |
| `legal-builder-hub` | `legal-builder-hub/.claude-plugin/plugin.json`；`legal-builder-hub/CLAUDE.md` | `legal-builder-hub/.mcp.json`：TBD server，占位为中国法律技能社区连接器。 | 10 | `legal-builder-hub/references/allowlist-default.yaml`；`legal-builder-hub/references/currency-watch.md`；`legal-builder-hub/skills/skill-installer/references/allowlist.md`；`legal-builder-hub/skills/skill-installer/references/freshness.md`；`legal-builder-hub/skills/registry-browser/references/registries.yaml` | `skill-installer` 先读 allowlist/freshness，再读运行时 allowlist，缺省时读 allowlist-default seed；`skill-manager` 和冷启动也读 allowlist seed/rules；`auto-updater`、`skills-qa` 读 currency-watch。 |
| `legal-clinic` | `legal-clinic/.claude-plugin/plugin.json`；`legal-clinic/CLAUDE.md` | `legal-clinic/.mcp.json`：feishu_wecom、enterprise_drive、pkulaw、wenshu、legal_aid_case_system。 | 16 | `legal-clinic/references/plausibility-bands/mainland-cn.md`；`legal-clinic/skills/client-intake/references/intake-templates/README.md`；`legal-clinic/skills/supervisor-review-queue/references/review-queue.yaml` | `client-intake` 先读 intake templates；`deadlines` 在新增或复核期限时读 mainland-cn plausibility bands；`supervisor-review-queue` 先读 review queue seed 或运行时队列副本。 |
| `litigation-legal` | `litigation-legal/.claude-plugin/plugin.json`；`litigation-legal/CLAUDE.md` | `litigation-legal/.mcp.json`：enterprise_collab、enterprise_drive、evidence_platform、lawyer_collaboration_network、iphouse、wenshu、pkulaw、faxin、wolterskluwer_cn。 | 19 | `litigation-legal/references/civil-procedure-core.md`；`litigation-legal/references/evidence-rules-core.md`；`litigation-legal/references/enforcement-core.md`；`litigation-legal/skills/claim-chart/references/element-templates.md` | 接案/程序/协查类读 civil procedure；证据、要件和文书段落类读 evidence rules；执行/状态/结案类读 enforcement；`claim-chart` 还读 element templates；`portfolio-status` 可读 dashboard template。 |
| `privacy-legal` | `privacy-legal/.claude-plugin/plugin.json`；`privacy-legal/CLAUDE.md` | `privacy-legal/.mcp.json`：当前无具体 server，建议接入企业协作、文档或内部法规库。 | 9 | `privacy-legal/references/pipl-core-provisions.md`；`privacy-legal/references/currency-watch.md`；`references/company-profile-template.md` | `use-case-triage`、`dsar-response`、`pia-generation`、`reg-gap-analysis` 读 PIPL core；`dpa-review`、`dsar-response`、`pia-generation`、`policy-monitor`、`reg-gap-analysis` 读 currency-watch；冷启动读 company profile 模板。 |
| `product-legal` | `product-legal/.claude-plugin/plugin.json`；`product-legal/CLAUDE.md` | `product-legal/.mcp.json`：当前无具体 server，推荐 project-management、issue-tracking、documents、chat。 | 7 | `product-legal/references/currency-watch.md`；`product-legal/skills/launch-review/references/seven-category-framework.md` | `launch-review` 先读 seven-category framework，再按团队自定义框架覆盖；`feature-risk-assessment`、`is-this-a-problem`、`launch-review`、`marketing-claims-review` 读 currency-watch。 |
| `regulatory-legal` | `regulatory-legal/.claude-plugin/plugin.json`；`regulatory-legal/CLAUDE.md` | `regulatory-legal/.mcp.json`：当前无具体 server，建议接入法律法规数据库、国务院政策文件库和部委官网源。 | 9 | `regulatory-legal/references/admin-law-core.md`；`regulatory-legal/skills/reg-feed-watcher/references/source-catalog.md`；`regulatory-legal/skills/gap-surfacer/references/gap-tracker.yaml`；`regulatory-legal/skills/gap-surfacer/references/comment-tracker.yaml` | `comments`、`gaps`、`policy-diff`、`policy-redraft`、`reg-feed-watcher` 读 admin law core；`reg-feed-watcher` 读 source catalog；`gap-surfacer` 读 gap-tracker seed；`comments` 在无运行时追踪器时读 comment-tracker seed。 |

## 法条 / 法规动态资料链

- 领域 core reference 是静态规则索引，进入具体技能的“先读取”链后，技能才能做法条结构化分析。现有链条包括：
  - `ai-governance-legal/references/ai-governance-core.md` → AI 安全评估、政策起草、法规差距、用例分诊、供应商 AI 审查。
  - `commercial-legal/references/contract-law-core.md` → NDA、通用合同审查、修订建议、SaaS MSA、供应商协议审查。
  - `corporate-legal/references/company-law-2024-core.md` → 董事会/股东会文件、交割清单、尽调问题、主体合规、书面决议。
  - `employment-legal/references/labor-core-rules.md` → 招聘、解除、工时工资、员工手册、用工关系分类。
  - `ip-legal/references/ip-core-rules.md` → 商标、专利、开源、权利归属、通知删除和侵权分诊。
  - `litigation-legal/references/civil-procedure-core.md`、`litigation-legal/references/evidence-rules-core.md`、`litigation-legal/references/enforcement-core.md` → 程序、证据、执行和案件组合状态。
  - `privacy-legal/references/pipl-core-provisions.md` → PIPIA、DSAR、个人信息处理活动分诊和隐私法规差距。
  - `regulatory-legal/references/admin-law-core.md` → 行政监管、政策差异、征求意见、合规差距和监管动态。
- `currency-watch.md` 是动态法规追踪清单，不是最终法源。任何技能依赖生效日期、备案/认证状态、阈值、监管动态、执法态势或近期规则时，应先读对应插件的 currency-watch，再联网或通过法律检索 MCP 核验。
- PIPL 链条以 `privacy-legal/references/pipl-core-provisions.md` 为静态规则，以 `privacy-legal/references/currency-watch.md` 为动态核验；进入 `use-case-triage`、`pia-generation`、`dsar-response`、`reg-gap-analysis`。
- Mainland China 法律援助期限链条以 `legal-clinic/references/plausibility-bands/mainland-cn.md` 为“明显异常提示区间”，只用于期限 sanity check，不替代一手法源。
- Dashboard 输出链条以 `references/dashboard-template.md` 为跨插件 HTML/dashboard 输出模板，进入 `commercial-legal:stakeholder-summary`、`corporate-legal:deal-team-summary`、`employment-legal:investigation-summary`、`litigation-legal:portfolio-status`。
- 共享公司画像链条以 `references/company-profile-template.md` 为模板，进入 `employment-legal:cold-start-interview` 和 `privacy-legal:cold-start-interview`，写入共享 company profile 后供其他插件跳过重复公司问题。
- Allowlist 链条以 `legal-builder-hub/references/allowlist-default.yaml` 为默认 seed，以 `legal-builder-hub/skills/skill-installer/references/allowlist.md` 和 `legal-builder-hub/skills/skill-installer/references/freshness.md` 解释字段、来源、发布者、连接器、许可证和时效门禁。
- Review queue 链条以 `legal-clinic/skills/supervisor-review-queue/references/review-queue.yaml` 初始化等待指导教师审查的队列；运行时副本存在时以运行时副本为准。
- Renewal register 链条以 `commercial-legal/skills/renewal-tracker/references/renewal-register.yaml` 初始化续约字段；不得把用户运行时合同台账写回 seed。
- Regulatory register 链条以 `regulatory-legal/skills/gap-surfacer/references/gap-tracker.yaml` 和 `regulatory-legal/skills/gap-surfacer/references/comment-tracker.yaml` 初始化差距与征求意见跟踪器；字段名、状态值、机器字段不得中文化。
- Source catalog 链条以 `regulatory-legal/skills/reg-feed-watcher/references/source-catalog.md` 提供一手/二手监管源目录；二手源只能作为线索，必须回溯一手源。

## 命令链

- Slash command 规范为 `/<plugin>:<skill>`，例如 `/commercial-legal:review`、`/privacy-legal:pia-generation`、`/regulatory-legal:reg-feed-watcher`。
- 禁止裸命令 `/<skill>`。同名 skill 在多个插件中存在，例如 `cold-start-interview`、`customize`、`matter-workspace`；裸命令会丢失插件上下文。
- `SKILL.md` frontmatter 的 `name` 必须等于技能目录名，例如 `commercial-legal/skills/review/SKILL.md` 的 `name` 必须是 `review`。
- README 中列出的命令应只引用已存在的技能目录；若一个命令路由到内部 skill 或未直接调用 skill，必须在 README 或对应 `SKILL.md` 中说明。
- 机器名、slug、frontmatter 字段、YAML/JSON 字段、MCP server name、slash command 保持英文/ASCII；中文只用于用户可读说明。

## Cookbook / 自动化工作流链

| Cookbook | 对应插件 | 关键文件 | 关系链 |
|---|---|---|---|
| `managed-agent-cookbooks/reg-monitor` | `regulatory-legal` | `managed-agent-cookbooks/reg-monitor/README.md`；`managed-agent-cookbooks/reg-monitor/agent.yaml` | 调用监管动态扫描、重要性过滤和摘要写入；与 `regulatory-legal/skills/reg-feed-watcher/SKILL.md`、`regulatory-legal/skills/policy-diff/SKILL.md` 同源。 |
| `managed-agent-cookbooks/renewal-watcher` | `commercial-legal` | `managed-agent-cookbooks/renewal-watcher/README.md`；`managed-agent-cookbooks/renewal-watcher/agent.yaml` | 扫描合同续约/解除期限；读取商业合同审查手册配置和续约 register 结构。 |
| `managed-agent-cookbooks/diligence-grid` | `corporate-legal` | `managed-agent-cookbooks/diligence-grid/README.md`；`managed-agent-cookbooks/diligence-grid/agent.yaml` | 批量读取数据室文档，输出尽调网格；使用 `corporate-legal/skills/tabular-review/SKILL.md` 及其列定义/输出 reference。 |
| `managed-agent-cookbooks/launch-radar` | `product-legal` | `managed-agent-cookbooks/launch-radar/README.md`；`managed-agent-cookbooks/launch-radar/agent.yaml` | 扫描上线追踪系统，按产品法务风险校准分类，并通过 handoff 触发完整上线审查。 |
| `managed-agent-cookbooks/docket-watcher` | `litigation-legal` | `managed-agent-cookbooks/docket-watcher/README.md`；`managed-agent-cookbooks/docket-watcher/agent.yaml` | 监控法院案件流程和候选期限；输出案件流程状态与 deadlines 数据。 |

Cookbook 的共同规则：读取层接触不可信输入但无 Write；分析层只处理结构化 JSON；写入层是唯一 Write 持有者；编排器只路由，不自行解析原始材料。

## 新增 / 修改引用时的维护规则

- 新增 reference 后，必须同步到最相关 `SKILL.md` 的前置读取步骤；只把文件放进 `references/` 不会让 skill 自动加载。
- 全局验收规则：有 references/seed 的插件必须登记 reference -> `SKILL.md` 强制读取链；无 references 的插件必须登记其上下文来源和状态/命令链，不得硬造 reference。
- 新增 skill 后，必须登记其读取链：插件级 `CLAUDE.md`、插件级 reference、技能级 reference、runtime seed、MCP 依赖、matter/session 状态、技能间命令链、是否可 slash command 调用；不存在的 reference/seed 必须明确标为无，不得编造。
- 新增 command 时，必须使用 `/<plugin>:<skill>`；同时确认目录、frontmatter `name`、README 命令表一致。
- 新增 seed YAML 时，必须在消费它的 `SKILL.md` 中写明：先读 runtime；runtime 不存在时读打包 seed；不得把用户数据写回 seed；字段名和状态值保持机器可读。
- 新增 MCP server 时，同步更新对应插件 `.mcp.json`、插件 `CLAUDE.md` 的“可用集成”、相关 skill 的读取/降级逻辑，以及 cookbook 如需使用的 manifest。
- 中国本地法律口径优先：法条、法规、监管机构、裁判/案例、公开征求意见、律师审查闸门均按中国大陆法律实务表达；涉外内容只能作为补充，不得替代中国法分析。
- 本仓输出是供执业律师审查的草稿。新增或修改 skill 时，保留来源标注、法律检索核验、管辖地假设、去向检查、保密义务和人工审查闸门。
- 本地自动化工作流口径必须保持：`managed-agent-cookbooks/` 是 cookbook 模板，不是云端托管服务；它们由用户自己的调度器和连接器运行。
- 不要把机器字段中文化：frontmatter key、JSON/YAML key、MCP server name、command slug、skill directory、status enum、register id 都保持英文/ASCII。

# 法律本地自动化工作流 cookbooks

`managed-agent-cookbooks/` 作为机器目录名保留，以兼容已有脚本和路径。目录内容是**本地定时任务 / 本地自动化工作流** cookbook 模板，不是云端代理服务。它们预期运行在你自己的调度器或工作流引擎之后，并连接你自己的系统连接器。

本仓的每个自动化能力提供**两种交付形态**：一是可直接安装的 Claude Code 插件（见仓库根目录下各业务线目录），二是供平台团队适配自有工作流引擎的本地自动化工作流 cookbook。**同一组技能，默认按本地运行和中国语境配置；按使用界面选择即可。** 下方每个目录都是一个本地运行 manifest，引用对应插件的技能，并附带默认本地连接器口径的系统文本。

这些是 **cookbook，不是成品系统**。它们只是起点。需要按你的文档管理系统、合同库、企业协作空间、通知路由和复核节奏进行适配。未适配前不应直接投入使用；这也是设计预期。

运行 `../scripts/deploy-managed-agent.sh <slug>` 可解析本地工作流模板，在运行时需要时上传技能，创建叶子 worker，并为你自己的编排层准备 `POST /v1/agents` 配置。每个模板都附带 [`steering-examples.json`](./reg-monitor/steering-examples.json) 和单独 README，说明安全分层与交接方式。

| 工作流 | 业务线插件 | 关注对象 | 触发事件 | 叶子 worker |
|---|---|---|---|---|
| [`reg-monitor`](./reg-monitor/) | regulatory-legal | 国家法律法规数据库、国务院政策文件库、北大法宝/威科先行 | `按 <date> 检查法规源，重要性阈值：<threshold>` | feed-reader · materiality-filter · **digest-writer** |
| [`renewal-watcher`](./renewal-watcher/) | commercial-legal | 合同管理系统续约与解约期限 | `扫描 <X>–<Y> 天内续约，标记偏离 playbook 的事项` | repo-reader · deadline-calculator · **alert-writer** |
| [`diligence-grid`](./diligence-grid/) | corporate-legal | 企业网盘、数据室系统、文档管理系统 | `按 schema <schema-id> 审查文件夹 <path>` | doc-reader · extractor · normalizer · **grid-writer** |
| [`launch-radar`](./launch-radar/) | product-legal | 飞书多维表格、TAPD、禅道或自部署事项系统上线跟踪 | `扫描未来 <N> 周上线跟踪表` | tracker-reader · risk-classifier · **memo-writer** |
| [`docket-watcher`](./docket-watcher/) | litigation-legal | 中国裁判文书网、北大法宝 | `关注 <court> 的案件 <case-id>，事项 <matter-id>` | docket-reader · deadline-mapper · **tracker-writer** |

**加粗**的叶子 worker = 唯一拥有 `Write` 的 worker。

## Manifest 与 API 的对应

`agent.yaml` 文件使用真实 `POST /v1/agents` 字段名，同时包含少量由部署脚本解析的便利写法：

| Manifest 写法 | 解析为 |
|---|---|
| `system: {file: ../../<plugin>/agents/<agent>.md, append: "..."}` | `system: "<inlined contents + append>"` |
| `system: {text: "..."}` | `system: "<text>"` |
| `skills: [{from_plugin: ../../<plugin>}]` | 上传该目录下每个 `skills/*` → `[{type: custom, skill_id: ...}, ...]` |
| `skills: [{path: ../../...}]` | `skills: [{type: custom, skill_id: <uploaded-id>}]` |
| `callable_agents: [{manifest: ./subagents/x.yaml}]` | `callable_agents: [{type: agent, id: <created-id>, version: latest}]` |

> **研究预览能力：** `callable_agents`（多 agent 委派）目前支持**一层委派**。编排器可以调用 worker；worker 不能继续调用下级 subagent。

## 跨工作流交接

具名工作流之间不直接互调。当一个工作流需要另一个工作流接手时（例如 `launch-radar` 发现某次上线需要完整审查备忘录），它会在输出中发出 `handoff_request`；[`../scripts/orchestrate.py`](../scripts/orchestrate.py)（或你自己的事件总线）会把它作为新的触发事件路由到目标会话。参考脚本对目标做硬编码 allowlist，并对 payload 做 schema 校验。

## 安全模型

法律文件和诉讼材料都是**不可信输入**。每个 cookbook 都采用三层 worker 拆分：

1. **读取层** 接触不可信文档，仅具备 `Read`/`Grep`，没有 MCP、没有 Write、没有网络访问。它们返回限制长度的结构化 JSON。文档中夹带的任何指令都只能视为数据，不是命令。
2. **分析层** 接收读取层的结构化 JSON，按用户配置的规则分析，并可使用 MCP 只读访问做核验。没有 Write。
3. **写入层** 生成最终输出，是唯一具备 `Write` 的层级。它们不接触原始文档。

编排器没有 Write，也不读取原始文档。它只做路由，不直接处理材料。

## 工作成果与保密义务

本代理产出的内容为律师工作成果，受中国《律师法》第38条保密义务及委托合同保密条款保护。

## 交付内容与边界

- **你会得到：** 可运行的 manifest 结构、带有合理安全分层的参考架构、已在 Claude Code 插件中验证过的技能，以及触发事件示例。
- **你不会得到：** 开箱即用的生产系统。你需要把 MCP 连接器接到*你自己的*系统，设置运行节奏，配置通知路由，按你的业务调校提示词，并在信任输出前完成自己的评测。
- **尤其不会得到：** 律师替代品。这些工作流可以监控、提取和起草；律师负责复核、核验和决策。

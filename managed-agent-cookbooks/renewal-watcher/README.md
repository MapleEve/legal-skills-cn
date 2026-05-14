# 续约监控器（Renewal Watcher）—— 托管代理模板

## 概述

扫描合同库中即将到来的续约和解约截止日，与团队审查手册交叉比对，标记有即将到期、审查手册偏离和逐级上报触发条件的合同，并撰写预警报告。与 [`renewal-watcher`](../../commercial-legal/agents/renewal-watcher.md) Claude Code 代理及 [`renewal-tracker`](../../commercial-legal/skills/renewal-tracker) 技能同一来源——本目录为 `POST /v1/agents` 的托管代理模板。

本模板为**模板而非成品**。它默认使用合同管理系统作为记录合同生命周期的主系统，因为配套插件如此假设；使用其他合同管理系统、iManage 或存储已签署 PDF 的企业网盘的团队，应相应更换 MCP 端点。

## 部署前注意事项

- **从合同元数据中提取的解约截止日和续约条款可能不准确。** 合同管理系统元数据可能与已签署文件存在偏差——补充协议签署后未被重新录入、生效日期可能与签署日期不同、自动续约机制有时被错误标注。在依据计算出的期限做出解约或续约决定前，执业律师须根据已签署协议及任何补充协议进行核实。
- **逐级上报路由遵循配置矩阵；但不替代逐级上报的判断。** 被标记的审查手册偏离在特定情境下可能仍可接受；未被标记的条款可能仍需关注。矩阵是路由器，而非审查者。
- **安静的周期不等于干净的周期。** 一份未被检出的合同可能不在合同管理系统中、被错误标注、或已过通知窗口但元数据未反映。全部清零的页脚意味着代理已运行，而非无事可做。

## 部署

```bash
export ANTHROPIC_API_KEY=sk-ant-...
export IRONCLAD_MCP_URL=...
export GDRIVE_MCP_URL=...
# 可选——如果已签署协议存储于此，请在清单中启用
export IMANAGE_MCP_URL=...
export DOCUSIGN_MCP_URL=...
../../scripts/deploy-managed-agent.sh renewal-watcher
```

## 引导事件

参见 [`steering-examples.json`](./steering-examples.json)。默认周一早间巡检使用第一个示例。另外两个覆盖临时按合同相对方范围的扫描和签署后偏离检查。

## 安全与交接

合同文本、相对方消息和合同管理系统评论均为**不可信输入**。三级隔离：

| 层级 | 是否接触不可信文档？ | 工具 | 连接器 |
|---|---|---|---|
| **`repo-reader`** | **是** | 仅 `Read`、`Grep` | ironclad、gdrive（只读）；imanage 默认关闭 |
| `deadline-calculator` / 编排器 | 否 | `Read`、`Grep`、`Glob`、`Agent` | 无 |
| **`alert-writer`**（Write 持有者） | 否 | `Read`、`Write`、`Edit` | 无 |

`repo-reader` 返回长度受限、符合 Schema 验证的 JSON。`deadline-calculator` 对该 JSON 加磁盘上的审查手册配置做纯计算——无 MCP、无网络。`alert-writer` 产出 `./out/renewal-alerts-<YYYY-MM-DD>.md` 并发出 `handoff_request` 用于 Slack 投递。

**交接：** 编排器将 `alert-writer` 的 `handoff_request` 路由到 Slack 发送工作节点，通道从部署团队的内部风格配置中读取。代理绝不自行发送 Slack 消息。

**相关代理：** 当需要签署后偏离检查时，`handoff_request` 也可路由到 [`deal-debrief`](../../commercial-legal/agents/deal-debrief.md)；当续约时点的偏离累积形成模式时，可路由到 [`playbook-monitor`](../../commercial-legal/agents/playbook-monitor.md)。具名代理绝不直接互相调用——路由是编排器的工作。

**不予保证：** 本代理建议一项行动；由律师决定是否解约、重新协商或任由续约生效。

## 适配说明

在信任工作流输出之前：

- **指向你的合同管理系统。** `IRONCLAD_MCP_URL` 为默认值。如果已签署协议存储在 iManage，请在 `agent.yaml` 和 `subagents/repo-reader.yaml` 中将 `imanage` 切换为 `default_config: { enabled: true }` 并设置 `IMANAGE_MCP_URL`。如果存储在企业网盘文件夹中，依赖 `gdrive` 和 repo-reader 的备用搜索路径。如果存储在无公开 MCP 的合同管理系统中，请接入自定义连接器并更新 MCP 服务器区块。
- **设置 Slack 通道。** alert-writer 发出命名 Slack 通道的 `handoff_request`。编排器从你的审查手册配置的**内部风格 -> 续约预警**字段读取通道。在首次定时运行前设置好，否则交接将进入死信队列。
- **调整前瞻窗口。** deadline-calculator 的默认层级为 已逾期/30/60/90/180 天。如果你的续约周期较短（一年以下的 SaaS 订单）或较长（需 12 个月通知窗口的多年期企业主服务协议），请在 deadline-calculator 提示词和 `alert-writer.yaml` 的对应章节中调整层级阈值。
- **调整逐级上报矩阵。** deadline-calculator 读取审查手册中的逐级上报矩阵，以决定是否设置 `escalation_needed: true` 及路由对象。在启用定时运行前，确认矩阵反映了当前审批权限（谁有权批准放任自动续约到期、谁有权批准超过金额阈值的重新协商）。[`escalation-flagger`](../../commercial-legal/skills/escalation-flagger) 技能已在 `alert-writer` 中加载，用于格式化。
- **确认工作产出标头。** `agent.yaml` 中的 headless append 指示代理添加审查手册的工作产出标头。在启用前与法务总监确认标头措辞。
- **运行周期。** 默认为每周。高流量团队应每日运行；小型团队可按月运行。周期由你自己的工作流引擎控制——本模板不自行调度。

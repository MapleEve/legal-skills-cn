# 商业合同插件

企业内部商业合同工作流：合同审查、保密协议审查、框架协议审查、合同变更追踪、续约管理、审批升级路由、干系人摘要。围绕团队实践画像构建，该画像通过冷启动访谈生成——插件学习的是**你的**审查手册，而非通用模板。

**所有输出均为供律师审查的草稿——含引用、标注和门槛控制——不构成法律结论。**插件完成工作：阅读文档、应用审查手册、发现问题、起草备忘录。律师负责审查、核实和决策。引用标注来源以便区分研究工具产出与需人工核验部分。特权标记保守适用，避免意外弃权。后续操作——提交、发送、签署——均需明确确认后方可执行。

## 法律依据

本插件审查标准基于以下法律法规及司法解释：

- 《中华人民共和国民法典》合同编
- 《中华人民共和国反不正当竞争法》
- 最高人民法院关于适用《中华人民共和国民法典》合同编通则若干问题的解释
- 最高人民法院关于审理买卖合同纠纷案件适用法律问题的解释
- 其他相关司法解释及审判指导意见

## 适用角色

| 角色 | 主要工作流 |
|---|---|
| **法务** | 合同审查、升级审批路由、干系人摘要 |
| **合同管理员/法务助理** | 保密协议分流、续约追踪、首轮审查 |
| **采购** | 续约预警、以干系人身份接收摘要 |
| **销售/商务** | 联系法务前自助进行保密协议分流 |

## 首次运行：冷启动访谈

首次使用时，插件会进行约十分钟的对话式访谈，了解团队的运作方式。包括审查手册立场、升级规则，以及最让你头疼的事项。随后会请你提供 5-10 份近期已签署合同（越多越好，20 份可形成更清晰的模式），以便了解实际审查立场。

学习结果写入 `~/.claude/plugins/config/claude-for-legal/commercial-legal/CLAUDE.md`——一份关于团队实践的通俗英文文档，所有其他技能在执行前读取。你编辑的是文档，而非配置文件。

```
/commercial-legal:cold-start-interview
```

**审查手册侧别。**在设置早期，你将选择构建**销售侧**手册（你销售产品或服务；你是卖方；通常用己方模板）、**采购侧**手册（你采购；你是买方；通常用对方模板），或二者兼备。选择将翻转几乎每条审查立场——责任上限、赔偿方向、解除权、知识产权归属——因此需先予明确。若选择二者，设置先构建销售侧；之后运行 `/commercial-legal:cold-start-interview --side purchasing` 构建采购侧。配置文件并行存放两套手册，审查技能在执行前检查适用侧别后读取对应手册。

## 命令

| 命令 | 功能 |
|---|---|
| `/commercial-legal:cold-start-interview` | 运行（或重新运行）冷启动访谈 |
| `/commercial-legal:review [文件]` | 依据审查手册审查合同（买卖合同/服务合同/保密协议/框架协议） |
| `/commercial-legal:renewal-tracker` | 未来 90 天内续约事项及解除期限预警 |
| `/commercial-legal:escalation-flagger` | 将问题路由至适当审批人并起草请示 |
| `/commercial-legal:amendment-history [文件]` | 追踪合同自基础协议起经各次补充协议的变化轨迹 |
| `/commercial-legal:review-proposals` | 逐条审查监控代理提出的审查手册更新建议 |
| `/commercial-legal:matter-workspace` | 管理事项工作区（仅多客户私人执业）——新建、列出、切换、关闭、无 |

## 技能

| 技能 | 用途 |
|---|---|
| **cold-start-interview** | 首次运行访谈，写入 `~/.claude/plugins/config/claude-for-legal/commercial-legal/CLAUDE.md` |
| **vendor-agreement-review** | 完整的手册对照合同偏差分析，含修订建议 |
| **nda-review** | 快速绿/黄/红分流，法务仅审阅需要关注的保密协议 |
| **saas-msa-review** | SaaS 订阅专项审查：自动续约、价格调整、数据迁出、SLA |
| **renewal-tracker** | 解除期限登记册，预警即将到期事项 |
| **escalation-flagger** | 按升级矩阵匹配问题，起草审批请示 |
| **stakeholder-summary** | 将法律审查结论转化为业务干系人可读的两段式摘要 |
| **amendment-history** | 汇总基础协议与各补充协议的变更内容，或追踪特定条款至当前有效版本 |
| **matter-workspace** | 创建、列出、切换和关闭多客户事项工作区；隔离各客户/事项，防止上下文泄露 |

## 交互命令 vs. 定时代理

上述命令由用户手动触发——用于处理当前事项。以下代理按计划运行——用于监控动态变化：

| 代理 | 监控内容 | 默认频率 |
|---|---|---|
| **renewal-watcher** | 续约登记册——发布未来 90 天即将到期事项，对 0-13 天内解除期限窗口发出红色预警 | 每周（周一） |
| **deal-debrief** | 近期已签署合同中偏离手册的条款；提示律师在记忆清晰时记录背景 | 每周（周一） |
| **playbook-monitor** | 偏差日志——当某条款在滚动 12 个月内被覆盖 5 次及以上时，提议更新审查手册 | 数据触发（每次 deal-debrief 后） |

## 集成

**请先连接法律研究工具——引用护栏依赖此工具。**未连接时，每条引用标记为 `[待核实]`，每份输出上方的审查说明记录来源未经验证。技能可在无研究工具时运行；研究工具（北大法宝/威科先行/法信）仅为你分担核实工作。

本插件在 `.mcp.json` 中配置以下连接器：

- **合同生命周期管理（CLM）**——合同全生命周期管理
- **电子签章**——签署状态及签署流程追踪
- **企业微信**——搜索消息、读取群聊、查找讨论（通用通道）
- **企业网盘**——搜索、读取和获取文档（通用通道）

连接 CLM 后：审查时检查与同一交易对手方的在先协议，批量加载续约登记册，创建附审查备忘录的记录。

连接电子签章后：追踪签署状态，按审批人顺序流转签署流程。

## 快速开始

### 1. 进行访谈

```
/commercial-legal:cold-start-interview
```

约十分钟。准备 5-10 份近期已签署合同供分享（越多越好，20 份可形成更清晰的模式）。

配置文件存储在 `~/.claude/plugins/config/claude-for-legal/commercial-legal/CLAUDE.md`，插件更新后仍然有效。

### 2. 审查合同

```
/commercial-legal:review 供应商主协议.pdf
```

输出：逐条对照审查手册的偏差备忘录，含具体修订措辞及指定审批人。

### 3. 查看续约情况

```
/commercial-legal:renewal-tracker
```

输出：未来 90 天内所有含解除期限的事项，按紧急程度分组。

## 学习机制

位于 `~/.claude/plugins/config/claude-for-legal/commercial-legal/CLAUDE.md` 的团队实践画像并非一成不变——随着插件使用而持续完善。技能会在输出来源于应调整的默认值时提示。`playbook-monitor` 代理在实践偏离手册时提议更新。可重新运行设置、直接编辑文件，或告诉技能记录新的审查立场。

## 文件结构

```
commercial-legal/
├── .claude-plugin/plugin.json
├── .mcp.json
├── CLAUDE.md                    # 团队实践画像——冷启动写入，人工编辑维护
├── README.md
├── agents/
│   ├── renewal-watcher.md
│   ├── deal-debrief.md
│   └── playbook-monitor.md
├── skills/
│   ├── cold-start-interview/
│   ├── review/
│   ├── review-proposals/
│   ├── vendor-agreement-review/
│   ├── nda-review/
│   ├── saas-msa-review/
│   ├── renewal-tracker/
│   │   └── references/renewal-register.yaml
│   ├── escalation-flagger/
│   ├── amendment-history/
│   ├── matter-workspace/
│   └── stakeholder-summary/
└── hooks/hooks.json
```

## 注意事项

- 插件默认在多数审查中将你视为**采购方**。当你是卖方时请标注，审查将翻转手册立场。
- 保密协议分流专为非律师自助使用设计。绿色表示"直接签署"，不进行谈判。
- 续约追踪仅涵盖通过本插件审查或从 CLM 批量加载的合同。安装本插件前签署的合同需进行一次性扫描导入。

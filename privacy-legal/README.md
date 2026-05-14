# 数据合规插件

面向中国企业的数据合规工作流：个人信息保护影响评估(PIPIA)、个人信息主体权利请求处理、委托处理协议审查、个人信息出境合规评估、监管差距分析及相关数据处理活动的合规分类与处置。基于《个人信息保护法》(PIPL)、《数据安全法》(DSL)、《网络安全法》(CSL) 三大法律体系构建，融合《网络数据安全管理条例》《App 违法违规收集使用个人信息行为认定方法》等配套规章。

**所有产出均为供执业律师审查的工作草案——含引用标注、风险评估、待决事项标记——不是最终法律结论。** 插件负责执行工作：读取文档、应用你的合规策略、发现问题、起草分析报告。律师负责审查、核实和决策。引用标注按来源标注，让审查者清楚哪些来自法规检索、哪些来自模型知识。保密标识谨慎使用，确保律师—客户特权不被不当放弃。产生法律后果的操作——提交、发出、签署——须经明确确认。

## 适用角色

| 角色 | 主要工作流 |
|---|---|
| **数据合规负责人 / DPO** | 委托处理协议审查、PIPIA 签署、监管差距分析 |
| **隐私项目经理** | 个人信息主体权利请求处理、PIPIA 管理、供应商隐私审查 |
| **产品法务** | 新产品/功能的 PIPIA 生成 |
| **客服 / 用户支持** | 权利请求一线响应（含升级机制） |

## 首次运行：冷启动访谈

插件通过引导式访谈了解你的合规实践：你是个人信息处理者还是受托处理者，实际适用哪些法规，你在委托处理协议中的底线条款是什么。然后它读取三份种子文件——你的隐私政策、你的委托处理协议模板、一份你认可的 PIPIA 报告——学习你的真实立场和工作风格。

你的合规配置存储在 `~/.claude/plugins/config/claude-for-legal/privacy-legal/CLAUDE.md`，不受插件更新影响。

```
/privacy-legal:cold-start-interview
```

## 命令

| 命令 | 功能 |
|---|---|
| `/privacy-legal:cold-start-interview` | 冷启动访谈 |
| `/privacy-legal:use-case-triage [活动描述]` | 是否需 PIPIA？快速分类 + 条件判断 |
| `/privacy-legal:dpa-review [文件]` | 按你的谈判手册审查委托处理协议（自动识别方向） |
| `/privacy-legal:dsar-response` | 引导式个人信息主体权利请求处理并起草回复 |
| `/privacy-legal:pia-generation [功能描述]` | 按你的工作风格生成 PIPIA |
| `/privacy-legal:reg-gap-analysis [法规]` | 新法规 vs 当前政策/实践的差距分析 |
| `/privacy-legal:policy-monitor` | 定期扫描政策与实际操作的偏差；或对特定新实践做即时查询 |
| `/privacy-legal:matter-workspace` | 管理事项工作区（多客户律所场景）——新建、列出、切换、关闭、取消 |

## Skills

| Skill | 用途 |
|---|---|
| **cold-start-interview** | 通过访谈 + 种子文件生成 CLAUDE.md 配置 |
| **use-case-triage** | 判断是否需要 PIPIA / 能否继续 / 存在政策冲突？+ 后续衔接 |
| **dpa-review** | 双向（处理者/受托处理者视角）委托处理协议逐条审查 |
| **dsar-response** | 身份核验 → 系统排查 → 豁免情形 → 起草回复 |
| **pia-generation** | 按内部格式生成 PIPIA，含政策一致性检查 |
| **reg-gap-analysis** | 新法规 vs 现状差距分析，给出整改方案 |
| **policy-monitor** | 扫描产出物发现实践偏差；起草政策语言更新 |
| **matter-workspace** | 多客户律所场景的事项工作区管理，隔离各客户/事项上下文 |

## 快速开始

### 1. 配置

```
/privacy-legal:cold-start-interview
```

请准备好：你公开的隐私政策 URL、你的委托处理协议标准模板、一份参考 PIPIA 报告。

### 2. 分类新功能或数据处理活动

```
/privacy-legal:use-case-triage "市场部计划使用用户行为数据进行广告个性化推荐"
```

产出：继续 / 需PIPIA / 必须PIPIA / 停止 —— 附条件表格、合法性基础问题，并提供在同一对话中启动 PIPIA 的选项。

### 3. 审查合作方委托处理协议

```
/privacy-legal:dpa-review 合作方协议.pdf
```

产出：自动识别方向、逐条对比谈判手册、建议修改稿、政策一致性检查。

### 4. 处理个人信息主体权利请求

```
/privacy-legal:dsar-response
```

引导式流程：分类 → 核验 → 定位 → 豁免 → 起草。使用你配置中的系统清单。

### 5. 对新功能做 PIPIA

```
/privacy-legal:pia-generation "位置共享功能"
```

引导式问答 → 按你内部格式生成 PIPIA → 政策差异 → 条件清单。

## 插件如何学习

你的合规实践配置 `~/.claude/plugins/config/claude-for-legal/privacy-legal/CLAUDE.md` 是动态的——随着使用不断优化。各 skill 会告知你某次产出使用了默认配置、建议调整。`policy-monitor` 持续监测政策与实际执行的偏差并提出更新建议。你可以重新运行配置、直接编辑文件，或告知 skill 记录新的立场。

## 文件结构

```
privacy-legal/
├── .claude-plugin/plugin.json
├── .mcp.json
├── CLAUDE.md
├── README.md
├── references/
│   └── currency-watch.md
├── skills/
│   ├── cold-start-interview/
│   ├── use-case-triage/
│   ├── dpa-review/
│   ├── dsar-response/
│   ├── pia-generation/
│   ├── reg-gap-analysis/
│   ├── policy-monitor/
│   ├── matter-workspace/
│   └── customize/
└── hooks/hooks.json
```

## 备注

- **委托处理协议审查是双向的**：同一 skill 既可审查合作方协议（保障运营灵活性），也可审查供应商协议（保护数据安全）。方向自动识别，也可手动指定。
- **PIPIA 格式源自你的种子 PIPIA**。若配置时未提供，则使用通用结构——重新运行配置并提交参考 PIPIA 即可修正。
- **reg-gap-analysis** 处理外部法规变化。**policy-monitor** 处理内部实践漂移。不同工具，不同变化方向。
- **policy-monitor** 需要配置输出文件夹（配置时设置）才能执行扫描。直接查询模式不需要。
- **个人信息出境**：涉及的合规路径（安全评估、标准合同备案、保护认证）请参考 `references/currency-watch.md` 追踪最新要求。

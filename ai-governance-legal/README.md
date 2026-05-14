# 人工智能治理插件

企业AI治理法务工作流：AI用例分诊、人工智能安全评估、供应商AI条款审查、法规与政策差距分析。基于中国法框架，以团队实务配置为核心——从AI政策、参考安全评估和关键供应商AI协议中学习而定。

**所有输出均为供法务审核的草稿——附引用标注、风险标记和门槛控制——不构成正式法律意见。** 本插件负责执行工作：阅读文件、套用你的审查清单、发现问题、草拟备忘录。由法务人员进行审核、核实并做出决定。引用来源均标注出处标签，便于区分哪些来自研究工具、哪些需要核验。

## 适用角色

| 角色 | 主要工作流 |
|---|---|
| **AI治理法务/数据合规法务** | 安全评估、供应商AI审查、法规差距分析 |
| **产品法务** | AI用例分诊、含AI组件的上线审查 |
| **法务总监/法务运营** | AI政策治理、升级事项、汇报层级问题 |
| **采购/法务** | 供应商AI合同审查 |

## 首次使用：冷启动访谈

本插件通过访谈了解：你是AI服务提供者、使用者还是兼而有之——哪些法规实际适用——你的AI用例红线是什么——以及合格的安全评估在你这里的标准格式是什么。然后读取你的参考文件，学习你的实际立场和文书风格。

```
/ai-governance-legal:cold-start-interview
```

## 命令

| 命令 | 功能 |
|---|---|
| `/ai-governance-legal:cold-start-interview` | 冷启动访谈——写入你的实务配置 |
| `/ai-governance-legal:use-case-triage [用例]` | 对照用例登记表对新用例进行分类（批准/有条件/禁止） |
| `/ai-governance-legal:aia-generation [用例]` | 按你的文书格式进行人工智能安全评估 |
| `/ai-governance-legal:vendor-ai-review [供应商/文件]` | 对照你的立场审查供应商AI协议 |
| `/ai-governance-legal:reg-gap-analysis [法规]` | 将新法规或指导文件与当前政策/实践做差异分析 |
| `/ai-governance-legal:policy-monitor` | 每周巡检AI政策与实际操作的偏离，或直接查询提议的新做法 |
| `/ai-governance-legal:policy-starter` | 参考已发布的标准政策起草AI使用政策初稿 |
| `/ai-governance-legal:matter-workspace` | 管理项目工作区（仅限多客户律所场景） |

## 技能

| 技能 | 用途 |
|---|---|
| **cold-start-interview** | 通过访谈+参考文件写入实务配置 |
| **use-case-triage** | 对照登记表分类用例；标记缺失的评估 |
| **aia-generation** | 按标准格式输出人工智能安全评估 |
| **vendor-ai-review** | 对照治理立场审查AI供应商合同 |
| **reg-gap-analysis** | 新法规/指导文件 vs. 现状，产出整改方案 |
| **policy-monitor** | 巡检产出文件中的实践偏离；起草AI政策语言更新 |
| **policy-starter** | 参考已发布的政策标准生成AI使用政策初稿 |
| **matter-workspace** | 创建、列出、切换、关闭项目工作区 |

## 快速上手

### 1. 设置

```
/ai-governance-legal:cold-start-interview
```

请准备好（如有）：AI或可接受使用政策、先前的安全评估报告、关键供应商AI协议、模型清单或已批准工具列表。

你的配置存储在 `~/.claude/plugins/config/claude-for-legal/ai-governance-legal/CLAUDE.md`，插件更新时配置不会丢失。

### 2. 对新用例进行分诊

```
/ai-governance-legal:use-case-triage "销售团队希望用AI自动对潜在客户评分"
```

输出：风险层级、登记表匹配或缺口、必要条件、是否需要安全评估。

### 3. 进行安全评估

```
/ai-governance-legal:aia-generation "AI驱动的简历筛选，用于HR招聘"
```

提问→按标准格式输出安全评估→政策一致性检查→缓解条件。

### 4. 审查供应商AI协议

```
/ai-governance-legal:vendor-ai-review 供应商协议.pdf
```

输出：逐条款对照你的立场、建议修订、需升级的差距。

## 插件三角：AI治理 ↔ 产品合规 ↔ 数据隐私

这三个插件设计为协同工作。AI治理是第三条腿。

- **产品合规** 检测到上线需求包含AI组件 → 传递至 `/ai-governance-legal:use-case-triage` 和 `/ai-governance-legal:aia-generation`
- **数据隐私** 检测到AI用例涉及个人信息 → 传递至 `/privacy-legal:pia-generation`（如插件已安装）
- **AI治理** 检测到安全评估提出数据保护问题 → 传递至 `/privacy-legal:pia-generation`（如插件已安装）

传递是显式的：每个插件在被需要时标记并说明需要回答什么问题。

## 如何学习

你的实务配置 `~/.claude/plugins/config/claude-for-legal/ai-governance-legal/CLAUDE.md` 不是静态的——它会随着你使用插件而改进。当某项输出使用了你应该调整的默认值时，技能会提示你。`policy-monitor` 代理监控AI治理政策与实际操作之间的偏离并提出更新建议。你可以重新运行设置、直接编辑文件，或告诉技能记录新的立场。

## 注意事项

- 差距检查（`reg-gap-analysis`）处理新发布的法规。政策巡检（`policy-monitor`）处理内部实践的偏离。两者方向不同。
- 政策巡检需要配置输出文件夹（设置时设定），直接查询模式则无需。
- 用例分诊的好坏取决于登记表的质量。在设置访谈中把红线定对——它们驱动一切。
- 安全评估格式来源于你的参考评估。如果设置时未提供，则使用基线结构——重新运行设置并提供参考文件以改进。
- AI服务提供者和使用者的义务分开处理。如果你身兼两者，技能会就每项任务询问以哪个身份执行。
- 差距分析为手动触发（你指向某法规或指导文件）。如需自动监控，可搭配 `regulatory-legal` 插件使用（如插件已安装）。

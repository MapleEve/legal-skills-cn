# 法律技能市场插件

中国法律社区技能发现与安装。浏览中文法律技能社区注册库，安装和自动更新技能，在你的其他法律插件中浮现相关社区技能。cold-start 面谈本身就是入门技能包推荐引擎 —— 询问你的业务类型，推荐可安装的技能。

**每项社区技能在安装前都以原始内容展示，经过提示注入模式扫描，并对照法律技能设计框架进行评估。本插件帮助你发现和评估；你来决定信任什么。**

## 面向谁

所有使用法律插件的用户。这就是法律技能应用商店。

## 首次运行：cold-start

询问你的业务类型、行业、团队规模、工具熟练度。推荐匹配的社区技能入门包。安装你选择的技能。

```
/legal-builder-hub:cold-start-interview
```

你的配置存放在 `~/.claude/plugins/config/claude-for-legal-cn/legal-builder-hub/CLAUDE.md`，不受插件升级影响。

## 安全姿态

已安装的社区技能在你的环境中运行，可以访问你的客户数据、案件文件和团队操作手册。本 hub 将每一次安装和每一次更新都视为一次信任决策。四层防御，每一层单独都不足够：

- **白名单（管理员控制）：** `~/.claude/plugins/config/claude-for-legal-cn/legal-builder-hub/allowlist.yaml` 声明了社区技能可以使用哪些注册库、发布者和 MCP 连接器。`restrictive`（严格）模式（推荐用于律所/企业部署）拒绝白名单之外的任何来源；`permissive`（宽松）模式对未列出的来源发出警告。白名单在安装器读取任何第三方内容之前先被检查。模式说明详见 `skills/skill-installer/references/allowlist.md`。
- **原始源码，而非摘要：** 安装器向你展示完整的原始 `SKILL.md` —— 不是 AI 摘要 —— 然后才写入任何文件。摘要是便利；想做坏事的技能必须在原始文本中做，而原始文本展示会让它暴露。
- **启发式扫描：** 安装器和 `skills-qa` 都会扫描技能中的提示注入模式（覆盖/权威声明、越权读写、外部 URL、隐藏 Unicode、Shell 执行、凭证请求）。这些是 AI 启发式扫描，明确标注为此类 —— 一次干净的扫描不是安全审计，而是提示你亲自阅读文本。
- **每次都需要人工批准：** 没有用户新输入的 `yes`，任何文件都不会被写入磁盘。批准不从之前的消息中推断。作为纵深防御，安装器建议在读-only 子智能体中运行获取/分析阶段，这样 Write 能力仅在批准后才可用。

更新采用相同的安全姿态：自动更新器锁定到 commit SHA（而非可变标签），显示完整差异（包括 hooks 和 MCP 变更），并每次更新都需要明确的批准。不存在自动应用模式。

如果已安装技能出现问题：`/legal-builder-hub:disable [skill-name]` 使其静默而不删除文件；`/legal-builder-hub:uninstall [skill-name]` 将其完全删除。两者都仅限于通过本 hub 安装的社区技能 —— 它们拒绝触碰第一方插件技能。

## 前置条件

- 来自 registry-sync 智能体的 Slack 通知需要你的环境中配置了 Slack MCP 服务器。没有的话，智能体将摘要写入文件。
- `~/.claude/plugins/config/claude-for-legal-cn/legal-builder-hub/CLAUDE.md` 中的默认注册库列表初始为社区推荐项。通过 `/legal-builder-hub:registry-browser` 添加你信任的注册库，或直接编辑配置文件。

## 命令

| 命令 | 功能 |
|---|---|
| `/legal-builder-hub:cold-start-interview` | 业务档案 + 入门技能包推荐 |
| `/legal-builder-hub:registry-browser [query]` | 在已关注的注册库中搜索技能 |
| `/legal-builder-hub:skill-installer [skill]` | 安装社区技能 |
| `/legal-builder-hub:auto-updater` | 检查已安装技能的更新 |
| `/legal-builder-hub:related-skills-surfacer` | 根据你近期的操作推荐相关技能 |
| `/legal-builder-hub:skills-qa [skill]` | 在安装前对照法律技能设计框架评估一项技能 |
| `/legal-builder-hub:disable [skill]` | 禁用已安装的社区技能但不删除文件 |
| `/legal-builder-hub:uninstall [skill]` | 卸载通过本 hub 安装的社区技能 |

## 技能

| 技能 | 用途 |
|---|---|
| **cold-start-interview** | 业务档案 → 入门技能包 |
| **registry-browser** | 跨已关注注册库搜索 |
| **skill-installer** | 白名单关、获取、展示原始 SKILL.md、信任检查、QA、安装社区技能 |
| **uninstall** | 卸载通过本 hub 安装的社区技能（第一方插件技能不可触碰） |
| **disable** | 禁用社区技能而不删除其文件；可后续重新启用 |
| **skill-manager** | 参考：`uninstall` 和 `disable` 技能使用的详细卸载/禁用/重新启用工作流 |
| **skills-qa** | 对照法律技能设计框架评估技能 —— 设计、失败模式、信任面、提示注入启发式扫描 |
| **auto-updater** | 检查更新；显示差异和信任审查；仅在明确批准时应用 |
| **related-skills-surfacer** | 任务完成后浮现相关社区技能（直接调用或通过 hook） |

## 交互命令 vs. 定时智能体

以上命令在你调用时运行 —— 适用于你在处理案件时。以下智能体按计划运行 —— 适用于你没盯着时发生的变化：

| 智能体 | 关注什么 | 默认频率 |
|---|---|---|
| **registry-sync** | 已关注注册库中的新技能和更新技能；按更新偏好发布通知 | 每周 |

## 已关注注册库（默认）

默认白名单预配置了社区注册库。编辑仓库中的 `references/allowlist-default.yaml`，或编辑你的个人配置文件 `~/.claude/plugins/config/claude-for-legal-cn/legal-builder-hub/allowlist.yaml`，来添加、删除或在严格/宽松模式之间切换。

- **TBD** —— 待定中文法律技能社区 —— URL 待定
- 通过 `/legal-builder-hub:registry-browser` 添加你自己的注册库

## 它如何学习

你在 `~/.claude/plugins/config/claude-for-legal-cn/legal-builder-hub/CLAUDE.md` 中的业务档案不是静态的 —— 它随着你使用插件而改进。本 hub 在每次 `/legal-builder-hub:registry-browser` 和 `/legal-builder-hub:related-skills-surfacer` 时重新读取它，因此调整你的业务类型、行业或已关注注册库会使未来的推荐更精准。直接编辑文件，或在工作变化时重新运行 `/legal-builder-hub:cold-start-interview --redo`。

## 注意事项

- 社区技能在安装前被完整读取。你看到的是**原始** SKILL.md —— 不是摘要 —— 然后才决定是否接受。
- 自动更新默认关闭。如果你信任来源，可以针对单个技能开启。
- related-skills-surfacer 在其他插件内运行：当你在做某件事时，它检查社区是否有相关内容。
- 企业/律所部署：在 `allowlist.yaml` 中设置 `mode: restrictive` 并填充 `registries`、`publishers` 和 `connectors` 列表。在严格模式下，安装器拒绝从任何未列出来源获取、分析或安装任何内容。

# 尽调网格（Diligence Grid）—— 托管代理模板

## 概述

对虚拟数据室进行批量文档审查。两种模式：

- **监控** —— 监控虚拟数据室中自截止时间以来的新增上传，将每份文档对照部署团队的尽调需求清单分类，标记高优先级类别（重大合同、诉讼、知识产权）的上传。
- **网格** —— 对文件夹中的文档按列 Schema 执行表格审查。每份文档一行，每个数据点一列，每个单元格均引用逐字来源原文。并购尽调的主力工具。

与 [`corporate-legal`](../../corporate-legal) 插件同一来源——本目录为 `POST /v1/agents` 的托管代理模板。网格模式即 `tabular-review` 技能，在提取工作节点集群上以无人工界面模式运行。

## 部署前注意事项

- **每个单元格是线索，而非事实认定。** 一份尽调网格在律师阅读底层文档之前，不是陈述与保证、不是披露清单、也不是尽调备忘录。每个单元格中的逐字引用是为了让审查者能快速核实——应充分使用。
- **重大性过滤器和列分类应用启发式判断，而非法律判断。** Schema 判定为非重大的合同可能是扼杀交易的那份。即使提取器误读了条款，标记为"已应答"的单元格仍可能是错误的。审查者时间按 `unclear` + `needs_review` + `answered` 成比例分配——不仅是已标记的那些。
- **监控模式分类的是元数据和预览，而非完整文档。** 分类器标记为"低优先级"的新增上传仍可能是改变交易的补充协议。将监控报告视为队列，而非过滤器。
- **相对方上传的文档对整个工具链同样为不可信输入。** grid-writer 的 CSV 公式注入防御是强制性的，而非可选的——参见下方安全章节。

## 部署

```bash
export ANTHROPIC_API_KEY=sk-ant-...
export BOX_MCP_URL=...
export GDRIVE_MCP_URL=...
export IMANAGE_MCP_URL=...          # 可选；如使用，将工具集默认设为 enabled
export DEFINELY_MCP_URL=...         # 可选；用于 normalizer 步骤的条款结构质检
../../scripts/deploy-managed-agent.sh diligence-grid
```

## 引导事件

参见 [`steering-examples.json`](./steering-examples.json)。

## 安全与交接

虚拟数据室文档——合同、董事会纪要、补充协议、相对方上传文件——均为**不可信输入**。相对方上传的合同可能包含旨在操纵审查者或下游工具链的字符串。四级隔离将 Write 持有者和 MCP 持有者与文档分开：

| 层级 | 是否接触不可信文档？ | 工具 | 连接器 |
|---|---|---|---|
| **`doc-reader`** | **是**（只读） | `Read`、`Grep` | Box、企业网盘、iManage（只读） |
| **`extractor`** | **是**（只读） | `Read`、`Grep` | 无 |
| `normalizer` / 编排器 | 否 | `Read`、`Grep`、`Glob`、`Agent` | 无（definely 可选，只读） |
| **`grid-writer`**（Write 持有者） | 否 | `Read`、`Write` | 无 |

`doc-reader` 和 `extractor` 返回长度受限、符合 Schema 验证的 JSON。编排器和 `normalizer` 仅接触结构化数据。`grid-writer` 产出 `./out/diligence-grid-<date>.csv`、`./out/diligence-grid-<date>_sources.csv` 和 `./out/diligence-grid-<date>-summary.md`。

**CSV 公式注入。** `grid-writer` 写入的每个单元格——值、逐字引用、位置、文档名称、列标签——均对其首字符检查 `=`、`+`、`-`、`@`、制表符和回车符。匹配的单元格在写入 CSV 前添加单引号前缀。相对方上传的合同通常包含 Excel 和 Sheets 会作为公式执行的字符串（`=HYPERLINK(...)` 数据窃取、旧版 Excel 的 `=cmd|...` DDE），在交易团队打开文件的那一刻即可触发。来源 CSV 是更大的暴露面——逐字引用是攻击者控制的攻击面。

**Xlsx 是部署层面的问题。** 本模板仅交付 CSV。部署团队根据 [`corporate-legal/skills/tabular-review/references/excel-output.md`](../../corporate-legal/skills/tabular-review/references/excel-output.md) 中的工作簿结构将其转换为 `.xlsx`——隐藏 `_source` 列、悬停显示引用的单元格批注、基于状态的填充色、每列 `Verified` 下拉菜单、`_schema` 和 `_summary` 工作表。该转换在部署团队的 Excel 环境（Claude in Excel、openpyxl 或通过 Sheets API 的 Google Sheets）中完成。从无人工界面代理交付 xlsx 需要可信运行时和宏环境，本模板有意不做此假设。

**不予保证：** 本代理产出的每个单元格都是**需要核实的线索**，而非事实认定。审查者阅读来源、检查引用、标记 `Verified` 列。由律师决定哪些进入陈述与保证、披露清单或备忘录。

## 适配说明

- **虚拟数据室 URL。** 设置 `BOX_MCP_URL` / `GDRIVE_MCP_URL` / `IMANAGE_MCP_URL` 以匹配你的数据室。默认启用 Box 和企业网盘；如果以 iManage 或 Datasite 为主，请在 [`agent.yaml`](./agent.yaml) 中切换 `default_config`。如果虚拟数据室使用国内数据室服务(TBD)，在 `mcp_servers` 和 `tools` 中添加条目及匹配的 MCP URL。
- **列 Schema。** [`corporate-legal/skills/tabular-review/references/ma-diligence-columns.md`](../../corporate-legal/skills/tabular-review/references/ma-diligence-columns.md) 中的并购尽调标准为默认。根据交易类型自定义——科技/知识产权、医疗、房地产、政府承包商、受监管金融——使用该参考资料中的扩展项。
- **输出目标。** 输出落地在 `./out/`。通过部署管道接入交易文件夹、企业网盘、iManage 工作区或 Box 文件夹。不要给 `grid-writer` 授予上传的 MCP 权限；交接给上传步骤更干净，且保持 Write 层级隔离。
- **默认模式。** 监控 vs 网格按引导事件选择。如果工作流几乎总是其中一种，在编排器中相应设定引导事件模板。
- **需求清单分类。** 监控模式根据部署团队 corporate-legal `CLAUDE.md` 配置中的分类进行文档分类。在为实时交易接入监控模式前，在那里重新运行 `/corporate-legal:cold-start-interview`。
- **工作产出标头。** `grid-writer` 从部署团队的 `## Outputs` 配置添加标头。在部署前与法律团队确认标头——因审查者角色（律师 vs 非律师）而异。
- **Slack 路由。** 本代理绝不直接发布。报告是文件；`handoff_request` 告诉编排器路由到哪个通道。在部署团队的 `CLAUDE.md` 内部风格部分配置交易通道。

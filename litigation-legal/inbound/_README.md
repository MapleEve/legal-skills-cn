# inbound/ — 中国争议解决来函和外部文书

本文件夹保存外部来函和外部文书的分流、分析与回应工作，包括：律师函、催告函、解除通知、侵权警告函、应诉通知书、传票、举证通知书、证据保全申请、调查令、协助执行通知书、行政调查或监管问询。

它与 `demand-letters/`（对外函件）和 `matters/`（案件台账）分开，是因为来函/外部文书有自己的工作流：阅读 → 分流 → 决策 → 回应（或升级为案件）。不是每个来件都会成为台账案件。

## 目录结构

```
inbound/
├── _README.md
└── [slug]/
    ├── incoming.pdf              # 或 .eml / .docx，原件或链接/指针
    ├── triage.md                 # 分析：范围、期限、证据义务、保密、可选回应
    └── response-v1.docx          # 如需回应，保存回应草稿（迭代时使用 v2、v3）
```

## Slug 约定

格式为 `[type]-[sender-short]-[yyyy-mm]`。示例：

- `demand-rec-acme-2026-04` (收到律师函/催告函)
- `summons-zhang-v-company-2026-04` (传票 or 应诉通知书)
- `evidence-notice-court-2026-04` (举证通知书)
- `investigation-order-court-2026-04` (调查令)
- `assist-enforcement-court-2026-04` (协助执行通知书)
- `admin-investigation-agency-2026-04` (行政调查或监管问询)
- `preservation-vendor-2026-04` (收到证据保全申请)

## 工作流

| 类型 | 命令 | 输出 |
|---|---|---|
| 律师函 / 催告函 / 侵权警告函 | `/litigation-legal:demand-received [path]` | triage.md + 可选回应草稿 |
| 传票 / 应诉通知书 / 举证通知书 / 调查令 / 协助执行通知书 | `/litigation-legal:subpoena-triage [path]` | triage.md + 异议/回函要点 |
| 行政调查 / 监管问询 | *未来技能* | |

每次分流分析都会交叉检查 `matters/_log.yaml` 中是否存在相关案件（同一相对方、事项重叠）。如果存在相关案件，流程会标记并询问是否将本来件加入 related_matter 记录。如果本来件本身应升级为台账案件，流程会带着预填字段交接给 `/matter-intake`。

## 与案件台账的关系

- 来件 + 关联既有案件 → 通过 `_log.yaml` 中的 `related_matters` 字段关联；文件仍保留在 `inbound/`。
- 来件 + 应升级为案件 → 创建案件；matter.md 反向链接到 `inbound/[slug]/`。
- 来件 + 已处理并关闭（无需建案）→ 作为记录保留在 `inbound/`。

## 与对外函件的关系

如果来件回应本身需要形成对外函件（例如反向催告、澄清、异议、和解方案或保密回应），分流分析流程会带着预填信息交接给 `/demand-intake`。对外函件保存在 `demand-letters/`，并反向链接回本来件文件夹。

# matters/ — 中国争议解决案件台账

本文件夹保存争议解决案件组合：民事诉讼、商事仲裁、劳动仲裁、知识产权争议、商业秘密争议、公司纠纷、执行案件、证据保全、行政调查和重大诉前函件。分为两层：

- **`_log.yaml`** — 台账。每个案件一行。可由技能解析，是汇总视图的事实来源。
- **`[slug]/`** — 单案详情。保存叙述和历史，供人工阅读和编辑。

## 目录结构

```
matters/
├── _log.yaml                  # 台账（包括已关闭案件）
├── _README.md                 # 本文件
└── [matter-slug]/
    ├── matter.md              # 叙述式接案记录、案件理论和当前姿态
    └── history.md             # 仅追加的事件日志
```

## Slug 约定

使用小写、连字符，并在末尾放年份。示例：
- `acme-v-us-2026`
- `admin-investigation-agency-2026`
- `labor-zhang-2026`
- `ip-infringement-competitor-2026`
- `assist-enforcement-court-2026`

年份让 slug 在之后出现类似案件时仍保持稳定。文件夹名必须与 slug 完全一致。

## 谁写什么

| 文件 | 写入者 | 是否可直接编辑 |
|---|---|---|
| `_log.yaml` | `/litigation-legal:matter-intake`、`/litigation-legal:matter-update`、`/litigation-legal:matter-close` | 可以，但应在案件的 `history.md` 中反映变化 |
| `matter.md` | `/litigation-legal:matter-intake` 在接案时写入；`/litigation-legal:matter-close` 追加 | 可以，用于更新案件理论 / 姿态说明 |
| `history.md` | `/litigation-legal:matter-intake` 初始化；`/litigation-legal:matter-update` 和 `/litigation-legal:matter-close` 追加 | 实务上仅追加；把既有条目视为记录 |

## 已关闭案件

保留在这里，不要删除。`/litigation-legal:portfolio-status` 默认会从活跃案件汇总中排除它们；`/litigation-legal:portfolio-status --all` 会纳入。已关闭案件是组合判断的训练样本。

## 中国争议解决常见文书类型

常见触发案件建档的文书包括：律师函、催告函、解除通知、侵权警告函、证据保全申请、应诉通知书、传票、举证通知书、调查令、协助执行通知书、行政调查通知或监管问询。接案记录应写明期限、回应机关、证据保全义务、保密限制、商业秘密审查、个人信息审查，以及和解或调解沟通是否存在证据使用限制。

## 更正

如果过去的历史记录有误，不要直接修改。应新增一条记录，引用并更正原条目。更正过程的记录与更正内容同样重要。

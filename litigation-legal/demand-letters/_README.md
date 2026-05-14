# demand-letters/ — 中国争议解决函件工作区

本文件夹保存中国争议解决场景下对外函件的起草记录和支持材料，包括：律师函、催告函、解除通知、侵权警告函、证据保全申请、财产保全前沟通函、劳动争议沟通函、行政调查回应前沟通函。

它与 `matters/` 分开，是因为：

- 不是每封函件都需要升级为台账案件。小额催收、常规违约催告、普通停止侵权函可以只留在这里，不进入案件台账。
- 每封对外函件的工作流形态相同（接收信息 → 起草 → 发送 → 检查清单），无论之后是否升级为案件。
- 函件升级为案件时，对应案件的 `matter.md` 会反向链接到这里；起草历史仍随函件保存。

## 目录结构

```
demand-letters/
├── _README.md                     # 本文件
└── [slug]/
    ├── intake.md                  # 背景收集、策略、谈判筹码、保密与证据使用限制
    ├── draft-v1.docx              # 函件正文（迭代时使用 v2、v3）
    └── checklist.md               # 发送后检查清单：送达、抄送、日历期限、跟进
```

## Slug 约定

格式为 `[type]-[counterparty]-[yyyy-mm]`。示例：

- `payment-acme-2026-04`
- `infringement-warning-competitor-x-2026-04`
- `breach-supplier-2026-04`
- `termination-notice-vendor-2026-04`
- `evidence-preservation-vendor-2026-04`

## 工作流

1. `/litigation-legal:demand-intake [title]` → 运行自适应接待流程，写入 `intake.md`
2. `/litigation-legal:demand-draft [slug]` → 按中国法语境处理和解沟通、调解保密、证据使用限制、商业秘密和个人信息审查，起草 `.docx`，写入 `checklist.md`，并询问是否创建案件

## 与案件台账的关系

函件起草后，`demand-draft` 会按内部 `~/.claude/plugins/config/claude-for-legal-cn/litigation-legal/CLAUDE.md` 中的启发式规则判断重要性，并询问是否创建案件。若确认创建，`matters/_log.yaml` 会新增一行并标记 `source: demand-letter`，`matters/[matter-slug]/matter.md` 会链接回本文件夹。

未达到案件台账标准的函件只保存在这里。它们仍是起草和回应记录，只是不纳入组合案件跟踪。

## 更正与版本

不要覆盖已经发送的草稿。如果函件已发送但需要修订（例如补充催告），应新建 `draft-v2.docx`。版本历史本身就是有价值的记录。

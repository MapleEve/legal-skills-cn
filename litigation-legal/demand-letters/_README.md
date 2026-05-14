# demand-letters/ — 中国争议解决函件工作区

This folder holds drafting records and supporting materials for outbound China dispute-resolution correspondence: 律师函、催告函、解除通知、侵权警告函、证据保全申请、财产保全前沟通函、劳动争议沟通函、行政调查回应前沟通函。

Separate from `matters/` because:

- Not every letter rises to a tracked matter. Small-dollar 催收、常规违约催告、普通停止侵权函 may stay here without a log row.
- Every outbound letter has the same workflow shape (intake → draft → send → checklist), regardless of whether it later becomes a matter.
- When a letter becomes a matter, the matter's `matter.md` cross-links back here — the drafting history stays with the letter.

## Layout

```
demand-letters/
├── _README.md                     # this file
└── [slug]/
    ├── intake.md                  # context gathering, strategy, leverage, confidentiality and evidence-use filters
    ├── draft-v1.docx              # the letter (v2, v3 as iterated)
    └── checklist.md               # post-send checklist — delivery, copies, calendared deadlines, follow-up
```

## Slug conventions

`[type]-[counterparty]-[yyyy-mm]`. Examples:

- `payment-acme-2026-04`
- `infringement-warning-competitor-x-2026-04`
- `breach-supplier-2026-04`
- `termination-notice-vendor-2026-04`
- `evidence-preservation-vendor-2026-04`

## Workflow

1. `/litigation-legal:demand-intake [title]` → runs adaptive intake, writes `intake.md`
2. `/litigation-legal:demand-draft [slug]` → runs China-law settlement communication, mediation confidentiality, evidence-use limits, commercial secret and personal information review, drafts `.docx`, writes `checklist.md`, offers to create a matter

## Relationship to matters

After a letter is drafted, `demand-draft` assesses materiality (heuristic from house `~/.claude/plugins/config/claude-for-legal-cn/litigation-legal/CLAUDE.md`) and offers to create a matter. If yes, a matter row goes into `matters/_log.yaml` with `source: demand-letter`, and `matters/[matter-slug]/matter.md` links back to this folder.

Immaterial letters stay here only. They're still a drafting and response record — just not portfolio-tracked.

## Corrections and versions

Never overwrite a sent draft. If a letter was sent and needs revision (e.g., a supplemental demand), start `draft-v2.docx`. The history of versions is itself useful record.

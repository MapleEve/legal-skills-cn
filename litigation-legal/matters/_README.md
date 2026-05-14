# matters/ — 中国争议解决案件台账

This folder holds the dispute-resolution portfolio: 民事诉讼、商事仲裁、劳动仲裁、知识产权争议、商业秘密争议、公司纠纷、执行案件、证据保全、行政调查 and material pre-litigation correspondence. Two layers:

- **`_log.yaml`** — the ledger. One row per matter. Parseable by skills. Source of truth for rollups.
- **`[slug]/`** — per-matter detail. Narrative and history. Where humans read and edit.

## Layout

```
matters/
├── _log.yaml                  # ledger (all matters, including closed)
├── _README.md                 # this file
└── [matter-slug]/
    ├── matter.md              # narrative intake + theory + posture
    └── history.md             # append-only event log
```

## Slug conventions

Lowercase, hyphens, year at the end. Examples:
- `acme-v-us-2026`
- `admin-investigation-agency-2026`
- `labor-zhang-2026`
- `ip-infringement-competitor-2026`
- `assist-enforcement-court-2026`

Year makes the slug stable even if a similar matter arises later. The folder name matches the slug exactly.

## Who writes what

| File | Written by | Edit directly? |
|---|---|---|
| `_log.yaml` | `/matter-intake`, `/matter-update`, `/matter-close` | Yes, but reflect the change in the matter's `history.md` |
| `matter.md` | `/matter-intake` at intake; appended by `/matter-close` | Yes, for evolving theory / posture notes |
| `history.md` | `/matter-intake` seeds; `/matter-update` and `/matter-close` append | Append-only in practice — treat past entries as record |

## Closed matters

Stay here. Don't delete. `/portfolio-status` filters them from active rollups by default; `/portfolio-status --all` includes them. Closed matters are the training set for portfolio judgment.

## China dispute-resolution document types

Common matter-triggering documents include 律师函、催告函、解除通知、侵权警告函、证据保全申请、应诉通知书、传票、举证通知书、调查令、协助执行通知书、行政调查通知或监管问询。 Intake should record deadlines, responding authority, evidence preservation duties, confidentiality limits, commercial secret review, personal information review, and whether settlement or mediation communications may have restricted evidentiary use.

## Corrections

If a past history entry was wrong, don't edit it. Append a new entry that references and corrects it. The record of the correction is as important as the correction itself.

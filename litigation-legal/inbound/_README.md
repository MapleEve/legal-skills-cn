# inbound/ — 中国争议解决来函和外部文书

This folder holds triage and response work for anything arriving from the outside world: 律师函、催告函、解除通知、侵权警告函、应诉通知书、传票、举证通知书、证据保全申请、调查令、协助执行通知书、行政调查或监管问询。

Separate from `demand-letters/` (outbound) and `matters/` (tracked portfolio) because inbound items have their own workflow: read → triage → decide → respond (or escalate to matter). Not every incoming item becomes a tracked matter.

## Layout

```
inbound/
├── _README.md
└── [slug]/
    ├── incoming.pdf              # or .eml / .docx — the original (or link/pointer)
    ├── triage.md                 # analysis: scope, deadlines, evidence duties, confidentiality, options
    └── response-v1.docx          # drafted response, if we respond (v2, v3 as iterated)
```

## Slug conventions

`[type]-[sender-short]-[yyyy-mm]`. Examples:

- `demand-rec-acme-2026-04` (收到律师函/催告函)
- `summons-zhang-v-company-2026-04` (传票 or 应诉通知书)
- `evidence-notice-court-2026-04` (举证通知书)
- `investigation-order-court-2026-04` (调查令)
- `assist-enforcement-court-2026-04` (协助执行通知书)
- `admin-investigation-agency-2026-04` (行政调查或监管问询)
- `preservation-vendor-2026-04` (收到证据保全申请)

## Workflow

| Type | Command | Outputs |
|---|---|---|
| 律师函 / 催告函 / 侵权警告函 | `/litigation-legal:demand-received [path]` | triage.md + optional response draft |
| 传票 / 应诉通知书 / 举证通知书 / 调查令 / 协助执行通知书 | `/litigation-legal:subpoena-triage [path]` | triage.md + 异议/回函要点 |
| 行政调查 / 监管问询 | *future skill* | |

Each triage cross-checks `matters/_log.yaml` for related matters (same counterparty, overlapping subject). If a related matter exists, the triage flags it and offers to add this as a related_matter entry. If this inbound item should itself become a tracked matter, the triage hands off to `/matter-intake` with fields pre-populated.

## Relationship to matters

- Inbound + related to existing matter → link via `related_matters` field in `_log.yaml`; file stays in `inbound/`.
- Inbound + should become a matter → create matter; matter.md cross-links back to `inbound/[slug]/`.
- Inbound + handled and closed (no matter needed) → stays in `inbound/` as a record.

## Relationship to outbound

If the response to an inbound item is itself an outbound letter (for example a counter-demand, clarification, objection, settlement proposal, or confidentiality response), the triage hands off to `/demand-intake` pre-populated. The outbound letter lives in `demand-letters/`, with a cross-link back to this inbound folder.

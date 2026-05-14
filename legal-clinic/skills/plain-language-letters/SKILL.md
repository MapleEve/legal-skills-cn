---
name: plain-language-letters
description: >
  已废弃 — 常规函件请使用 `/legal-clinic:client-letter`，实质性案件进展更新请使用 `/legal-clinic:status client`。
  本技能在v2重构中拆分为两个更聚焦中国法律援助实践需求的技能。保留为迁移重定向。
user-invocable: false
---

# [已废弃] 通俗语言信件 → 请参见 `/legal-clinic:client-letter` 和 `/legal-clinic:status`

本技能在v2重构期间被拆分：
- 预约确认、文件请求、案情告知等常规函件 → `/legal-clinic:client-letter`（`/legal-clinic:client-letter`）
- 包含实质性法律分析的案件进展更新 → `/legal-clinic:status client`（`/legal-clinic:status client`）

废弃原因：原技能将"通俗语言"作为独立分类，但在中国法律援助诊所实践中，
所有面向当事人的函件和案件进展更新均应使用通俗语言——这是《法律援助法》(2022)
第47条当事人知情权保障的基本要求，不需要单独成为一个技能。
统一为 `/legal-clinic:client-letter`（常规沟通）和 `/legal-clinic:status`（实质性进展汇报），
二者均以通俗语言作为默认要求。

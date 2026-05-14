# client-comms/ — per-case communication logs

每个案件一个文件夹。文件夹内维护一个持续追加的 `log.md`，记录与当事人及必要第三方的每次沟通，包括电话、邮件、短信、微信、书面函件和面谈。由 `/legal-clinic:client-comms-log` 生成和追加。

## Layout

```
client-comms/
├── _README.md                     # this file
└── [case-id]/
    └── log.md                     # append-only running log
```

## Slug

与案件在接待记录、`deadlines.yaml` 的 `case_id` 中使用的 ID 保持一致。一个案件 = 一个文件夹。

## Why this exists

- **当事人沟通记录** — 记录何时、由谁、通过何种方式沟通过哪些事实和下一步事项。
- **指导教师监督** — 长期未回复、情绪危机、期限风险、授权不清、证据缺口等应成为指导教师复核信号。
- **学期交接连续性** — 接手学生可先读沟通脉络，避免重复询问当事人、遗漏承诺或误解案件进展。
- **法律援助案件归档** — 沟通记录是案件材料的一部分，结案归档时应与接待、授权、文书、证据和审查记录对应。
- **隐私保护** — 仅记录办案必要信息；身份证号、住址、联系方式、病史、未成年人信息等敏感内容按诊所规则脱敏或限制访问。

## What the log entries look like

```markdown
## [YYYY-MM-DD HH:MM] — [in / out] — [medium]

**Who (student):** [name]
**Who (client side):** [client name, or third-party if call from opposing counsel/etc]
**Duration / length:** [10 min call | 3-paragraph email | 2-page letter]

**Summary:**
[What happened, 2-4 sentences. Substance plus tone where it matters.]

**Action items:**
- [Item the student owes the client, with deadline]
- [Item the client owes the student, with expected timing]

**Follow-up due:** [date if applicable]

**Supervisor review needed:** [yes / no; if yes, why]

**Privacy notes:**
[Any sensitive data handling, consent limits, or access restrictions]
```

## What this folder does NOT contain

- 实体法律分析（放在接待记录、memo 或 status 文件中）
- 文书草稿（放在对应案件工作目录）
- 仅供指导教师查看的教学评价、冲突审查或敏感策略记录
- 不必要的完整身份证件、病历、聊天截图或其他高敏材料原件

沟通日志是事实联系记录，不是法律意见书。可以记录当事人陈述和学生承诺，但策略判断、法律结论和教师批注意见应放在相应的内部工作文件中，并按诊所权限控制。

## Retention

追加写入。不要直接改写旧记录；如发现旧记录有误或需要补充，新增一条记录并引用原记录日期。结案时随法律援助案件材料归档；跨学期案件在 `handoffs/` 中引用最新沟通状态和未完成事项。

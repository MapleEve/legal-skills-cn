# handoffs/ — end-of-semester case handoff memos

按学期建立文件夹，为每个未结案件生成一份交接备忘录。由 `/legal-clinic:semester-handoff` 在学期末生成，供下一届学生在 `/legal-clinic:ramp` 中读取。

## Layout

```
handoffs/
├── _README.md                             # this file
└── [YYYY-semester]/                       # e.g., 2026-spring, 2026-fall
    ├── _summary.md                        # cross-case rollup: what transitions, who to whom
    ├── [case-id].md                       # one per active case
    └── ...
```

## Slug / folder conventions

Semester folder: `[year]-[spring|summer|fall]`. Examples:
- `2026-spring`
- `2026-summer`
- `2026-fall`

Case memo: 使用案件的 `case_id`（来自 `deadlines.yaml` 或接待记录）。与其他案件文件保持一致。

## What a handoff memo contains

- 案件摘要（事实、业务类型、当前阶段）
- 离届学生姓名、已完成工作及与当事人的沟通关系
- 指导教师已审查/待审查事项
- 待办期限（来自 `deadlines.yaml`，并标注是否已复核）
- 未完成问题、待决策事项和需要补证的事实
- 沟通历史摘要（引用 `client-comms/[case-id]/log.md`）
- 已起草、已提交、已归档的材料清单及路径
- 法律援助申请、审批、指派、授权、结案归档状态
- 隐私和权限限制（未成年人、家暴、病史、身份证件、住址、联系方式等）
- 接手学生第一周需要完成的动作

## Workflow

1. `/legal-clinic:semester-handoff` 由指导教师运行；也可由离届学生先为本人案件生成草稿。
2. 学期结束前 1-2 周生成逐案备忘录和 `_summary.md`，离届学生补全事实和材料位置。
3. 指导教师审查交接备忘录，确认期限、授权、隐私限制和归档状态。
4. 下一届学生在学期开始运行 `/legal-clinic:ramp`，读取分配给自己的案件交接材料。
5. 接手学生完成首次复核后，在案件状态文件中记录已接手、待核验事项和下一次当事人沟通安排。

## Retention

交接备忘录随案件材料保存。历史交接用于证明案件如何跨学期流转、哪些事项已由指导教师监督、哪些材料已归档。不要删除旧交接；如需更正，新增修订说明并保留原记录。

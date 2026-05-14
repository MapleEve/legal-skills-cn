---
name: matter-workspace
description: >
  管理知识产权事项工作区——创建、列表、切换、关闭或脱离当前事项。
  在多客户执业中使用以将一个客户或委托的上下文与另一个客户保持分离。
argument-hint: "<new | list | switch | close | none> [slug]"
---

# /ip-legal:matter-workspace

执业者在多个客户和知识产权事项中工作。事项工作区使一个客户或委托的上下文与每个其他上下文保持分离。此技能管理这些工作区。

## 中国知识产权案件类型

案件类型包括：
- 商标检索/商标申请/商标异议/商标无效宣告/撤销三年不使用/商标侵权/商标许可谈判
- 专利申请/审查意见答复/专利无效宣告/FTO/专利侵权/专利许可谈判/标准必要专利
- 著作权登记/著作权侵权/信息网络传播权/软件著作权
- 商业秘密侵权/员工离职商业秘密保护/刑事报案
- 知识产权条款审查/委托开发合同/合作开发合同/许可协议
- 开源合规/开源审计
- 域名争议（CNDRP/UDRP）
- 知识产权组合维护
- 知识产权尽职调查（投融资/并购/IPO背景下的知识产权审查）
- 其他

## 子命令

- `/ip-legal:matter-workspace new <slug>`——创建新事项工作区
- `/ip-legal:matter-workspace list`——列出事项及状态
- `/ip-legal:matter-workspace switch <slug>`——设置当前事项
- `/ip-legal:matter-workspace close <slug>`——归档事项（永不删除）
- `/ip-legal:matter-workspace none`——脱离任何当前事项

## 存储布局

所有案件数据位于`~/.claude/plugins/config/claude-for-legal-cn/ip-legal/matters/`下。

```
~/.claude/plugins/config/claude-for-legal-cn/ip-legal/
├── CLAUDE.md                       # 执业级别执业画像
└── matters/
    ├── <slug>/
    │   ├── matter.md                  # 客户、事项类型、关键事实、例外设置
    │   ├── history.md                  # 带日期的事件、决定、草案、审查日志
    │   ├── notes.md                  # 自由形式的工作笔记
    │   └── outputs/                # 此案件的技能输出
    └── _archived/
        └── <slug>/                 # 关闭的事项
```

## 当前事项在执业 CLAUDE.md 中

`## 事项工作区` 下的 `当前事项:` 行是单一真相来源。切换事项编辑该行。

## 子命令逻辑

### `new <slug>`
运行信息收集访谈，创建案件文件（matter.md、history.md、notes.md）。

### `list`
枚举所有事项并打印表格，标记当前事项。已归档事项单独列出。

### `switch <slug>`
编辑当前事项行。显示事项摘要以确认。

### `close <slug>`
归档事项——移至 `_archived/`，记录关闭日期。

### `none`
设置为仅执业级别。

## 跨事项上下文

默认为关闭。绝不在关闭时跨事项读取。这符合律师职业伦理中关于客户保密的要求（《律师法》第38条）。

当为开启时，仅当用户明确要求时跨事项读取。

## 此技能不做什么

- 不运行利益冲突检查——冲突检查是执业者/律所的责任
- 不强制执行保留——归档不删除，保留政策不在范围内
- 不自动路由输出——实质性技能决定写入内容
- 不决定跨事项是否适当

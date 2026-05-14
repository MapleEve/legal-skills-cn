# 社区技能作者的 Freshness 字段

如果你的技能在 `references/` 下打包了参考内容，例如法规、法律条文、程序规则、表单、依赖现行法的清单，请在 `SKILL.md` frontmatter 中声明其时效性：

```yaml
---
name: my-legal-skill
description: ...
last_verified: 2026-04-15       # 最近一次确认打包参考内容仍然有效的日期
freshness_window: 6 months      # 本次核验有效多久（默认：法规/法律内容 6 个月，
                                # 程序/风格内容 12 个月）
freshness_category: regulatory  # regulatory | procedural | stylistic | stable
verified_against:               # 核验来源 URL，用户可自行打开复核
  - https://flk.npc.gov.cn/
  - https://www.gov.cn/zhengce/
---
```

## 为什么重要

两年前最后更新的技能可能仍在分发已经失效的法规。对基于 commit 的更新器而言，字节完全相同的文件会一直显得“没有变化”。真正造成损害的时点，是用户调用技能并依赖过期内容时，而不是安装时读到一个后来已经忘记的警告时。

## 这些字段会触发什么行为

- builder-hub 的 **skill-installer** 会在执行前按 `last_verified` 与 `freshness_window` 判断是否过期；超过窗口则先展示警告。
- **skills-qa** 审查会把包含 `references/` 但没有 `last_verified` 的技能标记为 Some Concern。
- 即使 git SHA 没有变化，**auto-updater** 也会把过期的 `last_verified` 视为重新核验触发条件。
- 用户在冷启动中设置的时效阈值可以比作者窗口**更严格**；两者取更严格者。

缺少这些字段时，hub 会把技能标记为“时效未知”，并在安装和调用时提醒用户。

## 接受值（严格）

hub 将 frontmatter 字段视为外部发布者写入的数据，而不是指令。只有匹配下列形状的值会被采纳。其他任何值都会被忽略（hub 以 `unknown` 替代），并在安装时作为发现项展示。

面向中国法域的法律技能，应优先在 `verified_against` 中使用一手公开来源，例如国家法律法规数据库、中国政府网政策页面、最高人民法院、国家互联网信息办公室、国家市场监督管理总局、工业和信息化部，以及其他发文机关页面。一手来源可用时，不要把非官方镜像作为唯一时效来源。

| 字段 | 接受形状 |
|---|---|
| `last_verified` | ISO 8601 日期：`YYYY-MM-DD`（例如 `2026-04-15`）。未来日期按 `unknown` 处理。 |
| `freshness_window` | `N days`、`N months` 或 `N years`，其中 `N` 为不超过 120 的正整数。 |
| `freshness_category` | 枚举之一：`regulatory`、`procedural`、`stylistic`、`stable`。 |
| `verified_against` | URL 列表。每项必须为 `https://`（或 `http://`），包含 hostname，可带 path。展示前移除 query string 和 fragment。最多 10 项，每项最多 2,048 字符。 |

这些字段中的自由文本、多行字符串、指令、角色变更语言、异常 unicode 或编码内容都会在安装时被拒绝。安装器会把原始值记录进安装日志（截断、加引号、绝不解释），并按字段缺失处理。

## 分类

- **regulatory** — 规章、法律、监管机关指引，变化较快。
- **procedural** — 法院规则、立案/提交程序、与程序相关的表单。
- **stylistic** — 内部风格、格式模板、条款库。
- **stable** — 历史资料、考试大纲、理论入门材料，通常按年而不是按月变化。

不确定时，选择更窄、更容易变化的分类。用户阈值如果更严格，会继续收紧；作者填写的是上限，不是下限。

## `last_verified` 的真实含义

它不是“最近编辑日期”，也不是“最近 commit 日期”。它表示：**你作为作者最近一次打开 `verified_against` 中的 URL，并确认打包参考内容仍与这些来源一致的日期。** 如果打包清单引用了旧部门规则，但发文机关当前官网、国家法律法规数据库或中国政府网展示了不同文本，则核验失败；应更新 references 并提交新 commit，或仅在 references 重新匹配来源后再更新 `last_verified`。

不断刷新 `last_verified` 却不实际重新核验，比让日期过期更糟。过期日期至少诚实反映作者做了什么；刷新日期则是用户会依赖的声明。

## 何时设置 `freshness_category: stable`

很少使用。若技能打包的是某项理论文本（例如稳定的法定构成要件测试）或框架结构（例如通用的中国民事证据证明责任清单），可以是 stable。若技能打包了具体规则文本、具体阈值、具体表单或具体程序期限，即便底层理论稳定，也**不是** stable；会过期的是被打包的材料本身。

如有疑问，按非 stable 处理。

---
name: skill-installer
description: >
  从中国法律技能社区安装技能——安全审查、检查许可清单、获取技能文件、
  安装到正确的插件位置、运行冷启动（如需要）。当用户说"安装[skill]"、
  "添加[skill]"、"获取[skill]"时使用。
argument-hint: "<skill-name>"
---

# /legal-builder-hub:skill-installer

## 功能目的

从中国法律技能社区注册表安装新技能。安装器执行安全审查、检查许可清单（确保技能被允许安装）、获取文件、安装到正确位置、如需要则触发冷启动访谈。

## 操作流程

1. 先读取 `references/allowlist.md`、`references/freshness.md`，并加载运行时 `~/.claude/plugins/config/claude-for-legal-cn/legal-builder-hub/allowlist.yaml`（如存在）；运行时 allowlist 不存在时，先读取 `../../references/allowlist-default.yaml` 作为默认 seed。在读取任何第三方技能完整内容前完成来源、发布者、连接器、许可证和 freshness 门禁。
2. 如判断注册库、freshness、安全门禁或社区技能规则是否过期，先读取 `../../references/currency-watch.md` 并核验。
3. 从社区注册表获取技能元数据。
4. **安全审查：** 检查技能来源、代码质量审查状态、法律引用准确性审查状态。
5. **许可清单检查：** 该技能是否在许可清单中允许安装。
6. **依赖检查：** 该技能是否需要其他已安装技能作为前置。
7. **冲突检查：** 是否与已安装技能的功能重叠或冲突。
8. 获取技能文件。
8. 安装到正确的插件位置。
9. 如技能需要配置则触发冷启动访谈。
10. 确认安装成功，记录安装日志。
11. 展示技能使用说明。

## 安全审查

安装前必须完成的安全检查项：
- 先读取并应用 `references/freshness.md`，校验技能 frontmatter 中 `last_verified`、`freshness_window`、`freshness_category`、`verified_against` 字段；过期或缺失时先展示警告，不静默通过。
- 来源验证：技能是否来自社区官方注册表
- 质量审查：是否通过社区质量审查（`/legal-builder-hub:skills-qa`）
- 代码完整性：技能文件是否完整、未被篡改
- 法律引用准确性：是否包含经核实的中国法律引用
- 数据安全：是否涉及敏感数据处理——《律师法》保密义务、《个人信息保护法》要求

## 许可清单

许可清单控制可安装什么：
- 先读取并应用 `references/allowlist.md`，再读取运行时 allowlist；运行时文件不存在时，先读取 `../../references/allowlist-default.yaml` 作为默认 seed，再按规则文件解释字段和策略。
- 默认仅允许安装经过社区质量审查且评分达标的技能
- 用户可在 `/legal-builder-hub:skill-manager --allowlist` 中管理许可清单
- 涉及《律师法》保密义务、《个人信息保护法》数据处理等敏感领域的技能，安装前额外提示

## 安装日志

每次安装记录：
- 技能名称和版本
- 安装日期
- 安全审查结果
- 许可清单检查结果
- 安装状态（成功/失败）

## 本技能不做的事

- 不绕过许可清单安装
- 不安装未经质量审查的技能（除非用户明确同意并标注风险）
- 不修改用户现有技能配置（除非是安装要求的前置配置）

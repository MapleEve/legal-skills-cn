# 变更日志

## 2026-05-15

- 修复 150 个 skill frontmatter name 以匹配目录 slug。
- 提升插件版本，确保已安装的 Claude Code 用户能收到更新。
- 将插件版本真源保留在各插件 `plugin.json`，避免 marketplace entry 双写 `version`。
- 修复 skill name、命令标题、可运行示例和用户文档中的伪命令占位。
- 明确执行 command / slash command、machine reference、China-law content、plugin/marketplace version/name、skill frontmatter name 的一致性修复。
- 同步 plugin/marketplace 版本与 CN namespace 命名，避免配置路径回落到 upstream slug。
- 修复 Markdown 中的机器引用、配置路径、事项与案件工作区文件名和命令 flag，使机器可读路径保持 ASCII。
- 补充 China-law workflow 对齐修复，避免法律引用和业务流程继续沿用不适配的 upstream 表述。

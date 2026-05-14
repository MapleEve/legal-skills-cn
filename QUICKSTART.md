# 快速上手

**60 秒**，即可开始使用你的插件。

## 在 Claude Cowork 中安装
1. [安装 Claude Desktop](https://claude.com/download)
2. 获取 Claude Cowork 使用权限
3. 按照下方视频说明操作：

https://github.com/user-attachments/assets/51394f0a-5277-4fe2-b81c-5c5e9ac876b5

## 在 Claude Code 中安装

1. **打开 Claude Code**（终端中）或 **Claude Cowork**（桌面应用）。不确定你用的是哪个？如果你打开了一个终端窗口，里面有 Claude，那就是 Claude Code。

2. **添加市场。** 在 Claude Code 中执行：

   ```
   /plugin marketplace add https://github.com/MapleEve/legal-skills-cn
   ```

   如果你已经把仓库 clone 到本机，也可以使用本地路径：`/plugin marketplace add /Users/your-name/Desktop/claude-for-legal-cn`

3. **安装你的插件。** 从下方表格中选择与你工作领域匹配的插件，然后执行：
   ```
   /plugin install privacy-legal@claude-for-legal-cn
   ```

4. **重启 Claude Code。** 关闭后重新打开。此步骤不可跳过——插件在重启之前不会生效。

5. **运行初始化设置。** 快速模式约需 2 分钟，完整模式约需 10-15 分钟。
   ```
   /privacy-legal:cold-start-interview
   ```

6. **接入检索工具。** 未接入检索工具时，引文会标记为未验证。Cowork 用户：设置 → 连接器 → 添加北大法宝。Claude Code 用户：插件已在配置中列出检索 MCP；首次运行某个技能需要时，系统会提示你授权。

## 安装为"用户级"，不要安装为"项目级"

执行 `/plugin install` 时，系统可能会问你是安装为"仅当前项目"还是"所有项目（用户级）"。**选择"用户级"。**

这有点反直觉：项目级看起来更安全。但项目级会阻止插件读取项目文件夹之外的文件——你放在"下载"里的提纲、"文档"里的合同、"云盘"里的客户资料。大多数技能需要读取你的文件。用户级并不会给插件额外的文件访问权限——插件只能读取你明确指定的文件或当前目录下的文件。它只是让插件在任何文件夹下都能工作，而不是仅限于某一个文件夹。

如果你已经安装为项目级，想切换：先 `/plugin uninstall <plugin-name>`，然后在你的用户主目录下执行 `/plugin install <plugin-name>@claude-for-legal-cn`。

## 哪个插件适合我？

| 你的角色 | 展示名 | 安装 slug | 第一条命令 |
|---|---|---|---|
| 数据合规律师 / 数据保护官 | 数据合规 | `privacy-legal` | `/privacy-legal:use-case-triage` |
| 商业合同律师 / 法务 | 商业合同 | `commercial-legal` | `/commercial-legal:review` |
| 公司证券律师 / 投融资法务 | 公司证券 | `corporate-legal` | `/corporate-legal:diligence-issue-extraction` |
| 劳动用工律师 / 人事法务 | 劳动用工 | `employment-legal` | `/employment-legal:wage-hour-qa` |
| 产品合规法务 | 产品合规 | `product-legal` | `/product-legal:is-this-a-problem` |
| 知识产权律师 / 专利代理人 | 知识产权 | `ip-legal` | `/ip-legal:clearance` |
| 争议解决律师（企业法务/律所/个人执业） | 争议解决 | `litigation-legal` | `/litigation-legal:matter-intake` |
| 政府监管 / 合规法务 | 政府监管 | `regulatory-legal` | `/regulatory-legal:reg-feed-watcher` |
| 人工智能治理负责人 | 人工智能治理 | `ai-governance-legal` | `/ai-governance-legal:use-case-triage` |
| 法律援助诊所指导教师（法学院） | 法律援助工作站 | `legal-clinic` | `/legal-clinic:cold-start-interview` |
| 法学生 | 法学生 | `law-student` | `/law-student:cold-start-interview` |
| 法律运营 / 寻找更多技能 | 法律技能管理 | `legal-builder-hub` | `/legal-builder-hub:registry-browser` |

## 你正在安装的是什么

每个插件通过初始化访谈了解你的工作流程，将其写入业务档案文件（`~/.claude/plugins/config/claude-for-legal-cn/<plugin-name>/CLAUDE.md`），此后每个技能都从中读取。这份档案属于你——你可以编辑它、重新运行初始化、或者口头指示某个技能更新它。

**所有输出均为律师审阅前草稿。** 插件会标记不确定之处、按数据来源标注引文、对不可逆操作设置门槛。律师负责审阅、核实并承担责任。插件让审阅更快；它不替代审阅。

## 包含什么

12 个业务领域插件、5 个自动化工作流手册、16+ 个连接器。完整参考见 [README.md](README.md)。

## 遇到问题？

- **安装后提示"命令未找到"** → 你漏了第 4 步。重启 Claude Code。
- **提示"请先运行初始化"** → 在执行任何其他命令之前，先运行 `/commercial-legal:cold-start-interview`。
- **引文标记为 `[需核实]`** → 接入检索工具（第 6 步）。没有检索工具时，所有引文来自训练数据而非当前数据库。
- **"无法读取 [file]"** → 通常是插件安装为项目级，而文件在项目文件夹之外。见上方"安装为用户级"——重装为用户级或把文件移到项目文件夹内。
- **插件不包含 X 功能** → 运行 `/legal-builder-hub:related-skills-surfacer` 寻找更匹配的技能，或查看该插件的 README 中"本插件不做什么"一节。

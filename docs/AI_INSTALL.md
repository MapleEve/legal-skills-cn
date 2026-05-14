# AI 安装入口

这份文档是给 AI 先读的安装入口。你可以把本文件发给 Codex、Claude Code 或其他 AI 助手，或直接要求它先读取 `docs/AI_INSTALL.md`、`README.md`、`QUICKSTART.md`，再根据你的电脑环境给出安装步骤。

## 最小上下文

- 仓库：`https://github.com/MapleEve/legal-skills-cn`
- 项目：个人开源项目 `MapleEve/legal-skills-cn`
- 本地目录通常是用户下载或克隆后的 `claude-for-legal-cn` 文件夹。
- 推荐顺序：先把 `https://github.com/MapleEve/legal-skills-cn` 作为 Claude Code 插件市场添加，再按工作领域安装具体插件。
- 常用参考：`README.md` 负责完整说明，`QUICKSTART.md` 负责快速安装口径。

## 让 AI 知道怎么安装

把本文件交给 AI 后，请让它先确认你使用的是本地目录还是 GitHub URL：

- 默认使用 GitHub URL：`/plugin marketplace add https://github.com/MapleEve/legal-skills-cn`。
- 如果你已经有本地文件夹，也可以让 AI 使用本地路径，例如 `/Users/your-name/Desktop/claude-for-legal-cn`。
- 不要让 AI 编造新的安装命令；Claude Code 和 Claude Cowork 的安装步骤以 `README.md` 和 `QUICKSTART.md` 为准。

## Codex 怎么用

在 Codex 中，把任务说成“读取安装入口并按我的电脑环境生成步骤”。建议这样写：

```text
请先读取 docs/AI_INSTALL.md、README.md、QUICKSTART.md。
这个仓库是 https://github.com/MapleEve/legal-skills-cn。
请根据我当前是否已有本地仓库路径，说明如何在 Claude Code 或 Claude Cowork 中安装。
不要编造 README/QUICKSTART 没写过的命令；如果需要本地路径，请先告诉我应该使用哪个文件夹路径。
```

Codex 适合帮助你检查本地路径、阅读 README/QUICKSTART、整理安装步骤和排查“命令未找到”“插件未生效”“项目级/用户级安装选错”等问题。真正安装 Claude Code 插件时，仍需要在 Claude Code 里执行对应 `/plugin` 命令。

## Claude Code 安装口径

在 Claude Code 中，先添加本仓库作为插件市场：

```bash
/plugin marketplace add https://github.com/MapleEve/legal-skills-cn
```

如果你已经把仓库 clone 到本机，也可以把上面的 GitHub URL 换成本地仓库路径，例如 `/Users/your-name/Desktop/claude-for-legal-cn`。

然后安装与你工作领域匹配的插件。README 中使用目录 slug 示例：

```bash
/plugin install commercial-legal@claude-for-legal-cn
/plugin install privacy-legal@claude-for-legal-cn
/plugin install corporate-legal@claude-for-legal-cn
```

QUICKSTART 中也给出中文插件名示例：

```bash
/plugin install 数据合规@claude-for-legal-cn
```

安装后重启 Claude Code，再运行对应插件的冷启动访谈。例如：

```bash
/privacy-legal:cold-start-interview
```

注意：安装命令可以使用市场中的中文插件名；斜杠命令前缀使用插件目录 slug，例如 `privacy-legal`。

如安装时询问安装范围，QUICKSTART 建议选择“用户级”，避免插件只能在单个项目目录内工作。

## Claude Cowork 安装口径

Claude Cowork 的安装路径以 README/QUICKSTART 为准：

1. 安装 [Claude Desktop](https://claude.com/download)。
2. 获取 Claude Cowork 使用权限。
3. 打开 **Cowork** 标签页，进入 **Customize（自定义）**。
4. 点击 **Browse plugins（浏览插件）** 并安装需要的插件，或上传任意插件目录的 zip 压缩包。

README/QUICKSTART 中的操作视频：

https://github.com/user-attachments/assets/51394f0a-5277-4fe2-b81c-5c5e9ac876b5

## 给 AI 的可复制提示词

```text
请先读取 docs/AI_INSTALL.md、README.md、QUICKSTART.md。
仓库是 https://github.com/MapleEve/legal-skills-cn，项目名是 MapleEve/legal-skills-cn。
请根据我的环境判断我应该使用本地路径还是先获取 GitHub 仓库。
然后说明如何先添加 Claude Code 插件市场，再按我的工作领域安装插件，并提醒我重启 Claude Code、运行 cold-start-interview、选择用户级安装。
如果我使用 Claude Cowork，请按 README/QUICKSTART 的真实步骤说明：Claude Desktop、Cowork 权限、Customize、Browse plugins 或上传插件目录 zip。
不要编造 README/QUICKSTART 没有出现过的命令；不确定时先指出需要我提供本地路径或当前工具环境。
最后提醒：不要提交凭据，不要上传未脱敏法律材料，所有输出都是供律师审查的草稿，不是法律意见。
```

## 安全边界

- 不要提交 API key、token、密码、私钥或本地配置文件。
- 不要上传未脱敏的合同、案件材料、客户资料、身份信息或其他敏感法律材料。
- 未接入检索工具时，引文和法律来源需要人工核实。
- 本仓库的输出是供执业律师审查的草稿，不构成法律意见，不构成法律结论，不替代律师判断。

# Google Sheets 输出规范

适用于使用 Google Workspace 的团队。结构与 Excel 输出相同，生成机制不同。如果 Excel 和 Sheets 路径都可用，应询问用户偏好，不要根据自己的环境猜测。

## 写入方式

按优先级依次尝试三种路径：

1. **Google Sheets MCP**（如果已连接具备写入/创建能力的 `gdrive` 或 `gsheets` MCP）。创建 spreadsheet，写入各 sheet，并通过 API 设置格式。
2. **通过 ADC 使用 Google Sheets API**（如果用户已配置 `gcloud auth application-default login --enable-gdrive-access`，且 Python 环境有 `google-api-python-client`）。使用 `sheets.spreadsheets().create()` 创建，并用 `batchUpdate` 设置格式。
3. **降级：CSV + 手动导入。** 写出 CSV，提示用户导入 Sheets。同时写出 `format-instructions.md`，让用户可手动应用颜色编码和数据验证。

不要假设自己拥有未验证的写入权限。先检查；不可用时平稳降级。

## 工作簿结构

严格镜像 Excel 规范：相同 sheet、相同语义，只使用 Sheets 原生机制：

**Sheet: `Review`**（主表格）
- 第 1 行：工作成果页眉（合并单元格）
- 第 2 行：列标题
- 第 3 行及以后：每份文档一行
- A 列：文档名称 / 链接（如果源文档在 Drive 中，应超链接到文件；这是 Sheets 相比 Excel 的优势）
- B 列起：每个 schema 字段一列
- **来源引文写入单元格 note**（Sheets notes，不是 comments；notes 是持久注释，comments 是协作讨论串）。Notes 可悬停查看，导出为 `.xlsx` 时会变为批注。
- 按状态填充单元格：默认 = `answered`，浅黄 = `unclear` 或 `needs_review`，浅灰 = `not_present`。在 `batchUpdate` 中使用带 `userEnteredFormat.backgroundColor` 的 `repeatCell`。
- 每组字段后增加一个 `Verified` 列：默认留空，通过 `setDataValidation` 设置 `✓ | ✗ | ?` 下拉验证。

**Sheet: `Flags`**
- 与 Excel 规范相同。每个被标记单元格一行。

**Sheet: `_schema`**
- 来自 `.review-schema.yaml` 的列定义。

**Sheet: `_summary`**
- 统计、被标记字段、复核提醒。

## 应利用的 Sheets 特性

- **源文档超链接。** 如果被审文档在 Drive 中（VDR 导出和内部资料库常见），每行文档名称都应链接到文件。这是 click-to-source 模式，Sheets 原生支持。
- **多人共同复核。** Sheets 比本地 `.xlsx` 更适合并发复核。如果交易团队需要分工核验，应优先使用该格式。
- **schema 的 named ranges。** 为每一列定义 named range，让下游公式（透视表、条件计数）更易读。
- **按状态列做条件格式。** 如果为每个数据列写一个隐藏 `_state` 列，可用条件格式规则驱动颜色编码；这比逐单元格设置更干净，也更能承受排序。

## Sheets 特有注意事项

- **Notes 是逐单元格注释，打印时不可见。** 如果输出要打印或转 PDF 给合伙人会议使用，也要把引文写进 `Flags` sheet，避免丢失。
- **Sheets 有 1,000 万单元格限制。** 法律审查通常不会触达上限，但如果有人尝试把 50,000 份文档、30 个字段及来源列全部铺开，应提示风险。
- **分享默认值。** 按插件业务画像，这是律师工作成果。创建 spreadsheet 时应限制分享（仅 owner），并提示用户主动选择分享对象。不要默认“知道链接的任何人可访问”。
- **公式转义。** 如果逐字引文以 `=`、`+`、`-` 或 `@` 开头，要加单引号前缀（`'`），避免 Sheets 将其解析为公式。这是真实失败模式：以“- 双方同意……”开头的合同条款如果不转义，会显示为公式错误。

## 不应这样做

与 Excel 规范相同：不要写置信度百分比，不要截断引文，不要在数据区域合并单元格，并且必须写出 `_schema` 和 `_summary` sheet。


## 公式注入防护

写入 Excel、Sheets 或 CSV 的任何单元格前，都要中和公式注入。来自相对方或外部材料的文本（合同引文、主体名称、工商登记信息、CLM 导出等）都属于攻击者可控内容。以 `=`、`+`、`-`、`@`、制表符、回车或换行开头的单元格可能被解释为公式，或破坏行结构。

- **前缀单引号：** `'=SUM(A1:A10)` → `=SUM(A1:A10)`（显示为文本，不执行）
- **适用于所有包含文档、工具结果或用户粘贴内容的单元格。** 你控制的列标题和你计算出的值是安全的。
- **CSV：还要转义内嵌逗号、双引号和换行**（RFC 4180 quoting）。
- 这不是可选项。用户在 Excel 中打开的表格如果触发宏或通过 DDE 外传数据，就是针对用户的供应链攻击。

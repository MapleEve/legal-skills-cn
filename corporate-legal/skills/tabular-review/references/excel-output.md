# Excel 输出规范

Excel 文件通常是交易团队真正会打开的交付物，必须把结构和安全细节做好。

## 如果 Claude in Excel / Office agent 可用

通过 Office agent 直接在 Excel 中生成 workbook。这是优先路径，因为它能保留格式，让复核人在熟悉的工具里工作，并原生支持单元格批注模式。

## 如果不可用，使用 openpyxl

先用 `python3 -c "import openpyxl"` 检查环境。若未安装，可询问是否安装（`pip3 install openpyxl`），或降级输出 CSV。

## 工作簿结构

**Sheet 1: `Review`**（主表格）
- 第 1 行：工作成果页眉（合并单元格，内容来自插件配置 `## Outputs`）
- 第 2 行：列标题
- 第 3 行及以后：每份文档一行
- A 列：文档名称 / 路径
- B 列起：按 schema 顺序，每个 schema 字段一列
- 每个数据列后增加一个隐藏的 `_source` 列，内容为 `[quote] | [location]`
- 数据列单元格批注 = 引文和位置（即使 `_source` 隐藏，悬停时也可见）
- 按状态填充单元格：无填充 = `answered`，`#FFF2CC`（浅黄）= `unclear` 或 `needs_review`，`#EFEFEF`（浅灰）= `not_present`
- 每组 [data + _source] 后增加一个 `Verified` 列：默认留空，由复核人填写。下拉验证值：`✓`、`✗`、`?`。

**Sheet 2: `Flags`**
- 每个被标记为 `unclear` 或 `needs_review` 的单元格一行
- 列：文档、字段、状态、值（如有）、引文、位置、备注
- 这是复核工作队列。按 Column 排序，便于复核人批量处理同类判断。

**Sheet 3: `_schema`**
- 来自 `.review-schema.yaml` 的列定义，每个字段一行：id、label、type、options、prompt
- 让文件自带说明。六个月后打开文件的合伙人也能看到当时具体问了什么。

**Sheet 4: `_summary`**
- 文档数量、字段数量、运行日期
- 每列 answered / not_present / unclear / needs_review 的数量
- normalization pass 标记过的字段列表
- 复核提醒文本

## 不应这样做

- 不要写置信度百分比列。那不是有效信息；状态 + 引文才是信号。
- 不要为了适配单元格而截断引文。应换行显示，或把完整引文放进批注。
- 不要在数据区域合并单元格。律师会排序和筛选。
- 不要只写主表而省略 `_schema` 和 `_summary`。自说明能力是文件可信的关键。


## 公式注入防护

写入 Excel、Sheets 或 CSV 的任何单元格前，都要中和公式注入。来自相对方或外部材料的文本（合同引文、主体名称、工商登记信息、CLM 导出等）都属于攻击者可控内容。以 `=`、`+`、`-`、`@`、制表符、回车或换行开头的单元格可能被解释为公式，或破坏行结构。

- **前缀单引号：** `'=SUM(A1:A10)` → `=SUM(A1:A10)`（显示为文本，不执行）
- **适用于所有包含文档、工具结果或用户粘贴内容的单元格。** 你控制的列标题和你计算出的值是安全的。
- **CSV：还要转义内嵌逗号、双引号和换行**（RFC 4180 quoting）。
- 这不是可选项。用户在 Excel 中打开的表格如果触发宏或通过 DDE 外传数据，就是针对用户的供应链攻击。

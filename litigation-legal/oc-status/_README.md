# oc-status/ — 每周对方律师状态询问草稿

这里保存 `/litigation-legal:oc-status` 的输出。每次运行按日期创建文件夹；每个文件夹内，每个案件一份 markdown 草稿，并包含一个 `_summary.md`。

## 目录结构

```
oc-status/
├── _README.md                       # 本文件
└── [YYYY-MM-DD]/
    ├── _summary.md                  # 本次运行内容、跳过项和原因
    ├── [slug-1].md                  # 每个案件一封邮件草稿
    ├── [slug-2].md
    └── ...
```

配置邮件连接器或企业邮箱连接器后，也可以在用户邮箱中创建草稿。markdown 文件是持久记录；邮箱草稿是执行层。Gmail 可作为可选连接器配置，但不是本插件默认项。

## 运行节奏

设置定时任务后，每周运行一次（周一上午）。使用 `/litigation-legal:oc-status --setup-schedule` 注册计划。

也可随时临时运行：`/litigation-legal:oc-status`（默认筛选）或 `/litigation-legal:oc-status --slug=[slug]`（单个案件）。

## 清理规则

日期文件夹会持续累积。对方律师回复且案件历史已更新后，这些文件通常不再需要。可删除超过 30 天的旧文件夹。

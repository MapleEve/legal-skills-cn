#!/usr/bin/env python3
# Copyright 2026 Anthropic PBC
# SPDX-License-Identifier: Apache-2.0
"""本地工作流 worker 输出的 schema 校验工具。

用法：validate.py <output.json> <schema.json|schema.yaml>
校验通过返回 0；校验失败返回 1，并将原因写入 stderr。

当前运行接口不强制结构化输出，因此本地部署辅助脚本会在读取型子节点和编排器
之间运行此校验。Schema 写在各子节点 yaml 的 `output_schema:` 下，由部署脚本提取。
"""
import json
import sys
from pathlib import Path

import jsonschema


def _load(path: Path):
    text = path.read_text()
    if path.suffix in (".yaml", ".yml"):
        import yaml
        return yaml.safe_load(text)
    return json.loads(text)


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__, file=sys.stderr)
        return 2
    instance = _load(Path(sys.argv[1]))
    schema = _load(Path(sys.argv[2]))
    try:
        jsonschema.validate(instance=instance, schema=schema)
    except jsonschema.ValidationError as e:
        print(f"无效：{e.message}，位置 {'/'.join(str(p) for p in e.absolute_path)}", file=sys.stderr)
        return 1
    print("通过")
    return 0


if __name__ == "__main__":
    sys.exit(main())

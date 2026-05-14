#!/usr/bin/env python3
# Copyright 2026 Anthropic PBC
# SPDX-License-Identifier: Apache-2.0
"""校验编排器 `agent.yaml` 的工具权限是否收窄。

遍历每个 `managed-agent-cookbooks/*/agent.yaml`，检查编排器 `tools:`
配置是否存在提权缺口。写入和企业协作投递权限应放在叶子节点，
不应放在编排器上：

  1. 编排器不能配置 `mcp_toolset`；MCP 客户端应放在子节点。
  2. 任何 `agent_toolset*` 配置都不能启用 `write`；只有指定写入叶子节点可写。
  3. 不能授予企业协作投递工具；编排器应输出 `handoff_request`，
     由本地事件循环或工作流引擎路由。

发现违规时返回非 0，并打印违规文件与工具名。全部通过时返回 0，
并为每个 cookbook 打印一行摘要。
"""
from __future__ import annotations

import sys
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parent.parent
COOKBOOKS_DIR = ROOT / "managed-agent-cookbooks"
FORBIDDEN_EXTERNAL_TOOL_PREFIXES = ("cn_collab", "external_send", "team_send")


def _lint_one(path: Path) -> list[str]:
    """返回违规信息列表；空列表表示通过。"""
    errs: list[str] = []
    with path.open() as f:
        doc = yaml.safe_load(f)
    tools = doc.get("tools") or []
    for idx, entry in enumerate(tools):
        if not isinstance(entry, dict):
            errs.append(f"{path}: tools[{idx}] 不是 mapping")
            continue
        ttype = entry.get("type", "")
        if ttype == "mcp_toolset":
            name = entry.get("mcp_server_name", "<unnamed>")
            errs.append(
                f"{path}: 编排器不能携带 mcp_toolset "
                f"(mcp_server_name={name})；请移到子节点"
            )
            continue
        if not ttype.startswith("agent_toolset"):
            continue
        # 检查逐工具配置。
        default_cfg = entry.get("default_config") or {}
        default_enabled = bool(default_cfg.get("enabled", False))
        configs = entry.get("configs") or []
        seen = set()
        for cfg in configs:
            if not isinstance(cfg, dict):
                continue
            name = cfg.get("name")
            enabled = bool(cfg.get("enabled", default_enabled))
            seen.add(name)
            if enabled and name == "write":
                errs.append(
                    f"{path}: 编排器不能启用 'write'；"
                    f"只有写入叶子节点可以启用 Write"
                )
            if enabled and isinstance(name, str) and name.startswith(
                FORBIDDEN_EXTERNAL_TOOL_PREFIXES
            ):
                errs.append(
                    f"{path}: 编排器不能启用企业协作投递工具 '{name}'；"
                    f"应输出 handoff_request 交给本地编排层"
                )
        # 如果默认启用，它会扩展到 toolset 内所有工具，包括写入与外部投递。
        # 这里无法枚举完整 toolset，因此编排器直接拒绝 default-enabled。
        if default_enabled:
            errs.append(
                f"{path}: 编排器 agent_toolset 必须设置 "
                f"default_config.enabled=false；当前 default enabled=true"
            )
    return errs


def main() -> int:
    if not COOKBOOKS_DIR.is_dir():
        print(f"未找到 cookbooks 目录：{COOKBOOKS_DIR}", file=sys.stderr)
        return 2
    total_errs: list[str] = []
    clean: list[str] = []
    for agent_yaml in sorted(COOKBOOKS_DIR.glob("*/agent.yaml")):
        errs = _lint_one(agent_yaml)
        if errs:
            total_errs.extend(errs)
        else:
            clean.append(agent_yaml.parent.name)
    if total_errs:
        print("tool-scope lint 未通过：", file=sys.stderr)
        for e in total_errs:
            print(f"  {e}", file=sys.stderr)
        return 1
    for slug in clean:
        print(f"  ✓ {slug:24s} 编排器工具权限已收窄")
    return 0


if __name__ == "__main__":
    sys.exit(main())

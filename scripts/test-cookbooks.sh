#!/usr/bin/env bash
# Copyright 2026 Anthropic PBC
# SPDX-License-Identifier: Apache-2.0
# 对每个本地自动化 cookbook 执行 dry-run，并确认解析出的 POST /v1/agents
# 请求体结构正确：JSON 合法、只有一层子节点、system prompt 非空、不泄露
# output_schema。任一 cookbook 失败则返回非 0。
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fail=0

# 工具权限校验：编排器不能携带 MCP toolset、Write 或企业协作投递工具。
# 编排器应输出 handoff_request，由本地事件循环或工作流引擎路由。
if ! python3 "$ROOT/scripts/lint-tool-scope.py"; then
  echo "  ✗ tool-scope lint 未通过" >&2
  fail=1
fi

for d in "$ROOT"/managed-agent-cookbooks/*/; do
  slug=$(basename "$d")
  if ! bash "$ROOT/scripts/deploy-managed-agent.sh" "$slug" --dry-run 2>&1 | tail -n +2 | python3 -c "
import json,sys
b=json.load(sys.stdin)
errs=[]
for i,x in enumerate(b):
    if not x.get('system'): errs.append(f'{x.get(\"name\")}: system 为空')
    if i<len(b)-1 and x.get('callable_agents'): errs.append(f'{x.get(\"name\")}: 深度超过 1（子节点含 callable_agents）')
if 'output_schema' in json.dumps(b): errs.append('output_schema 泄露到请求体')
if errs:
    for e in errs: print(f'      {e}', file=sys.stderr)
    sys.exit(1)
print(f'  ✓ {sys.argv[1]:24s} {len(b)} 个请求体')
" "$slug"; then
    echo "  ✗ $slug" >&2
    fail=1
  fi
done
exit $fail

#!/usr/bin/env bash
# Copyright 2026 Anthropic PBC
# SPDX-License-Identifier: Apache-2.0
# 将本地自动化工作流模板解析为本地可审查的 /v1/agents 请求体。
#
# 输出前会解析 manifest 中的便捷写法：
#   system: {file: ...}                  -> inlined string
#   skills: [{path: ...}]                -> dry-run 占位；--upload 时上传并引用 skill_id
#   callable_agents: [{manifest: ...}]   -> dry-run 占位；--upload 时先创建并以资源 id 引用
#
# 带 `output_schema` 的读取型子节点会加一层轻量校验，确保 JSON 通过
# schema 检查后再交给编排器消费。
#
# 默认只 dry-run 输出请求体。仅当显式传入 --upload 时才调用 Anthropic API。
#
# 用法：scripts/deploy-managed-agent.sh <slug> [--dry-run|--upload]
#   例如：scripts/deploy-managed-agent.sh reg-monitor

set -euo pipefail

usage() {
  echo "用法：deploy-managed-agent.sh <slug> [--dry-run|--upload]" >&2
}

ROLE="${1:-}"
[[ -n "$ROLE" ]] || { usage; exit 2; }
MODE="${2:---dry-run}"
case "$MODE" in
  --dry-run) DRY_RUN=1 ;;
  --upload) DRY_RUN=0 ;;
  *) usage; exit 2 ;;
esac
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="$ROOT/managed-agent-cookbooks/$ROLE"
API="${ANTHROPIC_API_BASE:-https://api.anthropic.com}"
[[ $DRY_RUN -eq 1 ]] || : "${ANTHROPIC_API_KEY:?必须设置 ANTHROPIC_API_KEY}"

[[ -f "$DIR/agent.yaml" ]] || { echo "未找到 manifest：$DIR/agent.yaml" >&2; exit 1; }

# 使用与 YAML 环境变量替换相同的 allowlist 校验 SKILL_TITLE_PREFIX。
# 该字符串会进入 `curl -F display_title=...`；如果不校验，恶意前缀
# 可能注入额外 multipart 字段或夹带换行。
if [[ -n "${SKILL_TITLE_PREFIX:-}" ]]; then
  if ! [[ "$SKILL_TITLE_PREFIX" =~ ^[A-Za-z0-9._/:@\ -]+$ ]]; then
    echo "拒绝 SKILL_TITLE_PREFIX：值包含 [A-Za-z0-9._/:@ -] 之外的字符" >&2
    exit 1
  fi
fi

req() {
  curl -sS -H "x-api-key: $ANTHROPIC_API_KEY" \
           -H "anthropic-version: 2023-06-01" \
           -H "anthropic-beta: managed-agents-2026-04-01" \
           -H "content-type: application/json" "$@"
}

# jq + python(pyyaml) 负责 manifest -> payload 转换
command -v jq >/dev/null || { echo "需要安装 jq" >&2; exit 1; }
python3 -c 'import yaml' 2>/dev/null || { echo "需要安装 python3 + pyyaml" >&2; exit 1; }
yaml2json() {
  python3 -c '
import sys,os,re,yaml,json
SAFE = re.compile(r"^[A-Za-z0-9._/:@-]*$")
def sub(m):
    name = m.group(1)
    v = os.environ.get(name)
    if v is None:
        return m.group(0)
    if not SAFE.fullmatch(v):
        sys.exit(f"拒绝 ${{{name}}}：值包含 [A-Za-z0-9._/:@-] 之外的字符")
    return v
t = open(sys.argv[1]).read()
t = re.sub(r"\$\{([A-Z0-9_]+)\}", sub, t)
json.dump(yaml.safe_load(t), sys.stdout)
' "$1"
}

SKILL_CACHE_FILE="$(mktemp "${TMPDIR:-/tmp}/skillcache.XXXXXXXXXX")"
trap 'rm -f "$SKILL_CACHE_FILE"' EXIT
upload_skill() {
  local path="$1" key cached
  key="$(basename "$path")"
  cached=$(grep -m1 "^${key}=" "$SKILL_CACHE_FILE" 2>/dev/null | cut -d= -f2-)
  if [[ -n "$cached" ]]; then printf '%s' "$cached"; return; fi
  if [[ $DRY_RUN -eq 1 ]]; then
    cached=$(printf '{"type":"custom","skill_id":"DRYRUN_%s","version":"latest"}' "$key")
    echo "${key}=${cached}" >>"$SKILL_CACHE_FILE"
    printf '%s' "$cached"; return
  fi
  local resp id zip
  zip="$(mktemp "${TMPDIR:-/tmp}/skill.XXXXXXXXXX").zip"
  (cd "$(dirname "$path")" && zip -qr "$zip" "$(basename "$path")")
  # /v1/skills 使用独立 beta header 和 multipart，不走 agents JSON 路径。
  resp=$(curl -sS "$API/v1/skills" \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "anthropic-beta: skills-2025-10-02" \
    -F "display_title=${SKILL_TITLE_PREFIX:-}$(basename "$path")" \
    -F "files[]=@$zip")
  rm -f "$zip"
  id=$(jq -r '.id // empty' <<<"$resp")
  if [[ -z "$id" ]]; then
    echo "POST /v1/skills 失败：$path" >&2
    echo "$resp" | jq . >&2 2>/dev/null || echo "$resp" >&2
    exit 1
  fi
  cached=$(printf '{"type":"custom","skill_id":"%s","version":"latest"}' "$id")
  echo "${key}=${cached}" >>"$SKILL_CACHE_FILE"
  printf '%s' "$cached"
}

resolve_manifest() {
  local file="$1" base
  base="$(cd "$(dirname "$file")" && pwd)"
  local json
  json=$(yaml2json "$file")
  # 将 {from_plugin: <dir>} 展开为该目录下每个 skills/* 对应的 {path: ...}。
  local fp
  fp=$(jq -r '.skills[]? | select(.from_plugin) | .from_plugin' <<<"$json" | head -1)
  if [[ -n "$fp" ]]; then
    local plugdir expanded="[]"
    plugdir="$(cd "$base/$fp" && pwd)"
    for sk in "$plugdir"/skills/*/; do
      [[ -d "$sk" ]] || continue
      expanded=$(jq --arg p "${sk%/}" '. + [{__upload:$p}]' <<<"$expanded")
    done
    json=$(jq --argjson e "$expanded" \
      '.skills = ((.skills // [] | map(select(.from_plugin | not))) + $e)' <<<"$json")
  fi
  jq --arg base "$base" '
    .skills = ((.skills // []) | map(
      if .path then {__upload: ($base + "/" + .path)}
      elif .__upload then .
      else . end))
  ' <<<"$json"
}

inline_system() {
  local json="$1" base="$2" sysfile text append body
  if jq -e '.system | type == "object"' >/dev/null <<<"$json"; then
    sysfile=$(jq -r '.system.file // empty' <<<"$json")
    text=$(jq -r '.system.text // empty' <<<"$json")
    append=$(jq -r '.system.append // empty' <<<"$json")
    body="$text"
    if [[ -n "$sysfile" ]]; then
      [[ -f "$base/$sysfile" ]] || { echo "未找到 system.file：$base/$sysfile" >&2; exit 1; }
      body="$(cat "$base/$sysfile")"
    fi
    [[ -n "$append" ]] && body="${body}"$'\n\n'"${append}"
    jq --arg s "$body" '.system=$s' <<<"$json"
  else
    printf '%s' "$json"
  fi
}

create_agent() {
  local file="$1" base json sub_ids skills_json
  base="$(cd "$(dirname "$file")" && pwd)"
  json=$(resolve_manifest "$file")
  json=$(inline_system "$json" "$base")

  skills_json="[]"
  while IFS= read -r p; do
    [[ -z "$p" ]] && continue
    [[ -d "$p" ]] || { echo "未找到 skill path：$p" >&2; exit 1; }
    skills_json=$(jq ". + [$(upload_skill "$p")]" <<<"$skills_json")
  done < <(jq -r '.skills[]? | select(.__upload) | .__upload' <<<"$json")
  json=$(jq --argjson s "$skills_json" '.skills=$s' <<<"$json")

  sub_ids="[]"
  while IFS= read -r m; do
    [[ -z "$m" ]] && continue
    local out sid sver
    out=$(create_agent "$base/$m")
    sid=${out%% *}; sver=${out##* }
    sub_ids=$(jq --arg i "$sid" --argjson v "$sver" '. + [{type:"agent", id:$i, version:$v}]' <<<"$sub_ids")
  done < <(jq -r '.callable_agents[]?.manifest // empty' <<<"$json")
  json=$(jq --argjson c "$sub_ids" '.callable_agents=$c | del(.output_schema)' <<<"$json")
  [[ -n "${DEPLOY_DEBUG:-}" ]] && jq -c '{name, callable_agents}' <<<"$json" >&2

  if [[ $DRY_RUN -eq 1 ]]; then
    echo "$json" >>"$DRY_OUT"
    jq -r '"DRYRUN_" + .name + " 1"' <<<"$json"; return
  fi
  local resp id ver
  resp=$(req -X POST "$API/v1/agents" -d "$json")
  id=$(jq -r '.id // empty' <<<"$resp")
  ver=$(jq -r '.version // 1' <<<"$resp")
  if [[ -z "$id" ]]; then
    echo "POST /v1/agents 失败：$(jq -r .name <<<"$json")" >&2
    echo "$resp" | jq . >&2 2>/dev/null || echo "$resp" >&2
    exit 1
  fi
  echo "$id $ver"
}

if [[ $DRY_RUN -eq 1 ]]; then
  DRY_OUT="$(mktemp)"
  create_agent "$DIR/agent.yaml" >/dev/null
  echo "# --dry-run：已解析的 POST /v1/agents 请求体（子节点在前，编排器在后）"
  jq -s '.' "$DRY_OUT"
  rm -f "$DRY_OUT"
  exit 0
fi

OUT=$(create_agent "$DIR/agent.yaml")
AGENT_ID=${OUT%% *}
echo "已创建工作流资源：$ROLE"
echo "资源 id：$AGENT_ID"
echo "控制台 URL：https://console.anthropic.com/agents/$AGENT_ID"

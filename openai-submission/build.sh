#!/usr/bin/env bash
# Build the archive uploaded on the portal's Skills tab.
#
# The portal expects an archive whose root holds `.claude-plugin/plugin.json`
# (with a non-empty description) and a `skills/` directory with at least one
# valid skill. It converts plugin.json to `.codex-plugin/plugin.json` on import.
#
# Deliberately excluded, per the submission guide:
#   .claude-plugin/marketplace.json   marketplace metadata is regenerated in the portal
#   .mcp.json                         MCP config is entered in the portal form, not shipped
#   commands/                         no slash commands; converted to skills
set -euo pipefail

cd "$(dirname "$0")"
OUT="nitrograph-openai-plugin.zip"

# Fail loudly rather than shipping a bundle the portal will reject.
[ -f bundle/.claude-plugin/plugin.json ] || { echo "missing .claude-plugin/plugin.json"; exit 1; }
python3 -c "
import json,sys
m=json.load(open('bundle/.claude-plugin/plugin.json'))
assert m.get('description','').strip(), 'plugin.json needs a non-empty description'
for k in ('marketplace','mcpServers'):
    assert k not in m, f'{k} must not be in the submitted manifest'
print('manifest ok:', m['name'], m['version'])
"
for f in bundle/skills/*/SKILL.md; do
  [ -f "$f" ] || { echo "no skills found"; exit 1; }
  head -1 "$f" | grep -q '^---$' || { echo "$f missing frontmatter"; exit 1; }
  echo "skill ok: $f"
done

rm -f "$OUT"
if command -v zip >/dev/null; then
  ( cd bundle && zip -qr "../$OUT" . -x '.DS_Store' )
else
  # zip(1) isn't installed everywhere (minimal WSL images, slim containers).
  python3 - "$OUT" <<'PY'
import os, sys, zipfile
out = sys.argv[1]
with zipfile.ZipFile(out, 'w', zipfile.ZIP_DEFLATED) as z:
    for root, _, files in os.walk('bundle'):
        for fn in files:
            if fn == '.DS_Store':
                continue
            p = os.path.join(root, fn)
            z.write(p, os.path.relpath(p, 'bundle'))
PY
fi
echo "built $OUT ($(du -h "$OUT" | cut -f1))"
python3 -c "
import zipfile,sys
for n in sorted(zipfile.ZipFile('$OUT').namelist()): print('  ', n)
"

"""Run design_to_code for given guids, then immediately fetch all code
entries + referenced assets from the returned manifests.

Usage: python dtc_batch.py <outdir> <guid> [<guid> ...]
"""
import json
import os
import re
import sys
import urllib.request

from pixso_mcp import call, tool_text

OUT = sys.argv[1]
GUIDS = sys.argv[2:]
os.makedirs(OUT, exist_ok=True)

result = call("design_to_code", {"guids": GUIDS, "clientFrameworks": "html"})
res = result.get("result", {})
if res.get("isError"):
    print("TOOL ERROR:", tool_text(result)[:800])
    sys.exit(1)

entries = []
for c in res.get("content", []):
    if c.get("type") != "text":
        continue
    for m in re.finditer(r"\{[^{}]*\"pageEntries\"[\s\S]*?\}", c["text"]):
        pass
    # Robust: find all JSON objects with url keys in the text
    for m in re.finditer(r'"(?:url)"\s*:\s*"([^"]+)"', c["text"]):
        entries.append(m.group(1))

entries = list(dict.fromkeys(entries))
print("URLs found:", len(entries))

saved = []
for url in entries:
    name = os.path.basename(url)
    try:
        with urllib.request.urlopen(url, timeout=60) as r:
            data = r.read()
        path = os.path.join(OUT, name)
        with open(path, "wb") as f:
            f.write(data)
        saved.append((path, len(data)))
        print("saved", path, len(data))
    except Exception as e:  # noqa: BLE001
        print("FAILED", url, e)

# Also dump the full instruction text for reference
with open(os.path.join(OUT, "_instructions.txt"), "w", encoding="utf-8") as f:
    f.write(tool_text(result))
print("---- summary ----")
for p, n in saved:
    print(p, n)

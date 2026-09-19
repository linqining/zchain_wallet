"""Capture per-screen design reference screenshots from Pixso MCP."""
import base64
import json
import os

from pixso_mcp import call

SCREENS = [
    ("4:1862", "01-welcome"), ("4:1940", "02-success"), ("4:2030", "03-import"),
    ("4:2087", "04-lock"), ("4:2137", "05-home"), ("4:2331", "06-zc-dash"),
    ("4:2580", "07-evm-dash"), ("4:2823", "08-stk-dash"), ("4:3040", "09-zc-send"),
    ("4:3182", "10-zc-withdraw"), ("4:3349", "11-zc-confirm"), ("4:3485", "12-zc-sessions"),
    ("4:3602", "13-zc-portal"), ("4:3734", "14-zc-receipts"), ("4:3855", "15-evm-send"),
    ("4:3977", "16-evm-history"), ("4:4106", "17-evm-manage"), ("4:4233", "18-proofs"),
    ("4:4400", "19-settings"),
]

os.makedirs("shots", exist_ok=True)
for guid, slug in SCREENS:
    raw = call("get_screenshot", {"guid": guid, "clientFrameworks": "html"})
    res = raw.get("result", {})
    if res.get("isError"):
        print("ERR", slug, raw.get("result", {}).get("content"))
        continue
    for c in res.get("content", []):
        if c.get("type") == "image":
            data = base64.b64decode(c["data"])
            path = os.path.join("shots", slug + ".png")
            with open(path, "wb") as f:
                f.write(data)
            print("saved", path, len(data))
            break
    else:
        print("no image for", slug)

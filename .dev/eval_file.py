"""Run a JS snippet (from a file or inline arg) via Pixso MCP eval_script.

Usage:
  python eval_file.py script.js
  python eval_file.py -e "return 1+1"
Saves raw JSON reply to <basename>.json and prints extracted text.
"""
import json
import sys

from pixso_mcp import call, tool_text

if __name__ == "__main__":
    if sys.argv[1] == "-e":
        script = sys.argv[2]
        tag = "inline"
    else:
        with open(sys.argv[1], encoding="utf-8") as f:
            script = f.read()
        tag = sys.argv[1].replace("/", "_").replace("\\", "_").rsplit(".", 1)[0]
    raw = call("eval_script", {"script": script})
    with open(tag + ".json", "w", encoding="utf-8") as f:
        json.dump(raw, f, ensure_ascii=False, indent=1)
    res = raw.get("result", {})
    if res.get("isError"):
        print("ERROR:", tool_text(raw)[:1500])
    else:
        print(tool_text(raw))

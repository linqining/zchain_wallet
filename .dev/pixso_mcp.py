"""Minimal MCP client for the local Pixso MCP server (http://127.0.0.1:3667/mcp).

Usage:
  python pixso_mcp.py list
  python pixso_mcp.py call <tool_name> '<json-args>'
  python pixso_mcp.py call <tool_name> --  # read args JSON from stdin
"""
import json
import sys
import urllib.request

MCP_URL = "http://127.0.0.1:3667/mcp"
SESSION_FILE = __file__.rsplit(".", 1)[0] + ".session"


class Http400(Exception):
    pass


def _post(payload, session=None):
    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json, text/event-stream",
    }
    if session:
        headers["mcp-session-id"] = session
    req = urllib.request.Request(MCP_URL, data=json.dumps(payload).encode(), headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=180) as resp:
            sid = resp.headers.get("mcp-session-id")
            body = resp.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as e:
        if e.code == 400:
            raise Http400(e.read().decode("utf-8", "replace")[:300])
        raise
    return sid, body


def _parse_sse_or_json(body):
    body = body.strip()
    if body.startswith("{") or body.startswith("["):
        return json.loads(body)
    results = []
    for line in body.splitlines():
        if line.startswith("data:"):
            data = line[5:].strip()
            if data:
                results.append(json.loads(data))
    if len(results) == 1:
        return results[0]
    return results


def _get_session():
    try:
        with open(SESSION_FILE) as f:
            return f.read().strip()
    except OSError:
        return None


def _new_session():
    sid, body = _post({
        "jsonrpc": "2.0", "id": 1, "method": "initialize",
        "params": {
            "protocolVersion": "2025-03-26",
            "capabilities": {},
            "clientInfo": {"name": "zcode-agent", "version": "1.0"},
        },
    })
    _post({"jsonrpc": "2.0", "method": "notifications/initialized"}, sid)
    with open(SESSION_FILE, "w") as f:
        f.write(sid)
    return sid


def call(tool, args=None):
    args = args or {}
    payload = {"jsonrpc": "2.0", "id": 2, "method": "tools/call",
               "params": {"name": tool, "arguments": args}}
    try:
        sid, body = _post(payload, _get_session())
    except Http400:
        sid, body = _post(payload, _new_session())
    if sid:
        with open(SESSION_FILE, "w") as f:
            f.write(sid)
    result = _parse_sse_or_json(body)
    if isinstance(result, dict) and "error" in result:
        err = result["error"]
        if "session" in str(err.get("message", "")).lower():
            _, body = _post(payload, _new_session())
            result = _parse_sse_or_json(body)
        else:
            raise RuntimeError(json.dumps(err, ensure_ascii=False))
    return result


def tool_text(result):
    """Extract concatenated text content from a tools/call result."""
    out = []
    for item in result.get("content", []):
        if item.get("type") == "text":
            out.append(item.get("text", ""))
        elif item.get("type") == "image":
            out.append("[image: %s bytes, %s]" % (
                len(item.get("data", "")), item.get("mimeType", "?")))
        elif item.get("type") == "resource_link":
            out.append("[resource_link] %s" % item.get("uri"))
        else:
            out.append(json.dumps(item, ensure_ascii=False)[:200])
    return "\n".join(out)


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return
    cmd = sys.argv[1]
    if cmd == "list":
        sid, body = _post({"jsonrpc": "2.0", "id": 2, "method": "tools/list"})
        for line in body.splitlines():
            pass
        res = _parse_sse_or_json(body)
        for t in res["result"]["tools"]:
            print(t["name"])
    elif cmd == "call":
        tool = sys.argv[2]
        if len(sys.argv) > 3 and sys.argv[3] != "--":
            args = json.loads(sys.argv[3])
        else:
            args = json.load(sys.stdin)
        result = call(tool, args)
        print(json.dumps(result, ensure_ascii=False, indent=1))
    elif cmd == "text":
        tool = sys.argv[2]
        if len(sys.argv) > 3 and sys.argv[3] != "--":
            args = json.loads(sys.argv[3])
        else:
            args = json.load(sys.stdin)
        print(tool_text(call(tool, args)))
    else:
        print(__doc__)


if __name__ == "__main__":
    main()

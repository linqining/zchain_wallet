"""Extract all http://localhost:3667/assets/... URLs from HTML files in a
directory and download them into <outdir>/assets/ with flat filenames."""
import os
import re
import sys
import urllib.request

OUTDIR = sys.argv[1]
asset_dir = os.path.join(OUTDIR, "assets")
os.makedirs(asset_dir, exist_ok=True)

urls = set()
for fn in os.listdir(OUTDIR):
    p = os.path.join(OUTDIR, fn)
    if not os.path.isfile(p):
        continue
    with open(p, encoding="utf-8", errors="replace") as f:
        txt = f.read()
    for m in re.finditer(r'https?://[^"\'\)\s]+/assets/[^"\'\)\s]+', txt):
        urls.add(m.group(0))

print("asset urls:", len(urls))
ok, fail = 0, 0
for u in sorted(urls):
    name = u.rsplit("/", 1)[-1]
    # dedupe across batch ids by filename
    try:
        with urllib.request.urlopen(u, timeout=60) as r:
            data = r.read()
        with open(os.path.join(asset_dir, name), "wb") as f:
            f.write(data)
        ok += 1
        print("ok", name, len(data))
    except Exception as e:  # noqa: BLE001
        fail += 1
        print("FAIL", name, e)
print("done ok=%d fail=%d" % (ok, fail))

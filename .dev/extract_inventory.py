"""Extract per-screen text inventory + style summaries from dtc_all/0:0."""
import json
import os
import re
from html.parser import HTMLParser

SCREENS = [
    ("4:1862", "01-welcome"), ("4:1940", "02-success"), ("4:2030", "03-import"),
    ("4:2087", "04-lock"), ("4:2137", "05-home"), ("4:2331", "06-zc-dash"),
    ("4:2580", "07-evm-dash"), ("4:2823", "08-stk-dash"), ("4:3040", "09-zc-send"),
    ("4:3182", "10-zc-withdraw"), ("4:3349", "11-zc-confirm"), ("4:3485", "12-zc-sessions"),
    ("4:3602", "13-zc-portal"), ("4:3734", "14-zc-receipts"), ("4:3855", "15-evm-send"),
    ("4:3977", "16-evm-history"), ("4:4106", "17-evm-manage"), ("4:4233", "18-proofs"),
    ("4:4400", "19-settings"),
]

txt = open(os.path.join("dtc_all", "0%3A0"), encoding="utf-8").read()

os.makedirs("inventory", exist_ok=True)


class ScreenParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.stack = []
        self.texts = []
        self.styles = []
        self.imgs = 0
        self.svg = 0

    def handle_starttag(self, tag, attrs):
        d = dict(attrs)
        self.stack.append(tag)
        if tag == "img":
            self.imgs += 1
        if tag == "svg" or (tag == "use" and "svg" in (d.get("xlink:href") or "")):
            self.svg += 1
        style = d.get("style", "")
        if style:
            self.styles.append(style)

    def handle_endtag(self, tag):
        if self.stack and self.stack[-1] == tag:
            self.stack.pop()

    def handle_data(self, data):
        s = data.strip()
        if s and "frame-content" not in "".join(self.stack[-1:]):
            depth = len(self.stack)
            self.texts.append(("  " * min(depth, 12)) + s)


for guid, slug in SCREENS:
    m = re.search(r'<div class="frame-content-%s"[^>]*>' % guid.replace(":", "_"), txt)
    if not m:
        print("NOT FOUND", slug, guid)
        continue
    start = m.start()
    # find matching close by scanning div balance from start
    depth = 0
    pos = start
    for mm in re.finditer(r"<div\b|</div>", txt[start:]):
        if mm.group(0) == "<div":
            depth += 1
        else:
            depth -= 1
        if depth == 0:
            pos = start + mm.end()
            break
    html = txt[start:pos]

    p = ScreenParser()
    p.feed(html)

    # style summaries
    from collections import Counter
    bg = Counter()
    fg = Counter()
    fs = Counter()
    r = Counter()
    for st in p.styles:
        for k, c in (("background-color", bg), ("(?<!-)color:", fg)):
            pass
        v = re.search(r"background-color:\s*([^;]+)", st)
        if v:
            bg[v.group(1).strip()] += 1
        v = re.search(r"(?<![a-z-])color:\s*([^;]+)", st)
        if v:
            fg[v.group(1).strip()] += 1
        v = re.search(r"font-size:\s*([^;]+)", st)
        if v:
            fs[v.group(1).strip()] += 1
        v = re.search(r"border(?:-top|-right|-bottom|-left)?-?(?:top|right|bottom|left)?-?radius:\s*([^;]+)", st)
        if v:
            r[v.group(1).strip()] += 1

    out = {
        "guid": guid,
        "texts": [t.strip() for t in p.texts],
        "top_bg": bg.most_common(12),
        "top_fg": fg.most_common(10),
        "font_sizes": fs.most_common(12),
        "radii": r.most_common(8),
        "img_count": p.imgs,
        "html_chars": len(html),
    }
    with open(os.path.join("inventory", slug + ".json"), "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=1)
    # readable text dump
    with open(os.path.join("inventory", slug + ".txt"), "w", encoding="utf-8") as f:
        f.write("\n".join(p.texts))
    print(slug, "texts:", len(p.texts), "html:", len(html), "imgs:", p.imgs)

function walk(n, d, out) {
  if (d > 7) return;
  const kids = n.children || [];
  for (const c of kids) {
    const w = Math.round(c.width), h = Math.round(c.height);
    if (c.type === 'FRAME' && w >= 340 && w <= 420 && h >= 560 && h <= 640) {
      const t = c.absoluteTransform;
      out.push({ id: c.id, name: c.name, x: Math.round(t[0][2]), y: Math.round(t[1][2]), w: w, h: h });
    } else {
      walk(c, d + 1, out);
    }
  }
}
const out = [];
walk(pixso.getNodeById('4:2'), 0, out);
return out;

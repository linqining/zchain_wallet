const shots = [];
function walk(n, d) {
  if (d > 7) return;
  const kids = n.children || [];
  for (const c of kids) {
    const w = Math.round(c.width), h = Math.round(c.height);
    if (c.type === 'FRAME' && w >= 340 && w <= 420 && h >= 560 && h <= 640) {
      const t = c.absoluteTransform;
      shots.push({ id: c.id, name: c.name, x: Math.round(t[0][2]), y: Math.round(t[1][2]), w: w, h: h, parent: c.parent.id });
    } else {
      walk(c, d + 1);
    }
  }
}
walk(pixso.getNodeById('4:2'), 0);

// For each shot, collect all text content inside it (first 160 chars) and the
// caption text node that sits directly above it in its parent cell.
function textsOf(n, out) {
  const kids = n.children || [];
  for (const c of kids) {
    if (c.type === 'TEXT') out.push(c.characters);
    else textsOf(c, out);
  }
}
const rows = shots.map(function (s) {
  const node = pixso.getNodeById(s.id);
  const inner = [];
  textsOf(node, inner);
  let caption = '';
  const p = pixso.getNodeById(s.parent);
  if (p && p.parent) {
    const cell = p.parent; // cell wrapper containing shot + caption
    const ct = [];
    textsOf(cell, ct);
    caption = (ct[0] || '').slice(0, 80);
  }
  return {
    id: s.id, x: s.x, y: s.y, parent: s.parent,
    caption: caption,
    firstText: (inner[0] || '').slice(0, 60),
    allText: inner.join(' | ').slice(0, 160),
  };
});
return rows;

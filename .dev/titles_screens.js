const ids = ['4:1862','4:1940','4:2030','4:2087','4:2137','4:2331','4:2580','4:2823','4:3040','4:3182','4:3349','4:3485','4:3602','4:3734','4:3855','4:3977','4:4106','4:4233','4:4400'];
function textsOf(n, out) {
  const kids = n.children || [];
  for (const c of kids) {
    if (c.type === 'TEXT') out.push(c.characters);
    else textsOf(c, out);
  }
}
const rows = ids.map(function (id) {
  const t = [];
  textsOf(pixso.getNodeById(id), t);
  return { id: id, texts: t.slice(0, 5).map(function (s) { return s.slice(0, 40); }) };
});
return rows;

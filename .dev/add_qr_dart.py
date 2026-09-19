"""Append the demo qr-art symbol into lib/design/icons.dart."""
import random

random.seed(42)
n = 29
cells = []


def finder(x, y):
    cells.append('<rect x="{x}" y="{y}" width="7" height="7" fill="#000" stroke="none"/>'.format(x=x, y=y))
    cells.append('<rect x="{x}" y="{y}" width="3" height="3" fill="none" stroke="none"/>'.format(x=x + 2, y=y + 2))
    cells.append('<rect x="{x}" y="{y}" width="3" height="3" fill="#000" stroke="none"/>'.format(x=x + 2, y=y + 2))


finder(0, 0)
finder(n - 7, 0)
finder(0, n - 7)
for i in range(n):
    for j in range(n):
        in_finder = (i < 8 and j < 8) or (i > n - 9 and j < 8) or (i < 8 and j > n - 9)
        if in_finder:
            continue
        if random.random() < 0.42:
            cells.append('<rect x="{j}" y="{i}" width="1" height="1" fill="#000" stroke="none"/>'.format(j=j, i=i))

svg = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 29 29" fill="none">' + ''.join(cells) + '</svg>'
dart = svg.replace('\\', r'\\').replace("'", "\\'").replace('$', r'\$')

p = r'E:\projects\zchain_wallet\lib\design\icons.dart'
t = open(p, encoding='utf-8').read()
entry = "  'qr-art': '" + dart + "',\n  };"
t = t.replace('  };', entry, 1)
open(p, 'w', encoding='utf-8').write(t)
print('qr-art appended, modules:', len(cells))

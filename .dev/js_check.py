import os
import re

FILES = [
    r'E:\projects\zchain_wallet\js\icons.js',
    r'E:\projects\zchain_wallet\js\app.js',
    r'E:\projects\zchain_wallet\js\data.js',
]
PAT_SQ = re.compile(r"'(?:[^'\\]|\\.)*'")
PAT_DQ = re.compile(r'"(?:[^"\\]|\\.)*"')
PAT_BLK = re.compile(r'/\*.*?\*/', re.S)
PAT_LN = re.compile(r'//[^\n]*')

for p in FILES:
    t = open(p, encoding='utf-8').read()
    s = PAT_SQ.sub("''", t)
    s = PAT_DQ.sub('""', s)
    s = PAT_BLK.sub('', s)
    s = PAT_LN.sub('', s)
    bal = lambda a, b: s.count(a) - s.count(b)
    print(os.path.basename(p), 'braces', bal('{', '}'), 'parens', bal('(', ')'),
          'brackets', bal('[', ']'))

t = open(r'E:\projects\zchain_wallet\js\icons.js', encoding='utf-8').read()
print('symbols:', t.count('<symbol'))

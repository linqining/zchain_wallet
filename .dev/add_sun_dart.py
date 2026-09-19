"""Append the missing i-sun symbol into lib/design/icons.dart."""
p = r'E:\projects\zchain_wallet\lib\design\icons.dart'
t = open(p, encoding='utf-8').read()
if "'i-sun':" in t:
    print('i-sun already present')
else:
    svg = ('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" '
           'stroke="#000000" stroke-width="1.6" stroke-linecap="square" stroke-linejoin="miter">'
           '<circle cx="14.5" cy="13.5" r="4.2"/>'
           '<path d="M14.5 5.2v2.2M20.8 13.5h-2.2M19 8.2l-1.6 1.6M8.6 6.4l1.5 1.7M5 14h2.2"/></svg>')
    dart = svg.replace('\\', r'\\').replace("'", "\\'").replace('$', r'\$')
    entry = "  'i-sun': '" + dart + "',\n  };"
    t = t.replace('  };', entry, 1)
    open(p, 'w', encoding='utf-8').write(t)
    print('i-sun appended')

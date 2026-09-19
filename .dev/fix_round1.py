"""Round-1 fixes: row alignment, uppercase kind, SubHeader backIcon, rail badIndex."""
import os

# ---------- 1) 共享 LedgerRow:Spacer+Flexible → Expanded 右对齐 ----------
p = r'E:\projects\zchain_wallet\lib\design\widgets.dart'
t = open(p, encoding='utf-8').read()
old = '''          const Spacer(),
          Flexible(
            child: Text(
              valueText,
              textAlign: TextAlign.right,'''
new = '''          Expanded(
            child: Text(
              valueText,
              textAlign: TextAlign.right,'''
assert old in t, 'LedgerRow pattern not found'
t = t.replace(old, new)

# ---------- 2) DashHeader kind 大写 ----------
t = t.replace(
    'Text(kind, style: ZcType.section(context, color: c.ink3)),',
    "Text(kind.toUpperCase(), style: ZcType.section(context, color: c.ink3)),")

# ---------- 3) SubHeader backIcon 参数 ----------
t = t.replace('''  const SubHeader({super.key, required this.title, this.trailing});
  final String title;
  final Widget? trailing;''',
'''  const SubHeader({
    super.key,
    required this.title,
    this.trailing,
    this.backIcon = 'i-back',
  });
  final String title;
  final Widget? trailing;

  /// 返回键图标(签名请求类页面用关闭 X)
  final String backIcon;''')
t = t.replace('''              SquareIconButton(
                icon: 'i-back',
                onTap: () => ZcNav.back(context),
              ),''',
'''              SquareIconButton(
                icon: backIcon,
                onTap: () => ZcNav.back(context),
              ),''')

# ---------- 4) FinalityRail badIndex ----------
t = t.replace('''  const FinalityRail({
    super.key,
    this.states = const <String>['pending', 'soft', 'proven', 'finalized'],
    this.current = 2,
    this.caption,
    this.captionAction,
    this.onAction,
  });

  final List<String> states;
  final int current; // 当前停留节点(之前的为 done)''',
'''  const FinalityRail({
    super.key,
    this.states = const <String>['pending', 'soft', 'proven', 'finalized'],
    this.current = 2,
    this.badIndex,
    this.caption,
    this.captionAction,
    this.onAction,
  });

  final List<String> states;
  final int current; // 当前停留节点(之前的为 done)

  /// 卡住/未达标的节点(红色,如 fail-closed 提现预览的 proven)
  final int? badIndex;''')
t = t.replace('''      final bool done = i < current;
      final bool cur = i == current;
      final Color sq = done ? c.felt : (cur ? c.amb : c.cd);
      final Color bd = done ? c.felt : (cur ? c.amb : c.rl2);
      final Color lb = done ? c.felt : (cur ? c.amb : c.ink3);''',
'''      final bool done = i < current;
      final bool cur = i == current;
      final bool bad = badIndex != null && i == badIndex;
      final Color sq = bad
          ? c.bad
          : done
          ? c.felt
          : cur
          ? c.amb
          : c.cd;
      final Color bd = bad
          ? c.bad
          : done
          ? c.felt
          : cur
          ? c.amb
          : c.rl2;
      final Color lb = bad
          ? c.bad
          : done
          ? c.felt
          : cur
          ? c.amb
          : c.ink3;''')
t = t.replace('''                      weight: cur ? FontWeight.w600 : FontWeight.w400,''',
'''                      weight: (cur || bad) ? FontWeight.w600 : FontWeight.w400,''')
open(p, 'w', encoding='utf-8').write(t)
print('widgets.dart patched')


def patch(path, pairs):
    t = open(path, encoding='utf-8').read()
    for old_s, new_s in pairs:
        if old_s not in t:
            print('  !! pattern missing in', os.path.basename(path))
            continue
        t = t.replace(old_s, new_s)
    open(path, 'w', encoding='utf-8').write(t)
    print('patched', os.path.basename(path))


# ---------- 5) s11 _Lr(值为 Widget 列表) ----------
patch(r'E:\projects\zchain_wallet\lib\screens\s11_zc_confirm.dart', [(
'''          const Spacer(),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (int i = 0; i < value.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(width: 5),
                  value[i],
                ],
              ],
            ),
          ),''',
'''          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                for (int i = 0; i < value.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(width: 5),
                  value[i],
                ],
              ],
            ),
          ),''')])

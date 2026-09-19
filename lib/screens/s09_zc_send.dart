// 屏幕 09 · 转账 · 贪心选币(zc-send)
// 设计:Pixso「设计文件」09-zc-send —— GAME 域 PLAY 转账:大号等宽金额输入、
// 收款 owner、贪心选币明细(小面额优先,显示按面额降序)、网关代付费用行、
// 凭证条与确认按钮;子页,无底部 Tab。
import 'package:flutter/material.dart';

import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

/// GAME 域 PLAY note(DemoNet 演示票据;合计 12,400.00 = 可用余额)
class _ZcNote {
  const _ZcNote(this.hash, this.value, this.label);

  final String hash;
  final double value;
  final String label; // 展示用金额(与设计稿一致)
}

class ZcSendScreen extends StatefulWidget {
  const ZcSendScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const ZcSendScreen();

  @override
  State<ZcSendScreen> createState() => _ZcSendScreenState();
}

class _ZcSendScreenState extends State<ZcSendScreen> {
  static const double _available = 12400.00;

  /// note 池(升序);默认金额 500.00 时贪心命中 300 + 200,与设计稿一致
  static const List<_ZcNote> _pool = <_ZcNote>[
    _ZcNote('91c7…e03a', 200.00, '200.00'),
    _ZcNote('4f2a…c19d', 300.00, '300.00'),
    _ZcNote('c41d…4a02', 500.00, '500.00'),
    _ZcNote('8e55…d3c1', 1000.00, '1,000.00'),
    _ZcNote('2b90…77ee', 2000.00, '2,000.00'),
    _ZcNote('f0a3…19bc', 4000.00, '4,000.00'),
    _ZcNote('a6d1…5e70', 4400.00, '4,400.00'),
  ];

  final TextEditingController _amt = TextEditingController(text: '500.00');

  @override
  void initState() {
    super.initState();
    _amt.addListener(_refresh);
  }

  @override
  void dispose() {
    _amt.removeListener(_refresh);
    _amt.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  /// 贪心选币:小面额优先累加至覆盖金额,展示按面额降序(与设计稿同序)
  static (List<_ZcNote>, double) _select(double? amount) {
    if (amount == null || amount <= 0) {
      return (<_ZcNote>[], 0);
    }
    final List<_ZcNote> picked = <_ZcNote>[];
    double sum = 0;
    for (final _ZcNote n in _pool) {
      if (sum >= amount) break;
      picked.add(n);
      sum += n.value;
    }
    picked.sort((_ZcNote a, _ZcNote b) => b.value.compareTo(a.value));
    return (picked, sum - amount);
  }

  static double? _parse(String text) =>
      double.tryParse(text.replaceAll(',', '').trim());

  static String _fmt(double v) {
    final List<String> parts = v.toStringAsFixed(2).split('.');
    final String intPart = parts[0];
    final StringBuffer buf = StringBuffer();
    for (int i = 0; i < intPart.length; i++) {
      buf.write(intPart[i]);
      final int rest = intPart.length - i - 1;
      if (rest > 0 && rest % 3 == 0) buf.write(',');
    }
    return '${buf.toString()}.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    final double? amount = _parse(_amt.text);
    final (List<_ZcNote> picked, double change) = _select(amount);
    final bool overflow = amount != null && amount > _available;
    return ZcScreen(
      header: SubHeader(
        title: '转账',
        trailing: ZcChip('GAME', tone: 'play', xs: true),
      ),
      body: ZcBody(
        children: <Widget>[
          _amountField(context, c),
          _ownerField(context, c),
          if (overflow) ...<Widget>[
            NoticeBanner(
              '金额超出可用',
              'GAME 域可用 12,400.00 PLAY,请调低转账金额。',
              tone: 'bad',
            ),
            Gap(),
          ],
          LedgerCard(
            header: '贪心选币 · 消耗 ${picked.length} 张 NOTE',
            child: picked.isEmpty
                ? const ZcEmpty('输入金额后自动贪心选币')
                : Column(
                    children: <Widget>[
                      for (int i = 0; i < picked.length; i++)
                        _lr(
                          context,
                          keyText: picked[i].hash,
                          keyMono: true,
                          keyMax: 96,
                          value: <Widget>[
                            _mono(context, picked[i].label),
                            ZcChip('proven', tone: 'felt', xs: true),
                          ],
                        ),
                      _lr(
                        context,
                        keyText: '找零 note',
                        last: true,
                        value: <Widget>[
                          _mono(
                            context,
                            change == 0 ? '0.00(本次无找零)' : '${_fmt(change)}(找零)',
                            color: c.ink3,
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          Gap(),
          LedgerCard(
            child: Column(
              children: <Widget>[
                _lr(
                  context,
                  keyText: '网络费',
                  value: <Widget>[
                    _mono(context, '网关代付'),
                    ZcChip('免费', tone: 'felt', xs: true),
                  ],
                ),
                _lr(
                  context,
                  keyText: '回执路径',
                  last: true,
                  value: <Widget>[
                    _mono(context, 'signed → seen → included', color: c.ink3),
                  ],
                ),
              ],
            ),
          ),
          Gap(),
          LedgerCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: FinalityRail(
              current: 2,
              caption: Text.rich(
                TextSpan(
                  style: ZcType.ui(context, size: 10.5, color: c.ink2),
                  children: <InlineSpan>[
                    const TextSpan(text: '支出 note 短板 '),
                    TextSpan(
                      text: 'proven',
                      style: ZcType.ui(
                        context,
                        size: 10.5,
                        weight: FontWeight.w700,
                        color: c.ink,
                      ),
                    ),
                    const TextSpan(text: ' · 满足 GAME 域要求'),
                  ],
                ),
              ),
            ),
          ),
          Gap(),
          ZcButton(
            '确认转账',
            variant: 'p',
            onTap: () => _confirm(amount, overflow),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              '提交后可在「证明 → 回执」跟踪 inclusion 状态',
              textAlign: TextAlign.center,
              style: ZcType.ui(context, size: 10.5, color: c.ink3),
            ),
          ),
        ],
      ),
    );
  }

  void _confirm(double? amount, bool overflow) {
    if (amount == null || amount <= 0) {
      ZcScope.state(context).showToast('示意:请输入有效金额');
      return;
    }
    if (overflow) {
      ZcScope.state(context).showToast('示意:金额超过可用余额 12,400.00');
      return;
    }
    ZcScope.state(context).showToast('已签名并提交 · 回执 0xc41d…9b');
  }

  // ---- 表单(等价 .fld / .fl / .inp-amt / .tsel / .in-ic) ----

  Widget _amountField(BuildContext context, ZcPalette c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '金额',
                style: ZcType.mono(context, size: 11, ls: 0.55, color: c.ink2),
              ),
              const Spacer(),
              Text(
                '可用 12,400.00 · ',
                style: ZcType.mono(context, size: 10.5, color: c.ink3),
              ),
              InkWell(
                onTap: () => _amt.text = _fmt(_available),
                child: Text(
                  'MAX',
                  style: ZcType.mono(
                    context,
                    size: 10.5,
                    color: c.felt,
                  ).copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Stack(
            children: <Widget>[
              TextField(
                controller: _amt,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: ZcType.mono(
                  context,
                  size: 24,
                  weight: FontWeight.w600,
                  ls: -0.3,
                  color: c.ink,
                ),
                decoration: _inputDecoration(
                  c,
                  contentPadding: const EdgeInsets.fromLTRB(12, 10, 96, 10),
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: _tokenSelector(
                  context,
                  c,
                  letter: 'P',
                  name: 'PLAY',
                  tone: 'play',
                  toast: '示意:GAME 域仅 PLAY 可转',
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              '测试筹码 · 不计价',
              style: ZcType.mono(context, size: 10.5, color: c.ink3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ownerField(BuildContext context, ZcPalette c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            '收款 OWNER',
            style: ZcType.mono(context, size: 11, ls: 0.55, color: c.ink2),
          ),
          const SizedBox(height: 5),
          Stack(
            children: <Widget>[
              TextField(
                style: ZcType.mono(context, size: 11.5, color: c.ink),
                decoration: _inputDecoration(
                  c,
                  hint: '0x… / zc1q…',
                  contentPadding: const EdgeInsets.fromLTRB(12, 13, 74, 13),
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Row(
                  children: <Widget>[
                    SquareIconButton(
                      icon: 'i-copy',
                      tooltip: '粘贴',
                      onTap: () => ZcScope.state(context).showToast('已粘贴'),
                    ),
                    const SizedBox(width: 3),
                    SquareIconButton(
                      icon: 'i-qr',
                      tooltip: '扫码',
                      onTap: () => ZcScope.state(context).showToast('示意:扫码'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 资产选择钮(tsel):小瓦片 + 符号 + 下拉箭头
  static Widget _tokenSelector(
    BuildContext context,
    ZcPalette c, {
    required String letter,
    required String name,
    required String tone,
    required String toast,
  }) {
    Color fg = c.ink2;
    Color bg = c.cd2;
    Color bd = c.rl2;
    if (tone == 'play') {
      fg = c.play;
      bg = c.playW;
      bd = c.playRl;
    }
    if (tone == 'real') {
      fg = c.real;
      bg = c.realW;
      bd = c.realRl;
    }
    return Material(
      color: c.pg2,
      borderRadius: BorderRadius.circular(2),
      child: InkWell(
        onTap: () => ZcScope.state(context).showToast(toast),
        borderRadius: BorderRadius.circular(2),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            border: Border.all(color: c.rl2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: bg,
                  border: Border.all(color: bd),
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: ZcType.mono(
                    context,
                    size: 9,
                    weight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                name,
                style: ZcType.mono(
                  context,
                  size: 11,
                  weight: FontWeight.w600,
                  color: c.ink,
                ),
              ),
              const SizedBox(width: 4),
              ZcIcons.icon('i-chev-d', size: 11, color: c.ink3),
            ],
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(
    ZcPalette c, {
    String? hint,
    required EdgeInsetsGeometry contentPadding,
  }) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: c.cd,
      hintText: hint,
      hintStyle: ZcType.ui(null, size: 11.5, color: c.ink3),
      contentPadding: contentPadding,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ZcPalette.rS),
        borderSide: BorderSide(color: c.rl2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(ZcPalette.rS),
        borderSide: BorderSide(color: c.ink),
      ),
    );
  }

  // ---- 账簿行(等价 .lr;值为 文本/徽章 组合,末行可去底线) ----

  static Widget _lr(
    BuildContext context, {
    required String keyText,
    required List<Widget> value,
    bool keyMono = false,
    double keyMax = 160,
    bool last = false,
  }) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: last
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: c.rl)),
            ),
      child: Row(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: keyMax),
            child: Text(
              keyText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: keyMono
                  ? ZcType.mono(context, size: 11, color: c.ink2)
                  : ZcType.ui(context, size: 12.5, color: c.ink2),
            ),
          ),
          const Spacer(),
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
          ),
        ],
      ),
    );
  }

  static Widget _mono(BuildContext context, String text, {Color? color}) {
    final ZcPalette c = ZcScope.of(context);
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: ZcType.mono(context, size: 12.5, color: color ?? c.ink),
    );
  }
}

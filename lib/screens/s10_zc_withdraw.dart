// 屏幕 10 · REAL 提现预览 · fail-closed(zc-withdraw)
// 设计:Pixso「设计文件」10-zc-withdraw —— REAL 域 NATIVE 提现预览:金色
// 托管警示、提现金额/收款 owner、贪心选币(3 张 note,最弱凭证 soft)、
// finality 检查与「暂不可提交」原因;fail-closed:提交入口禁用(虚线笔触);
// 子页,无底部 Tab。
import 'package:flutter/material.dart';

import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class ZcWithdrawScreen extends StatefulWidget {
  const ZcWithdrawScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const ZcWithdrawScreen();

  @override
  State<ZcWithdrawScreen> createState() => _ZcWithdrawScreenState();
}

class _ZcWithdrawScreenState extends State<ZcWithdrawScreen> {
  final TextEditingController _amt = TextEditingController(text: '5,000.00');

  @override
  void dispose() {
    _amt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: SubHeader(
        title: '提现(预览)',
        trailing: ZcChip('REAL', tone: 'real', xs: true),
      ),
      body: ZcBody(
        children: <Widget>[
          // 托管警示(REAL 区块必带托管提示)
          NoticeBanner(
            '托管警示',
            'REAL 域由运营方托管映射。以下为模拟预览,不会提交任何链上交易。',
            tone: 'real',
          ),
          Gap(),
          _amountField(context, c),
          _ownerField(context, c),
          LedgerCard(
            header: '贪心选币 · 3 张 NOTE',
            child: Column(
              children: <Widget>[
                _lr(
                  context,
                  keyText: '77b1…04dd',
                  keyMono: true,
                  keyMax: 88,
                  value: <Widget>[
                    _mono(context, '1,000.00'),
                    ZcChip('proven', tone: 'felt', xs: true),
                  ],
                ),
                _lr(
                  context,
                  keyText: 'c93e…5f10',
                  keyMono: true,
                  keyMax: 88,
                  value: <Widget>[
                    _mono(context, '2,500.00'),
                    ZcChip('proven', tone: 'felt', xs: true),
                  ],
                ),
                _lr(
                  context,
                  keyText: 'a208…91ce',
                  keyMono: true,
                  keyMax: 88,
                  value: <Widget>[
                    _mono(context, '1,500.00'),
                    ZcChip('soft', tone: 'amb', xs: true),
                  ],
                ),
                _lr(
                  context,
                  keyText: '找零 note',
                  last: true,
                  value: <Widget>[
                    _mono(context, '0.00(合计恰好 5,000.00)', color: c.ink3),
                  ],
                ),
              ],
            ),
          ),
          Gap(),
          // finality 检查(卡头带「?」入口;凭证条卡在 proven:最弱 note 仅 soft)
          LedgerCard(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: c.rl)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'FINALITY 检查',
                        style: ZcType.section(context, color: c.ink3),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () =>
                            ZcScope.state(context).showToast('示意:凭证阶梯说明'),
                        child: Text(
                          '?',
                          style: ZcType.mono(context, size: 10, color: c.felt),
                        ),
                      ),
                    ],
                  ),
                ),
                FinalityRail(current: 2, badIndex: 2),
                Container(
                  margin: const EdgeInsets.only(top: 9),
                  child: Column(
                    children: <Widget>[
                      _lr(
                        context,
                        keyText: '所需证明',
                        value: <Widget>[_mono(context, 'finalized')],
                      ),
                      _lr(
                        context,
                        keyText: '最弱凭证',
                        last: true,
                        value: <Widget>[
                          _mono(context, 'soft(1 张 note 未达标)', color: c.amb),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(),
          LedgerCard(
            header: '暂不可提交 · 原因',
            child: Column(
              children: <Widget>[
                _reason(context, c, '提现通道未开放(v1 托管模式)'),
                _reason(context, c, '1 张 note 的证明未达 finalized'),
                _reason(context, c, '托管方签名服务待接入', tone: 'real'),
              ],
            ),
          ),
          Gap(),
          _disabledButton(context, c),
          Container(
            padding: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Text(
              'fail-closed:原因消除前,提交入口保持禁用(虚线即「不可用」的专用笔触)',
              textAlign: TextAlign.center,
              style: ZcType.ui(context, size: 10.5, color: c.ink3),
            ),
          ),
        ],
      ),
    );
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
                '提现金额',
                style: ZcType.mono(context, size: 11, ls: 0.55, color: c.ink2),
              ),
              const Spacer(),
              Text(
                'REAL 可用 10,000.00',
                style: ZcType.mono(context, size: 10.5, color: c.ink3),
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
                  letter: 'N',
                  name: 'NATIVE',
                  toast: '示意:REAL 域提现仅支持 NATIVE',
                ),
              ),
            ],
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
            '收款 OWNER(L1 地址)',
            style: ZcType.mono(context, size: 11, ls: 0.55, color: c.ink2),
          ),
          const SizedBox(height: 5),
          Stack(
            children: <Widget>[
              TextField(
                style: ZcType.mono(context, size: 11.5, color: c.ink),
                decoration: _inputDecoration(
                  c,
                  hint: '0x…',
                  contentPadding: const EdgeInsets.fromLTRB(12, 13, 44, 13),
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: SquareIconButton(
                  icon: 'i-copy',
                  tooltip: '粘贴',
                  onTap: () => ZcScope.state(context).showToast('已粘贴'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 资产选择钮(tsel):小瓦片 + 符号 + 下拉箭头(REAL 域金色)
  static Widget _tokenSelector(
    BuildContext context,
    ZcPalette c, {
    required String letter,
    required String name,
    required String toast,
  }) {
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
                  color: c.realW,
                  border: Border.all(color: c.realRl),
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.center,
                child: Text(
                  letter,
                  style: ZcType.mono(
                    context,
                    size: 9,
                    weight: FontWeight.w700,
                    color: c.real,
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

  // ---- 账簿行(等价 .lr;末行可去底线) ----

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

  /// 原因行(等价 .rsn):i-x 图标 + 说明;托管项用金墨
  static Widget _reason(
    BuildContext context,
    ZcPalette c,
    String text, {
    String tone = 'bad',
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ZcIcons.icon('i-x', size: 14, color: tone == 'real' ? c.real : c.bad),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: ZcType.ui(context, size: 11.5, color: c.ink2),
            ),
          ),
        ],
      ),
    );
  }

  /// 禁用提交钮:pg-2 底 + rl-2 虚线(「不可用」的专用笔触)+ ink-3 文字
  static Widget _disabledButton(BuildContext context, ZcPalette c) {
    return CustomPaint(
      foregroundPainter: _DashedRectPainter(c.rl2),
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: c.pg2,
          borderRadius: BorderRadius.circular(ZcPalette.rS),
        ),
        child: Text(
          '提交提现',
          style: ZcType.ui(
            context,
            size: 13,
            weight: FontWeight.w600,
            color: c.ink3,
          ),
        ),
      ),
    );
  }
}

/// 虚线描边(fail-closed 禁用态的专用笔触)
class _DashedRectPainter extends CustomPainter {
  const _DashedRectPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final Path rect = Path()
      ..addRect(Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1));
    const double dash = 4;
    const double gap = 3;
    for (final m in rect.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        final double end = d + dash > m.length ? m.length : d + dash;
        canvas.drawPath(m.extractPath(d, end), p);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter old) => old.color != color;
}

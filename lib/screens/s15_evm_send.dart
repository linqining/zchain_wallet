// 屏幕 15 · 发送 · 交易预览(evm-send)
// 设计:Pixso「设计文件」15 —— EVM 层转账:大号等宽金额输入(Ξ ETH 选择钮)、
// 收款地址(粘贴/扫码)、交易预览卡(eth_sendTransaction 字段明细 + chainId
// 校验徽章)、bad 提示条与「确认签名并发送」;子页,无底部 Tab。
import 'package:flutter/material.dart';

import '../data/demo.dart';
import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class EvmSendScreen extends StatefulWidget {
  const EvmSendScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const EvmSendScreen();

  @override
  State<EvmSendScreen> createState() => _EvmSendScreenState();
}

class _EvmSendScreenState extends State<EvmSendScreen> {
  /// 可用余额(与设计稿 / evm-dash 资产卡同源)
  static const double _available = 2.4183;

  /// 演示汇率:0.25 ETH ≈ $840.12(与设计稿一致)
  static const double _ethUsd = 3360.48;

  final TextEditingController _amt = TextEditingController(text: '0.25');

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

  static double? _parse(String text) =>
      double.tryParse(text.replaceAll(',', '').trim());

  /// fiat 折算(两位小数 + 千分位)
  static String _fmtUsd(double v) {
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
    return ZcScreen(
      header: SubHeader(
        title: '发送',
        trailing: const ZcChip('ETHEREUM', xs: true),
      ),
      body: ZcBody(
        children: <Widget>[
          _amountField(context, c),
          _addressField(context, c),
          _previewCard(context, amount),
          Gap(),
          NoticeBanner('发送后不可撤销', '请核对地址与金额;chainId 不符时交易将被拒绝签名。', tone: 'bad'),
          Gap(),
          ZcButton(
            '确认签名并发送',
            variant: 'p',
            onTap: () => ZcScope.state(context).showToast('已签名并广播 · 0x8f3a…c2'),
          ),
        ],
      ),
    );
  }

  // ---- 表单(等价 .fld / .fl / .inp-amt / .tsel / .in-ic) ----

  Widget _amountField(BuildContext context, ZcPalette c) {
    final double? amount = _parse(_amt.text);
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                '金额',
                style: ZcType.mono(context, size: 11, ls: 0.55, color: c.ink2),
              ),
              const Spacer(),
              Text(
                '可用 2.4183 · ',
                style: ZcType.mono(context, size: 10.5, color: c.ink3),
              ),
              InkWell(
                onTap: () => _amt.text = _available.toString(),
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
              Positioned(right: 6, top: 6, child: _tokenSelector(context, c)),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Text(
              amount == null
                  ? '≈ — · gas price 12 gwei'
                  : '≈ \$${_fmtUsd(amount * _ethUsd)} · gas price 12 gwei',
              style: ZcType.mono(context, size: 10.5, color: c.ink3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressField(BuildContext context, ZcPalette c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            '收款地址',
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

  /// 资产选择钮(tsel):Ξ 瓦片 + ETH + 下拉箭头
  static Widget _tokenSelector(BuildContext context, ZcPalette c) {
    return Material(
      color: c.pg2,
      borderRadius: BorderRadius.circular(2),
      child: InkWell(
        onTap: () => ZcScope.state(context).showToast('示意:仅支持 ETH 转账'),
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
                  color: c.cd2,
                  border: Border.all(color: c.rl2),
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Ξ',
                  style: ZcType.mono(
                    context,
                    size: 10,
                    weight: FontWeight.w700,
                    color: c.ink2,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'ETH',
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

  // ---- 交易预览卡(等价 cd-h「交易预览」+ more eth_sendTransaction + .lr 行) ----

  Widget _previewCard(BuildContext context, double? amount) {
    return LedgerCard(
      header: '交易预览',
      moreLabel: 'eth_sendTransaction',
      child: Column(
        children: <Widget>[
          _lr(context, keyText: 'from', value: DemoData.layers[1].addr),
          _lr(context, keyText: 'to', value: '0x8f3a…d7e2'),
          _lr(
            context,
            keyText: 'value',
            value: amount == null ? '—' : '${_amt.text.trim()} ETH',
          ),
          _lr(context, keyText: 'gas limit', value: '21,000(EIP-155)'),
          _lr(context, keyText: '预估手续费', value: '0.000252 ETH ≈ \$0.85'),
          _lr(
            context,
            keyText: 'chainId',
            last: true,
            value: '1',
            chip: const ZcChip('校验通过', tone: 'felt', xs: true),
          ),
        ],
      ),
    );
  }

  /// 账簿行(等价 .lr;值为 等宽文本 + 可选徽章,末行可去底线)
  static Widget _lr(
    BuildContext context, {
    required String keyText,
    required String value,
    Widget? chip,
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
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              keyText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ZcType.ui(context, size: 12.5, color: c.ink2),
            ),
          ),
          const Spacer(),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ZcType.mono(context, size: 12.5, color: c.ink),
                  ),
                ),
                if (chip != null) ...<Widget>[const SizedBox(width: 5), chip],
              ],
            ),
          ),
        ],
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
}

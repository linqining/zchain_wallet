// 屏幕 14 · 回执状态机(zc-receipts)
// 设计:Pixso「设计文件」14-zc-receipts —— 交易回执列表:signed→seen→included
// 徽章行、全部/签名中/已上链 ink 实底筛选段控、超出 deadline 行的 ForceInclude
// 禁用按钮(仅展示协议状态,不实现提交)、底部状态机说明;子页,无底部 Tab。
import 'package:flutter/material.dart';

import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class ZcReceiptsScreen extends StatefulWidget {
  const ZcReceiptsScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const ZcReceiptsScreen();

  @override
  State<ZcReceiptsScreen> createState() => _ZcReceiptsScreenState();
}

class _ZcReceiptsScreenState extends State<ZcReceiptsScreen> {
  static const List<String> _segLabels = <String>['全部', '签名中', '已上链'];

  /// 0=全部 1=签名中 2=已上链(与设计稿分 pane 一致:签名中仅 signed,
  /// 已上链仅 included;seen 只出现在「全部」)
  int _seg = 0;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: SubHeader(title: '交易回执', trailing: _stateChip()),
      body: ZcBody(
        children: <Widget>[_segControl(context, c), _pane(context, c)],
      ),
    );
  }

  /// 子页栏右侧状态机徽章;sub-s 槽位仅 66px 宽,用 OverflowBox 让宽徽章
  /// 右对齐向左溢出(与设计稿一致,不挤压居中标题)。
  Widget _stateChip() {
    return OverflowBox(
      alignment: Alignment.centerRight,
      maxWidth: double.infinity,
      child: const ZcChip('SIGNED→SEEN→INCLUDED', xs: true),
    );
  }

  // ---- 筛选段控(seg:ink 实底选中格) ----

  Widget _segControl(BuildContext context, ZcPalette c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: c.rl2,
        border: Border.all(color: c.rl2),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: <Widget>[
          for (int i = 0; i < _segLabels.length; i++) ...<Widget>[
            if (i > 0) Container(width: 1, color: c.rl2),
            Expanded(child: _segCell(context, c, i)),
          ],
        ],
      ),
    );
  }

  Widget _segCell(BuildContext context, ZcPalette c, int i) {
    final bool on = _seg == i;
    return Material(
      color: on ? c.ink : c.cd,
      child: InkWell(
        onTap: () => setState(() => _seg = i),
        child: Container(
          height: 32,
          alignment: Alignment.center,
          child: Text(
            _segLabels[i],
            style: ZcType.mono(
              context,
              size: 11.5,
              ls: 0.35,
              weight: on ? FontWeight.w600 : FontWeight.w400,
              color: on ? c.onInk : c.ink2,
            ),
          ),
        ),
      ),
    );
  }

  // ---- 回执列表(按段控分 pane) ----

  Widget _pane(BuildContext context, ZcPalette c) {
    final List<Widget> rows;
    switch (_seg) {
      case 1:
        rows = <Widget>[
          const TxRow(
            icon: 'i-clock',
            tone: 'warn',
            name: '开桌签名 · 8♠ 桌',
            sub: '0x77d0…31 · 92s 后过期',
            amount: '-500.00',
            status: 'SIGNED',
            statusTone: 'amb',
          ),
        ];
      case 2:
        rows = <Widget>[
          const TxRow(
            icon: 'i-check',
            tone: 'ok',
            name: '买入 · 8♠ 桌',
            sub: '0xc41d…9b · 2 分钟前',
            amount: '-500.00',
            status: 'INCLUDED',
            statusTone: 'felt',
          ),
          const TxRow(
            icon: 'i-check',
            tone: 'ok',
            name: '转账 · 收款人 0x8f…d7',
            sub: '0x9a02…ef · 1 小时前',
            amount: '-200.00',
            status: 'INCLUDED',
            statusTone: 'felt',
          ),
        ];
      default:
        rows = <Widget>[
          const TxRow(
            icon: 'i-clock',
            tone: 'warn',
            name: '开桌签名 · 8♠ 桌',
            sub: '0x77d0…31 · 92s 后过期',
            amount: '-500.00',
            status: 'SIGNED',
            statusTone: 'amb',
          ),
          const TxRow(
            icon: 'i-receipt',
            tone: 'blue',
            name: '结算 · 8♠ 桌 #128',
            sub: '0x3f9e…aa · 刚刚',
            amount: '+620.50',
            amountTone: 'pos',
            status: 'SEEN',
            statusTone: 'play',
          ),
          const TxRow(
            icon: 'i-check',
            tone: 'ok',
            name: '买入 · 8♠ 桌',
            sub: '0xc41d…9b · 2 分钟前',
            amount: '-500.00',
            status: 'INCLUDED',
            statusTone: 'felt',
          ),
          const TxRow(
            icon: 'i-check',
            tone: 'ok',
            name: '转账 · 收款人 0x8f…d7',
            sub: '0x9a02…ef · 1 小时前',
            amount: '-200.00',
            status: 'INCLUDED',
            statusTone: 'felt',
          ),
          _forceRow(context, c),
        ];
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LedgerCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          child: Column(children: rows),
        ),
        // 状态机说明(仅「全部」pane,与设计稿一致)
        if (_seg == 0) _stateNote(context, c),
      ],
    );
  }

  /// 超出 deadline 行:金额 + 禁用的 ForceInclude 幽灵按钮
  /// (btn btn-g btn-sm[disabled]:灰底虚线框、42% 透明,不可点)。
  Widget _forceRow(BuildContext context, ZcPalette c) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: <Widget>[
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: c.badW,
              border: Border.all(color: c.badRl),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.center,
            child: ZcIcons.icon('i-warn', size: 13, color: c.bad),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '结算 · 9♣ 桌 #96',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZcType.ui(
                    context,
                    size: 12.5,
                    weight: FontWeight.w600,
                  ),
                ),
                Text(
                  '0x51b7…c8 · 超出 deadline',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZcType.mono(context, size: 10.5, color: c.ink3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '+88.00',
                style: ZcType.mono(
                  context,
                  size: 13,
                  weight: FontWeight.w600,
                  color: c.felt,
                ),
              ),
              const SizedBox(height: 3),
              Opacity(
                opacity: 0.42,
                child: Tooltip(
                  message: '仅展示协议状态,ForceInclude 提交路径未实现',
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: c.pg2,
                      border: Border.all(color: c.rl2),
                      borderRadius: BorderRadius.circular(ZcPalette.rS),
                    ),
                    child: Text(
                      'ForceInclude 未开放',
                      style: ZcType.ui(context, size: 12, color: c.ink3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 状态机说明(hint-s):signed → seen → included 单向推进,与凭证阶梯
  /// 是两套独立状态;红色加粗为「只展示状态、不实现提交」。
  Widget _stateNote(BuildContext context, ZcPalette c) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      child: Text.rich(
        TextSpan(
          style: ZcType.ui(context, size: 10.5, height: 1.7, color: c.ink3),
          children: <InlineSpan>[
            const TextSpan(
              text:
                  '回执状态机 signed → seen → included 单向推进,与凭证阶梯 '
                  'pending → proven → finalized 是两套独立状态,不得混用同一种笔触。'
                  '超出 deadline(10s)时提示存在 ForceInclude 协议路径,但当前版本',
            ),
            TextSpan(
              text: '只展示状态、不实现提交',
              style: TextStyle(fontWeight: FontWeight.w700, color: c.bad),
            ),
            const TextSpan(text: '——按钮保持禁用;evidence 按网关返回如实展示,未验签就写未验签。'),
          ],
        ),
      ),
    );
  }
}

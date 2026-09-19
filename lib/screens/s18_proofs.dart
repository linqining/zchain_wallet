// 屏幕 18 · 凭证簿(proofs)
// 设计:Pixso「设计文件」18 —— v2 新增屏:本机凭证簿。抬头(kind=PROOFS +
// engine stwo 网络胶囊;印章「独立可验」+ 锁定钮)下依次为:凭证分布卡
// (阶梯凭证条 + 达标统计)、待复验清单、已复验凭证明细、本地复验说明;
// 底部 Tab「证明」。
import 'package:flutter/material.dart';

import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class ProofsScreen extends StatelessWidget {
  const ProofsScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const ProofsScreen();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: DashHeaderBlock(header: const _ProofsHeader()),
      body: ZcBody(
        children: <Widget>[
          LedgerCard(
            header: '凭证分布',
            moreLabel: '阶梯',
            onMore: () => ZcScope.state(context).showToast('示意:阶梯说明'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const FinalityRail(current: 3),
                Container(
                  margin: const EdgeInsets.only(top: 9),
                  child: LedgerRow(
                    '4 份已达 finalized',
                    '可提现',
                    valueColor: c.felt,
                  ),
                ),
                _Lr(
                  '1 份停在 soft',
                  valueText: '未达 REAL 门槛',
                  valueColor: c.amb,
                  last: true,
                ),
              ],
            ),
          ),
          const SectionTitle('待复验'),
          LedgerCard(
            tight: true,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: <Widget>[
                MenuRow(
                  icon: 'i-shield',
                  tone: 'amb',
                  title: '8♠ 桌 #128 · 结算',
                  subtitle: '0x3f9e…aa · seen 未 included',
                  onTap: () => ZcNav.go(context, 'zc-portal'),
                ),
                MenuRow(
                  icon: 'i-bolt',
                  title: '9♣ 桌 #96 · 超期回执',
                  subtitle: '0x51b7…c8 · 可 ForceInclude',
                  onTap: () => ZcNav.go(context, 'zc-portal'),
                ),
              ],
            ),
          ),
          const SectionTitle('已复验'),
          LedgerCard(
            tight: true,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: <Widget>[
                _Lr('8♠ 桌 #127', value: const Seal('verified')),
                const LedgerRow('校验耗时', '1.72s(浏览器内 stwo)', dim: true),
                const _Lr('payout_root', valueText: '0x8c3f…d210', last: true),
              ],
            ),
          ),
          const Gap(),
          const NoticeBanner(
            '验证在本地完成',
            '证明文件与结算明细由网关拉取,复验在 wallet-core(wasm)本地执行;不依赖服务端「已验证」结论。',
            tone: 'info',
            icon: 'i-info',
          ),
          const Gap(),
          Align(
            alignment: Alignment.centerLeft,
            child: RichText(
              text: TextSpan(
                style: ZcType.ui(null, size: 10.5, color: c.ink3),
                children: <InlineSpan>[
                  const TextSpan(text: '阶梯是'),
                  TextSpan(
                    text: '凭证',
                    style: ZcType.ui(
                      null,
                      size: 10.5,
                      weight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                  const TextSpan(
                    text: '状态(锚定在 note 上);回执的 signed → seen → included 是',
                  ),
                  TextSpan(
                    text: '投递',
                    style: ZcType.ui(
                      null,
                      size: 10.5,
                      weight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                  const TextSpan(text: '状态。两者在 DS-07 里刻意用了不同笔触。'),
                ],
              ),
            ),
          ),
        ],
      ),
      tabs: 'proofs',
    );
  }
}

/// 抬头(等价 .dh):kind + 网络胶囊;印章 + 标题/副题 + 锁定钮。
class _ProofsHeader extends StatelessWidget {
  const _ProofsHeader();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      decoration: BoxDecoration(color: c.cd),
      padding: const EdgeInsets.fromLTRB(14, 9, 14, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 20,
            child: Row(
              children: <Widget>[
                Text('PROOFS', style: ZcType.section(context, color: c.ink3)),
                const SizedBox(width: 8),
                const NetPill('engine stwo'),
                const Spacer(),
                GroundToggleIconButton.bareButton(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 3, bottom: 10),
            child: Row(
              children: <Widget>[
                const Seal('独立可验'),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '本机凭证簿',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ZcType.ui(
                          context,
                          size: 13.5,
                          weight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '最近 24 小时 · 5 份结算证明',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ZcType.mono(context, size: 10.5, color: c.ink3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                SquareIconButton(
                  icon: 'i-lock',
                  tooltip: '锁定',
                  onTap: () => ZcNav.go(context, 'lock'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 账簿行变体(等价 .lr):值可为任意部件;末行可去底线。
class _Lr extends StatelessWidget {
  const _Lr(
    this.keyText, {
    this.value,
    this.valueText,
    this.valueColor,
    this.last = false,
  }) : assert(value != null || valueText != null);

  final String keyText;
  final Widget? value;
  final String? valueText;
  final Color? valueColor;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: last
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: c.rl)),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              keyText,
              overflow: TextOverflow.ellipsis,
              style: ZcType.ui(context, size: 12.5, color: c.ink2),
            ),
          ),
          Expanded(
            child: DefaultTextStyle.merge(
              textAlign: TextAlign.right,
              child: Align(
                alignment: Alignment.centerRight,
                child:
                    value ??
                    Text(
                      valueText!,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ZcType.mono(
                        context,
                        size: 12.5,
                        color: valueColor ?? c.ink,
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

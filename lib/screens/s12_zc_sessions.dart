// 屏幕 12 · 会话密钥 · SNIP-12(zc-sessions)
// 设计:Pixso「设计文件」12 —— 授权簿按 origin 记账:会话卡(dapp、
// scope 徽章、单笔/日累计限额、用量进度、状态徽章)、danger 撤销按钮;
// 分段切换「现有会话 / 新建草稿」;子页,无底部 Tab。
import 'package:flutter/material.dart';

import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class ZcSessionsScreen extends StatelessWidget {
  const ZcSessionsScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const ZcSessionsScreen();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: SubHeader(title: '会话密钥', trailing: ZcChip('SNIP-12', xs: true)),
      body: ZcBody(
        children: <Widget>[
          _segTabs(context, c),
          Gap(),
          _activeCard(context, c),
          Gap(),
          Opacity(opacity: 0.6, child: _exhaustedCard(context, c)),
          Gap(),
          Text(
            '授权簿按 origin 记账;撤销只影响该 origin 的委托密钥,不动主密钥。',
            style: ZcType.ui(context, size: 10.5, color: c.ink3),
          ),
        ],
      ),
    );
  }

  /// 分段切换(等价 .seg):v2 仅保留「现有会话」清单;「新建草稿」示意
  static Widget _segTabs(BuildContext context, ZcPalette c) {
    return Container(
      decoration: BoxDecoration(
        color: c.rl2,
        border: Border.all(color: c.rl2),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: <Widget>[
          Expanded(child: _segCell(context, c, '现有会话', on: true)),
          Container(width: 1, height: 32, color: c.rl2),
          Expanded(
            child: _segCell(
              context,
              c,
              '新建草稿',
              onTap: () => ZcScope.state(context).showToast('示意:新建草稿'),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _segCell(
    BuildContext context,
    ZcPalette c,
    String label, {
    bool on = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: on ? c.ink : c.cd,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 32,
          alignment: Alignment.center,
          child: Text(
            label,
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

  /// 活跃会话卡(等价 v1 加重边框的 .cd)
  static Widget _activeCard(BuildContext context, ZcPalette c) {
    return Container(
      decoration: BoxDecoration(
        color: c.cd,
        border: Border.all(color: c.ink, width: 1.5),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
        boxShadow: c.shadow == const Color(0x00000000)
            ? null
            : <BoxShadow>[
                BoxShadow(color: c.shadow, offset: const Offset(0, 1)),
              ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _sessionHead(
            context,
            c,
            tile: _keyTile(c, warn: false),
            name: 'poker.zchain.devnet',
            sub: 'delegated 0x7ad9…c1e4',
            badge: ZcChip('活跃', tone: 'felt', xs: true),
          ),
          const SizedBox(height: 9),
          _Lr(
            'scope',
            value: <Widget>[
              ZcChip('开桌', xs: true),
              ZcChip('买入', xs: true),
              ZcChip('结算', xs: true),
            ],
          ),
          const LedgerRow('单笔限额', '≤ 1,000 PLAY'),
          const LedgerRow('日累计', '2,150 / 5,000 PLAY'),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: const ZcMeter(0.43),
          ),
          const LedgerRow('桌白名单', '8♠ · 9♣(2 桌)'),
          const _Lr('有效期', valueText: '剩 6 天 12 小时', last: true),
          Container(
            margin: const EdgeInsets.only(top: 11),
            child: ZcButton(
              '撤销授权',
              variant: 'd',
              small: true,
              onTap: () => ZcScope.state(context).showToast('示意:撤销为粘滞操作,需二次确认'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 7),
            child: Text(
              '撤销为粘滞操作:立即生效,本会话永久失效',
              style: ZcType.ui(context, size: 10.5, color: c.ink3),
            ),
          ),
        ],
      ),
    );
  }

  /// 已耗尽会话卡(整卡 60% 透明)
  static Widget _exhaustedCard(BuildContext context, ZcPalette c) {
    return LedgerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _sessionHead(
            context,
            c,
            tile: _keyTile(c, warn: true),
            name: 'demo.local',
            sub: 'delegated 0x1e40…88a2',
            badge: ZcChip('已耗尽', tone: 'amb', xs: true),
          ),
          const SizedBox(height: 8),
          const _Lr('日累计', valueText: '5,000 / 5,000 PLAY', last: true),
          Container(
            margin: const EdgeInsets.only(top: 9),
            child: Row(
              children: <Widget>[
                ZcButton(
                  '删除记录',
                  variant: 'g',
                  small: true,
                  expanded: false,
                  onTap: () => ZcScope.state(context).showToast('示意:已删除'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 会话卡头:26×26 密钥瓦片 + 名称/委托地址 + 状态徽章
  static Widget _sessionHead(
    BuildContext context,
    ZcPalette c, {
    required Widget tile,
    required String name,
    required String sub,
    required Widget badge,
  }) {
    return Row(
      children: <Widget>[
        tile,
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ZcType.ui(context, size: 12.5, weight: FontWeight.w600),
              ),
              Text(
                sub,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ZcType.mono(context, size: 10.5, color: c.ink3),
              ),
            ],
          ),
        ),
        badge,
      ],
    );
  }

  /// 密钥瓦片(等价 .tic ok / .tic warn,26×26)
  static Widget _keyTile(ZcPalette c, {required bool warn}) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: warn ? c.ambW : c.feltW,
        border: Border.all(color: warn ? c.ambRl : c.feltRl),
        borderRadius: BorderRadius.circular(2),
      ),
      alignment: Alignment.center,
      child: ZcIcons.icon('i-key', size: 14, color: warn ? c.amb : c.felt),
    );
  }
}

/// 账簿行变体:值为徽章组合或纯文本,末行可去底线(等价 .lr)
class _Lr extends StatelessWidget {
  const _Lr(this.keyText, {this.value, this.valueText, this.last = false})
    : assert(value != null || valueText != null);

  final String keyText;
  final List<Widget>? value;
  final String? valueText;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    final List<Widget> items =
        value ??
        <Widget>[
          Text(
            valueText!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ZcType.mono(context, size: 12.5),
          ),
        ];
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
              style: ZcType.ui(context, size: 12.5, color: c.ink2),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                for (int i = 0; i < items.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(width: 5),
                  items[i],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

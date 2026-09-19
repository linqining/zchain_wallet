// 屏幕 11 · dapp 签名请求(zc-confirm)
// 设计:Pixso「设计文件」11 —— v2 由「签名确认」改名并演进:dapp 头部
// (favicon 方块 + 名称 + 域名 + 连接状态)、请求明细(等宽)、过期倒计时、
// 会话密钥签名提示与可展开的原始摘要;子页,无底部 Tab。
import 'package:flutter/material.dart';

import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class ZcConfirmScreen extends StatelessWidget {
  const ZcConfirmScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const ZcConfirmScreen();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: SubHeader(
        backIcon: 'i-x',
        title: '签名请求',
        trailing: ZcChip('1:52', tone: 'amb', xs: true),
      ),
      body: ZcBody(
        children: <Widget>[
          _dappCard(context, c),
          Gap(),
          _amountBlock(context, c),
          Gap(),
          LedgerCard(
            header: '请求内容',
            child: Column(
              children: <Widget>[
                const LedgerRow('链', 'zchain-devnet-1'),
                const LedgerRow('桌 table_id', '#A3F2'),
                _Lr(
                  '资产',
                  value: <Widget>[
                    _mono(context, 'PLAY'),
                    ZcChip('GAME', tone: 'play', xs: true),
                  ],
                ),
                const LedgerRow('rake', '2.00%'),
                _Lr(
                  '过期',
                  last: true,
                  value: <Widget>[
                    _mono(context, '120 秒'),
                    ZcChip('倒计时中', tone: 'amb', xs: true),
                  ],
                ),
              ],
            ),
          ),
          Gap(),
          LedgerCard(
            header: '授权对象',
            child: Column(
              children: <Widget>[
                const LedgerRow('收款 owner', '0x8f3a91c4…d7e2'),
                const LedgerRow('hand_binding', '0xc41d8f22…04b79b'),
                const LedgerRow('request_id', '3f9e77d0…aa31'),
                _Lr(
                  '证明',
                  last: true,
                  value: <Widget>[
                    _mono(context, '结算后可在 Portal 完整验证', color: c.ink3),
                  ],
                ),
              ],
            ),
          ),
          Gap(),
          NoticeBanner(
            '将使用会话密钥签名',
            '在单笔限额(≤ 1,000 PLAY)内,无需输入口令。',
            tone: 'ok',
            icon: 'i-key',
          ),
          Gap(),
          Row(
            children: <Widget>[
              Expanded(
                child: ZcButton(
                  '拒绝',
                  variant: 'd',
                  onTap: () => ZcNav.back(context),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: ZcButton(
                  '批准签名',
                  variant: 'p',
                  onTap: () =>
                      ZcScope.state(context)
                          .showToast('已用会话密钥签名 · 回执 0xc41d…9b'),
                ),
              ),
            ],
          ),
          const _RawDigest(),
        ],
      ),
    );
  }

  /// dapp 卡:favicon 方块 + 名称/域名 + 连接状态徽章(等价 .dapp)
  static Widget _dappCard(BuildContext context, ZcPalette c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.cd,
        border: Border.all(color: c.rl),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: c.pg2,
              border: Border.all(color: c.rl2),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.center,
            child: ZcIcons.icon('i-spade', size: 14, color: c.ink2),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'poker.zchain.devnet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZcType.ui(context, size: 12, weight: FontWeight.w600),
                ),
                Text(
                  '请求签名 · 会话密钥路径',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZcType.mono(context, size: 10, color: c.ink3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 9),
          ZcChip('已授权 ORIGIN', tone: 'felt', xs: true),
        ],
      ),
    );
  }

  /// 金额块(等价 .cfm:纸纹底 + 居中等宽大额)
  static Widget _amountBlock(BuildContext context, ZcPalette c) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.cd,
        border: Border.all(color: c.rl2),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(painter: RuledPaperPainter(c.rulePaper)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('开桌买入', style: ZcType.section(context, color: c.ink3)),
              Container(
                margin: const EdgeInsets.only(top: 4, bottom: 2),
                child: Text(
                  '-500.00',
                  style: ZcType.mono(
                    context,
                    size: 28,
                    weight: FontWeight.w600,
                    ls: -0.5,
                    color: c.ink,
                  ),
                ),
              ),
              Text(
                'PLAY · 8♠ 桌 · GAME 域 · 不动 REAL 资产',
                style: ZcType.mono(context, size: 10.5, color: c.ink2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _mono(BuildContext context, String text, {Color? color}) =>
      Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: ZcType.mono(context, size: 12.5, color: color),
      );
}

/// 账簿行变体:值为文本 + 徽章组合(等价 .lr,末行可去底线)
class _Lr extends StatelessWidget {
  const _Lr(this.keyText, {required this.value, this.last = false});

  final String keyText;
  final List<Widget> value;
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
}

/// 可展开的原始摘要(等价 details/summary + .raw)
class _RawDigest extends StatefulWidget {
  const _RawDigest();

  @override
  State<_RawDigest> createState() => _RawDigestState();
}

class _RawDigestState extends State<_RawDigest> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            onTap: () => setState(() => _open = !_open),
            child: Row(
              children: <Widget>[
                Text(
                  _open ? '▾' : '▸',
                  style: ZcType.mono(context, size: 9, color: c.ink3),
                ),
                const SizedBox(width: 4),
                Text(
                  '原始摘要(SNIP-12)',
                  style: ZcType.mono(
                    context,
                    size: 11,
                    ls: 0.44,
                    color: c.ink3,
                  ),
                ),
              ],
            ),
          ),
          if (_open)
            Container(
              margin: const EdgeInsets.only(top: 7),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: c.code,
                border: Border.all(color: c.rl),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                '0x1a2b3c4d5e6f70819a2b3c4d5e6f708192a3b4c5d6e7f8091a2b'
                '3c4d5e6f7a8b9c0d',
                softWrap: true,
                style: ZcType.mono(
                  context,
                  size: 9.5,
                  color: c.ink3,
                ).copyWith(height: 1.65),
              ),
            ),
        ],
      ),
    );
  }
}

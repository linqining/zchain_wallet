// 屏幕 06 · 账簿 · ZChain 层(zc-dash)
// 设计:Pixso「设计文件」06-zc-dash —— ZChain 层账簿;链切换器在三条账簿屏
// 之间导航(v2 把 v1 的单屏三面板拆为三屏);底部 Tab「账簿」。
import 'package:flutter/material.dart';

import '../data/demo.dart';
import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class ZcDashScreen extends StatelessWidget {
  const ZcDashScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const ZcDashScreen();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: DashHeaderBlock(
        header: DashHeader(
          kind: 'Ledger · Zchain',
          title: DemoData.accountName,
          subtitle: DemoData.layers[0].addr,
          actions: <Widget>[
            SquareIconButton(
              icon: 'i-qr',
              tooltip: '收款',
              onTap: () => _showReceiveSheet(context),
            ),
            SquareIconButton(
              icon: 'i-lock',
              tooltip: '锁定',
              onTap: () => ZcNav.go(context, 'lock'),
            ),
          ],
        ),
      ),
      body: ZcBody(
        children: <Widget>[
          ChainSwitcher(<ChainSwitchItem>[
            ChainSwitchItem('ZChain', 2, on: true),
            ChainSwitchItem(
              'EVM',
              1,
              onTap: () => ZcNav.go(context, 'evm-dash'),
            ),
            ChainSwitchItem(
              'Starknet',
              1,
              onTap: () => ZcNav.go(context, 'stk-dash'),
            ),
          ]),
          SplitColumns(
            left: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ZcChip('GAME', tone: 'play', xs: true),
                    const SizedBox(width: 6),
                    _colLabel(c, '可用筹码'),
                  ],
                ),
                _colAmount(c, '12,400.00', 'PLAY', c.ink),
              ],
            ),
            right: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ZcChip('REAL', tone: 'real', xs: true),
                    const SizedBox(width: 6),
                    _colLabel(c, '托管映射'),
                  ],
                ),
                _colAmount(c, '10,000.00', 'NATIVE', c.real),
              ],
            ),
          ),
          NoticeBanner('托管映射资产', 'REAL 域提现通道未开放;GAME 域筹码不上主网。', tone: 'real'),
          Gap(),
          ActionGrid(<QuickAction>[
            QuickAction(
              '收款',
              'i-qr',
              () => _showReceiveSheet(context),
              tone: 'play',
            ),
            QuickAction('转账', 'i-send', () => ZcNav.go(context, 'zc-send')),
            QuickAction(
              '提现',
              'i-out',
              () => ZcNav.go(context, 'zc-withdraw'),
              tone: 'real',
            ),
            QuickAction(
              'Portal',
              'i-shield',
              () => ZcNav.go(context, 'zc-portal'),
            ),
          ]),
          LedgerCard(
            header: '资产',
            moreLabel: '回执',
            onMore: () => ZcNav.go(context, 'zc-receipts'),
            child: Column(
              children: <Widget>[
                AssetRow(
                  tile: 'P',
                  tileTone: 'play',
                  name: 'PLAY',
                  chip: 'GAME',
                  chipTone: 'play',
                  sub: '可用 12,400.00 · 桌上锁定 0.00',
                  amount: '12,400.00',
                ),
                AssetRow(
                  tile: 'N',
                  tileTone: 'real',
                  name: 'NATIVE',
                  chip: 'REAL',
                  chipTone: 'real',
                  sub: '托管映射 · 提现未开放',
                  amount: '10,000.00',
                ),
                const AssetRow(
                  tile: 'U',
                  name: 'USDT / USDC',
                  sub: '未接入',
                  amount: '—',
                  amountTone: 'dim',
                  dim: true,
                ),
              ],
            ),
          ),
          Gap(),
          LedgerCard(
            header: '最新动态',
            moreLabel: '查看全部',
            onMore: () => ZcNav.go(context, 'zc-receipts'),
            child: Column(
              children: <Widget>[
                TxRow(
                  icon: 'i-check',
                  tone: 'ok',
                  name: '买入 · 8♠ 桌',
                  sub: '0xc41d…9b · 2 分钟前',
                  amount: '-500.00',
                  status: 'included',
                  statusTone: 'felt',
                ),
                TxRow(
                  icon: 'i-receipt',
                  tone: 'blue',
                  name: '结算 · 8♠ 桌 #128',
                  sub: '0x3f9e…aa · 刚刚',
                  amount: '+620.50',
                  amountTone: 'pos',
                  status: 'seen',
                ),
              ],
            ),
          ),
          Gap(),
          LedgerCard(
            header: '会话密钥 · SNIP-12',
            moreLabel: '管理',
            onMore: () => ZcNav.go(context, 'zc-sessions'),
            child: Column(
              children: <Widget>[
                LedgerRow('poker.zchain.devnet', '活跃', valueColor: c.felt),
                const LedgerRow('单笔 / 日累计', '≤1,000 · 2,150/5,000'),
                const SizedBox(height: 8),
                const ZcMeter(0.43),
              ],
            ),
          ),
        ],
      ),
      tabs: 'zc-dash',
    );
  }

  static Widget _colLabel(ZcPalette c, String text) =>
      Text(text, style: ZcType.section(null, color: c.ink3));

  static Widget _colAmount(
    ZcPalette c,
    String amount,
    String unit,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(
            amount,
            style: ZcType.mono(
              null,
              size: 22,
              weight: FontWeight.w600,
              ls: -0.3,
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            unit,
            style: ZcType.mono(null, size: 9.5, ls: 1.33, color: c.ink3),
          ),
        ],
      ),
    );
  }

  /// 收款 sheet(演示地址 + 装饰 QR)
  static void _showReceiveSheet(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: c.pg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ZcPalette.rL)),
      ),
      builder: (BuildContext ctx) {
        final ZcPalette cc = ZcScope.of(ctx);
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 34,
                    height: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: cc.rl2,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '收款 · ZChain 层',
                        style: ZcType.ui(
                          ctx,
                          size: 13,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SquareIconButton(
                      icon: 'i-x',
                      bare: true,
                      onTap: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                Text(
                  'zc1qpoker9xf7x2wwn2h3a5v8…',
                  style: ZcType.mono(ctx, size: 9.5, color: cc.ink3),
                ),
                Text(
                  '完整地址 · 点按下方按钮复制',
                  style: ZcType.ui(ctx, size: 10, color: cc.ink3),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 98),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: cc.rl2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: ZcIcons.icon(
                    'qr-art',
                    size: 134,
                    color: const Color(0xFF14130F),
                  ),
                ),
                const SizedBox(height: 14),
                ZcButton(
                  '复制地址',
                  variant: 's',
                  small: true,
                  expanded: true,
                  icon: 'i-copy',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    ZcScope.state(ctx).showToast('地址已复制');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

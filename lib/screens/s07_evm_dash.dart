// 屏幕 07 · 账簿 · EVM 层(evm-dash)
// 设计:Pixso「设计文件」07-evm-dash —— EVM 层账簿;链切换器在三条账簿屏
// 之间导航;总余额卡(≈ 价格 + 收款/浏览器裸钮)打头,动作条为
// 发送/收款/历史/合约;网络卡含校验通过与 gas 徽章;资产卡含只读 USDC;
// 最新动态卡可查看全部;账户管理卡指向 evm-manage。底部 Tab「账簿」。
import 'package:flutter/material.dart';

import '../data/demo.dart';
import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class EvmDashScreen extends StatelessWidget {
  const EvmDashScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const EvmDashScreen();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: DashHeaderBlock(
        header: DashHeader(
          kind: 'Ledger · Evm',
          net: 'Ethereum · chainId 1',
          title: DemoData.accountName,
          subtitle: DemoData.layers[1].addr,
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
            ChainSwitchItem(
              'ZChain',
              2,
              onTap: () => ZcNav.go(context, 'zc-dash'),
            ),
            ChainSwitchItem('EVM', 1, on: true),
            ChainSwitchItem(
              'Starknet',
              1,
              onTap: () => ZcNav.go(context, 'stk-dash'),
            ),
          ]),
          TotalCard(
            label: '总余额 · ETH',
            amount: '2.4183',
            unit: 'ETH',
            subChips: <Widget>[
              Text(
                '≈ \$8,124.69',
                style: ZcType.mono(context, size: 10.5, color: c.ink2),
              ),
              const SizedBox(width: 12),
              SquareIconButton(
                icon: 'i-qr',
                bare: true,
                tooltip: '收款',
                onTap: () => _showReceiveSheet(context),
              ),
              const SizedBox(width: 6),
              SquareIconButton(
                icon: 'i-ext',
                bare: true,
                tooltip: '浏览器打开',
                onTap: () => ZcScope.state(context).showToast('示意:浏览器打开'),
              ),
            ],
          ),
          Gap(),
          ActionGrid(<QuickAction>[
            QuickAction('发送', 'i-send', () => ZcNav.go(context, 'evm-send')),
            QuickAction('收款', 'i-qr', () => _showReceiveSheet(context)),
            QuickAction(
              '历史',
              'i-receipt',
              () => ZcNav.go(context, 'evm-history'),
            ),
            QuickAction(
              '合约',
              'i-file',
              () => ZcScope.state(context).showToast('示意:合约读写面板'),
            ),
          ]),
          Gap(),
          LedgerCard(
            header: '网络',
            moreLabel: '切换',
            moreIcon: 'i-swap',
            onMore: () => ZcScope.state(context).showToast('示意:切换网络下拉'),
            child: Column(
              children: <Widget>[
                _LrChipRow('chainId', '1', '校验通过', chipTone: 'felt'),
                _LrChipRow('gas', '12 gwei', '偏低'),
                const LedgerRow('nonce', '42'),
              ],
            ),
          ),
          Gap(),
          LedgerCard(
            header: '资产',
            child: Column(
              children: <Widget>[
                const AssetRow(
                  tile: 'Ξ',
                  name: 'ETH',
                  sub: '原生币',
                  amount: '2.4183',
                ),
                const AssetRow(
                  tile: 'U',
                  name: 'USDC',
                  chip: '只读',
                  sub: 'erc-20 · eth_call 读取',
                  amount: '320.00',
                ),
              ],
            ),
          ),
          Gap(),
          LedgerCard(
            header: '最新动态',
            moreLabel: '查看全部',
            onMore: () => ZcNav.go(context, 'evm-history'),
            child: Column(
              children: <Widget>[
                TxRow(
                  icon: 'i-send',
                  tone: 'ok',
                  name: '发送 · 0.25 ETH',
                  sub: '0x8f3a…c2 · 2 分钟前',
                  amount: '-0.2500',
                  status: '成功',
                  statusTone: 'felt',
                ),
                TxRow(
                  icon: 'i-recv',
                  tone: 'blue',
                  name: '接收 · 1.20 ETH',
                  sub: '0x51b7…c8 · 昨天',
                  amount: '+1.2000',
                  amountTone: 'pos',
                  status: '成功',
                  statusTone: 'felt',
                ),
              ],
            ),
          ),
          Gap(),
          LedgerCard(
            header: '账户管理',
            moreLabel: '进入',
            onMore: () => ZcNav.go(context, 'evm-manage'),
            child: const LedgerRow('私钥 · 口令 · RPC', '危险区需二次确认', dim: true),
          ),
        ],
      ),
      tabs: 'zc-dash',
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
                        '收款 · EVM 层',
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
                  '0x59195049a3…29f97527',
                  style: ZcType.mono(ctx, size: 9.5, color: cc.ink3),
                ),
                Text(
                  'Ethereum · chainId 1',
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

/// 账簿行 · 值侧带小徽章(网络卡的 chainId / gas 行)
class _LrChipRow extends StatelessWidget {
  const _LrChipRow(this.keyText, this.valueText, this.chip, {this.chipTone});

  final String keyText;
  final String valueText;
  final String chip;
  final String? chipTone;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.rl)),
      ),
      child: Row(
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
            child: Text(
              valueText,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ZcType.mono(context, size: 12.5, color: c.ink),
            ),
          ),
          const SizedBox(width: 5),
          ZcChip(chip, tone: chipTone, xs: true),
        ],
      ),
    );
  }
}

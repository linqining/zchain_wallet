// 屏幕 08 · 账簿 · Starknet 层(stk-dash)
// 设计:Pixso「设计文件」08-stk-dash —— Starknet 层账簿(锁定态);
// 链切换器在三条账簿屏之间导航;总余额卡(≈ 价格 + 收款/浏览器裸钮)
// 打头,其下 amb 提示条说明本层已锁定、余额为链上只读数据;动作条为
// 发送/收款/水龙头/历史;网络卡含 UDC 地址;资产卡仅只读 ETH;
// 最新动态卡无查看全部。底部 Tab「账簿」。
import 'package:flutter/material.dart';

import '../data/demo.dart';
import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class StkDashScreen extends StatelessWidget {
  const StkDashScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const StkDashScreen();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: DashHeaderBlock(
        header: DashHeader(
          kind: 'Ledger · Starknet',
          net: 'SN DevNet · ZCDN',
          title: DemoData.accountName,
          subtitle: DemoData.layers[2].addr,
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
            ChainSwitchItem(
              'EVM',
              1,
              onTap: () => ZcNav.go(context, 'evm-dash'),
            ),
            ChainSwitchItem('Starknet', 1, on: true),
          ]),
          TotalCard(
            label: '总余额 · ETH',
            amount: '1.2034',
            unit: 'ETH',
            subChips: <Widget>[
              Text(
                '≈ \$4,043.42',
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
                onTap: () =>
                    ZcScope.state(context).showToast('示意:starkscan 打开'),
              ),
            ],
          ),
          Gap(),
          NoticeBanner(
            '本层已锁定',
            '解锁后才能发起 invoke;当前余额为链上只读数据。',
            tone: 'amb',
            icon: 'i-lock',
          ),
          Gap(),
          ActionGrid(<QuickAction>[
            QuickAction(
              '发送',
              'i-send',
              () => ZcScope.state(context).showToast('示意:解锁后发送(同账簿模板)'),
            ),
            QuickAction('收款', 'i-qr', () => _showReceiveSheet(context)),
            QuickAction(
              '水龙头',
              'i-flask',
              () => ZcScope.state(context).showToast('示意:水龙头领取 10 ETH'),
            ),
            QuickAction(
              '历史',
              'i-receipt',
              () => ZcScope.state(context).showToast('示意:历史(同账簿模板)'),
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
                _LrChipRow('chainId', 'ZCDN', '校验通过', chipTone: 'felt'),
                const LedgerRow('nonce', '7'),
                const LedgerRow('UDC 地址', '0x41a7…8e02(公式推导)'),
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
                  sub: 'ERC-20 · u256 形状',
                  amount: '1.2034',
                ),
              ],
            ),
          ),
          Gap(),
          LedgerCard(
            header: '最新动态',
            child: Column(
              children: <Widget>[
                TxRow(
                  icon: 'i-send',
                  tone: 'ok',
                  name: 'invoke · transfer',
                  sub: '0x33c1…67 · maxFee 0.00042',
                  amount: '-0.5000',
                  status: '成功',
                  statusTone: 'felt',
                ),
                TxRow(
                  icon: 'i-flask',
                  tone: 'blue',
                  name: '水龙头 · dev_faucet',
                  sub: '0xe8b0…19 · 1 小时前',
                  amount: '+10.0000',
                  amountTone: 'pos',
                  status: 'dev',
                  statusTone: 'play',
                ),
              ],
            ),
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
                        '收款 · Starknet 层',
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
                  '0x058ff920c8…8b29853f',
                  style: ZcType.mono(ctx, size: 9.5, color: cc.ink3),
                ),
                Text(
                  'SN DevNet · ZCDN',
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

/// 账簿行 · 值侧带小徽章(网络卡的 chainId 行)
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

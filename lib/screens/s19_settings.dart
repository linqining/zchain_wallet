// 屏幕 19 · 设置 · 能力矩阵(settings)
// 设计:Pixso「设计文件」19 —— 设置子页(无底部 Tab):通用 / 安全与备份 /
// 关于 三组菜单(MenuRow + ZcSwitch + 徽章),未审计提示条;「能力矩阵」
// 弹层如实对照三链能力与红线;底部为版本脚注。
import 'package:flutter/material.dart';

import '../data/demo.dart';
import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const SettingsScreen();

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _showTestnet = true;

  @override
  Widget build(BuildContext context) {
    // ZcScope 依赖注册:底色切换时本屏随 palette 重建(外观底面徽章联动)。
    final bool isDark = ZcScope.state(context).isDark;
    return ZcScreen(
      header: const SubHeader(title: '设置'),
      body: ZcBody(
        children: <Widget>[
          const SectionTitle('通用'),
          LedgerCard(
            tight: true,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: <Widget>[
                MenuRow(
                  icon: 'i-clock',
                  title: '自动锁定',
                  subtitle: '无操作 15 分钟,或后台页面被浏览器回收(即 fail-closed)',
                  trailing: const ZcChip('15 MIN', xs: true),
                  onTap: () =>
                      ZcScope.state(context)
                          .showToast('示意:自动锁定为 fail-closed 策略'),
                ),
                MenuRow(
                  icon: 'i-eye',
                  title: '显示测试网',
                  subtitle: '关闭后隐藏 devnet 资产',
                  trailing: ZcSwitch(
                    on: _showTestnet,
                    onTap: () => setState(() => _showTestnet = !_showTestnet),
                  ),
                ),
                MenuRow(
                  icon: 'i-wallet',
                  title: '货币计价',
                  subtitle: 'USD(仅展示,非托管承诺)',
                  trailing: const ZcChip('USD', xs: true),
                  onTap: () => ZcScope.state(context).showToast('示意:货币计价'),
                ),
                MenuRow(
                  icon: 'i-book',
                  title: '外观底面',
                  subtitle: '纸白账簿 / 夜场账簿',
                  trailing: ZcChip(isDark ? '夜场' : '纸白', xs: true),
                  onTap: () => ZcScope.state(context).toggleGround(),
                ),
              ],
            ),
          ),
          const SectionTitle('安全与备份'),
          LedgerCard(
            tight: true,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: <Widget>[
                MenuRow(
                  icon: 'i-dl',
                  title: '备份导出(.zcbk)',
                  subtitle: '仅 ZChain 层 REAL/PLAY 双库 · 备份口令独立',
                  onTap: () =>
                      ZcScope.state(context).showToast('示意:加密导出 .zcbk'),
                ),
                MenuRow(
                  icon: 'i-ul',
                  title: '从备份恢复',
                  subtitle: 'Argon2id 本地解密',
                  onTap: () => ZcNav.go(context, 'import'),
                ),
                MenuRow(
                  icon: 'i-key',
                  title: '授权簿 / 会话密钥',
                  subtitle: '按 origin 撤销 dapp 授权',
                  onTap: () => ZcNav.go(context, 'zc-sessions'),
                ),
                MenuRow(
                  icon: 'i-file',
                  title: '能力矩阵',
                  subtitle: '各层能力与红线的如实说明',
                  onTap: () => _showCapabilityMatrix(context),
                ),
              ],
            ),
          ),
          const SectionTitle('关于'),
          LedgerCard(
            tight: true,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: <Widget>[
                MenuRow(
                  icon: 'i-info',
                  title: '版本',
                  subtitle:
                      'MV3 · DevNet 形态 · 本${DemoData.designVersion} 对齐此版本',
                  trailing: const ZcChip('0.6.1', xs: true),
                ),
                MenuRow(
                  icon: 'i-ext',
                  title: '文档与源码',
                  subtitle: 'docs / website',
                  onTap: () => ZcScope.state(context).showToast('示意:打开文档站'),
                ),
              ],
            ),
          ),
          const Gap(),
          const NoticeBanner(
            '未通过第三方审计',
            '「可验证」指密码学与结算证明可被独立复核,不等于已审计;本界面不出现任何审计徽章。',
            tone: 'bad',
            icon: 'i-warn',
          ),
          ZcFoot(<String>[
            'ZChain Wallet · 桌上飞快,结算可证',
            'Fast at the table. Verifiable at settlement.',
            DemoData.build,
          ]),
        ],
      ),
    );
  }

  /// 能力矩阵弹层(等价 v1 mdl-cap):三链能力与红线的如实对照。
  void _showCapabilityMatrix(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        final ZcPalette cc = ZcScope.of(ctx);
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cc.pg,
              border: Border.all(color: cc.ink),
              borderRadius: BorderRadius.circular(ZcPalette.rS),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  '能力矩阵',
                  style: ZcType.ui(ctx, size: 14, weight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  '逐层能力与红线,按 extension 的交付面如实列举;不为好看放宽。',
                  style: ZcType.ui(ctx, size: 11.5, color: cc.ink2),
                ),
                const SizedBox(height: 4),
                _matrixRow(
                  ctx,
                  cc,
                  'i-spade',
                  'ZChain',
                  'GAME 域可签可转;REAL 仅展示,提现预览 canSubmit 恒 false',
                ),
                _matrixRow(
                  ctx,
                  cc,
                  'i-ether',
                  'EVM',
                  '转账与合约写入可签名广播(EIP-155 + chainId 校验);不签 note spend',
                ),
                _matrixRow(
                  ctx,
                  cc,
                  'i-layers',
                  'Starknet',
                  'invoke v1 + devnet 水龙头;SNIP-12 授权面已备,链上 admission 未开放',
                ),
                _matrixRow(
                  ctx,
                  cc,
                  'i-swap',
                  '网络',
                  'mainnet 刻意不注册 → NetworkUnsupported;devnet/testnet 才可选',
                ),
                _matrixRow(
                  ctx,
                  cc,
                  'i-key',
                  '边界',
                  '盲签拒绝;私钥 / 助记词 / nullifier 不出边界;网关水位原样展示、不推进',
                ),
                _matrixRow(
                  ctx,
                  cc,
                  'i-lock',
                  '会话',
                  '三层共用口令、会话彼此独立;后台被回收即锁定(fail-closed)',
                ),
                Container(
                  margin: const EdgeInsets.only(top: 14),
                  child: ZcButton(
                    '知道了',
                    variant: 'p',
                    onTap: () => Navigator.of(ctx).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 矩阵行(等价 .rsn):图标 + 等宽粗体域名 + 能力说明。
  static Widget _matrixRow(
    BuildContext context,
    ZcPalette c,
    String icon,
    String domain,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ZcIcons.icon(icon, size: 14, color: c.ink3),
          const SizedBox(width: 7),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: domain,
                    style: ZcType.mono(
                      context,
                      size: 11,
                      weight: FontWeight.w600,
                      color: c.ink,
                    ),
                  ),
                  TextSpan(
                    text: ' · $text',
                    style: ZcType.ui(context, size: 11.5, color: c.ink2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

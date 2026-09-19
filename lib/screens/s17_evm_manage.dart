// 屏幕 17 · 账户管理 · 危险区(evm-manage)
// 设计:Pixso「设计文件」17 —— EVM 层账户管理:账户卡(B 头像 + 地址 +
// 已解锁徽章 + 重命名)、安全(导出私钥 / 修改口令 / 锁定)、网络(RPC /
// Explorer API 覆盖)、危险区(删除账户,bad 描边卡 + 二次确认弹层)与
// keystore 脚注;子页,无底部 Tab。
import 'package:flutter/material.dart';

import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class EvmManageScreen extends StatelessWidget {
  const EvmManageScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const EvmManageScreen();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: SubHeader(title: '账户管理'),
      body: ZcBody(
        children: <Widget>[
          _accountCard(context, c),
          const SectionTitle('安全'),
          LedgerCard(
            tight: true,
            child: Column(
              children: <Widget>[
                MenuRow(
                  icon: 'i-eye',
                  tone: 'bad',
                  title: '导出私钥',
                  subtitle: '口令确认后展开 · 设计稿:30 秒自动收起',
                  onTap: () =>
                      ZcScope.state(context).showToast('示意:口令确认后展开 · 30 秒自动收起'),
                ),
                MenuRow(
                  icon: 'i-key',
                  title: '修改口令',
                  subtitle: '三层 keystore 各自重派生(两套 KDF)',
                  onTap: () =>
                      ZcScope.state(context).showToast('示意:三层 keystore 各自重派生'),
                ),
                MenuRow(
                  icon: 'i-lock',
                  title: '锁定',
                  subtitle: '立即清除内存中的会话',
                  onTap: () => ZcNav.go(context, 'lock'),
                ),
              ],
            ),
          ),
          const SectionTitle('网络'),
          LedgerCard(
            tight: true,
            child: Column(
              children: <Widget>[
                MenuRow(
                  icon: 'i-swap',
                  title: 'RPC 覆盖',
                  subtitle: 'Ethereum · 自定义 https://…',
                  onTap: () => ZcScope.state(context).showToast('示意:RPC 覆盖配置'),
                ),
                MenuRow(
                  icon: 'i-ext',
                  title: 'Explorer API 覆盖',
                  subtitle: 'Etherscan 兼容 · 已配置',
                  onTap: () =>
                      ZcScope.state(context).showToast('示意:Explorer API 覆盖配置'),
                ),
              ],
            ),
          ),
          const SectionTitle('危险区', danger: true),
          _dangerCard(context, c),
          const ZcFoot(<String>[
            '本机 keystore(本层):PBKDF2-SHA256 600k + AES-256-GCM · 私钥只在后台内存会话,落盘仅密文 · 无云端副本',
          ]),
        ],
      ),
    );
  }

  /// 账户卡:头像 + 名称(重命名)+ 地址 + 已解锁徽章
  Widget _accountCard(BuildContext context, ZcPalette c) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.cd,
        border: Border.all(color: c.rl),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
        boxShadow: c.shadow == const Color(0x00000000)
            ? null
            : <BoxShadow>[
                BoxShadow(color: c.shadow, offset: const Offset(0, 1)),
              ],
      ),
      child: Row(
        children: <Widget>[
          const Avatar('B', size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        '账户 2',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ZcType.ui(
                          context,
                          size: 13,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SquareIconButton(
                      icon: 'i-pen',
                      bare: true,
                      tooltip: '重命名',
                      onTap: () => ZcScope.state(context).showToast('示意:重命名'),
                    ),
                  ],
                ),
                Text(
                  '0x59195049a3…29f97527',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZcType.mono(context, size: 10.5, color: c.ink3),
                ),
              ],
            ),
          ),
          const ZcChip('已解锁', tone: 'felt', xs: true),
        ],
      ),
    );
  }

  /// 危险区卡:bad 描边 + 删除账户菜单行(二次确认弹层)
  Widget _dangerCard(BuildContext context, ZcPalette c) {
    return Container(
      decoration: BoxDecoration(
        color: c.cd,
        border: Border.all(color: c.badRl),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
        boxShadow: c.shadow == const Color(0x00000000)
            ? null
            : <BoxShadow>[
                BoxShadow(color: c.shadow, offset: const Offset(0, 1)),
              ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: MenuRow(
        icon: 'i-trash',
        danger: true,
        title: '删除账户',
        subtitle: '需输入口令确认;导出私钥前请先备份',
        onTap: () => _showDeleteDialog(context),
      ),
    );
  }

  /// 删除确认弹层(等价 mdl-del):取消 / 确认删除
  void _showDeleteDialog(BuildContext context) {
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
                  '删除账户 2?',
                  style: ZcType.ui(ctx, size: 14, weight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  '该账户的私钥将从本机 keystore 永久移除。若没有备份,资产无法找回。此操作与其他两层无关。',
                  style: ZcType.ui(ctx, size: 11.5, color: cc.ink2),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 14),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ZcButton(
                          '取消',
                          variant: 'g',
                          onTap: () => Navigator.of(ctx).pop(),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: ZcButton(
                          '确认删除',
                          variant: 'd',
                          onTap: () {
                            Navigator.of(ctx).pop();
                            ZcScope.state(ctx).showToast('示意:需口令校验后执行');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

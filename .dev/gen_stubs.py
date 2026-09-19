"""Generate stub screen files for screens not yet implemented."""
SCREENS = [
    ("s01_welcome", "WelcomeScreen", "01 · 欢迎 · 一次创建三层", "welcome"),
    ("s02_success", "SuccessScreen", "02 · 创建成功 · 解锁口令", "success"),
    ("s03_import", "ImportScreen", "03 · 导入 / 恢复", "import"),
    ("s09_zc_send", "ZcSendScreen", "09 · 转账 · 贪心选币", "zc-send"),
    ("s10_zc_withdraw", "ZcWithdrawScreen", "10 · REAL 提现预览 · fail-closed", "zc-withdraw"),
    ("s11_zc_confirm", "ZcConfirmScreen", "11 · dapp 签名请求", "zc-confirm"),
    ("s12_zc_sessions", "ZcSessionsScreen", "12 · 会话密钥 · SNIP-12", "zc-sessions"),
    ("s13_zc_portal", "ZcPortalScreen", "13 · Proof Portal", "zc-portal"),
    ("s14_zc_receipts", "ZcReceiptsScreen", "14 · 回执状态机", "zc-receipts"),
    ("s15_evm_send", "EvmSendScreen", "15 · 发送 · 交易预览", "evm-send"),
    ("s16_evm_history", "EvmHistoryScreen", "16 · 交易记录 · 双边对账", "evm-history"),
    ("s17_evm_manage", "EvmManageScreen", "17 · 账户管理 · 危险区", "evm-manage"),
    ("s18_proofs", "ProofsScreen", "18 · 凭证簿 · v2 新增屏", "proofs"),
    ("s19_settings", "SettingsScreen", "19 · 设置 · 能力矩阵", "settings"),
]

TPL = '''/// 屏幕 __NO__(占位:待实现)
/// 设计:Pixso「设计文件」__NO__ —— 屏幕内容按设计稿截图与文本清单实现。
import 'package:flutter/material.dart';

import '../design/scope.dart';
import '../design/widgets.dart';

class __CLS__ extends StatelessWidget {
  const __CLS__({super.key});

  static WidgetBuilder get builder => (_) => const __CLS__();

  @override
  Widget build(BuildContext context) {
    return ZcScreen(
      header: null,
      body: ZcBody(children: <Widget>[
        ZcEmpty('__TITLE__ · 待实现'),
      ]),
    );
  }
}
'''

import os
d = r'E:\projects\zchain_wallet\lib\screens'
os.makedirs(d, exist_ok=True)
for fname, cls, title, route in SCREENS:
    p = os.path.join(d, fname + '.dart')
    if os.path.exists(p):
        continue
    no = fname.split('_')[0].lstrip('s')
    open(p, 'w', encoding='utf-8').write(
        TPL.replace('__CLS__', cls).replace('__TITLE__', title).replace('__NO__', no))
    print('stub', fname)

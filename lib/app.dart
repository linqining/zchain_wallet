// ZChain Wallet 应用外壳:主题(纸白/夜场)+ 19 屏路由。
import 'package:flutter/material.dart';

import 'design/scope.dart';
import 'design/theme.dart';
import 'screens/s01_welcome.dart';
import 'screens/s02_success.dart';
import 'screens/s03_import.dart';
import 'screens/s04_lock.dart';
import 'screens/s05_home.dart';
import 'screens/s06_zc_dash.dart';
import 'screens/s07_evm_dash.dart';
import 'screens/s08_stk_dash.dart';
import 'screens/s09_zc_send.dart';
import 'screens/s10_zc_withdraw.dart';
import 'screens/s11_zc_confirm.dart';
import 'screens/s12_zc_sessions.dart';
import 'screens/s13_zc_portal.dart';
import 'screens/s14_zc_receipts.dart';
import 'screens/s15_evm_send.dart';
import 'screens/s16_evm_history.dart';
import 'screens/s17_evm_manage.dart';
import 'screens/s18_proofs.dart';
import 'screens/s19_settings.dart';
import 'state/app_state.dart';

/// 路由表:route id 与设计稿 slug 一致
final Map<String, WidgetBuilder> kRoutes = <String, WidgetBuilder>{
  'welcome': WelcomeScreen.builder,
  'success': SuccessScreen.builder,
  'import': ImportScreen.builder,
  'lock': LockScreen.builder,
  'home': HomeScreen.builder,
  'zc-dash': ZcDashScreen.builder,
  'evm-dash': EvmDashScreen.builder,
  'stk-dash': StkDashScreen.builder,
  'zc-send': ZcSendScreen.builder,
  'zc-withdraw': ZcWithdrawScreen.builder,
  'zc-confirm': ZcConfirmScreen.builder,
  'zc-sessions': ZcSessionsScreen.builder,
  'zc-portal': ZcPortalScreen.builder,
  'zc-receipts': ZcReceiptsScreen.builder,
  'evm-send': EvmSendScreen.builder,
  'evm-history': EvmHistoryScreen.builder,
  'evm-manage': EvmManageScreen.builder,
  'proofs': ProofsScreen.builder,
  'settings': SettingsScreen.builder,
};

class ZChainWalletApp extends StatelessWidget {
  const ZChainWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ZcScope(
      notifier: appState,
      child: ListenableBuilder(
        listenable: appState,
        builder: (BuildContext context, _) {
          final ThemeData theme = buildTheme(appState.palette);
          return MaterialApp(
            title: 'ZChain Wallet',
            debugShowCheckedModeBanner: false,
            theme: theme,
            themeMode: appState.isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme: theme,
            initialRoute: '/welcome',
            onGenerateRoute: (RouteSettings settings) {
              final String name = settings.name!.substring(1);
              final WidgetBuilder? builder = kRoutes[name];
              if (builder == null) return null;
              return MaterialPageRoute<void>(
                builder: builder,
                settings: settings,
              );
            },
          );
        },
      ),
    );
  }
}

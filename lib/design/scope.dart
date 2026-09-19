// 作用域:向全树提供当前底色 token 集(palette)+ 应用状态;导航助手。
import 'package:flutter/material.dart';

import '../state/app_state.dart';
import 'tokens.dart';

class ZcScope extends InheritedNotifier<AppState> {
  const ZcScope({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static ZcPalette of(BuildContext context) {
    final ZcScope? scope = context
        .dependOnInheritedWidgetOfExactType<ZcScope>();
    return scope!.notifier!.palette;
  }

  static AppState state(BuildContext context) {
    final ZcScope? scope = context
        .dependOnInheritedWidgetOfExactType<ZcScope>();
    return scope!.notifier!;
  }
}

/// 路由助手:route id 与设计稿 slug 一致(home / zc-dash / proofs…)。
class ZcNav {
  const ZcNav._();

  /// 压栈导航(等价设计稿 data-nav)。
  static void go(BuildContext context, String route) {
    Navigator.of(context).pushNamed('/$route');
  }

  /// Tab 切换:清栈后替换,避免无限叠栈。
  static void switchTab(BuildContext context, String route) {
    Navigator.of(context).popUntil((Route<Object?> r) => r.isFirst);
    Navigator.of(context).pushReplacementNamed('/$route');
  }

  /// 返回(子页返回键)。
  static void back(BuildContext context) {
    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
  }
}

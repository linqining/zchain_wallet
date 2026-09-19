// 冒烟测试:应用可构建、19 条路由齐全。
import 'package:flutter_test/flutter_test.dart';

import 'package:zchain_wallet/app.dart';

void main() {
  test('路由表包含 19 屏', () {
    expect(kRoutes.length, 19);
    for (final String route in kRoutes.keys) {
      expect(kRoutes[route], isNotNull, reason: '路由 $route 缺少 builder');
    }
  });
}

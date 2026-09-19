// 应用状态:双底色(纸白/夜场)+ 全局提示。
import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// 底色模式
enum Ground { paper, night }

class AppState extends ChangeNotifier {
  Ground _ground = Ground.paper;
  String? _toast;

  Ground get ground => _ground;
  ZcPalette get palette =>
      _ground == Ground.paper ? ZcColors.paper : ZcColors.night;
  bool get isDark => _ground == Ground.night;

  void toggleGround() {
    _ground = _ground == Ground.paper ? Ground.night : Ground.paper;
    notifyListeners();
  }

  /// 轻提示(等价设计稿的 data-toast;数秒后自动消失由调用方管理)
  String? get toast => _toast;

  void showToast(String msg) {
    _toast = msg;
    notifyListeners();
  }

  void clearToast() {
    _toast = null;
    notifyListeners();
  }
}

/// 全局单例(MVP 阶段:无外部状态库依赖)
final AppState appState = AppState();

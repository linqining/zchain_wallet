// 主题:由 ZcPalette 构建 Material ThemeData(纸白 / 夜场)。
import 'package:flutter/material.dart';

import 'tokens.dart';

ThemeData buildTheme(ZcPalette c) {
  final ColorScheme scheme = ColorScheme.light(
    primary: c.felt,
    onPrimary: c.onFelt,
    secondary: c.real,
    onSecondary: c.onFelt,
    error: c.bad,
    onError: c.onBad,
    surface: c.cd,
    onSurface: c.ink,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: c.pg,
    fontFamily: ZcType.uiFamily,
    splashFactory: InkSparkle.splashFactory,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    dialogTheme: DialogThemeData(
      backgroundColor: c.pg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ZcPalette.rS),
        side: BorderSide(color: c.ink),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.pg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ZcPalette.rL)),
      ),
      showDragHandle: false,
    ),
  );
}

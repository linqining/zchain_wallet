/// ZChain Wallet · 账簿 Ledger —— 设计 token(tokens.dart)
///
/// 与 Pixso 设计文件「设计文件」(file wrfLcH3XiFpZsxMwj0DPkw)逐值一致:
/// 纸白底、细线账格、方形印章、等宽数字右对齐;双底色(纸白/夜场)一键切换。
/// 品牌硬规则:零 webfont(系统栈 + 等宽数字);哈希/地址/金额一律等宽;
/// 无描边字、无发光字;REAL 区块必带托管提示;金色仅用于 REAL 强调。
library;

import 'package:flutter/material.dart';

/// 双底色 token 集(纸白 Ledger / 夜场 Felt)
class ZcColors {
  const ZcColors._();

  static const ZcPalette paper = ZcPalette(
    pg: Color(0xFFF5F2EA),
    pg2: Color(0xFFEAE5D9),
    cd: Color(0xFFFFFDF7),
    cd2: Color(0xFFF8F5EC),
    ink: Color(0xFF14130F),
    ink2: Color(0xFF4B4840),
    ink3: Color(0xFF666256),
    rl: Color(0xFFDDD6C6),
    rl2: Color(0xFFC3BBA7),
    felt: Color(0xFF0B6B45),
    feltW: Color(0xFFE6EFE8),
    feltRl: Color(0xFFA8C8B6),
    play: Color(0xFF15507F),
    playW: Color(0xFFE5ECF3),
    playRl: Color(0xFFA9C0D6),
    real: Color(0xFF7D5308),
    realW: Color(0xFFF6EBD4),
    realRl: Color(0xFFD8BD85),
    bad: Color(0xFFA83226),
    badW: Color(0xFFF7E6E2),
    badRl: Color(0xFFDDA9A1),
    amb: Color(0xFF8A5A12),
    ambW: Color(0xFFF6EEDA),
    ambRl: Color(0xFFDCC796),
    onFelt: Color(0xFFFFFDF7),
    onInk: Color(0xFFF5F2EA),
    onBad: Color(0xFFFFFDF7),
    code: Color(0xFFEFEADE),
    rulePaper: Color(0x0B14130F),
    shadow: Color(0x0A14130F),
  );

  /// 夜场底:14 个 token 逐字来自 media-kit/v0.1/brand.css(毡布绿夜场)
  static const ZcPalette night = ZcPalette(
    pg: Color(0xFF070D0A),
    pg2: Color(0xFF0B1410),
    cd: Color(0xFF101C15),
    cd2: Color(0xFF152418),
    ink: Color(0xFFF0F7F1),
    ink2: Color(0xFFABC3B6),
    ink3: Color(0xFF7D9A8B),
    rl: Color(0xFF1D3326),
    rl2: Color(0xFF2A4A37),
    felt: Color(0xFF37E39C),
    feltW: Color(0x1C37E39C),
    feltRl: Color(0x5937E39C),
    play: Color(0xFF66C4FF),
    playW: Color(0x1C66C4FF),
    playRl: Color(0x5966C4FF),
    real: Color(0xFFFFC75A),
    realW: Color(0x1CFFC75A),
    realRl: Color(0x61FFC75A),
    bad: Color(0xFFFF9483),
    badW: Color(0x1AFF9483),
    badRl: Color(0x59FF9483),
    amb: Color(0xFFFFD166),
    ambW: Color(0x1AFFD166),
    ambRl: Color(0x59FFD166),
    onFelt: Color(0xFF05130C),
    onInk: Color(0xFF070D0A),
    onBad: Color(0xFF1A0A08),
    code: Color(0xFF0A120D),
    rulePaper: Color(0x0DF0F7F1),
    shadow: Color(0x00000000),
  );
}

/// 单一底色的完整 token 集
class ZcPalette {
  const ZcPalette({
    required this.pg,
    required this.pg2,
    required this.cd,
    required this.cd2,
    required this.ink,
    required this.ink2,
    required this.ink3,
    required this.rl,
    required this.rl2,
    required this.felt,
    required this.feltW,
    required this.feltRl,
    required this.play,
    required this.playW,
    required this.playRl,
    required this.real,
    required this.realW,
    required this.realRl,
    required this.bad,
    required this.badW,
    required this.badRl,
    required this.amb,
    required this.ambW,
    required this.ambRl,
    required this.onFelt,
    required this.onInk,
    required this.onBad,
    required this.code,
    required this.rulePaper,
    required this.shadow,
  });

  final Color pg; // 页面底
  final Color pg2; // 页面底·深一档
  final Color cd; // 卡片纸面
  final Color cd2; // 卡片纸面·深一档(hover / 瓦片)
  final Color ink; // 主墨(文字/实心强调)
  final Color ink2; // 次级文字
  final Color ink3; // 弱化文字
  final Color rl; // 细线
  final Color rl2; // 细线·深一档(边框)
  final Color felt; // 账簿绿(主操作/成功)
  final Color feltW; // 账簿绿·弱底
  final Color feltRl; // 账簿绿·描边
  final Color play; // PLAY 蓝(筹码)
  final Color playW;
  final Color playRl;
  final Color real; // REAL 金墨(法币域)
  final Color realW;
  final Color realRl;
  final Color bad; // 印章红(危险)
  final Color badW;
  final Color badRl;
  final Color amb; // 琥珀(注意/锁定)
  final Color ambW;
  final Color ambRl;
  final Color onFelt; // felt 底上的文字
  final Color onInk; // ink 底上的文字
  final Color onBad; // bad 底上的文字
  final Color code; // 代码/口令底
  final Color rulePaper; // 账格纸纹线
  final Color shadow; // 卡片阴影(夜场为无)

  /// 圆角:账簿体系用小圆角(r=3, rL=6)
  static const double rS = 3;
  static const double rL = 6;
}

/// 字体体系:系统 UI 栈 + 等宽数字(fontFeature tabular)
class ZcType {
  const ZcType._();

  static const String uiFamily = 'Roboto';
  static const String monoFamily = 'monospace';

  /// 屏幕正文 13
  static const double body = 13;
  static const double s10 = 10.5;
  static const double s9 = 9.5;

  /// 等宽文本样式(金额/地址/标签;tabular-nums)
  static TextStyle mono(
    BuildContext? context, {
    double size = body,
    FontWeight weight = FontWeight.w400,
    double? ls,
    Color? color,
    bool tabular = true,
  }) {
    return TextStyle(
      fontFamily: monoFamily,
      fontFamilyFallback: const ['Courier New', 'monospace'],
      fontSize: size,
      fontWeight: weight,
      letterSpacing: ls,
      color: color,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
      height: 1.5,
    );
  }

  /// UI 文本样式
  static TextStyle ui(
    BuildContext? context, {
    double size = body,
    FontWeight weight = FontWeight.w400,
    double? ls,
    double? height,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: uiFamily,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: ls,
      color: color,
      height: height ?? 1.55,
    );
  }

  /// 小型等宽大写节标题(cd-h / sec-t / dh-kind:9.5 · 字距 .15em)
  static TextStyle section(
    BuildContext? context, {
    double size = s9,
    double ls = 0.15 * s9,
    Color? color,
  }) =>
      mono(context, size: size, weight: FontWeight.w500, ls: ls, color: color);
}

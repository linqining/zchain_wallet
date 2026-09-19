// 屏幕 01 · 欢迎 · 一次创建三层(welcome)
// 设计:Pixso「设计文件」01-welcome —— 封面页,引导流;无底部 Tab。
// 账格纸纹封面:logo / 标题 / 三格数据 / 层徽章,主次按钮压底,cv-foot 脚注。
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/demo.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

/// v1 内联 SVG logo(圆角方框 + Z + 右上菱形),与截图一致;经 srcIn 染当前墨色。
const String _kLogoSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" fill="none" stroke="#000000" stroke-width="4"><rect x="2" y="2" width="60" height="60" rx="14"/><path d="M17 21 H45 L24 43 H47" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/><rect x="42" y="8" width="9" height="9" rx="1.5" transform="rotate(45 46.5 12.5)" fill="#000000" stroke="none"/></svg>';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: null,
      body: Container(
        color: c.pg,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(painter: RuledPaperPainter(c.rulePaper)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SvgPicture.string(
                        _kLogoSvg,
                        width: 44,
                        height: 44,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(c.ink, BlendMode.srcIn),
                      ),
                      const Spacer(),
                      const ZcChip('DEVNET', solid: true),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'ZChain Wallet',
                    style: ZcType.ui(
                      context,
                      size: 21,
                      weight: FontWeight.w700,
                      ls: -0.21,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '桌上飞快,结算可证',
                    style: ZcType.ui(context, size: 12.5, color: c.ink2),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'FAST AT THE TABLE. VERIFIABLE AT SETTLEMENT.',
                    style: ZcType.mono(
                      context,
                      size: 9.5,
                      ls: 1.33,
                      color: c.ink3,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _metaGrid(context, c),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: <Widget>[
                      ZcChip('ZCHAIN 隐私层', tone: 'felt', icon: 'i-spade'),
                      const ZcChip('EVM 多链', icon: 'i-ether'),
                      const ZcChip('STARKNET', icon: 'i-layers'),
                    ],
                  ),
                  const Spacer(),
                  ZcButton(
                    '一键创建钱包',
                    variant: 'p',
                    icon: 'i-dl',
                    onTap: () => ZcNav.go(context, 'success'),
                  ),
                  const SizedBox(height: 8),
                  ZcButton(
                    '导入或恢复钱包',
                    variant: 's',
                    onTap: () => ZcNav.go(context, 'import'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '一次创建三层账户:ZChain 隐私层 + EVM 多链 + Starknet',
                    textAlign: TextAlign.center,
                    style: ZcType.ui(
                      context,
                      size: 10.5,
                      color: c.ink3,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      footer: _cvFoot(c),
    );
  }

  /// cv-meta:三格数据(细线分隔的纸卡格)
  static Widget _metaGrid(BuildContext context, ZcPalette c) {
    return Container(
      decoration: BoxDecoration(
        color: c.rl,
        border: Border.all(color: c.rl),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      child: Row(
        children: <Widget>[
          _metaCell(context, c, '3', '账户层'),
          Container(width: 1, color: c.rl),
          _metaCell(context, c, '2 套 KDF', '本地加密'),
          Container(width: 1, color: c.rl),
          _metaCell(context, c, 'STARK', '可复验'),
        ],
      ),
    );
  }

  static Widget _metaCell(
    BuildContext context,
    ZcPalette c,
    String value,
    String label,
  ) {
    return Expanded(
      child: Container(
        color: c.cd,
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
        child: Column(
          children: <Widget>[
            Text(
              value,
              style: ZcType.mono(context, size: 12, weight: FontWeight.w600),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: ZcType.mono(context, size: 8.5, ls: 0.85, color: c.ink3),
            ),
          ],
        ),
      ),
    );
  }

  /// cv-foot:等宽大写脚注(两行)
  static Widget _cvFoot(ZcPalette c) {
    final String line1 =
        '${DemoData.designVersion} · 对齐 ${DemoData.extension} · MV3 · 继续即代表知悉测试网风险'
            .toUpperCase();
    final String line2 = DemoData.build.toUpperCase();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.rl)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            line1,
            textAlign: TextAlign.center,
            style: ZcType.mono(null, size: 9, ls: 0.72, color: c.ink3),
          ),
          Text(
            line2,
            textAlign: TextAlign.center,
            style: ZcType.mono(null, size: 9, ls: 0.72, color: c.ink3),
          ),
        ],
      ),
    );
  }
}

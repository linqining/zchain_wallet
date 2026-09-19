// 屏幕 04 · 锁定 · 统一解锁(lock)
// 设计:Pixso「设计文件」04-lock —— 封面页,引导流;无底部 Tab。
import 'package:flutter/material.dart';

import '../data/demo.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const LockScreen();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: null,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: c.pg,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CustomPaint(painter: RuledPaperPainter(c.rulePaper)),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Avatar(DemoData.accountInitial, size: 52),
                        const SizedBox(height: 12),
                        Text(
                          DemoData.accountName,
                          style: ZcType.ui(
                            context,
                            size: 16,
                            weight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DemoData.layers[0].addr,
                          style: ZcType.mono(context, size: 11, color: c.ink3),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ZcChip('已锁定', tone: 'amb', icon: 'i-lock'),
                            const SizedBox(width: 6),
                            const ZcChip('15 分钟无操作 / 后台被回收'),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 22),
                          width: 282,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ZcInput(hint: '解锁口令', obscure: true),
                              const SizedBox(height: 10),
                              ZcButton(
                                '解锁三层',
                                variant: 'p',
                                onTap: () =>
                                    ZcNav.switchTab(context, 'zc-dash'),
                              ),
                              const SizedBox(height: 4),
                              ZcButton(
                                '忘记口令?使用备份恢复',
                                variant: 'g',
                                onTap: () => ZcNav.go(context, 'import'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // cv-foot
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: c.cd,
              border: Border(top: BorderSide(color: c.rl)),
            ),
            child: Text(
              '统一解锁三层 · ZChain 层 Argon2id + ChaCha20-Poly1305,EVM / Starknet 层 PBKDF2-SHA256(600k)+ AES-256-GCM',
              textAlign: TextAlign.center,
              style: ZcType.mono(context, size: 9, ls: 0.72, color: c.ink3),
            ),
          ),
        ],
      ),
    );
  }
}

// 屏幕 03 · 导入 / 恢复(import)
// 设计:Pixso「设计文件」03-import —— 引导子页;SubHeader + 三分段。
// 备份恢复(.zcbk 文件)/ 私钥导入 / 自定义口令三个 pane,seg 可切换。
import 'package:flutter/material.dart';

import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const ImportScreen();

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  int _tab = 0; // 0 备份恢复 / 1 私钥导入 / 2 自定义口令
  final TextEditingController _targetCtrl = TextEditingController(
    text: 'EVM · Ethereum compatible',
  );

  static const List<String> _tabLabels = <String>['备份恢复', '私钥导入', '自定义口令'];

  @override
  void dispose() {
    _targetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: SubHeader(title: '导入 / 恢复'),
      body: ZcBody(
        children: <Widget>[
          _seg(context, c),
          if (_tab == 0) ..._backupPane(context, c),
          if (_tab == 1) ..._keyPane(context, c),
          if (_tab == 2) ..._passPane(context, c),
        ],
      ),
    );
  }

  /// seg 分段(备份恢复 / 私钥导入 / 自定义口令)
  Widget _seg(BuildContext context, ZcPalette c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: c.rl2,
        border: Border.all(color: c.rl2),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < _tabLabels.length; i++) ...<Widget>[
            if (i > 0) Container(width: 1, color: c.rl2),
            Expanded(
              child: Material(
                color: i == _tab ? c.ink : c.cd,
                child: InkWell(
                  onTap: () => setState(() => _tab = i),
                  child: Container(
                    height: 32,
                    alignment: Alignment.center,
                    child: Text(
                      _tabLabels[i],
                      style: ZcType.mono(
                        context,
                        size: 11.5,
                        ls: 0.35,
                        weight: i == _tab ? FontWeight.w600 : FontWeight.w400,
                        color: i == _tab ? c.onInk : c.ink2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---- pane 1 · 备份恢复 ----

  List<Widget> _backupPane(BuildContext context, ZcPalette c) {
    return <Widget>[
      _filePicker(context, c),
      Container(
        margin: const EdgeInsets.only(top: 13),
        child: ZcField(label: '备份口令', hint: '≥ 8 位,与钱包解锁口令相互独立', obscure: true),
      ),
      ZcButton(
        '恢复钱包',
        variant: 'p',
        onTap: () => ZcScope.state(context).showToast('示意:Argon2id 本地解密中'),
      ),
      const Gap(h: 12),
      NoticeBanner(
        '只覆盖 ZChain 层',
        'ZCBK v1 含 REAL/PLAY 双库与 keystore 信封,不含 EVM / Starknet 账户——那两层请在各自管理页导出私钥。解密全程本地完成,备份口令不离开设备。',
        tone: 'info',
        icon: 'i-info',
      ),
    ];
  }

  /// empty 虚线框:选择 .zcbk 备份文件
  Widget _filePicker(BuildContext context, ZcPalette c) {
    return CustomPaint(
      painter: _DashedBorderPainter(c.rl2),
      child: Material(
        color: c.cd,
        child: InkWell(
          onTap: () => ZcScope.state(context).showToast('示意:文件选择器'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
            child: Column(
              children: <Widget>[
                ZcIcons.icon('i-ul', size: 24, color: c.felt),
                const SizedBox(height: 7),
                Text(
                  '选择 .zcbk 备份文件',
                  style: ZcType.ui(context, size: 13, weight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Text(
                  '由「设置 → 备份导出」生成 · 仅 ZChain 层 note 库',
                  style: ZcType.mono(context, size: 10.5, color: c.ink3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---- pane 2 · 私钥导入(v1 语义结构;截图未展开,文案按 v1) ----

  List<Widget> _keyPane(BuildContext context, ZcPalette c) {
    return <Widget>[
      ZcField(
        label: '目标层',
        controller: _targetCtrl,
        suffix: ZcIcons.icon('i-chev-d', size: 16, color: c.ink3),
      ),
      ZcField(label: '私钥(hex)', hint: '0x…'),
      ZcField(label: '加密口令', hint: '用于本地 keystore 加密', obscure: true),
      ZcButton(
        '导入到所选层',
        variant: 'p',
        onTap: () => ZcScope.state(context).showToast('示意:导入到所选层'),
      ),
      Container(
        margin: const EdgeInsets.only(top: 12),
        child: RichText(
          text: TextSpan(
            style: ZcType.ui(null, size: 11.5, color: c.ink3),
            children: <InlineSpan>[
              const TextSpan(
                text: '支持各层独立导入:Starknet 走 STARK curve,EVM 走 secp256k1,ZChain note 层',
              ),
              TextSpan(
                text: '暂不支持私钥导入',
                style: ZcType.ui(
                  null,
                  size: 11.5,
                  weight: FontWeight.w700,
                  color: c.bad,
                ),
              ),
              const TextSpan(text: '。'),
            ],
          ),
        ),
      ),
    ];
  }

  // ---- pane 3 · 自定义口令(v1 语义结构;截图未展开,文案按 v1) ----

  List<Widget> _passPane(BuildContext context, ZcPalette c) {
    return <Widget>[
      ZcField(label: '自定义解锁口令', hint: '至少 10 位,含数字与字母', obscure: true),
      const ZcMeter(0.66),
      Container(
        margin: const EdgeInsets.only(top: 6, bottom: 13),
        child: Text(
          '强度:良好',
          style: ZcType.mono(context, size: 10.5, color: c.ink3),
        ),
      ),
      ZcField(label: '确认口令', hint: '再次输入', obscure: true),
      ZcButton(
        '创建并使用自定义口令',
        variant: 'p',
        onTap: () => ZcNav.switchTab(context, 'home'),
      ),
    ];
  }
}

/// 虚线描边(empty 的 dashed 边框;Flutter 无原生 dashed border)
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    const double seg = 3;
    final double w = size.width - 1;
    final double h = size.height - 1;
    for (double x = 0.5; x < w; x += seg * 2) {
      final double e = x + seg > w ? w : x + seg;
      canvas.drawLine(Offset(x, 0.5), Offset(e, 0.5), p);
      canvas.drawLine(Offset(x, h), Offset(e, h), p);
    }
    for (double y = 0.5; y < h; y += seg * 2) {
      final double e = y + seg > h ? h : y + seg;
      canvas.drawLine(Offset(0.5, y), Offset(0.5, e), p);
      canvas.drawLine(Offset(w, y), Offset(w, e), p);
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) => old.color != color;
}

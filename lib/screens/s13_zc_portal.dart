// 屏幕 13 · Proof Portal(zc-portal)
// 设计:Pixso「设计文件」13-zc-portal —— 证明生成/提交入口:hand binding(note 绑定)
// 输入、一键生成 STARK 证明、验证步骤 3/4(拉取明细 → 下载证明 → 浏览器内验证
// 运行中 → 本地复验待办)、性能如实标注提示条、结算摘要与「已验证」印章 +
// 验证通过提示条;子页,无底部 Tab。
import 'package:flutter/material.dart';

import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class ZcPortalScreen extends StatefulWidget {
  const ZcPortalScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const ZcPortalScreen();

  @override
  State<ZcPortalScreen> createState() => _ZcPortalScreenState();
}

class _ZcPortalScreenState extends State<ZcPortalScreen> {
  /// hand binding:待验证手牌的结算 note 标识(与设计稿一致)
  final TextEditingController _binding = TextEditingController(
    text: '0xc41d8f22e9a04b79b',
  );

  @override
  void dispose() {
    _binding.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: SubHeader(
        title: 'Proof Portal',
        trailing: ZcChip('STARK', tone: 'felt', xs: true),
      ),
      body: ZcBody(
        children: <Widget>[
          _bindingField(context, c),
          ZcButton(
            '验证这一手牌',
            icon: 'i-shield',
            onTap: () => ZcScope.state(context).showToast('示意:开始验证流程'),
          ),
          const Gap(h: 14),
          _stepsCard(context, c),
          const Gap(),
          NoticeBanner(
            '性能如实标注',
            '浏览器内完整验证约 1.7s,超出 500ms 交互预算——进度如实展示,不伪装即时。',
            tone: 'info',
            icon: 'i-info',
          ),
          const Gap(),
          LedgerCard(
            header: '结算摘要',
            child: Column(
              children: <Widget>[
                const LedgerRow('底池', '1,240.00 PLAY'),
                const LedgerRow('rake', '24.80 PLAY(2%)'),
                LedgerRow('我方份额', '+620.50 PLAY', valueColor: c.felt),
                const LedgerRow('payout_root', '0x8c3f…d210'),
              ],
            ),
          ),
          const Gap(),
          const Align(alignment: Alignment.centerLeft, child: Seal('已验证')),
          NoticeBanner(
            '验证通过',
            '该手牌结算与链上 STARK 证明一致。',
            tone: 'ok',
            icon: 'i-shield',
          ),
        ],
      ),
    );
  }

  // ---- hand binding 字段(fld + fl + iw + in-ic) ----

  Widget _bindingField(BuildContext context, ZcPalette c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'HAND BINDING',
            style: ZcType.mono(context, size: 11, ls: 0.55, color: c.ink2),
          ),
          const SizedBox(height: 5),
          Stack(
            children: <Widget>[
              TextField(
                controller: _binding,
                style: ZcType.mono(context, size: 11.5, color: c.ink),
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: c.cd,
                  contentPadding: const EdgeInsets.fromLTRB(12, 13, 42, 13),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ZcPalette.rS),
                    borderSide: BorderSide(color: c.rl2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(ZcPalette.rS),
                    borderSide: BorderSide(color: c.ink),
                  ),
                ),
              ),
              Positioned(
                right: 6,
                top: 6,
                child: SquareIconButton(
                  icon: 'i-copy',
                  tooltip: '粘贴',
                  onTap: () => ZcScope.state(context).showToast('已粘贴'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- 验证步骤卡(卡头右侧 3/4 计数) ----

  Widget _stepsCard(BuildContext context, ZcPalette c) {
    return LedgerCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _cardHead(
            context,
            '验证步骤',
            trailing: Text(
              '3/4',
              style: ZcType.mono(context, size: 10, color: c.felt),
            ),
          ),
          const _StepRow(
            title: '拉取结算明细',
            subtitle: '网关 127.0.0.1:18900 · 200 OK',
            icon: 'i-check',
            state: 'done',
          ),
          const _StepRow(
            title: '下载 STARK 证明',
            subtitle: 'payload 84.2 KB · engine stwo',
            icon: 'i-check',
            state: 'done',
          ),
          const _StepRow(
            title: '浏览器内完整验证',
            subtitle: 'stwo wasm 运行中…',
            icon: 'i-refresh',
            state: 'run',
          ),
          const _StepRow(
            index: '4',
            title: 'wallet-core 本地复验',
            subtitle: '结算关系与 payout_root 比对',
            state: 'todo',
            last: true,
          ),
        ],
      ),
    );
  }

  /// 卡头(cd-h):等宽大写节标题 + 右侧附加内容(共享 LedgerCard 的卡头
  /// 只支持「查看全部」链接,这里需要裸计数,故自绘同款)。
  static Widget _cardHead(
    BuildContext context,
    String text, {
    Widget? trailing,
  }) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.rl)),
      ),
      child: Row(
        children: <Widget>[
          Text(text, style: ZcType.section(context, color: c.ink3)),
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}

/// 步骤行(stp):done=绿底对勾 / run=琥珀描边刷新 / todo=灰底序号。
/// 共享 StepRow 只支持文本序号,按设计稿补齐图标状态与分隔线。
class _StepRow extends StatelessWidget {
  const _StepRow({
    this.index,
    required this.title,
    required this.subtitle,
    this.icon,
    this.state = 'todo',
    this.last = false,
  });

  final String? index;
  final String title;
  final String subtitle;
  final String? icon;
  final String state; // done / run / todo
  final bool last;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    Color bg = c.cd2;
    Color bd = c.rl2;
    Color fg = c.ink3;
    if (state == 'done') {
      bg = c.felt;
      bd = c.felt;
      fg = c.onFelt;
    }
    if (state == 'run') {
      bd = c.amb;
      fg = c.amb;
      bg = c.ambW;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: last
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: c.rl)),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: bd),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.center,
            child: icon != null
                ? ZcIcons.icon(icon!, size: 11, color: fg)
                : Text(
                    index ?? '',
                    style: ZcType.mono(context, size: 9.5, color: fg),
                  ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: ZcType.ui(context, size: 12, weight: FontWeight.w600),
                ),
                Text(
                  subtitle,
                  style: ZcType.mono(context, size: 10.5, color: c.ink3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

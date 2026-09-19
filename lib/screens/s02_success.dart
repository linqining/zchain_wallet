// 屏幕 02 · 创建成功 · 解锁口令(success)
// 设计:Pixso「设计文件」02-success —— 引导流;无头部、无底部 Tab。
// 印章 + 一次性口令提示条 + 口令块 + 三层地址卡;勾选后解锁「开始使用」。
import 'package:flutter/material.dart';

import '../data/demo.dart';
import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const SuccessScreen();

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  bool _saved = false;

  static const List<String> _layerLabels = <String>[
    'ZChain',
    'EVM',
    'Starknet',
  ];

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: null,
      body: ZcBody(
        children: <Widget>[
          const SizedBox(height: 8),
          Column(
            children: <Widget>[
              const Seal('已创建'),
              const SizedBox(height: 14),
              Text(
                '钱包已创建',
                style: ZcType.ui(context, size: 19, weight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                '三层账户已就绪,先保存好解锁口令。',
                style: ZcType.ui(context, size: 12, color: c.ink2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          NoticeBanner(
            '解锁口令只显示这一次',
            '钱包不存储口令;丢失后仅能通过加密备份恢复。',
            tone: 'bad',
            icon: 'i-key',
          ),
          const Gap(),
          _passBlock(context, c),
          const Gap(h: 12),
          LedgerCard(
            header: '三层地址',
            child: Column(children: _addrRows(context, c)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2, bottom: 14),
            child: ZcCheckbox(
              text: '我已将口令保存在安全的地方(密码管理器 / 纸质备份)',
              on: _saved,
              onTap: () => setState(() => _saved = !_saved),
            ),
          ),
          if (_saved)
            ZcButton(
              '我已保存,开始使用',
              variant: 'p',
              onTap: () => ZcNav.switchTab(context, 'home'),
            )
          else
            _disabledButton(context, c),
        ],
      ),
    );
  }

  /// pass 口令块:code 底等宽口令 + 复制钮
  static Widget _passBlock(BuildContext context, ZcPalette c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: c.code,
        border: Border.all(color: c.rl2),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'felt-poker-verifiable-9x2a',
              style: ZcType.mono(context, size: 13, ls: 0.26),
            ),
          ),
          const SizedBox(width: 8),
          SquareIconButton(
            icon: 'i-copy',
            tooltip: '复制口令',
            onTap: () => ZcScope.state(context).showToast('口令已复制到剪贴板'),
          ),
        ],
      ),
    );
  }

  /// 三层地址行(lr):层图标 + 名称 + 地址 + 裸复制钮
  static List<Widget> _addrRows(BuildContext context, ZcPalette c) {
    final int n = DemoData.layers.length;
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < n; i++) {
      rows.add(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: i == n - 1
              ? null
              : BoxDecoration(
                  border: Border(bottom: BorderSide(color: c.rl)),
                ),
          child: Row(
            children: <Widget>[
              ZcIcons.icon(
                DemoData.layers[i].icon,
                size: 11,
                color: i == 0 ? c.felt : c.ink3,
              ),
              const SizedBox(width: 5),
              Text(
                _layerLabels[i],
                style: ZcType.ui(context, size: 12.5, color: c.ink2),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  DemoData.layers[i].addr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZcType.mono(context, size: 12.5),
                ),
              ),
              const SizedBox(width: 6),
              SquareIconButton(
                icon: 'i-copy',
                bare: true,
                onTap: () => ZcScope.state(context).showToast('地址已复制'),
              ),
            ],
          ),
        ),
      );
    }
    return rows;
  }

  /// 禁用态按钮(btn[disabled]:pg2 底 + 弱化文字,整体降透明)
  static Widget _disabledButton(BuildContext context, ZcPalette c) {
    return Opacity(
      opacity: 0.42,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: c.pg2,
          border: Border.all(color: c.rl2),
          borderRadius: BorderRadius.circular(ZcPalette.rS),
        ),
        child: Text(
          '我已保存,开始使用',
          style: ZcType.ui(
            context,
            size: 13,
            weight: FontWeight.w600,
            color: c.ink3,
          ),
        ),
      ),
    );
  }
}

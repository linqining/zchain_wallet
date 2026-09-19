// 屏幕 05 · 三链总账(General Ledger)
// 设计:Pixso「设计文件」05-home —— 账户首页;底部 Tab「总账」。
import 'package:flutter/material.dart';

import '../data/demo.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const HomeScreen();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: DashHeaderBlock(
        header: DashHeader(
          kind: 'General Ledger',
          title: DemoData.accountName,
          subtitle: DemoData.accountSub,
          actions: <Widget>[
            SquareIconButton(
              icon: 'i-lock',
              tooltip: '锁定',
              onTap: () => ZcNav.go(context, 'lock'),
            ),
          ],
        ),
      ),
      body: ZcBody(
        children: <Widget>[
          TotalCard(
            label: DemoData.totalLabel,
            amount: DemoData.totalAmount,
            eq: true,
            trailing: SquareIconButton(
              icon: 'i-eye',
              bare: true,
              tooltip: '隐藏金额',
              onTap: () => ZcScope.state(context).showToast('示意:隐藏金额'),
            ),
            subChips: <Widget>[ZcChip(DemoData.totalChipLabel, tone: 'real')],
            subTexts: const <String>[DemoData.totalNote],
          ),
          const SectionTitle('账户层'),
          LedgerCard(
            tight: true,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: <Widget>[
                for (int i = 0; i < DemoData.layers.length; i++) ...<Widget>[
                  AssetRow(
                    name: DemoData.layers[i].name,
                    chip: DemoData.layers[i].state,
                    chipTone: DemoData.layers[i].stateTone,
                    sub: DemoData.layers[i].sub,
                    tileIcon: DemoData.layers[i].icon,
                    amount: DemoData.layers[i].amount,
                    rightSub: DemoData.layers[i].addr,
                    onTap: () => ZcNav.go(context, DemoData.layers[i].route),
                  ),
                ],
              ],
            ),
          ),
          Gap(),
          LedgerCard(
            header: '最弱凭证',
            child: FinalityRail(
              current: 2,
              caption: _weakestCaption(c),
              captionAction: '查看',
              onAction: () => ZcNav.go(context, 'zc-withdraw'),
            ),
          ),
          Gap(),
          LedgerCard(
            header: '待办',
            moreLabel: '1 项',
            onMore: () => ZcNav.go(context, 'zc-confirm'),
            child: MenuRow(
              icon: 'i-pen',
              tone: 'amb',
              title: '开桌签名请求 · 8♠ 桌',
              subtitle: 'poker.zchain.devnet · 92s 后过期',
              onTap: () => ZcNav.go(context, 'zc-confirm'),
            ),
          ),
          Gap(),
          ZcButton(
            '全部锁定',
            variant: 's',
            small: true,
            icon: 'i-lock',
            onTap: () => ZcNav.go(context, 'lock'),
          ),
          ZcFoot(<String>[
            'ZChain Wallet · ${DemoData.designVersion} / ${DemoData.extension} · DevNet',
            DemoData.build,
          ]),
        ],
      ),
      tabs: 'home',
    );
  }

  static Widget _weakestCaption(ZcPalette c) {
    // 1 张 REAL note 停在 soft(b 琥珀强调)
    return RichText(
      text: TextSpan(
        style: ZcType.ui(null, size: 10.5, color: c.ink2),
        children: <InlineSpan>[
          const TextSpan(text: '1 张 REAL note 停在 '),
          TextSpan(
            text: 'soft',
            style: ZcType.ui(
              null,
              size: 10.5,
              weight: FontWeight.w700,
              color: c.amb,
            ),
          ),
        ],
      ),
    );
  }
}

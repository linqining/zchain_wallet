// 共享组件库:base.css 组件的 Flutter 移植(账簿 Ledger 体系)。
//
// 组件与设计稿 1:1:票据抬头(齿孔线)、纸卡、方形标签、印章、凭证条、
// 资产/交易行、链切换器、快捷动作条、底部 3 Tab、封面页等。
import 'package:flutter/material.dart';

import '../data/demo.dart';
import 'icons.dart';
import 'scope.dart';
import 'tokens.dart';

/// 账格纸纹(25px 间距水平细线)
class RuledPaperPainter extends CustomPainter {
  const RuledPaperPainter(this.color, {this.step = 26});
  final Color color;
  final double step;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()..color = color;
    for (double y = step - 1; y < size.height; y += step) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), p);
    }
  }

  @override
  bool shouldRepaint(covariant RuledPaperPainter old) => old.color != color;
}

/// 齿孔虚线(票据抬头下的裁切线:3px 实 / 5px 空,1px 高)
class PerforationPainter extends CustomPainter {
  const PerforationPainter(this.color, {this.opacity = 0.85});
  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()..color = color.withValues(alpha: opacity);
    const double period = 8;
    for (double x = 0; x < size.width; x += period) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 3, 1), p);
    }
  }

  @override
  bool shouldRepaint(covariant PerforationPainter old) =>
      old.color != color || old.opacity != opacity;
}

/// 齿孔线组件
class Perforation extends StatelessWidget {
  const Perforation({super.key, this.opacity = 0.85});
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return SizedBox(
      height: 4,
      width: double.infinity,
      child: CustomPaint(
        painter: PerforationPainter(c.rl2, opacity: opacity),
        size: Size.infinite,
      ),
    );
  }
}

/// 票据抬头(dh):两行头部 + 齿孔线。
class DashHeader extends StatelessWidget {
  const DashHeader({
    super.key,
    required this.kind,
    this.net = DemoData.network,
    required this.title,
    this.avatar = DemoData.accountInitial,
    required this.subtitle,
    this.actions = const <Widget>[],
    this.topActions,
  });

  final String kind;
  final String net;
  final String title;
  final String avatar;
  final String subtitle;
  final List<Widget> actions;
  final List<Widget>? topActions;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      decoration: BoxDecoration(color: c.cd),
      padding: const EdgeInsets.fromLTRB(14, 9, 14, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 20,
            child: Row(
              children: <Widget>[
                Text(
                  kind.toUpperCase(),
                  style: ZcType.section(context, color: c.ink3),
                ),
                const SizedBox(width: 8),
                NetPill(net),
                const Spacer(),
                ...(topActions ??
                    <Widget>[GroundToggleIconButton.bareButton()]),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 3, bottom: 10),
            child: Row(
              children: <Widget>[
                Avatar(avatar),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ZcType.ui(
                                context,
                                size: 13.5,
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          ZcIcons.icon('i-chev-d', size: 14, color: c.ink3),
                        ],
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ZcType.mono(context, size: 10.5, color: c.ink3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                ...actions,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 齿孔线 + 抬头组合(带底部裁切线)
class DashHeaderBlock extends StatelessWidget {
  const DashHeaderBlock({super.key, required this.header});
  final Widget header;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[header, const Perforation()],
    );
  }
}

/// 子页栏(sub):细线 + 方形返回 + 居中标题
class SubHeader extends StatelessWidget {
  const SubHeader({
    super.key,
    required this.title,
    this.trailing,
    this.backIcon = 'i-back',
  });
  final String title;
  final Widget? trailing;

  /// 返回键图标(签名请求类页面用关闭 X)
  final String backIcon;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: c.cd,
            border: Border(bottom: BorderSide(color: c.rl)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              SquareIconButton(
                icon: backIcon,
                onTap: () => ZcNav.back(context),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: ZcType.ui(context, size: 14, weight: FontWeight.w600),
                ),
              ),
              SizedBox(
                width: 30 + (trailing == null ? 0 : 36),
                child: Align(alignment: Alignment.centerRight, child: trailing),
              ),
            ],
          ),
        ),
        const Perforation(opacity: 0.7),
      ],
    );
  }
}

/// 底部 3 Tab(总账 / 账簿 / 证明)
class BottomTabs extends StatelessWidget {
  const BottomTabs({super.key, required this.active});
  final String active;

  static const List<({String route, String label, String icon})> _tabs =
      <({String route, String label, String icon})>[
        (route: 'home', label: '总账', icon: 'i-home'),
        (route: 'zc-dash', label: '账簿', icon: 'i-book'),
        (route: 'proofs', label: '证明', icon: 'i-shield'),
      ];

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: c.cd,
        border: Border(top: BorderSide(color: c.rl2)),
      ),
      child: Row(
        children: <Widget>[
          for (final ({String route, String label, String icon}) tb in _tabs)
            Expanded(
              child: InkWell(
                onTap: () => ZcNav.switchTab(context, tb.route),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ZcIcons.icon(
                      tb.icon,
                      size: 18,
                      color: tb.route == active ? c.ink : c.ink3,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tb.label,
                      style: ZcType.mono(
                        context,
                        size: 10.5,
                        weight: tb.route == active
                            ? FontWeight.w600
                            : FontWeight.w400,
                        ls: 0.42,
                        color: tb.route == active ? c.ink : c.ink3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 屏幕脚手架:header + 可滚动 body + 底部 Tab。
class ZcScreen extends StatelessWidget {
  const ZcScreen({
    super.key,
    required this.header,
    required this.body,
    this.tabs,
    this.footer,
    this.bottomOverlays,
  });

  final Widget? header;
  final Widget body;
  final String? tabs;
  final Widget? footer;
  final List<Widget>? bottomOverlays;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Scaffold(
      backgroundColor: c.pg,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              ?header,
              Expanded(child: body),
              ?footer,
              if (tabs != null) BottomTabs(active: tabs!),
            ],
          ),
          ...?bottomOverlays,
        ],
      ),
    );
  }
}

/// 可滚动 body(等价 .body:14/16/18 内边距)
class ZcBody extends StatelessWidget {
  const ZcBody({super.key, required this.children, this.pad = true});
  final List<Widget> children;
  final bool pad;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: pad
          ? const EdgeInsets.fromLTRB(16, 14, 16, 18)
          : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// 卡片间距(等价 margin-bottom:12)
class Gap extends StatelessWidget {
  const Gap({super.key, this.h = 12});
  final double h;

  @override
  Widget build(BuildContext context) => SizedBox(height: h);
}

/// 纸卡(cd)
class LedgerCard extends StatelessWidget {
  const LedgerCard({
    super.key,
    required this.child,
    this.header,
    this.moreLabel,
    this.onMore,
    this.moreIcon = 'i-chev-r',
    this.tight = false,
    this.padding,
  });

  final Widget child;
  final String? header;
  final String? moreLabel;
  final VoidCallback? onMore;
  final String moreIcon;
  final bool tight;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.cd,
        border: Border.all(color: c.rl),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
        boxShadow: c.shadow == const Color(0x00000000)
            ? null
            : <BoxShadow>[
                BoxShadow(color: c.shadow, offset: const Offset(0, 1)),
              ],
      ),
      padding:
          padding ??
          (tight
              ? const EdgeInsets.symmetric(horizontal: 14)
              : const EdgeInsets.all(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (header != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: c.rl)),
              ),
              child: Row(
                children: <Widget>[
                  Text(header!, style: ZcType.section(context, color: c.ink3)),
                  const Spacer(),
                  if (moreLabel != null)
                    InkWell(
                      onTap: onMore,
                      child: Row(
                        children: <Widget>[
                          Text(
                            moreLabel!,
                            style: ZcType.mono(
                              context,
                              size: 10,
                              color: c.felt,
                            ),
                          ),
                          ZcIcons.icon(moreIcon, size: 11, color: c.felt),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          child,
        ],
      ),
    );
  }
}

/// 节标题(sec-t)
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.danger = false});
  final String text;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    final Color color = danger ? c.bad : c.ink3;
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: <Widget>[
          Text(text, style: ZcType.section(context, ls: 1.52, color: color)),
          const SizedBox(width: 8),
          Expanded(child: Container(height: 1, color: c.rl)),
        ],
      ),
    );
  }
}

/// 方形标签(ch / ch-xs)
class ZcChip extends StatelessWidget {
  const ZcChip(
    this.text, {
    super.key,
    this.tone,
    this.xs = false,
    this.solid = false,
    this.icon,
  });

  final String text;
  final String? tone; // felt / play / real / bad / amb
  final bool xs;
  final bool solid;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    Color fg = c.ink2;
    Color bg = c.cd;
    Color bd = c.rl2;
    if (solid) {
      bg = c.ink;
      fg = c.onInk;
      bd = c.ink;
    } else if (tone != null) {
      switch (tone) {
        case 'felt':
          fg = c.felt;
          bg = c.feltW;
          bd = c.feltRl;
        case 'play':
          fg = c.play;
          bg = c.playW;
          bd = c.playRl;
        case 'real':
          fg = c.real;
          bg = c.realW;
          bd = c.realRl;
        case 'bad':
          fg = c.bad;
          bg = c.badW;
          bd = c.badRl;
        case 'amb':
          fg = c.amb;
          bg = c.ambW;
          bd = c.ambRl;
      }
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: xs ? 4 : 6,
        vertical: xs ? 0 : 1.5,
      ),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: bd),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            ZcIcons.icon(icon!, size: xs ? 9 : 11, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: ZcType.mono(
              context,
              size: xs ? 9 : 9.5,
              weight: FontWeight.w500,
              ls: (xs ? 0.06 : 0.09) * (xs ? 9 : 9.5),
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

/// 网络胶囊(net)
class NetPill extends StatelessWidget {
  const NetPill(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: c.cd,
        border: Border.all(color: c.rl2),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(width: 6, height: 6, color: c.felt),
          const SizedBox(width: 6),
          Text(text, style: ZcType.mono(context, size: 10.5, color: c.ink2)),
        ],
      ),
    );
  }
}

/// 方形头像(av)
class Avatar extends StatelessWidget {
  const Avatar(this.letter, {super.key, this.size = 30, this.real = false});
  final String letter;
  final double size;
  final bool real;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: real ? c.real : c.ink,
        borderRadius: BorderRadius.circular(2),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: ZcType.mono(
          context,
          size: size * 0.4,
          weight: FontWeight.w700,
          color: real ? c.onFelt : c.onInk,
        ),
      ),
    );
  }
}

/// 主按钮组(btn-p / btn-s / btn-g / btn-d)
class ZcButton extends StatelessWidget {
  const ZcButton(
    this.label, {
    super.key,
    this.onTap,
    this.variant = 'p',
    this.small = false,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onTap;
  final String variant; // p / s / g / d
  final bool small;
  final String? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    Color bg = Colors.transparent;
    Color fg = c.ink;
    Border? border;
    switch (variant) {
      case 'p':
        bg = c.felt;
        fg = c.onFelt;
      case 's':
        border = Border.all(color: c.ink);
      case 'g':
        fg = c.ink2;
      case 'd':
        bg = c.bad;
        fg = c.onBad;
    }
    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          ZcIcons.icon(icon!, size: small ? 13 : 16, color: fg),
          const SizedBox(width: 7),
        ],
        Text(
          label,
          style: ZcType.ui(
            context,
            size: small ? 12 : 13,
            weight: FontWeight.w600,
            color: fg,
          ),
        ),
      ],
    );
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(ZcPalette.rS),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ZcPalette.rS),
        child: Container(
          height: small ? 32 : 42,
          padding: EdgeInsets.symmetric(horizontal: small ? 12 : 16),
          decoration: border == null
              ? null
              : BoxDecoration(
                  border: border,
                  borderRadius: BorderRadius.circular(ZcPalette.rS),
                ),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );
  }
}

/// 方形图标按钮(ib / bare)
class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.bare = false,
    this.color,
    this.tooltip,
  });

  final String icon;
  final VoidCallback? onTap;
  final bool bare;
  final Color? color;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    final Widget box = Container(
      width: bare ? 24 : 30,
      height: bare ? 24 : 30,
      decoration: bare
          ? null
          : BoxDecoration(
              color: c.cd,
              border: Border.all(color: c.rl2),
              borderRadius: BorderRadius.circular(ZcPalette.rS),
            ),
      alignment: Alignment.center,
      child: ZcIcons.icon(icon, size: bare ? 14 : 14, color: color ?? c.ink2),
    );
    final Widget w = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ZcPalette.rS),
      child: box,
    );
    return tooltip == null ? w : Tooltip(message: tooltip!, child: w);
  }
}

/// 顶栏底色切换按钮(太阳图标)
class GroundToggleIconButton extends StatelessWidget {
  const GroundToggleIconButton({super.key, this.bare = true});
  final bool bare;

  /// 票据抬头顶行用的裸按钮
  static Widget bareButton() => const GroundToggleIconButton();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return SquareIconButton(
      icon: 'i-sun',
      bare: bare,
      color: c.ink2,
      tooltip: '切换纸白 / 夜场',
      onTap: () => ZcScope.state(context).toggleGround(),
    );
  }
}

/// 资产瓦片(tk)
class TokenTile extends StatelessWidget {
  const TokenTile(this.letter, {super.key, this.tone, this.icon});
  final String? letter;
  final String? tone; // felt / play / real
  final String? icon;

  const TokenTile.icon(this.icon, {super.key, this.tone}) : letter = null;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    Color fg = c.ink2;
    Color bg = c.cd2;
    Color bd = c.rl2;
    if (tone == 'felt') {
      fg = c.felt;
      bg = c.feltW;
      bd = c.feltRl;
    }
    if (tone == 'play') {
      fg = c.play;
      bg = c.playW;
      bd = c.playRl;
    }
    if (tone == 'real') {
      fg = c.real;
      bg = c.realW;
      bd = c.realRl;
    }
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: bd),
        borderRadius: BorderRadius.circular(2),
      ),
      alignment: Alignment.center,
      child: icon != null
          ? ZcIcons.icon(icon!, size: 15, color: fg)
          : Text(
              letter ?? '',
              style: ZcType.mono(
                context,
                size: 10,
                weight: FontWeight.w700,
                color: fg,
              ),
            ),
    );
  }
}

/// 资产行(ar)
class AssetRow extends StatelessWidget {
  const AssetRow({
    super.key,
    required this.name,
    required this.sub,
    required this.amount,
    this.chip,
    this.chipTone,
    this.tile,
    this.tileIcon,
    this.tileTone,
    this.amountTone,
    this.rightSub,
    this.onTap,
    this.dim = false,
  });

  final String name;
  final String sub;
  final String amount;
  final String? chip;
  final String? chipTone;
  final String? tile;
  final String? tileIcon;
  final String? tileTone;
  final String? amountTone; // pos / neg / dim
  final String? rightSub;
  final VoidCallback? onTap;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    Color amtColor = c.ink;
    if (amountTone == 'pos') amtColor = c.felt;
    if (amountTone == 'dim') amtColor = c.ink3;
    final Widget row = Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.rl)),
      ),
      child: Row(
        children: <Widget>[
          TokenTile(tile, icon: tileIcon, tone: tileTone),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ZcType.ui(
                          context,
                          size: 12.5,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (chip != null) ...<Widget>[
                      const SizedBox(width: 5),
                      ZcChip(chip!, tone: chipTone, xs: true),
                    ],
                  ],
                ),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZcType.mono(context, size: 10.5, color: c.ink3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                amount,
                style: ZcType.mono(
                  context,
                  size: 13,
                  weight: FontWeight.w600,
                  color: amtColor,
                ),
              ),
              if (rightSub != null)
                Text(
                  rightSub!,
                  style: ZcType.mono(context, size: 10.5, color: c.ink3),
                ),
            ],
          ),
        ],
      ),
    );
    if (dim) {
      return Opacity(opacity: 0.5, child: row);
    }
    if (onTap != null) {
      return InkWell(onTap: onTap, child: row);
    }
    return row;
  }
}

/// 交易行(tx)
class TxRow extends StatelessWidget {
  const TxRow({
    super.key,
    required this.icon,
    required this.tone,
    required this.name,
    required this.sub,
    required this.amount,
    this.amountTone = 'neg',
    this.status,
    this.statusTone,
  });

  final String icon;
  final String tone; // ok / warn / bad / blue / plain
  final String name;
  final String sub;
  final String amount;
  final String amountTone; // pos / neg
  final String? status;
  final String? statusTone;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    Color fg = c.ink2;
    Color bg = c.cd2;
    Color bd = c.rl2;
    if (tone == 'ok') {
      fg = c.felt;
      bg = c.feltW;
      bd = c.feltRl;
    }
    if (tone == 'warn') {
      fg = c.amb;
      bg = c.ambW;
      bd = c.ambRl;
    }
    if (tone == 'bad') {
      fg = c.bad;
      bg = c.badW;
      bd = c.badRl;
    }
    if (tone == 'blue') {
      fg = c.play;
      bg = c.playW;
      bd = c.playRl;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.rl)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: bd),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.center,
            child: ZcIcons.icon(icon, size: 13, color: fg),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZcType.ui(
                    context,
                    size: 12.5,
                    weight: FontWeight.w600,
                  ),
                ),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZcType.mono(context, size: 10.5, color: c.ink3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                amount,
                style: ZcType.mono(
                  context,
                  size: 13,
                  weight: FontWeight.w600,
                  color: amountTone == 'pos' ? c.felt : c.ink,
                ),
              ),
              if (status != null) ...<Widget>[
                const SizedBox(height: 3),
                Align(
                  alignment: Alignment.centerRight,
                  child: ZcChip(status!, tone: statusTone, xs: true),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// 账簿行(lr)
class LedgerRow extends StatelessWidget {
  const LedgerRow(
    this.keyText,
    this.valueText, {
    super.key,
    this.valueColor,
    this.dim = false,
  });
  final String keyText;
  final String valueText;
  final Color? valueColor;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.rl)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(
              keyText,
              overflow: TextOverflow.ellipsis,
              style: ZcType.ui(context, size: 12.5, color: c.ink2),
            ),
          ),
          Expanded(
            child: Text(
              valueText,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ZcType.mono(
                context,
                size: 12.5,
                color: valueColor ?? c.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 凭证条(finality rail:pending → soft → proven → finalized)
class FinalityRail extends StatelessWidget {
  const FinalityRail({
    super.key,
    this.states = const <String>['pending', 'soft', 'proven', 'finalized'],
    this.current = 2,
    this.badIndex,
    this.caption,
    this.captionAction,
    this.onAction,
  });

  final List<String> states;
  final int current; // 当前停留节点(之前的为 done)

  /// 卡住/未达标的节点(红色,如 fail-closed 提现预览的 proven)
  final int? badIndex;
  final Widget? caption;
  final String? captionAction;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    final List<Widget> items = <Widget>[];
    for (int i = 0; i < states.length; i++) {
      final bool done = i < current;
      final bool cur = i == current;
      final bool bad = badIndex != null && i == badIndex;
      final Color sq = bad
          ? c.bad
          : done
          ? c.felt
          : cur
          ? c.amb
          : c.cd;
      final Color bd = bad
          ? c.bad
          : done
          ? c.felt
          : cur
          ? c.amb
          : c.rl2;
      final Color lb = bad
          ? c.bad
          : done
          ? c.felt
          : cur
          ? c.amb
          : c.ink3;
      items.add(
        SizedBox(
          width: 52,
          child: Column(
            children: <Widget>[
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: sq,
                  border: Border.all(color: bd, width: 1.5),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                states[i].toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: ZcType.mono(
                  context,
                  size: 8.5,
                  weight: cur ? FontWeight.w600 : FontWeight.w400,
                  ls: 0.4,
                  color: lb,
                ),
              ),
            ],
          ),
        ),
      );
      if (i < states.length - 1) {
        items.add(
          Expanded(
            child: Container(
              height: 1.5,
              margin: const EdgeInsets.only(top: 4, left: 2, right: 2),
              color: i < current ? c.felt : c.rl2,
            ),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(children: items),
        if (caption != null)
          Container(
            margin: const EdgeInsets.only(top: 9),
            child: Row(
              children: <Widget>[
                Expanded(child: caption!),
                if (captionAction != null)
                  ZcButton(
                    captionAction!,
                    variant: 's',
                    small: true,
                    expanded: false,
                    onTap: onAction,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// 提示条(bn):real / ok / bad / info / amb
class NoticeBanner extends StatelessWidget {
  const NoticeBanner(
    this.title,
    this.text, {
    super.key,
    this.tone = 'real',
    this.icon = 'i-warn',
  });

  final String title;
  final String text;
  final String tone;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    Color accent = c.ink3;
    Color bg = c.cd;
    Color bd = c.rl;
    Color tc = c.ink;
    if (tone == 'real') {
      accent = c.real;
      bg = c.realW;
      bd = c.realRl;
      tc = c.real;
    }
    if (tone == 'ok') {
      accent = c.felt;
      bg = c.feltW;
      bd = c.feltRl;
      tc = c.felt;
    }
    if (tone == 'bad') {
      accent = c.bad;
      bg = c.badW;
      bd = c.badRl;
      tc = c.bad;
    }
    if (tone == 'info') {
      accent = c.play;
      bg = c.playW;
      bd = c.playRl;
      tc = c.play;
    }
    if (tone == 'amb') {
      accent = c.amb;
      bg = c.ambW;
      bd = c.ambRl;
      tc = c.amb;
    }
    // 非均匀色 Border 不能配 borderRadius(Border.paint 会抛断言):
    // 用均匀 Border.all 画边框,左侧 3dp 强调条用独立色条实现(clipBehavior 裁圆角)。
    // Row 的 stretch 需要有界交叉轴,故包一层 IntrinsicHeight(滚动容器内高度无界)。
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: bd),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(width: 3, color: accent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(9, 10, 12, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ZcIcons.icon(icon, size: 18, color: accent),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            style: ZcType.ui(
                              context,
                              size: 12,
                              weight: FontWeight.w600,
                              color: tc,
                            ),
                          ),
                          Text(
                            text,
                            style: ZcType.ui(
                              context,
                              size: 11.5,
                              color: c.ink2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 快捷动作条(acts):4 格方条
class ActionGrid extends StatelessWidget {
  const ActionGrid(this.actions, {super.key});
  final List<QuickAction> actions;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: c.rl2),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
        color: c.rl,
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: <Widget>[
          for (int i = 0; i < actions.length; i++) ...<Widget>[
            if (i > 0) Container(width: 1, height: 56, color: c.rl),
            Expanded(child: _cell(context, actions[i])),
          ],
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, QuickAction a) {
    final ZcPalette c = ZcScope.of(context);
    Color fg = c.ink2;
    if (a.tone == 'real') fg = c.real;
    if (a.tone == 'play') fg = c.play;
    return Material(
      color: c.cd,
      child: InkWell(
        onTap: a.onTap,
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ZcIcons.icon(a.icon, size: 17, color: fg),
              const SizedBox(height: 4),
              Text(
                a.label,
                style: ZcType.mono(context, size: 10, ls: 0.5, color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickAction {
  const QuickAction(this.label, this.icon, this.onTap, {this.tone});
  final String label;
  final String icon;
  final VoidCallback? onTap;
  final String? tone;
}

/// 链切换器(csw):三条账簿屏之间的分段导航
class ChainSwitcher extends StatelessWidget {
  const ChainSwitcher(this.items, {super.key});
  final List<ChainSwitchItem> items;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: c.ink,
        border: Border.all(color: c.ink),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: <Widget>[
          for (int i = 0; i < items.length; i++) ...<Widget>[
            if (i > 0) Container(width: 1, height: 34, color: c.ink),
            Expanded(child: _cell(context, items[i])),
          ],
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, ChainSwitchItem it) {
    final ZcPalette c = ZcScope.of(context);
    final bool on = it.on;
    return Material(
      color: on ? c.ink : c.cd,
      child: InkWell(
        onTap: it.onTap,
        child: Container(
          height: 34,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                it.label,
                style: ZcType.mono(
                  context,
                  size: 11,
                  ls: 0.55,
                  weight: on ? FontWeight.w600 : FontWeight.w400,
                  color: on ? c.onInk : c.ink2,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '${it.count}',
                style: ZcType.mono(
                  context,
                  size: 9,
                  color: on ? c.onInk.withValues(alpha: .7) : c.ink3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChainSwitchItem {
  const ChainSwitchItem(this.label, this.count, {this.on = false, this.onTap});
  final String label;
  final int count;
  final bool on;
  final VoidCallback? onTap;
}

/// 账簿封面块(tot):纸纹底 + 大额等宽数字
class TotalCard extends StatelessWidget {
  const TotalCard({
    super.key,
    required this.label,
    required this.amount,
    this.eq = false,
    this.unit,
    this.trailing,
    this.subChips = const <Widget>[],
    this.subTexts = const <String>[],
    this.amountColor,
    this.small = false,
  });

  final String label;
  final String amount;
  final bool eq;
  final String? unit;
  final Widget? trailing;
  final List<Widget> subChips;
  final List<String> subTexts;
  final Color? amountColor;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.cd,
        border: Border.all(color: c.rl2),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(painter: RuledPaperPainter(c.rulePaper)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(label, style: ZcType.section(context, color: c.ink3)),
                  const Spacer(),
                  ?trailing,
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    if (eq) ...<Widget>[
                      Text(
                        '≈',
                        style: ZcType.mono(context, size: 19, color: c.ink3),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      amount,
                      style: ZcType.mono(
                        context,
                        size: small ? 22 : 31,
                        weight: FontWeight.w600,
                        ls: small ? -0.3 : -0.6,
                        color: amountColor,
                      ),
                    ),
                    if (unit != null) ...<Widget>[
                      const SizedBox(width: 5),
                      Text(
                        unit!,
                        style: ZcType.mono(
                          context,
                          size: 12,
                          ls: 0.72,
                          color: c.ink3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (subChips.isNotEmpty || subTexts.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 9),
                  child: Row(
                    children: <Widget>[
                      ...subChips,
                      ...subTexts.map(
                        (String s) => Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            s,
                            style: ZcType.ui(
                              context,
                              size: 10.5,
                              color: c.ink2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 双列对比(split)
class SplitColumns extends StatelessWidget {
  const SplitColumns({super.key, required this.left, required this.right});
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: c.rl,
        border: Border.all(color: c.rl2),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: c.cd,
              padding: const EdgeInsets.all(13),
              child: left,
            ),
          ),
          Container(width: 1, color: c.rl),
          Expanded(
            child: Container(
              color: c.cd,
              padding: const EdgeInsets.all(13),
              child: right,
            ),
          ),
        ],
      ),
    );
  }
}

/// 裸输入框(iw + input:无标签,常用于封面页口令输入)
class ZcInput extends StatelessWidget {
  const ZcInput({
    super.key,
    this.hint,
    this.obscure = false,
    this.suffix,
    this.controller,
  });

  final String? hint;
  final bool obscure;
  final Widget? suffix;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: ZcType.ui(context, size: 13, color: c.ink),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: c.cd,
        hintText: hint,
        hintStyle: ZcType.ui(context, size: 13, color: c.ink3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ZcPalette.rS),
          borderSide: BorderSide(color: c.rl2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ZcPalette.rS),
          borderSide: BorderSide(color: c.ink),
        ),
        suffixIcon: suffix,
      ),
    );
  }
}

/// 表单字段(fld + fl)
class ZcField extends StatelessWidget {
  const ZcField({
    super.key,
    required this.label,
    this.hint,
    this.aux,
    this.onAux,
    this.obscure = false,
    this.trailing,
    this.controller,
    this.suffix,
    this.enabled = true,
  });

  final String label;
  final String? hint;
  final String? aux;
  final VoidCallback? onAux;
  final bool obscure;
  final Widget? trailing;
  final TextEditingController? controller;
  final Widget? suffix;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                label.toUpperCase(),
                style: ZcType.mono(context, size: 11, ls: 0.55, color: c.ink2),
              ),
              const Spacer(),
              if (aux != null)
                InkWell(
                  onTap: onAux,
                  child: Text(
                    aux!,
                    style: ZcType.mono(
                      context,
                      size: 10.5,
                      color: c.felt,
                    ).copyWith(decoration: TextDecoration.underline),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: obscure,
            enabled: enabled,
            style: ZcType.ui(context, size: 13, color: c.ink),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: c.cd,
              hintText: hint,
              hintStyle: ZcType.ui(context, size: 13, color: c.ink3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 13,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ZcPalette.rS),
                borderSide: BorderSide(color: c.rl2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ZcPalette.rS),
                borderSide: BorderSide(color: c.ink),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ZcPalette.rS),
                borderSide: BorderSide(color: c.rl2),
              ),
              suffixIcon: suffix,
            ),
          ),
        ],
      ),
    );
  }
}

/// 表单项之间的下拉/选择行(selrow)
class SelectRow extends StatelessWidget {
  const SelectRow(this.text, {super.key, this.onTap, this.icon = 'i-chev-d'});
  final String text;
  final VoidCallback? onTap;
  final String icon;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Material(
      color: c.cd,
      borderRadius: BorderRadius.circular(ZcPalette.rS),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            border: Border.all(color: c.rl2),
            borderRadius: BorderRadius.circular(ZcPalette.rS),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ZcType.ui(context, size: 13, color: c.ink),
                ),
              ),
              ZcIcons.icon(icon, size: 16, color: c.ink3),
            ],
          ),
        ),
      ),
    );
  }
}

/// 菜单行(mi)
class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.danger = false,
    this.trailing,
    this.tone,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool danger;
  final Widget? trailing;
  final String? tone; // 覆盖图标色:amb / bad / felt / play / real

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    Color ic = c.ink2;
    Color bg = c.cd2;
    Color bd = c.rl2;
    if (danger) {
      ic = c.bad;
      bg = c.badW;
      bd = c.badRl;
    }
    if (tone == 'amb') {
      ic = c.amb;
      bg = c.ambW;
      bd = c.ambRl;
    }
    if (tone == 'felt') {
      ic = c.felt;
      bg = c.feltW;
      bd = c.feltRl;
    }
    if (tone == 'play') {
      ic = c.play;
      bg = c.playW;
      bd = c.playRl;
    }
    if (tone == 'real') {
      ic = c.real;
      bg = c.realW;
      bd = c.realRl;
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.rl)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: bg,
                border: Border.all(color: bd),
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.center,
              child: ZcIcons.icon(icon, size: 14, color: ic),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ZcType.ui(
                      context,
                      size: 12.5,
                      weight: FontWeight.w600,
                      color: danger ? c.bad : c.ink,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ZcType.mono(context, size: 10.5, color: c.ink3),
                  ),
                ],
              ),
            ),
            trailing ?? ZcIcons.icon('i-chev-r', size: 14, color: c.ink3),
          ],
        ),
      ),
    );
  }
}

/// 开关(sw2)
class ZcSwitch extends StatelessWidget {
  const ZcSwitch({super.key, required this.on, this.onTap});
  final bool on;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 20,
        decoration: BoxDecoration(
          color: on ? c.feltW : c.pg2,
          border: Border.all(color: on ? c.felt : c.rl2),
          borderRadius: BorderRadius.circular(2),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(2),
        child: Align(
          alignment: on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(width: 14, height: 14, color: on ? c.felt : c.ink3),
        ),
      ),
    );
  }
}

/// 勾选框(chk + cb)
class ZcCheckbox extends StatelessWidget {
  const ZcCheckbox({
    super.key,
    required this.text,
    required this.on,
    this.onTap,
  });

  final String text;
  final bool on;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 17,
            height: 17,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: on ? c.ink : c.cd,
              border: Border.all(color: on ? c.ink : c.ink3, width: 1.5),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.center,
            child: on
                ? ZcIcons.icon('i-check', size: 11, color: c.onInk)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: ZcType.ui(context, size: 11.5, color: c.ink2),
            ),
          ),
        ],
      ),
    );
  }
}

/// 印章(seal)
class Seal extends StatelessWidget {
  const Seal(this.text, {super.key, this.tone = 'ok'});
  final String text;
  final String tone; // ok / real / bad

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    Color fg = c.felt;
    if (tone == 'real') fg = c.real;
    if (tone == 'bad') fg = c.bad;
    return Transform.rotate(
      angle: -4 * 3.14159265 / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: fg, width: 1.5),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          text.toUpperCase(),
          style: ZcType.mono(
            context,
            size: 9,
            ls: 1.17,
            weight: FontWeight.w600,
            color: fg,
          ),
        ),
      ),
    );
  }
}

/// 步骤行(stp)
class StepRow extends StatelessWidget {
  const StepRow({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    this.state = 'done', // done / run / todo
  });

  final String index;
  final String title;
  final String subtitle;
  final String state;

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
      decoration: BoxDecoration(
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
            child: Text(
              index,
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

/// 进度条(meter)
class ZcMeter extends StatelessWidget {
  const ZcMeter(this.ratio, {super.key, this.warn = false});
  final double ratio;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: c.pg2,
        border: Border.all(color: c.rl),
        borderRadius: BorderRadius.circular(1),
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: ratio.clamp(0.0, 1.0),
        child: Container(color: warn ? c.amb : c.felt),
      ),
    );
  }
}

/// 空状态(empty)
class ZcEmpty extends StatelessWidget {
  const ZcEmpty(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
      decoration: BoxDecoration(
        color: c.cd,
        border: Border.all(color: c.rl2),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: ZcType.ui(context, size: 11.5, color: c.ink3),
      ),
    );
  }
}

/// 屏幕脚注(foot)
class ZcFoot extends StatelessWidget {
  const ZcFoot(this.lines, {super.key});
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        children: <Widget>[
          for (final String l in lines)
            Text(
              l,
              textAlign: TextAlign.center,
              style: ZcType.mono(context, size: 9.5, ls: 0.57, color: c.ink3),
            ),
        ],
      ),
    );
  }
}

/// 轻提示(等价 .tst:ink 底、等宽、felt 对勾)
class ZcToast extends StatelessWidget {
  const ZcToast(this.msg, {super.key});
  final String msg;

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: c.ink,
          borderRadius: BorderRadius.circular(ZcPalette.rS),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ZcIcons.icon('i-check', size: 13, color: c.felt),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                msg,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ZcType.mono(context, size: 11.5, color: c.onInk),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

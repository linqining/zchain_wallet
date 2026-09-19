# ZChain Wallet · Flutter 屏幕实现规范（给屏幕实现者）

目标：按 Pixso 设计文件（B「账簿 Ledger」纸白体系）实现 19 屏 Flutter 原生应用。
本文件是屏幕实现者的唯一约定来源；先通读，再写代码。

## 项目布局

- `lib/design/tokens.dart` — `ZcPalette`（纸白 `ZcColors.paper` / 夜场 `ZcColors.night`）、`ZcType` 字体助手
- `lib/design/scope.dart` — `ZcScope.of(context)` 取当前 `ZcPalette`；`ZcScope.state(context)` 取 AppState（toast）；`ZcNav.go(context,'route')` 压栈导航、`ZcNav.switchTab` Tab 切换、`ZcNav.back`
- `lib/design/icons.dart` — `ZcIcons.icon('i-lock', size: 14, color: c.ink2)`；图标 id 清单见该文件 map（i-lock/i-send/i-out/i-qr/i-shield/i-spade/i-ether/i-layers/i-book/i-home/i-shield/i-pen/i-check/i-warn/i-copy/i-eye/i-gear/i-back/i-chev-d/i-chev-r/i-clock/i-info/i-x/i-refresh/i-key/i-receipt/i-wallet/i-file/i-swap/i-plus/i-trash/i-ext/i-flask/i-search/i-recv/i-ul/i-dl/i-bolt/i-unlock/i-sun）
- `lib/design/widgets.dart` — 全部共享组件（下表）
- `lib/data/demo.dart` — DemoData 共享示例数据（账户名/地址/金额）
- `lib/screens/s<NN>_<slug>.dart` — 每屏一个文件，你只改分配给你的文件
- `lib/app.dart` — 路由表（已配好，勿改）

## 屏幕文件契约

```dart
// 屏幕 NN · 标题(slug)                     ← 文件头用 // 注释（不要 ///，避免 lint）
import 'package:flutter/material.dart';
import '../design/icons.dart';      // 用到才 import
import '../design/scope.dart';      // 用到才 import
import '../design/tokens.dart';     // 用到才 import
import '../design/widgets.dart';
import '../data/demo.dart';         // 用到才 import

class XxxScreen extends StatelessWidget {
  const XxxScreen({super.key});
  static WidgetBuilder get builder => (_) => const XxxScreen();

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    return ZcScreen(
      header: ...,          // DashHeaderBlock(DashHeader(...)) 或 SubHeader(...) 或 null
      body: ZcBody(children: <Widget>[ ... ]),   // 可滚动主体
      tabs: 'home',         // 底部 Tab：'home'|'zc-dash'|'proofs'；引导页/子页给 null（省略参数）
      footer: ...,          // 可选：固定在 Tab 上方的内容（如 cover 页脚）
    );
  }
}
```

导航路由 id：welcome / success / import / lock / home / zc-dash / evm-dash / stk-dash /
zc-send / zc-withdraw / zc-confirm / zc-sessions / zc-portal / zc-receipts /
evm-send / evm-history / evm-manage / proofs / settings。
轻提示：`ZcScope.state(context).showToast('示意:xxx')`。

## 共享组件（widgets.dart，全部对齐设计稿 base.css）

- `ZcScreen(header:, body:, tabs:, footer:, bottomOverlays:)` — 屏幕骨架
- `ZcBody(children:, pad:)` — 可滚动主体（内边距 14/16/18）
- `Gap(h:12)` — 卡片间距
- `DashHeaderBlock(header: DashHeader(...))` — 票据抬头+齿孔线
- `DashHeader(kind:, net:, title:, subtitle:, actions:, topActions:)` — kind=左上角小字
  （如 'Ledger · Zchain'）；actions=头像行右侧方按钮（30×30 ib）；topActions 默认含主题切换太阳钮
- `SubHeader(title:, trailing:)` — 子页栏（方形返回+居中标题+齿孔线），返回已接好
- `LedgerCard(child:, header:, moreLabel:, onMore:, tight:, padding:)` — 纸卡 cd；header=卡头
  小写转大写的等宽节标题；moreLabel+onMore=右上角 felt 色"查看全部 >"
- `SectionTitle(text, danger:)` — 节标题 sec-t（上 16 下 8，右侧细线）
- `ZcChip(text, tone: 'felt'|'play'|'real'|'bad'|'amb'|null, xs:, solid:, icon:)` — 方形标签
- `NetPill(text)` — 网络胶囊；`Avatar(letter, size:, real:)` — 方形头像
- `ZcButton(label, variant: 'p'|'s'|'g'|'d', small:, icon:, expanded:, onTap:)` — 按钮
- `SquareIconButton(icon:, onTap:, bare:, color:, tooltip:)` — 方形/裸图标钮
- `TokenTile(letter | .icon(icon), tone:)` — 26×26 资产瓦片
- `AssetRow(name:, chip:, chipTone:, sub:, tile:, tileIcon:, tileTone:, amount:, amountTone:, rightSub:, onTap:, dim:)` — 资产行
- `TxRow(icon:, tone: 'ok'|'warn'|'bad'|'blue'|'plain', name:, sub:, amount:, amountTone: 'pos'|'neg', status:, statusTone:)` — 交易行
- `LedgerRow(keyText, valueText, valueColor:, dim:)` — 账簿行(lr)
- `FinalityRail(states:, current:, caption:(Widget?), captionAction:, onAction:)` — 凭证条
- `NoticeBanner(title, text, tone: 'real'|'ok'|'bad'|'info'|'amb', icon:)` — 提示条 bn
- `ActionGrid(List<QuickAction>)`；`QuickAction(label, icon, onTap, tone:)` — 4 格动作条 acts
- `ChainSwitcher(List<ChainSwitchItem>)`；`ChainSwitchItem(label, count, on:, onTap:)` — 链切换器
- `TotalCard(label:, amount:, eq:, unit:, trailing:, subChips:, subTexts:, amountColor:, small:)` — 大额纸纹卡
- `SplitColumns(left:, right:)` — 双列对比 split
- `ZcField(label:, hint:, obscure:, aux:, onAux:, controller:, suffix:)` / `ZcInput(hint:, obscure:, suffix:)` — 表单
- `SelectRow(text, onTap:, icon:)`；`MenuRow(icon:, title:, subtitle:, onTap:, danger:, tone:, trailing:)`
- `ZcSwitch(on:, onTap:)`；`ZcCheckbox(text, on:, onTap:)`；`Seal(text, tone:)`；`StepRow(index:, title:, subtitle:, state: 'done'|'run'|'todo')`
- `ZcMeter(ratio, warn:)`；`ZcEmpty(text)`；`ZcFoot(List<String>)`；`ZcToast(msg)`（一般不用直接用）
- `RuledPaperPainter(color)` — 账格纸纹；`Perforation(opacity:)` — 齿孔虚线

## 字体/文案规则（品牌硬规则）

- 金额、地址、哈希、计数、英文标签：一律等宽（`ZcType.mono`；组件内已处理，自绘文本要自己用 mono）
- 节标题/卡头/徽章文字大写 + 宽字距（组件已处理；自绘时用 `ZcType.section(null, color: c.ink3)`）
- 正文 `ZcType.ui(context, size:, weight:, color:)`，基准 13
- REAL 相关金额/提示用金墨 `c.real`；PLAY 用 `c.play`；危险 `c.bad`；锁定/注意 `c.amb`
- 不使用发光、描边字、阴影浮夸；卡片细线 1px、圆角 3（大卡 6）

## 布局节奏

- body 内卡片间距：`Gap()`(12)；大额卡后 14（`Gap(h:14)` 或跟随设计截图）
- 资产行/交易行内边距 9/0；菜单行 10/0；账簿行 7/0
- 表单字段间距 13（ZcField 已内置）；按钮高 42（sm 32）

## 参考材料（实现每屏前必看）

1. `.dev/shots/<slug>.png` — 设计稿逐屏截图（**视觉权威**）
2. `.dev/inventory/<slug>.txt` — 该屏全部文字（按 DOM 序，非视觉序）
3. `E:\projects\zchain\design\pixso\pixso-b-ledger.screens\<旧slug>.html` — v1 语义 HTML
   （结构与 class 体系同源，v2 改名/增删内容以截图+文本清单为准）
4. `.dev/dtc_screens/<slug>.html` — Pixso design_to_code 生成的绝对定位代码（查精确
   数值/颜色用，勿照抄结构）

## 完成标准（对每屏）

- 与设计截图对照：结构、顺序、文字、徽章颜色、金额、行布局一致
- `flutter analyze` 不新增任何 error/warning（允许 info 提示他屏占位的未用导入——忽略）
- 命令（在 E:\projects\zchain_wallet 下）：
  `export PATH="/e/tools/flutter/bin:$PATH" FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn PUB_HOSTED_URL=https://pub.flutter-io.cn && flutter analyze`
- 只写你分配到的 `lib/screens/s*.dart` 文件；不改 design/、app.dart、其他屏
- 不要跑 `dart format`、`flutter test`、`flutter build`（由集成者统一做）

范例参考：`lib/screens/s06_zc_dash.dart`（账簿屏）与 `lib/screens/s05_home.dart`（总账屏）。

# ZChain Wallet · 账簿 Ledger（Flutter 原生）

三链自托管钱包（ZChain 隐私层 / EVM 多链 / Starknet）的 Flutter 原生应用，Android 优先。
自绘渲染，**非 WebView 套壳**。

设计源：Pixso 设计文件「设计文件」
（`https://pixso.cn/app/design/wrfLcH3XiFpZsxMwj0DPkw?page-id=0:1&item-id=4:2`，
B「账簿 Ledger」纸白体系 v2 · 19 屏）。全部屏幕、组件、token 经 Pixso MCP
（`design_to_code` / `get_screenshot` / `get_node_dsl`）从该文件提取对齐。

## 运行

```bash
flutter pub get          # 国内镜像:PUB_HOSTED_URL=https://pub.flutter-io.cn
flutter run              # Android 设备/模拟器
flutter build apk        # 构建 APK(applicationId dev.zchain.wallet)
```

工程依赖：`flutter_svg`（设计稿 39 个 stroke 图标内嵌渲染），无其他运行时依赖。

## 结构

```text
lib/
├── main.dart               # 入口(竖屏锁定)
├── app.dart                # MaterialApp + 19 屏路由表(route id = 设计稿 slug)
├── design/
│   ├── tokens.dart         # 双底色 token(纸白 Ledger / 夜场 Felt,与设计稿逐值一致)
│   ├── theme.dart          # ThemeData 构建
│   ├── scope.dart          # ZcScope(取 palette/状态) + ZcNav(导航)
│   ├── icons.dart          # 设计稿图标库(38 个 stroke 符号 + 演示二维码)
│   └── widgets.dart        # 共享组件库(票据抬头/纸卡/方形标签/凭证条/链切换器…)
├── state/app_state.dart    # 底色切换(paper/night) + 全局 toast
├── data/demo.dart          # DevNet 演示数据(与设计稿同源)
└── screens/s01…s19.dart    # 19 屏,一一对应设计稿画板
```

19 屏清单（route id ↔ 设计稿画板）：
welcome / success / import / lock（引导）；home 三链总账；zc-dash / evm-dash /
stk-dash（三条分链账簿）；zc-send / zc-withdraw / zc-confirm / zc-sessions /
zc-portal / zc-receipts（ZChain 域）；evm-send / evm-history / evm-manage（EVM 域）；
proofs 凭证簿（底部 Tab「证明」）；settings 设置 · 能力矩阵。

## 品牌硬规则（实现遵守）

1. 零 webfont：系统栈 + 等宽数字（tabular figures）；金额/地址/哈希一律等宽右对齐
2. 纸白底、细线账格、方形标签与印章；圆角 3/6；无发光字、无描边字
3. REAL 域（金墨）区块必带托管提示；金色不用于非 REAL 强调
4. 双底色一键切换（顶栏太阳钮）：纸白 / 夜场（夜场 token 逐字来自 media-kit v0.1）

## 目录备注

- `design-html/` — 开发过程中的 HTML 交互原型（设计稿的可点击验证版），仅作设计参考，
  不参与应用构建；对应 `.dev/shots/`（设计稿逐屏截图）与 `.dev/inventory/`（逐屏文本清单）
- `.dev/` — 工具脚本与提取材料：Pixso MCP 客户端、design_to_code 逐屏参考、
  实现规范 CONVENTIONS.md、应用逐屏截图 `app_shots/`
- `zchain/` 主仓（`E:\projects\zchain`）中的 `wallet-app`（Tauri）与 `poker-wallet`
  （wallet-core）为本应用后续接入 Rust 内核的来源；当前交付为设计还原 + 交互骨架，
  数据为演示数据

## 质量门

- `flutter analyze` — 0 issues
- `flutter test` — 路由完整性冒烟测试通过
- 视觉走查 — 19/19 屏与应用截图（380×600，与设计稿同尺寸）对照通过；
  对照 `.dev/shots/*.png`（设计稿）↔ `.dev/app_shots/*.png`（应用）

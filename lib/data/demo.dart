/// 共享示例数据(DevNet 演示数据,与 Pixso 设计稿各屏同源)。
library;

class LayerAccount {
  const LayerAccount({
    required this.id,
    required this.name,
    required this.icon,
    required this.state,
    required this.stateTone,
    required this.sub,
    required this.amount,
    required this.addr,
    required this.route,
  });

  final String id;
  final String name;
  final String icon;
  final String state;
  final String stateTone; // felt / amb
  final String sub;
  final String amount;
  final String addr;
  final String route;
}

class DemoData {
  const DemoData._();

  static const String network = 'zchain-devnet-1';
  static const String build = 'Play / DevNet / v1.3';
  static const String extension = 'Extension 0.6.1';
  static const String designVersion = '设计稿 v0.2';

  static const String accountName = '牌手一号';
  static const String accountInitial = 'A';
  static const String accountSub = '三层统一账户 · 已解锁 2 / 3';
  static const String totalAmount = '\$22,288.63';
  static const String totalLabel = '三链总资产';
  static const String totalChipLabel = 'REAL 托管 \$10,120.00';
  static const String totalNote = 'PLAY 为测试筹码,不计价';

  static const List<LayerAccount> layers = [
    LayerAccount(
      id: 'zc',
      name: 'ZChain 隐私层',
      icon: 'i-spade',
      state: '已解锁',
      stateTone: 'felt',
      sub: 'PLAY 12,400.00 · NATIVE 10,000.00',
      amount: '\$10,120.00',
      addr: 'zc1qpoker…f7x2',
      route: 'zc-dash',
    ),
    LayerAccount(
      id: 'evm',
      name: 'EVM 多链',
      icon: 'i-ether',
      state: '已解锁',
      stateTone: 'felt',
      sub: 'ETH 2.4183 · Ethereum',
      amount: '\$8,124.69',
      addr: '0x5919…7527',
      route: 'evm-dash',
    ),
    LayerAccount(
      id: 'stk',
      name: 'Starknet',
      icon: 'i-layers',
      state: '已锁定',
      stateTone: 'amb',
      sub: 'ETH 1.2034 · SN DevNet',
      amount: '\$4,043.42',
      addr: '0x058f…853f',
      route: 'stk-dash',
    ),
  ];
}

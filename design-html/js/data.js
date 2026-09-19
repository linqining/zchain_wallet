/* ============================================================================
   ZChain Wallet —— 共享示例数据(data.js)
   ----------------------------------------------------------------------------
   与 Pixso 设计文件各屏示例数据同源(DevNet 演示数据,非真实资产)。
   屏幕模块只引用这里的事实数据;纯展示文案留在各自屏幕内。
   ============================================================================ */
window.ZC_DATA = {
  network: 'zchain-devnet-1',
  build: 'Play / DevNet / v1.3',
  extension: 'Extension 0.6.1',
  designVersion: '设计稿 v0.2',

  account: {
    name: '牌手一号',
    initial: 'A',
    unlockedLayers: '三层统一账户 · 已解锁 2 / 3',
    layers: [
      {
        id: 'zc', name: 'ZChain 隐私层', icon: 'i-spade', state: '已解锁',
        stateTone: 'felt', sub: 'PLAY 12,400.00 · NATIVE 10,000.00',
        amount: '$10,120.00', addr: 'zc1qpoker…f7x2', route: 'zc-dash',
      },
      {
        id: 'evm', name: 'EVM 多链', icon: 'i-ether', state: '已解锁',
        stateTone: 'felt', sub: 'ETH 2.4183 · Ethereum',
        amount: '$8,124.69', addr: '0x5919…7527', route: 'evm-dash',
      },
      {
        id: 'stk', name: 'Starknet', icon: 'i-layers', state: '已锁定',
        stateTone: 'amb', sub: 'ETH 1.2034 · SN DevNet',
        amount: '$4,043.42', addr: '0x058f…853f', route: 'stk-dash',
      },
    ],
    totals: {
      label: '三链总资产', amount: '$22,288.63',
      chips: ['REAL 托管 $10,120.00', 'PLAY 为测试筹码,不计价'],
    },
  },
};

// 屏幕 16 · 交易记录 · 双边对账(evm-history)
// 设计:Pixso「设计文件」16 —— EVM 层交易列表:「合并 Explorer 数据」开关
// (本地账本 + Etherscan 兼容 txlist 双边对账)、全部/转账/合约 分段筛选、
// TxRow 列表(hash 等宽、金额正负色、状态徽章)与对账原则说明;子页,无底部 Tab。
import 'package:flutter/material.dart';

import '../design/icons.dart';
import '../design/scope.dart';
import '../design/tokens.dart';
import '../design/widgets.dart';

class EvmHistoryScreen extends StatefulWidget {
  const EvmHistoryScreen({super.key});

  static WidgetBuilder get builder =>
      (_) => const EvmHistoryScreen();

  @override
  State<EvmHistoryScreen> createState() => _EvmHistoryScreenState();
}

class _EvmHistoryScreenState extends State<EvmHistoryScreen> {
  /// 分段:0 全部 / 1 转账 / 2 合约
  int _seg = 0;

  /// 双边对账开关:本地账本 + Explorer txlist(默认合并)
  bool _merged = true;

  static const List<_Tx> _txs = <_Tx>[
    _Tx(
      icon: 'i-send',
      tone: 'ok',
      name: '发送 · 0.25 ETH',
      hash: '0x8f3a…c2',
      when: '2 分钟前',
      fee: '\$0.85',
      amount: '-0.2500',
      amountTone: 'neg',
      status: '成功',
      statusTone: 'felt',
    ),
    _Tx(
      icon: 'i-clock',
      tone: 'warn',
      name: '发送 · 0.10 ETH',
      hash: '0x22af…71',
      when: '30 秒前',
      amount: '-0.1000',
      amountTone: 'neg',
      status: 'PENDING',
      statusTone: 'amb',
    ),
    _Tx(
      icon: 'i-recv',
      tone: 'blue',
      name: '接收 · 1.20 ETH',
      hash: '0x51b7…c8',
      when: '昨天',
      amount: '+1.2000',
      amountTone: 'pos',
      status: '成功',
      statusTone: 'felt',
    ),
    _Tx(
      kind: 'c',
      icon: 'i-file',
      tone: 'blue',
      name: 'approve · USDC',
      hash: '0xd901…34',
      when: '3 天前',
      amount: '合约',
      amountTone: 'dim',
      status: '成功',
      statusTone: 'felt',
    ),
    _Tx(
      kind: 'c',
      icon: 'i-file',
      tone: 'bad',
      name: 'swap · 1inch',
      hash: '0x9a02…ef',
      when: '5 天前',
      amount: 'Failed',
      amountTone: 'bad',
      status: '失败',
      statusTone: 'bad',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final ZcPalette c = ZcScope.of(context);
    final List<_Tx> rows = _txs
        .where(
          (_Tx t) =>
              _seg == 0 ||
              (_seg == 1 && t.kind == 'tx') ||
              (_seg == 2 && t.kind == 'c'),
        )
        .toList();
    return ZcScreen(
      header: SubHeader(
        title: '交易记录',
        trailing: const ZcChip('ETHEREUM', xs: true),
      ),
      body: ZcBody(
        children: <Widget>[
          _mergeRow(context, c),
          _segTabs(context, c),
          const SizedBox(height: 13),
          LedgerCard(
            tight: true,
            child: Column(
              children: <Widget>[
                for (int i = 0; i < rows.length; i++)
                  _txRow(
                    context,
                    rows[i],
                    withStatus: _seg != 1,
                    withAmount: _seg != 2,
                    withFee: _seg == 0,
                  ),
              ],
            ),
          ),
          if (_seg == 0)
            Container(
              margin: const EdgeInsets.only(top: 2),
              child: Text(
                '来源用 chip 区分(本地 / explorer);两者冲突时以链上回执为准,并把差异原样列在详情里,不做静默合并。',
                style: ZcType.ui(context, size: 10.5, color: c.ink3),
              ),
            ),
        ],
      ),
    );
  }

  /// 双边对账说明行:合并 Explorer 数据 + 开关
  Widget _mergeRow(BuildContext context, ZcPalette c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '合并 Explorer 数据',
                  style: ZcType.ui(context, size: 12, weight: FontWeight.w600),
                ),
                Text(
                  '本地账本 + Etherscan 兼容 txlist',
                  style: ZcType.mono(context, size: 10.5, color: c.ink3),
                ),
              ],
            ),
          ),
          ZcSwitch(
            on: _merged,
            onTap: () {
              setState(() => _merged = !_merged);
              ZcScope.state(context).showToast('示意:切换数据源');
            },
          ),
        ],
      ),
    );
  }

  /// 分段筛选(等价 .seg):全部 / 转账 / 合约
  Widget _segTabs(BuildContext context, ZcPalette c) {
    return Container(
      decoration: BoxDecoration(
        color: c.rl2,
        border: Border.all(color: c.rl2),
        borderRadius: BorderRadius.circular(ZcPalette.rS),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: <Widget>[
          Expanded(
            child: _segCell(
              context,
              c,
              '全部',
              on: _seg == 0,
              onTap: () => _pick(0),
            ),
          ),
          Container(width: 1, height: 32, color: c.rl2),
          Expanded(
            child: _segCell(
              context,
              c,
              '转账',
              on: _seg == 1,
              onTap: () => _pick(1),
            ),
          ),
          Container(width: 1, height: 32, color: c.rl2),
          Expanded(
            child: _segCell(
              context,
              c,
              '合约',
              on: _seg == 2,
              onTap: () => _pick(2),
            ),
          ),
        ],
      ),
    );
  }

  void _pick(int seg) {
    if (mounted) setState(() => _seg = seg);
  }

  static Widget _segCell(
    BuildContext context,
    ZcPalette c,
    String label, {
    bool on = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: on ? c.ink : c.cd,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 32,
          alignment: Alignment.center,
          child: Text(
            label,
            style: ZcType.mono(
              context,
              size: 11.5,
              ls: 0.34,
              weight: on ? FontWeight.w600 : FontWeight.w400,
              color: on ? c.onInk : c.ink2,
            ),
          ),
        ),
      ),
    );
  }

  /// 交易行分派:金额正负行用共享 TxRow;「合约 / Failed」行需自定义
  /// 金额颜色与字号,用下方 _TxRowExt(几何与 TxRow 一致)。
  static Widget _txRow(
    BuildContext context,
    _Tx t, {
    required bool withStatus,
    required bool withAmount,
    required bool withFee,
  }) {
    final String sub = withFee && t.fee != null
        ? '${t.hash} · ${t.when} · fee ${t.fee}'
        : '${t.hash} · ${t.when}';
    final String? status = withStatus ? t.status : null;
    if (t.amountTone == 'pos' || t.amountTone == 'neg') {
      return TxRow(
        icon: t.icon,
        tone: t.tone,
        name: t.name,
        sub: sub,
        amount: withAmount ? (t.amount ?? '') : '',
        amountTone: t.amountTone,
        status: status,
        statusTone: t.statusTone,
      );
    }
    return _TxRowExt(
      icon: t.icon,
      tone: t.tone,
      name: t.name,
      sub: sub,
      amount: withAmount ? t.amount : null,
      amountTone: t.amountTone,
      status: status,
      statusTone: t.statusTone,
    );
  }
}

/// 交易数据(DemoNet 演示,与设计稿同源)
class _Tx {
  const _Tx({
    this.kind = 'tx',
    required this.icon,
    required this.tone,
    required this.name,
    required this.hash,
    required this.when,
    this.fee,
    this.amount,
    this.amountTone = 'neg',
    this.status,
    this.statusTone,
  });

  final String kind; // tx 转账 / c 合约
  final String icon;
  final String tone; // ok / warn / bad / blue / plain
  final String name;
  final String hash;
  final String when;
  final String? fee;
  final String? amount;
  final String amountTone; // pos / neg / dim / bad
  final String? status;
  final String? statusTone;
}

/// 交易行(TxRow 扩展):金额颜色 / 字号可覆盖(「合约」弱化、「Failed」红),
/// 金额可整体省略(合约分段);行布局与共享 TxRow 一致。
class _TxRowExt extends StatelessWidget {
  const _TxRowExt({
    required this.icon,
    required this.tone,
    required this.name,
    required this.sub,
    this.amount,
    this.amountTone = 'neg',
    this.status,
    this.statusTone,
  });

  final String icon;
  final String tone; // ok / warn / bad / blue / plain
  final String name;
  final String sub;
  final String? amount;
  final String amountTone; // dim / bad
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
    final bool dim = amountTone == 'dim';
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
              if (amount != null)
                Text(
                  amount!,
                  style: ZcType.mono(
                    context,
                    size: dim ? 11 : 13,
                    weight: dim ? FontWeight.w400 : FontWeight.w600,
                    color: amountTone == 'bad' ? c.bad : c.ink3,
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

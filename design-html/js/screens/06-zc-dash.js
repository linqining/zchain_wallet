/* ============================================================================
   屏幕 06 · 账簿 · ZChain 层(zc-dash)
   设计:Pixso「设计文件」06-zc-dash —— ZChain 层账簿;链切换器在三条账簿屏
   之间导航(v2 把 v1 的单屏三面板拆为三屏);底部 Tab「账簿」。
   ============================================================================ */
(function () {
  'use strict';
  var ZC = window.ZC, D = window.ZC_DATA;

  ZC.screen({
    id: '06-zc-dash',
    route: 'zc-dash',
    title: '账簿 · ZChain 层',
    category: '账簿',

    render: function () {
      var a = D.account;
      var csw = [
        { route: 'zc-dash', label: 'ZChain', cnt: 2, on: true },
        { route: 'evm-dash', label: 'EVM', cnt: 1, on: false },
        { route: 'stk-dash', label: 'Starknet', cnt: 1, on: false },
      ].map(function (c) {
        return '<button class="' + (c.on ? 'on' : '') + '" data-nav="' + c.route + '">' +
          c.label + '<span class="cnt">' + c.cnt + '</span></button>';
      }).join('');

      return '' +
        '<header class="dh">' +
          '<div class="dh-top"><span class="dh-kind">Ledger · Zchain</span>' +
            '<span class="net"><span class="dot"></span>' + D.network + '</span>' +
            '<span class="dh-r"><button class="ib bare" data-ground-toggle title="切换纸白 / 夜场">' + ZC.icon('i-sun', 'ic ic-s ic-sun') + '</button></span>' +
          '</div>' +
          '<div class="dh-main"><span class="av">' + a.initial + '</span>' +
            '<div class="grow" style="min-width:0">' +
              '<div class="acct-n">' + a.name + ZC.icon('i-chev-d', 'ic ic-s') + '</div>' +
              '<div class="acct-a">' + a.layers[0].addr + '</div>' +
            '</div>' +
            '<span class="dh-r">' +
              '<button class="ib" data-open="ovl-zc-recv" title="收款">' + ZC.icon('i-qr', 'ic ic-s') + '</button>' +
              '<button class="ib" data-nav="lock" title="锁定">' + ZC.icon('i-lock', 'ic ic-s') + '</button>' +
            '</span>' +
          '</div>' +
        '</header>' +

        '<div class="body">' +
          '<div class="csw">' + csw + '</div>' +

          '<div class="split">' +
            '<div class="col"><div class="tot-l"><span class="ch ch-play ch-xs">GAME</span>可用筹码</div>' +
              '<div class="tot-a">12,400.00<span class="u">PLAY</span></div></div>' +
            '<div class="col"><div class="tot-l"><span class="ch ch-real ch-xs">REAL</span>托管映射</div>' +
              '<div class="tot-a" style="color:var(--real)">10,000.00<span class="u">NATIVE</span></div></div>' +
          '</div>' +

          '<div class="bn bn-real" style="padding:9px 11px">' + ZC.icon('i-warn') +
            '<div><b>托管映射资产</b><p>REAL 域提现通道未开放;GAME 域筹码不上主网。</p></div></div>' +

          '<div class="acts">' +
            '<button class="play" data-open="ovl-zc-recv">' + ZC.icon('i-qr') + '收款</button>' +
            '<button data-nav="zc-send">' + ZC.icon('i-send') + '转账</button>' +
            '<button class="real" data-nav="zc-withdraw">' + ZC.icon('i-out') + '提现</button>' +
            '<button data-nav="zc-portal">' + ZC.icon('i-shield') + 'Portal</button>' +
          '</div>' +

          '<div class="cd">' +
            '<div class="cd-h">资产 <span class="more" data-nav="zc-receipts">回执' + ZC.icon('i-chev-r', 'ic ic-xs') + '</span></div>' +
            '<div class="ar"><span class="tk tk-play">P</span><div class="ar-m">' +
              '<div class="ar-n">PLAY <span class="ch ch-play ch-xs">GAME</span></div>' +
              '<div class="ar-s">可用 12,400.00 · 桌上锁定 0.00</div></div>' +
              '<div class="ar-r"><div class="ar-amt">12,400.00</div></div></div>' +
            '<div class="ar"><span class="tk tk-real">N</span><div class="ar-m">' +
              '<div class="ar-n">NATIVE <span class="ch ch-real ch-xs">REAL</span></div>' +
              '<div class="ar-s">托管映射 · 提现未开放</div></div>' +
              '<div class="ar-r"><div class="ar-amt">10,000.00</div></div></div>' +
            '<div class="ar" style="opacity:.5"><span class="tk">U</span><div class="ar-m">' +
              '<div class="ar-n">USDT / USDC</div><div class="ar-s">未接入</div></div>' +
              '<div class="ar-r"><div class="ar-amt dim">—</div></div></div>' +
          '</div>' +

          '<div class="cd">' +
            '<div class="cd-h">最新动态 <span class="more" data-nav="zc-receipts">查看全部' + ZC.icon('i-chev-r', 'ic ic-xs') + '</span></div>' +
            '<div class="tx"><span class="tic ok">' + ZC.icon('i-check', 'ic ic-s') + '</span>' +
              '<div class="ar-m"><div class="ar-n">买入 · 8♠ 桌</div><div class="ar-s">0xc41d…9b · 2 分钟前</div></div>' +
              '<div class="ar-r"><div class="ar-amt neg">-500.00</div>' +
              '<div class="ar-st"><span class="ch ch-felt ch-xs">included</span></div></div></div>' +
            '<div class="tx"><span class="tic blue">' + ZC.icon('i-receipt', 'ic ic-s') + '</span>' +
              '<div class="ar-m"><div class="ar-n">结算 · 8♠ 桌 #128</div><div class="ar-s">0x3f9e…aa · 刚刚</div></div>' +
              '<div class="ar-r"><div class="ar-amt pos">+620.50</div>' +
              '<div class="ar-st"><span class="ch ch-xs">seen</span></div></div></div>' +
          '</div>' +

          '<div class="cd">' +
            '<div class="cd-h">会话密钥 · SNIP-12 <span class="more" data-nav="zc-sessions">管理' + ZC.icon('i-chev-r', 'ic ic-xs') + '</span></div>' +
            '<div class="lr"><span class="lr-k">poker.zchain.devnet</span>' +
              '<span class="lr-v" style="color:var(--felt)">活跃</span></div>' +
            '<div class="lr"><span class="lr-k">单笔 / 日累计</span>' +
              '<span class="lr-v">≤1,000 · 2,150/5,000</span></div>' +
            '<div class="meter" style="margin-top:8px"><i style="width:43%"></i></div>' +
          '</div>' +
        '</div>' +

        /* 收款 sheet(演示地址 + 装饰 QR) */
        '<div class="ovl" id="ovl-zc-recv">' +
          '<div class="ovl-bg" data-close></div>' +
          '<div class="sheet"><div class="grab"></div>' +
            '<div class="row"><div style="font-weight:600;font-size:13px;flex:1">收款 · ZChain 层</div>' +
              '<button class="ib bare" data-close>' + ZC.icon('i-x', 'ic ic-s') + '</button></div>' +
            '<div class="mono c" style="font-size:9.5px;color:var(--ink-3);margin:6px 0 0;word-break:break-all">zc1qpoker9xf7x2wwn2h3a5v8…</div>' +
            '<div class="c" style="font-size:10px;color:var(--ink-3);margin-bottom:12px">完整地址 · 点按下方按钮复制</div>' +
            '<div class="qr"><svg viewBox="0 0 29 29"><use href="#qr-art"/></svg></div>' +
            '<button class="btn btn-s btn-sm" style="margin-top:14px;width:100%" data-close data-toast="地址已复制">' +
              ZC.icon('i-copy', 'ic ic-s') + '复制地址</button>' +
          '</div>' +
        '</div>' +

        ZC.tabs('zc-dash');
    },
  });
})();

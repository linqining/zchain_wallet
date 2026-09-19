/* ============================================================================
   屏幕 05 · 三链总账(General Ledger)
   设计:Pixso「设计文件」05-home —— 账户首页;底部 Tab「总账」。
   ============================================================================ */
(function () {
  'use strict';
  var ZC = window.ZC, D = window.ZC_DATA;

  ZC.screen({
    id: '05-home',
    route: 'home',
    title: '三链总账',
    category: '账户',

    render: function () {
      var a = D.account;

      var layers = a.layers.map(function (l) {
        return '<button class="ar" data-nav="' + l.route + '">' +
          '<span class="tk">' + ZC.icon(l.icon, 'ic ic-s') + '</span>' +
          '<div class="ar-m"><div class="ar-n">' + l.name +
          ' <span class="ch ch-' + l.stateTone + ' ch-xs">' + l.state + '</span></div>' +
          '<div class="ar-s">' + l.sub + '</div></div>' +
          '<div class="ar-r"><div class="ar-amt">' + l.amount + '</div>' +
          '<div class="ar-s mono" style="text-align:right">' + l.addr + '</div></div>' +
          '</button>';
      }).join('');

      return '' +
        '<header class="dh">' +
          '<div class="dh-top"><span class="dh-kind">General Ledger</span>' +
            '<span class="net"><span class="dot"></span>' + D.network + '</span>' +
            '<span class="dh-r"><button class="ib bare" data-ground-toggle title="切换纸白 / 夜场">' + ZC.icon('i-sun', 'ic ic-s ic-sun') + '</button></span>' +
          '</div>' +
          '<div class="dh-main"><span class="av">' + a.initial + '</span>' +
            '<div class="grow" style="min-width:0">' +
              '<div class="acct-n">' + a.name + ZC.icon('i-chev-d', 'ic ic-s') + '</div>' +
              '<div class="acct-a">' + a.unlockedLayers + '</div>' +
            '</div>' +
            '<span class="dh-r"><button class="ib" data-nav="lock" title="锁定">' + ZC.icon('i-lock', 'ic ic-s') + '</button></span>' +
          '</div>' +
        '</header>' +

        '<div class="body">' +
          '<div class="tot">' +
            '<div class="tot-l">' + a.totals.label +
              ' <button class="ib bare" data-toast="示意:隐藏金额">' + ZC.icon('i-eye', 'ic ic-xs') + '</button>' +
            '</div>' +
            '<div class="tot-a"><span class="eq">≈</span>' + a.totals.amount + '</div>' +
            '<div class="tot-s"><span class="ch ch-real">' + a.totals.chips[0] + '</span>' +
              '<span>' + a.totals.chips[1] + '</span></div>' +
          '</div>' +

          '<div class="sec-t">账户层</div>' +
          '<div class="cd tight" style="padding:2px 14px">' + layers + '</div>' +

          '<div class="cd">' +
            '<div class="cd-h">最弱凭证</div>' +
            '<div class="rail">' +
              '<div class="rn done"><i></i><span>pending</span></div><div class="rline done"></div>' +
              '<div class="rn done"><i></i><span>soft</span></div><div class="rline done"></div>' +
              '<div class="rn cur"><i></i><span>proven</span></div><div class="rline"></div>' +
              '<div class="rn"><i></i><span>finalized</span></div>' +
            '</div>' +
            '<div class="rail-cap"><span>1 张 REAL note 停在 <b style="color:var(--amb)">soft</b></span>' +
              '<button class="btn btn-s btn-sm" data-nav="zc-withdraw">查看</button></div>' +
          '</div>' +

          '<div class="cd">' +
            '<div class="cd-h">待办 <span class="more" data-nav="zc-confirm">1 项</span></div>' +
            '<button class="mi" data-nav="zc-confirm">' +
              '<span class="mi-ic" style="color:var(--amb);border-color:var(--amb-rl);background:var(--amb-w)">' + ZC.icon('i-pen', 'ic ic-s') + '</span>' +
              '<span class="grow"><b>开桌签名请求 · 8♠ 桌</b><span>poker.zchain.devnet · 92s 后过期</span></span>' +
              ZC.icon('i-chev-r', 'ic ic-s') +
            '</button>' +
          '</div>' +

          '<button class="btn btn-s btn-sm" style="width:100%;height:38px" data-nav="lock">' +
            ZC.icon('i-lock', 'ic ic-s') + '全部锁定</button>' +
          '<div class="foot">ZChain Wallet · ' + D.designVersion + ' / ' + D.extension + ' · DevNet<br>' +
            D.build + '</div>' +
        '</div>' +

        ZC.tabs('home');
    },
  });
})();

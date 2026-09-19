/* ============================================================================
   屏幕 04 · 锁定 · 统一解锁(lock)
   设计:Pixso「设计文件」04-lock —— 封面页,引导流;无底部 Tab。
   ============================================================================ */
(function () {
  'use strict';
  var ZC = window.ZC, D = window.ZC_DATA;

  ZC.screen({
    id: '04-lock',
    route: 'lock',
    title: '锁定 · 统一解锁',
    category: '引导',

    render: function () {
      var a = D.account;
      return '' +
        '<div class="cover" style="justify-content:center;align-items:center;text-align:center">' +
          '<span class="av" style="width:52px;height:52px;font-size:19px">' + a.initial + '</span>' +
          '<div style="font-size:16px;font-weight:700;margin-top:12px">' + a.name + '</div>' +
          '<div class="mono" style="font-size:11px;color:var(--ink-3);margin-top:2px">' + a.layers[0].addr + '</div>' +
          '<div class="row" style="gap:6px;margin-top:12px;justify-content:center">' +
            '<span class="ch ch-amb">' + ZC.icon('i-lock', 'ic ic-xs') + '已锁定</span>' +
            '<span class="ch">15 分钟无操作 / 后台被回收</span>' +
          '</div>' +
          '<div style="width:100%;max-width:282px;margin-top:22px">' +
            '<div class="iw"><input type="password" placeholder="解锁口令">' +
              '<span class="in-ic"><button class="ib bare" data-toast="示意:明文切换">' + ZC.icon('i-eye', 'ic ic-xs') + '</button></span></div>' +
            '<button class="btn btn-p" style="margin-top:10px" data-nav="zc-dash">解锁三层</button>' +
            '<button class="btn btn-g" style="margin-top:4px" data-nav="import">忘记口令?使用备份恢复</button>' +
          '</div>' +
        '</div>' +
        '<div class="cv-foot">统一解锁三层 · ZChain 层 Argon2id + ChaCha20-Poly1305,EVM / Starknet 层 PBKDF2-SHA256(600k)+ AES-256-GCM</div>';
    },
  });
})();

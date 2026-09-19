/* ============================================================================
   ZChain Wallet —— 应用外壳(app.js)
   ----------------------------------------------------------------------------
   职责:
     · 屏幕注册表(ZC.screen)+ hash 路由(#/<route>)
     · 全局事件委托:data-nav 跳转 / data-toast 反馈 / data-ground 换底色
     · 公共片段:底部 3 Tab(ZC.tabs)、图标(ZC.icon)、toast
   屏幕模块在 js/screens/*.js,经 SCREEN_FILES 清单按序加载;
   每个模块调用 ZC.screen({...}) 完成注册,app.js 挂载当前路由的屏幕。
   ============================================================================ */
(function () {
  'use strict';

  /* ---- 屏幕文件清单(集成清单:新增屏幕必须登记于此) ---- */
  var SCREEN_FILES = [
    '01-welcome', '02-success', '03-import', '04-lock', '05-home',
    '06-zc-dash', '07-evm-dash', '08-stk-dash', '09-zc-send', '10-zc-withdraw',
    '11-zc-confirm', '12-zc-sessions', '13-zc-portal', '14-zc-receipts',
    '15-evm-send', '16-evm-history', '17-evm-manage', '18-proofs', '19-settings',
  ];

  var ZC = (window.ZC = window.ZC || {});
  var registry = {};   // route -> screen def
  var byId = {};       // file id -> screen def
  var toastTimer = null;
  var currentRoute = null;

  /* ---- 屏幕注册 ----
     def: { id, route, title, category, ground?, render(ctx), mount?(ctx) } */
  ZC.screen = function (def) {
    if (!def || !def.route || typeof def.render !== 'function') {
      throw new Error('ZC.screen: route 与 render 必填');
    }
    def.ground = def.ground || null; // null = 跟随当前主题
    registry[def.route] = def;
    byId[def.id] = def;
  };

  ZC.def = function (route) { return registry[route] || null; };
  ZC.all = function () { return registry; };

  /* ---- 图标 ---- */
  ZC.icon = function (name, cls) {
    return '<svg class="' + (cls || 'ic') + '"><use href="#' + name + '"/></svg>';
  };

  /* ---- 底部 3 Tab(总账 / 账簿 / 证明) ---- */
  ZC.TABS = [
    { route: 'home', label: '总账', icon: 'i-home' },
    { route: 'zc-dash', label: '账簿', icon: 'i-book' },
    { route: 'proofs', label: '证明', icon: 'i-shield' },
  ];
  ZC.tabs = function (activeRoute) {
    return '<nav class="tabs">' + ZC.TABS.map(function (t) {
      return '<button class="tb' + (t.route === activeRoute ? ' on' : '') +
        '" data-nav="' + t.route + '">' + ZC.icon(t.icon) + t.label + '</button>';
    }).join('') + '</nav>';
  };

  /* ---- 主题(纸白 / 夜场) ---- */
  ZC.ground = function (val) {
    if (val) {
      document.documentElement.setAttribute('data-ground', val);
      try { localStorage.setItem('zc-ground', val); } catch (e) { /* 隐私模式忽略 */ }
    }
    return document.documentElement.getAttribute('data-ground') || 'paper';
  };
  ZC.toggleGround = function () {
    ZC.ground(ZC.ground() === 'paper' ? 'night' : 'paper');
  };

  /* ---- toast ---- */
  ZC.toast = function (msg) {
    var host = document.getElementById('phone');
    var el = host.querySelector('.tst');
    if (!el) {
      el = document.createElement('div');
      el.className = 'tst';
      host.appendChild(el);
    }
    el.innerHTML = ZC.icon('i-check') + '<span></span>';
    el.lastChild.textContent = msg;
    el.classList.add('on');
    clearTimeout(toastTimer);
    toastTimer = setTimeout(function () { el.classList.remove('on'); }, 1800);
  };

  /* ---- 导航 ---- */
  ZC.go = function (route) {
    if (!registry[route]) { console.warn('未知路由:', route); return; }
    location.hash = '#/' + route;
  };

  /* ---- 渲染当前路由 ---- */
  function render() {
    var route = (location.hash || '').replace(/^#\//, '') || 'welcome';
    var def = registry[route];
    if (!def) { route = 'welcome'; def = registry[route]; }
    if (!def) return;
    if (def.ground) ZC.ground(def.ground);
    currentRoute = route;

    var ctx = { route: route, def: def, params: {} };
    var host = document.getElementById('phone');
    host.innerHTML = '';
    var scr = document.createElement('div');
    scr.className = 'scr scr-in';
    scr.innerHTML = def.render(ctx);
    host.appendChild(scr);
    var tst = document.createElement('div');
    tst.className = 'tst';
    host.appendChild(tst);

    document.title = def.title + ' · ZChain Wallet';
    if (typeof def.mount === 'function') def.mount(ctx);
  }

  /* ---- 全局事件委托 ---- */
  document.addEventListener('click', function (ev) {
    var t = ev.target.closest ? ev.target.closest('[data-nav],[data-toast],[data-ground-toggle],[data-open],[data-close]') : null;
    if (!t) return;
    if (t.hasAttribute('data-open')) {
      var ovl = document.getElementById(t.getAttribute('data-open'));
      if (ovl) ovl.classList.add('on');
      return;
    }
    if (t.hasAttribute('data-close')) {
      var open = t.closest('.ovl');
      if (open) open.classList.remove('on');
      return;
    }
    if (t.hasAttribute('data-ground-toggle')) { ZC.toggleGround(); return; }
    if (t.hasAttribute('data-toast')) { ZC.toast(t.getAttribute('data-toast')); return; }
    if (t.hasAttribute('data-nav')) {
      var route = t.getAttribute('data-nav');
      var def = registry[route];
      if (def && typeof def.ground === 'string' && def.ground) ZC.ground(def.ground);
      ZC.go(route);
    }
  });

  window.addEventListener('hashchange', render);

  /* ---- 启动:按清单加载屏幕模块后渲染 ---- */
  function boot() {
    ZC.ground((function () {
      try { return localStorage.getItem('zc-ground') || 'paper'; } catch (e) { return 'paper'; }
    })());
    render();
  }

  function loadScreens(i) {
    if (i >= SCREEN_FILES.length) { boot(); return; }
    var s = document.createElement('script');
    s.src = 'js/screens/' + SCREEN_FILES[i] + '.js';
    s.onload = function () { loadScreens(i + 1); };
    s.onerror = function () {
      console.error('屏幕模块加载失败:', SCREEN_FILES[i]);
      loadScreens(i + 1);
    };
    document.body.appendChild(s);
  }

  document.addEventListener('DOMContentLoaded', function () {
    loadScreens(0);
  });
})();

// ==UserScript==
// @name        MUA Web Unicode Converter (userscript)
// @description MUA - Web Unicode Converter userscript (TypeScript rewrite)
// @namespace   https://github.com/AungMyoKyaw/MUA-Web-Unicode-Converter
// @version     0.0.0-dev
// @author      Aung Myo Kyaw
// @license     GPL-3.0
// @match       *://*/*
// @updateURL   https://github.com/AungMyoKyaw/MUA-Web-Unicode-Converter/raw/master/dist/mua.user.js
// @downloadURL https://github.com/AungMyoKyaw/MUA-Web-Unicode-Converter/raw/master/dist/mua.user.js
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_registerMenuCommand
// @grant       GM_addStyle
// ==/UserScript==
const v = `(function(){"use strict";const o=/[\\u1031\\u1036\\u1037\\u103b\\u103c\\u103d\\u103e\\u1060-\\u109F]/;let c=null,s=null;try{const t=require("myanmar-tools");t?.ZawgyiDetector&&(c=new t.ZawgyiDetector),t?.ZawgyiConverter&&(s=new t.ZawgyiConverter)}catch{}function u(t,e=.95){if(c)try{return c.getZawgyiProbability(t)>=e||o.test(t)}catch{return o.test(t)}return o.test(t)}function d(t){const e={"ၪ":" ဉ","ၤ":"င်္","႐":"ရ","ွႇ":"ှှ","ံံ":"ံံ","ေကၤ":"င်္ကေ","ၤေက":"င်္ကေ","့ံ":"ံ့"};if(e[t])return e[t];if(s)try{return s.zawgyiToUnicode(t)}catch{return t}return t}self.addEventListener("message",t=>{const e=t.data;if(!(!e||!e.method)&&e.method==="detectAndConvert"){const r=e.payload.inputs||[],y=!!e.payload.convert,g=r.map(n=>{const i=/[\\u1000-\\u109F]/u.test(n),a=u(n),f=y&&i&&a?d(n):void 0;return{input:n,isMyanmar:i,isZawgyi:a,converted:f}}),l={id:e.id,results:g};self.postMessage(l)}})})();
`,
  y =
    typeof self < 'u' &&
    self.Blob &&
    new Blob(
      ['(self.URL || self.webkitURL).revokeObjectURL(self.location.href);', v],
      { type: 'text/javascript;charset=utf-8' }
    );
function A(t) {
  let o;
  try {
    if (((o = y && (self.URL || self.webkitURL).createObjectURL(y)), !o))
      throw '';
    const e = new Worker(o, { name: t?.name });
    return (
      e.addEventListener('error', () => {
        (self.URL || self.webkitURL).revokeObjectURL(o);
      }),
      e
    );
  } catch {
    return new Worker(
      'data:text/javascript;charset=utf-8,' + encodeURIComponent(v),
      { name: t?.name }
    );
  }
}
const p = new Set(['SCRIPT', 'STYLE', 'CODE', 'PRE', 'NOSCRIPT', 'TEMPLATE']);
function h(t, o, e = document.documentElement) {
  let n;
  const r = new Set(),
    c = () => {
      n === void 0 &&
        (n = setTimeout(() => {
          const a = Array.from(r);
          (r.clear(), (n = void 0), a.length && o(a));
        }, t));
    },
    s = new MutationObserver((a) => {
      for (const i of a)
        if (i.type === 'characterData' && i.target.nodeType === Node.TEXT_NODE)
          w(i.target, r);
        else if (i.type === 'childList')
          for (const m of i.addedNodes)
            (!m.parentElement || !C(m.parentElement, i.addedNodes)) && w(m, r);
      r.size > 0 && c();
    });
  return (
    s.observe(e, { characterData: !0, subtree: !0, childList: !0 }),
    {
      disconnect() {
        s.disconnect();
      }
    }
  );
}
function C(t, o) {
  for (let e = 0; e < o.length; e++) if (o[e].contains(t)) return !0;
  return !1;
}
function w(t, o) {
  if (t.nodeType === Node.TEXT_NODE) {
    const e = t.parentElement;
    if (
      !e ||
      p.has(e.tagName) ||
      e.closest('[contenteditable="true"]') ||
      e.closest('input,textarea')
    )
      return;
    o.add(t);
    return;
  }
  if (t.nodeType === Node.ELEMENT_NODE) {
    const e = t;
    if (
      p.has(e.tagName) ||
      e.closest('[contenteditable="true"]') ||
      e.closest('input,textarea')
    )
      return;
    const n = document.createTreeWalker(e, NodeFilter.SHOW_TEXT);
    let r = n.nextNode();
    for (; r; ) {
      const c = r.parentElement;
      (c &&
        !p.has(c.tagName) &&
        !c.closest('input,textarea') &&
        !c.closest('[contenteditable="true"]') &&
        o.add(r),
        (r = n.nextNode()));
    }
  }
}
const x = new Set(['SCRIPT', 'STYLE', 'CODE', 'PRE', 'NOSCRIPT', 'TEMPLATE']);
function g(t = document) {
  const o =
      /[\u1000-\u109F\uAA60-\uAA7F\u1031\u1036\u1037\u103b\u103c\u103d\u103e]/u,
    e = {
      acceptNode(s) {
        const a = s.parentElement;
        if (
          !a ||
          x.has(a.tagName) ||
          a.closest('input,textarea,[contenteditable="true"]')
        )
          return NodeFilter.FILTER_REJECT;
        const i = s.data;
        return !i || i.trim().length === 0 || !o.test(i)
          ? NodeFilter.FILTER_REJECT
          : NodeFilter.FILTER_ACCEPT;
      }
    },
    n = document.createTreeWalker(t, NodeFilter.SHOW_TEXT, e),
    r = [];
  let c = n.nextNode();
  for (; c; ) (r.push(c), (c = n.nextNode()));
  return r;
}
const T = new WeakMap(),
  L = new Set();
function F(t, o) {
  for (let e = 0; e < t.length; e++) {
    const n = t[e],
      r = o[e];
    typeof r == 'string' &&
      n.data !== r &&
      (T.has(n) || T.set(n, n.data), (n.data = r), L.add(n));
  }
}
const N = typeof GM_getValue == 'function' && typeof GM_setValue == 'function',
  M = 'mua:';
function k(t, o) {
  const e = M + t;
  try {
    if (N) {
      const r = GM_getValue(e, void 0);
      return typeof r == 'string' ? JSON.parse(r) : r === void 0 ? o : r;
    }
    const n = localStorage.getItem(e);
    return n ? JSON.parse(n) : o;
  } catch {
    return o;
  }
}
function _(t, o) {
  const e = M + t,
    n = JSON.stringify(o);
  try {
    if (N) {
      GM_setValue(e, n);
      return;
    }
    localStorage.setItem(e, n);
  } catch {}
}
const b = '1',
  S = 'settings';
function I() {
  return {
    enabled: !0,
    convertToUnicode: !0,
    perSite: {},
    ignoredSelectors: [
      'script,style,code,pre,noscript,template',
      'input,textarea'
    ],
    allowedSelectors: [],
    debounceMs: 150,
    batchSize: 256,
    debug: !1,
    version: b
  };
}
function O() {
  const t = I(),
    o = k(S, {}),
    e = { ...t, ...o };
  return (e.version !== b && ((e.version = b), f(e)), e);
}
function f(t) {
  _(S, t);
}
function U(t, o) {
  return o.perSite[t] ?? 'default';
}
function D(t, o) {
  typeof GM_registerMenuCommand == 'function' &&
    (GM_registerMenuCommand(t.enabled ? 'Disable MUA' : 'Enable MUA', () => {
      const e = { ...t, enabled: !t.enabled };
      (f(e), o(e));
    }),
    GM_registerMenuCommand('Ignore this site', () => {
      const e = location.hostname,
        n = { ...t };
      ((n.perSite[e] = 'block'), f(n), o(n));
    }),
    GM_registerMenuCommand('Allow this site', () => {
      const e = location.hostname,
        n = { ...t };
      ((n.perSite[e] = 'allow'), f(n), o(n));
    }));
}
function G() {
  const t = `
.mua-badge{position:fixed;z-index:2147483647;right:8px;bottom:8px;background:#111;color:#fff;font:12px/1.4 system-ui,sans-serif;padding:6px 8px;border-radius:6px;opacity:.75}
.mua-badge button{all:unset;color:#9cf;cursor:pointer;margin-left:6px}
`;
  if (typeof GM_addStyle == 'function') GM_addStyle(t);
  else {
    const n = document.createElement('style');
    ((n.textContent = t), document.head.appendChild(n));
  }
  const o = document.createElement('div');
  ((o.className = 'mua-badge'),
    o.setAttribute('role', 'status'),
    (o.textContent = 'MUA: active'));
  const e = document.createElement('button');
  return (
    e.setAttribute('aria-label', 'Hide badge'),
    (e.textContent = '✕'),
    e.addEventListener('click', () => o.remove()),
    o.appendChild(e),
    document.body.appendChild(o),
    o
  );
}
let u = null,
  l = O();
D(l, (t) => {
  ((l = t), l.enabled && R());
});
try {
  ((u = new A()),
    (u.onmessage = (t) => {
      console.log('worker', t.data);
    }));
} catch (t) {
  console.warn('Worker unavailable; falling back to inline execution', t);
}
function P() {
  const t = U(location.hostname, l);
  return t === 'allow' ? !0 : t !== 'block';
}
function E(t) {
  const e = window.requestIdleCallback;
  typeof e == 'function' ? e(t) : setTimeout(t, 0);
}
function d(t) {
  if (!t.length) return;
  const o = t.map((e) => e.data);
  if (u) {
    const e = Math.floor(Math.random() * 1e9);
    (u.addEventListener('message', function n(r) {
      const c = r.data;
      if (!c || c.id !== e) return;
      u?.removeEventListener('message', n);
      const s = (c.results || []).map((a) => a.converted);
      F(t, s);
    }),
      u.postMessage({
        id: e,
        method: 'detectAndConvert',
        payload: { inputs: o, convert: !0 }
      }));
  }
}
function W() {
  try {
    if (document.title && u) {
      const e = Math.floor(Math.random() * 1e9),
        n = document.title;
      (u.addEventListener('message', function r(c) {
        const s = c.data;
        if (!s || s.id !== e) return;
        u?.removeEventListener('message', r);
        const a = s.results?.[0];
        a?.isZawgyi &&
          typeof a.converted == 'string' &&
          (document.title = a.converted);
      }),
        u.postMessage({
          id: e,
          method: 'detectAndConvert',
          payload: { inputs: [n], convert: !0 }
        }));
    }
  } catch {}
  const t = g(document);
  if (t.length === 0) return;
  for (let e = 0; e < t.length; e += l.batchSize) {
    const n = t.slice(e, e + l.batchSize);
    E(() => d(n));
  }
  (document.querySelectorAll('*').forEach((e) => {
    const n = e.shadowRoot;
    if (n && n.mode === 'open') {
      const r = g(n);
      r.length && E(() => d(r));
    }
  }),
    document.querySelectorAll('iframe').forEach((e) => {
      try {
        const n = e.contentDocument;
        if (n?.location?.origin === location.origin) {
          const r = g(n);
          r.length && E(() => d(r));
        }
      } catch {}
    }));
}
function J() {
  (h(
    l.debounceMs,
    (t) => {
      const o =
          /[\u1000-\u109F\uAA60-\uAA7F\u1031\u1036\u1037\u103b\u103c\u103d\u103e]/u,
        e = t.filter((n) => o.test(n.data));
      e.length && d(e);
    },
    document.documentElement
  ),
    document.querySelectorAll('*').forEach((t) => {
      const o = t.shadowRoot;
      o &&
        o.mode === 'open' &&
        h(
          l.debounceMs,
          (e) => {
            const n =
                /[\u1000-\u109F\uAA60-\uAA7F\u1031\u1036\u1037\u103b\u103c\u103d\u103e]/u,
              r = e.filter((c) => n.test(c.data));
            r.length && d(r);
          },
          o
        );
    }),
    document.querySelectorAll('iframe').forEach((t) => {
      try {
        const o = t.contentDocument;
        o?.location?.origin === location.origin &&
          h(
            l.debounceMs,
            (e) => {
              const n =
                  /[\u1000-\u109F\uAA60-\uAA7F\u1031\u1036\u1037\u103b\u103c\u103d\u103e]/u,
                r = e.filter((c) => n.test(c.data));
              r.length && d(r);
            },
            o.documentElement
          );
      } catch {}
    }));
}
function R() {
  try {
    if (!l.enabled || !P()) return;
    (G(), W(), J());
  } catch (t) {
    console.error('bootstrap error', t);
  }
}
R();

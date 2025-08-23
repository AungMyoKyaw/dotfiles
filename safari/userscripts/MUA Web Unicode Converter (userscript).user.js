// ==UserScript==
// @name        MUA Web Unicode Converter (userscript)
// @namespace   https://github.com/AungMyoKyaw/MUA-Web-Unicode-Converter
// @version     0.0.0-dev
// @description MUA - Web Unicode Converter userscript (TypeScript rewrite)
// @author      Aung Myo Kyaw
// @license     GPL-3.0
// @grant       GM_getValue
// @grant       GM_setValue
// @grant       GM_registerMenuCommand
// @grant       GM_addStyle
// @match       *://*/*
// ==/UserScript==

'use strict';
(() => {
  var T = new Set(['SCRIPT', 'STYLE', 'CODE', 'PRE', 'NOSCRIPT', 'TEMPLATE']);
  function f(t, o, e = document.documentElement) {
    let n,
      r = new Set(),
      a = () => {
        n === void 0 &&
          (n = setTimeout(() => {
            let s = Array.from(r);
            (r.clear(), (n = void 0), s.length && o(s));
          }, t));
      },
      i = new MutationObserver((s) => {
        for (let u of s) {
          let p = [];
          u.type === 'characterData' &&
            u.target.nodeType === Node.TEXT_NODE &&
            p.push(u.target);
          for (let E of u.addedNodes) p.push(E);
          for (let E of p) L(E, r);
        }
        a();
      });
    return (
      i.observe(e, { characterData: !0, subtree: !0, childList: !0 }),
      {
        disconnect() {
          i.disconnect();
        }
      }
    );
  }
  function L(t, o) {
    if (t.nodeType === Node.TEXT_NODE) {
      let e = t.parentElement;
      if (!e || T.has(e.tagName) || e.closest('input,textarea')) return;
      o.add(t);
      return;
    }
    if (t.nodeType === Node.ELEMENT_NODE) {
      let e = t;
      if (T.has(e.tagName)) return;
      let n = document.createTreeWalker(e, NodeFilter.SHOW_TEXT),
        r = n.nextNode();
      for (; r; ) {
        let a = r.parentElement;
        a &&
          (T.has(a.tagName) ||
            a.closest('input,textarea') ||
            (o.add(r), (r = n.nextNode())));
      }
    }
  }
  var _ = new Set(['SCRIPT', 'STYLE', 'CODE', 'PRE', 'NOSCRIPT', 'TEMPLATE']);
  function m(t = document) {
    let o = /[\u1000-\u109F\uAA60-\uAA7F]/u,
      e = {
        acceptNode(i) {
          let s = i.parentElement;
          if (!s || _.has(s.tagName) || s.closest('input,textarea'))
            return NodeFilter.FILTER_REJECT;
          let u = i.data;
          return !u || u.trim().length === 0 || !o.test(u)
            ? NodeFilter.FILTER_REJECT
            : NodeFilter.FILTER_ACCEPT;
        }
      },
      n = document.createTreeWalker(t, NodeFilter.SHOW_TEXT, e),
      r = [],
      a = n.nextNode();
    for (; a; ) (r.push(a), (a = n.nextNode()));
    return r;
  }
  var S = new WeakMap(),
    I = new Set();
  function M(t, o) {
    for (let e = 0; e < t.length; e++) {
      let n = t[e],
        r = o[e];
      typeof r == 'string' &&
        n.data !== r &&
        (S.has(n) || S.set(n, n.data), (n.data = r), I.add(n));
    }
  }
  var x = typeof GM_getValue == 'function' && typeof GM_setValue == 'function',
    y = 'mua:';
  function N(t, o) {
    let e = y + t;
    try {
      if (x) {
        let r = GM_getValue(e, void 0);
        return typeof r == 'string' ? JSON.parse(r) : r === void 0 ? o : r;
      }
      let n = localStorage.getItem(e);
      return n ? JSON.parse(n) : o;
    } catch {
      return o;
    }
  }
  function v(t, o) {
    let e = y + t,
      n = JSON.stringify(o);
    try {
      if (x) {
        GM_setValue(e, n);
        return;
      }
      localStorage.setItem(e, n);
    } catch {}
  }
  var h = '1',
    w = 'settings';
  function G() {
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
      version: h
    };
  }
  function R() {
    let t = G(),
      o = N(w, {}),
      e = { ...t, ...o };
    return (e.version !== h && ((e.version = h), g(e)), e);
  }
  function g(t) {
    v(w, t);
  }
  function A(t, o) {
    return o.perSite[t] ?? 'default';
  }
  function F(t, o) {
    typeof GM_registerMenuCommand == 'function' &&
      (GM_registerMenuCommand(t.enabled ? 'Disable MUA' : 'Enable MUA', () => {
        let e = { ...t, enabled: !t.enabled };
        (g(e), o(e));
      }),
      GM_registerMenuCommand('Ignore this site', () => {
        let e = location.hostname,
          n = { ...t };
        ((n.perSite[e] = 'block'), g(n), o(n));
      }),
      GM_registerMenuCommand('Allow this site', () => {
        let e = location.hostname,
          n = { ...t };
        ((n.perSite[e] = 'allow'), g(n), o(n));
      }));
  }
  function C() {
    let t = `
.mua-badge{position:fixed;z-index:2147483647;right:8px;bottom:8px;background:#111;color:#fff;font:12px/1.4 system-ui,sans-serif;padding:6px 8px;border-radius:6px;opacity:.75}
.mua-badge button{all:unset;color:#9cf;cursor:pointer;margin-left:6px}
`;
    if (typeof GM_addStyle == 'function') GM_addStyle(t);
    else {
      let n = document.createElement('style');
      ((n.textContent = t), document.head.appendChild(n));
    }
    let o = document.createElement('div');
    ((o.className = 'mua-badge'),
      o.setAttribute('role', 'status'),
      (o.textContent = 'MUA: active'));
    let e = document.createElement('button');
    return (
      e.setAttribute('aria-label', 'Hide badge'),
      (e.textContent = '\u2715'),
      e.addEventListener('click', () => o.remove()),
      o.appendChild(e),
      document.body.appendChild(o),
      o
    );
  }
  function O(t) {
    let o = new Blob([t], { type: 'application/javascript' }),
      e = URL.createObjectURL(o);
    return new Worker(e);
  }
  var c = null,
    l = R();
  F(l, (t) => {
    ((l = t), l.enabled && k());
  });
  try {
    ((c =
      O(`"use strict";(()=>{function $(a){let u=a,s="\\u102B",i="\\u102D",c="\\u102F",g="\\u1030",r="\\u1036",l="\\u1037",n="\\u103A",o="\\u103B",E="\\u103C",d="\\u103D",p="\\u103E",f="\\u1040";return u=u.replace(/\\u106A/g," \\u1009"),u=u.replace(/\\u1025(?=[\\u1039\\u102C])/g,"\\u1009"),u=u.replace(/\\u1025\\u102E/g,"\\u1026"),u=u.replace(/\\u106B/g,"\\u100A"),u=u.replace(/\\u1090/g,"\\u101B"),u=u.replace(/\\u1040/g,f),u=u.replace(/\\u108F/g,"\\u1014"),u=u.replace(/\\u1012/g,"\\u1012"),u=u.replace(/\\u1013/g,"\\u1013"),u=u.replace(/[\\u103D\\u1087]/g,p),u=u.replace(/\\u103C/g,d),u=u.replace(/[\\u103B\\u107E\\u107F\\u1080\\u1081\\u1082\\u1083\\u1084]/g,E),u=u.replace(/[\\u103A\\u107D]/g,o),u=u.replace(/\\u103E\\u103B/g,o+p),u=u.replace(/\\u108A/g,d+p),u=u.replace(/\\u103E\\u103D/g,d+p),u=u.replace(/\\u102d\\u103e/g,"\\u103E\\u102D"),u=u.replace(/(\\u1031)?(\\u103C)?([\\u1000-\\u1021])\\u1064/g,"\\u1064$1$2$3"),u=u.replace(/(\\u1031)?(\\u103C)?([\\u1000-\\u1021])\\u108B/g,"\\u1064$1$2$3\\u102D"),u=u.replace(/(\\u1031)?(\\u103C)?([\\u1000-\\u1021])\\u108C/g,"\\u1064$1$2$3\\u102E"),u=u.replace(/(\\u1031)?(\\u103C)?([\\u1000-\\u1021])\\u108D/g,"\\u1064$1$2$3\\u1036"),u=u.replace(/\\u105A/g,s+n),u=u.replace(/\\u108E/g,i+r),u=u.replace(/\\u1033/g,c),u=u.replace(/\\u1034/g,g),u=u.replace(/\\u1088/g,p+c),u=u.replace(/\\u1089/g,p+g),u=u.replace(/\\u1039/g,"\\u103A"),u=u.replace(/[\\u1094\\u1095]/g,l),u=u.replace(/([\\u1000-\\u1021])([\\u102C\\u102D\\u102E\\u1032\\u1036]){1,2}([\\u1060\\u1061\\u1062\\u1063\\u1065\\u1066\\u1067\\u1068\\u1069\\u1070\\u1071\\u1072\\u1073\\u1074\\u1075\\u1076\\u1077\\u1078\\u1079\\u107A\\u107B\\u107C\\u1085])/g,"$1$3$2"),u=u.replace(/\\u1064/g,"\\u1004\\u103A\\u1039"),u=u.replace(/\\u104E/g,"\\u104E\\u1004\\u103A\\u1038"),u=u.replace(/\\u1086/g,"\\u103F"),u=u.replace(/\\u1060/g,"\\u1039\\u1000"),u=u.replace(/\\u1061/g,"\\u1039\\u1001"),u=u.replace(/\\u1062/g,"\\u1039\\u1002"),u=u.replace(/\\u1063/g,"\\u1039\\u1003"),u=u.replace(/\\u1065/g,"\\u1039\\u1005"),u=u.replace(/[\\u1066\\u1067]/g,"\\u1039\\u1006"),u=u.replace(/\\u1068/g,"\\u1039\\u1007"),u=u.replace(/\\u1069/g,"\\u1039\\u1008"),u=u.replace(/\\u106C/g,"\\u1039\\u100B"),u=u.replace(/\\u1070/g,"\\u1039\\u100F"),u=u.replace(/[\\u1071\\u1072]/g,"\\u1039\\u1010"),u=u.replace(/[\\u1073\\u1074]/g,"\\u1039\\u1011"),u=u.replace(/\\u1075/g,"\\u1039\\u1012"),u=u.replace(/\\u1076/g,"\\u1039\\u1013"),u=u.replace(/\\u1077/g,"\\u1039\\u1014"),u=u.replace(/\\u1078/g,"\\u1039\\u1015"),u=u.replace(/\\u1079/g,"\\u1039\\u1016"),u=u.replace(/\\u107A/g,"\\u1039\\u1017"),u=u.replace(/\\u107B/g,"\\u1039\\u1018"),u=u.replace(/\\u107C/g,"\\u1039\\u1019"),u=u.replace(/\\u1085/g,"\\u1039\\u101C"),u=u.replace(/\\u106D/g,"\\u1039\\u100C"),u=u.replace(/\\u1091/g,"\\u100F\\u1039\\u100D"),u=u.replace(/\\u1092/g,"\\u100B\\u1039\\u100C"),u=u.replace(/\\u1097/g,"\\u100B\\u1039\\u100B"),u=u.replace(/\\u106F/g,"\\u100E\\u1039\\u100D"),u=u.replace(/\\u106E/g,"\\u100D\\u1039\\u100D"),u=u.replace(/(\\u103C)([\\u1000-\\u1021])(\\u1039[\\u1000-\\u1021])?/g,"$2$3$1"),u=u.replace(/(\\u103E)(\\u103D)([\\u103B\\u103C])/g,"$3$2$1"),u=u.replace(/(\\u103E)([\\u103B\\u103C])/g,"$2$1"),u=u.replace(/(\\u103D)([\\u103B\\u103C])/g,"$2$1"),u=u.replace(/(([\\u1000-\\u101C\\u101E-\\u102A\\u102C-\\u102E-\\u103F\\u104C-\\u109F]))(\\u1040)(?=\\u0020)?/g,(t,e)=>e?e+"\\u101D":t+e),u=u.replace(/((\\u101D))(\\u1040)(?=\\u0020)?/g,(t,e)=>e?e+"\\u101D":t+e),u=u.replace(/([^\\u1040-\\u1049\\u1031])\\u1040([\\u102b-\\u1030\\u1036\\u1037\\u1038\\u103a]|[\\u1000-\\u1021]\\u103a)/g,"$1\\u101D$2"),u=u.replace(/(([\\u1000-\\u101C\\u101E-\\u102A\\u102C-\\u102E-\\u103F\\u104C-\\u109F]))(\\u1047)/g,(t,e)=>e?e+"\\u101B":t+e),u=u.replace(/(\\u1031)?([\\u1000-\\u1021])(\\u1039[\\u1000-\\u1021])?([\\u102D\\u102E\\u1032])?([\\u1036\\u1037\\u1038]{0,2})([\\u103B-\\u103E]{0,3})([\\u102F\\u1030])?([\\u1036\\u1037\\u1038]{0,2})([\\u102D\\u102E\\u1032])?/g,"$2$3$6$1$4$9$7$5$8"),u=u.replace(r+c,c+r),u=u.replace(/\\u1038\\u103a/g,"\\u103A\\u1038"),u=u.replace(/\\u102d\\u103a|\\u103a\\u102d/g,"\\u102D"),u=u.replace(/\\u002e\\u002e\\u002e\\u103a/g,"\\u103A"),u=u.replace(/\\u102d\\u102f\\u103a/g,"\\u102D\\u102F"),u=u.replace(/\\u0020\\u1037/g,"\\u1037"),u=u.replace(/\\u1037\\u1036/g,"\\u1036\\u1037"),u=u.replace(/\\u102d\\u102d/g,"\\u102D"),u=u.replace(/\\u102e\\u102e/g,"\\u102E"),u=u.replace(/\\u102d\\u102e|\\u102e\\u102d/g,"\\u102E"),u=u.replace(/\\u102f\\u102f/g,"\\u102F"),u=u.replace(/\\u102f\\u102d/g,"\\u102D\\u102F"),u=u.replace(/\\u1037\\u1037/g,"\\u1037"),u=u.replace(/\\u1032\\u1032/g,"\\u1032"),u=u.replace(/\\u1044\\u1004\\u103A\\u1038/g,"\\u104E\\u1004\\u103A\\u1038"),u=u.replace(/\\u1014\\u102F\\u103A\\u1015\\u103A/g,"\\u1014\\u103A\\u102F\\u1015\\u103A"),u=u.replace(/\\u102F\\u1036\\u102F/g,"\\u102F\\u1036"),u=u.replace(/\\u103A\\u103A/g,"\\u103A"),u=u.replace(/(\\u103A)(\\u1037)/g,"$2$1"),u}var D=/[\\u1031\\u103b\\u103c\\u103d\\u103e\\u1060-\\u109F]/;function A(a){return D.test(a)}function C(a){return $(a)}self.addEventListener("message",a=>{let u=a.data;if(!(!u||!u.method)&&u.method==="detectAndConvert"){let s=u.payload.inputs||[],i=!!u.payload.convert,c=s.map(r=>{let l=/[\\u1000-\\u109F]/u.test(r),n=A(r),o=i&&l&&n?C(r):void 0;return{input:r,isMyanmar:l,isZawgyi:n,converted:o}}),g={id:u.id,results:c};self.postMessage(g)}});})();
`)),
      (c.onmessage = (t) => {
        console.log('worker', t.data);
      }));
  } catch (t) {
    console.warn('Worker unavailable; falling back to inline execution', t);
  }
  function P() {
    let t = A(location.hostname, l);
    return t === 'allow' ? !0 : t !== 'block';
  }
  function b(t) {
    let e = window.requestIdleCallback;
    typeof e == 'function' ? e(t) : setTimeout(t, 0);
  }
  function d(t) {
    if (!t.length) return;
    let o = t.map((e) => e.data);
    if (c) {
      let e = Math.floor(Math.random() * 1e9);
      (c.addEventListener('message', function n(r) {
        let a = r.data;
        if (!a || a.id !== e) return;
        c?.removeEventListener('message', n);
        let i = (a.results || []).map((s) => s.converted);
        M(t, i);
      }),
        c.postMessage({
          id: e,
          method: 'detectAndConvert',
          payload: { inputs: o, convert: !0 }
        }));
    }
  }
  function W() {
    try {
      if (document.title && c) {
        let e = Math.floor(Math.random() * 1e9),
          n = document.title;
        (c.addEventListener('message', function r(a) {
          let i = a.data;
          if (!i || i.id !== e) return;
          c?.removeEventListener('message', r);
          let s = i.results?.[0];
          s?.isZawgyi &&
            typeof s.converted == 'string' &&
            (document.title = s.converted);
        }),
          c.postMessage({
            id: e,
            method: 'detectAndConvert',
            payload: { inputs: [n], convert: !0 }
          }));
      }
    } catch {}
    let t = m(document);
    if (t.length === 0) return;
    for (let e = 0; e < t.length; e += l.batchSize) {
      let n = t.slice(e, e + l.batchSize);
      b(() => d(n));
    }
    (document.querySelectorAll('*').forEach((e) => {
      let n = e.shadowRoot;
      if (n && n.mode === 'open') {
        let r = m(n);
        r.length && b(() => d(r));
      }
    }),
      document.querySelectorAll('iframe').forEach((e) => {
        try {
          let n = e.contentDocument;
          if (n?.location?.origin === location.origin) {
            let r = m(n);
            r.length && b(() => d(r));
          }
        } catch {}
      }));
  }
  function V() {
    (f(
      l.debounceMs,
      (t) => {
        let o = /[\u1000-\u109F\uAA60-\uAA7F]/u,
          e = t.filter((n) => o.test(n.data));
        e.length && d(e);
      },
      document.documentElement
    ),
      document.querySelectorAll('*').forEach((t) => {
        let o = t.shadowRoot;
        o &&
          o.mode === 'open' &&
          f(
            l.debounceMs,
            (e) => {
              let n = /[\u1000-\u109F\uAA60-\uAA7F]/u,
                r = e.filter((a) => n.test(a.data));
              r.length && d(r);
            },
            o
          );
      }),
      document.querySelectorAll('iframe').forEach((t) => {
        try {
          let o = t.contentDocument;
          o?.location?.origin === location.origin &&
            f(
              l.debounceMs,
              (e) => {
                let n = /[\u1000-\u109F\uAA60-\uAA7F]/u,
                  r = e.filter((a) => n.test(a.data));
                r.length && d(r);
              },
              o.documentElement
            );
        } catch {}
      }));
  }
  function k() {
    try {
      if (!l.enabled || !P()) return;
      (C(), W(), V());
    } catch (t) {
      console.error('bootstrap error', t);
    }
  }
  k();
})();

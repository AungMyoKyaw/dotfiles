// ==UserScript==
// @name         SF Pro Font Everywhere (Fixed & Optimized)
// @namespace    http://github.com/aungmyokyaw
// @version      2.0
// @description  Change font family for Latin characters to 'SF Pro' using an efficient CSS method.
// @author       Aung Myo Kyaw (Fixed by Gemini)
// @match        *://*/*
// @grant        GM_addStyle
// ==/UserScript==

(function () {
  'use strict';

  // CSS to apply SF Pro font only to specific character sets.
  // This avoids breaking icon fonts and other languages.
  const css = `
        @font-face {
            font-family: 'SF Pro Override';
            src: local('SF Pro Display'), local('SF Pro Text'), local('-apple-system'), local('BlinkMacSystemFont');
            /* Apply to Basic Latin, Latin-1 Supplement, and common punctuation/symbols */
            unicode-range: U+0020-007F, U+00A0-00FF, U+2000-206F, U+20A0-20CF, U+2190-21FF;
        }

        /* Apply the override font to everything EXCEPT for specific elements */
        body, body * {
            /* Exclude icon fonts, code blocks, and other special elements */
            &:not(pre):not(code):not(kbd):not(samp):not(var):not(textarea):not([class*="fa-"]):not([class*="icon"]):not(.material-icons) {
                font-family: 'SF Pro Override', var(--font-family, sans-serif) !important;
            }
        }
    `;

  // Inject the CSS into the page.
  // GM_addStyle is the standard and safest way to do this in userscripts.
  if (typeof GM_addStyle !== 'undefined') {
    GM_addStyle(css);
  } else {
    // Fallback for script managers that don't support GM_addStyle
    const styleNode = document.createElement('style');
    styleNode.type = 'text/css';
    styleNode.appendChild(document.createTextNode(css));
    (document.head || document.documentElement).appendChild(styleNode);
  }
})();

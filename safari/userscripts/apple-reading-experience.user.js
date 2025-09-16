// ==UserScript==
// @name         Apple Reading Experience
// @namespace    https://github.com/AungMyoKyaw
// @version      1.0
// @description  Enhance reading experience on all websites with Apple's UI/UX guidelines
// @author       Aung Myo Kyaw
// @exclude        *://*/*
// @grant        GM_addStyle
// @run-at       document-start
// ==/UserScript==

(function () {
  'use strict';

  // CSS to apply Apple-inspired reading enhancements
  const css = `
    /* Apple SF Pro font with fallbacks */
    @font-face {
      font-family: 'SF Pro Override';
      src: local('SF Pro Display'), local('SF Pro Text'), local('-apple-system'), local('BlinkMacSystemFont');
      /* Apply to Basic Latin, Latin-1 Supplement, and common punctuation/symbols */
      unicode-range: U+0020-007F, U+00A0-00FF, U+2000-206F, U+20A0-20CF, U+2190-21FF;
    }

    /* Apply enhanced typography to text content */
    body, body * {
      /* Apply SF Pro font with fallbacks, excluding special elements */
      &:not(pre):not(code):not(kbd):not(samp):not(var):not(textarea):not([class*="fa-"]):not([class*="icon"]):not(.material-icons) {
        font-family: 'SF Pro Override', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif !important;
      }

      /* Improve readability with better line height */
      &:is(p, li, dd, dt, figcaption, .content, .text, .post, .article, .entry-content) {
        line-height: 1.6 !important;
      }

      /* Optimize paragraph spacing */
      &:is(p) {
        margin-bottom: 1.5em !important;
      }

      /* Improve heading hierarchy */
      &:is(h1) {
        font-size: 2.2em !important;
        line-height: 1.2 !important;
        margin-top: 0.67em !important;
        margin-bottom: 0.67em !important;
      }

      &:is(h2) {
        font-size: 1.8em !important;
        line-height: 1.3 !important;
        margin-top: 0.83em !important;
        margin-bottom: 0.83em !important;
      }

      &:is(h3) {
        font-size: 1.5em !important;
        line-height: 1.4 !important;
        margin-top: 1em !important;
        margin-bottom: 1em !important;
      }

      &:is(h4) {
        font-size: 1.25em !important;
        line-height: 1.4 !important;
        margin-top: 1.33em !important;
        margin-bottom: 1.33em !important;
      }

      /* Optimize content width for readability (60-70 characters per line) */
      &:is(article, .article, .post, .entry-content, .content, main, .main) {
        max-width: 70ch !important;
        margin-left: auto !important;
        margin-right: auto !important;
      }

      /* Improve list readability */
      &:is(ul, ol) {
        margin-bottom: 1.5em !important;
      }

      &:is(li) {
        margin-bottom: 0.5em !important;
      }
    }

    /* Enhanced focus states for better keyboard navigation */
    a:focus, button:focus, input:focus, textarea:focus, select:focus {
      outline: 2px solid #007AFF !important;
      outline-offset: 2px !important;
    }

    /* Reduced motion support */
    @media (prefers-reduced-motion: reduce) {
      *, *::before, *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        transition-duration: 0.01ms !important;
      }
    }

    /* Improved contrast for better readability */
    body {
      -webkit-font-smoothing: antialiased !important;
      -moz-osx-font-smoothing: grayscale !important;
    }
  `;

  // Inject the CSS into the page
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

// ==UserScript==
// @name         Float MD Download Button
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Floating button to convert page to Markdown and download as .md file
// @author       You
// @match        *://*/*
// @grant        none
// @run-at       document-end
// ==/UserScript==

(() => {
  // --- CONFIG ---
  const TURNDOWN_CDN = 'https://unpkg.com/turndown/dist/turndown.js';
  const BTN_ID = 'float-md-download-btn';

  // --- STYLE ---
  const style = document.createElement('style');
  style.textContent = `
            #${BTN_ID} {
                position: fixed;
                bottom: 3vw;
                right: 3vw;
                z-index: 99999;
                background: #222;
                color: #fff;
                border: none;
                border-radius: 50%;
                width: 4vw;
                height: 4vw;
                min-width: 40px;
                min-height: 40px;
                box-shadow: 0 0.4vw 1.6vw rgba(0,0,0,0.2);
                font-size: 2vw;
                min-font-size: 20px;
                cursor: pointer;
                opacity: 0.85;
                transition: opacity 0.2s, box-shadow 0.2s;
            }
            #${BTN_ID}:hover {
                opacity: 1;
                box-shadow: 0 0.8vw 3.2vw rgba(0,0,0,0.3);
            }
        `;
  document.head.appendChild(style);

  // --- BUTTON ---
  function createButton() {
    if (document.getElementById(BTN_ID)) return;
    const btn = document.createElement('button');
    btn.id = BTN_ID;
    btn.title = 'Download page as Markdown';
    btn.innerHTML = '📝';
    btn.onclick = onClick;
    document.body.appendChild(btn);
  }

  // --- LOAD TURNDOWN ---
  function loadTurndown(callback) {
    if (window.TurndownService) return callback();
    const script = document.createElement('script');
    script.src = TURNDOWN_CDN;
    script.onload = callback;
    document.body.appendChild(script);
  }

  // --- DOWNLOAD ---
  function downloadMarkdown(md, filename) {
    const blob = new Blob([md], { type: 'text/markdown' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    setTimeout(() => {
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    }, 100);
  }

  // --- MAIN ACTION ---
  function onClick() {
    const btn = document.getElementById(BTN_ID);
    btn.style.display = 'none'; // Hide button so it's not included
    loadTurndown(() => {
      // Remove button from DOM for conversion
      btn.remove();

      // --- DOM CLEANUP ---
      const clone = document.body.cloneNode(true);
      // Remove unwanted elements by selector
      const removeSelectors = [
        'nav',
        'aside',
        'footer',
        'script',
        'style',
        'noscript'
      ];
      removeSelectors.forEach((sel) => {
        clone.querySelectorAll(sel).forEach((el) => el.remove());
      });

      // Prefer <main> or <article> if present
      const root =
        clone.querySelector('main') || clone.querySelector('article') || clone;

      // --- TURNDOWN ---
      const turndownService = new window.TurndownService();
      let md = turndownService.turndown(root.innerHTML);

      // --- MARKDOWN POST-PROCESSING ---
      // Remove base64 images
      md = md.replace(/!\[[^\]]*\]\(data:image\/[^)]+\)/g, '');
      // Collapse multiple blank lines
      md = md.replace(/\n{3,}/g, '\n\n');
      // Optionally, remove lines with only SVG or UI artifacts (future)

      const defaultName =
        (document.title || 'page').replace(/[^a-z0-9]+/gi, '-').toLowerCase() +
        '.md';
      const filename =
        prompt('Filename for Markdown download:', defaultName) || defaultName;
      downloadMarkdown(md, filename);
      // Restore button after download
      setTimeout(createButton, 500);
    });
  }

  // --- INIT ---
  createButton();
})();

// ==UserScript==
// @name         Float MD Download Button
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Floating button to convert page to Markdown and download as .md file
// @author       You
// @match        https://www.coursera.org/*
// @match        https://coursera.org/*
// @grant        none
// @run-at       document-end
// ==/UserScript==

(() => {
  // --- CONFIG ---
  const TURNDOWN_CDN = 'https://unpkg.com/turndown/dist/turndown.js';
  const BTN_ID = 'float-md-download-btn';
  const BTN_ICON = '📝';
  const BTN_LABEL = 'Download page as Markdown';
  const SHORTCUT = { ctrl: true, shift: true, key: 'M' };

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
      display: flex;
      align-items: center;
      justify-content: center;
    }
    #${BTN_ID}:hover {
      opacity: 1;
      box-shadow: 0 0.8vw 3.2vw rgba(0,0,0,0.3);
    }
    #${BTN_ID}-spinner {
      border: 2px solid #f3f3f3;
      border-top: 2px solid #555;
      border-radius: 50%;
      width: 22px;
      height: 22px;
      animation: spin-md-btn 0.7s linear infinite;
      margin: 0 auto;
    }
    @keyframes spin-md-btn {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
  `;
  document.head.appendChild(style);

  // --- BUTTON ---
  function createButton() {
    if (document.getElementById(BTN_ID)) return;
    const btn = document.createElement('button');
    btn.id = BTN_ID;
    btn.title = BTN_LABEL;
    btn.setAttribute('aria-label', BTN_LABEL);
    btn.innerHTML = BTN_ICON;
    btn.onclick = onClick;
    btn.tabIndex = 0;
    document.body.appendChild(btn);
  }

  // --- SPINNER ---
  function showSpinner() {
    const btn = document.getElementById(BTN_ID);
    if (!btn) return;
    btn.innerHTML = `<span id="${BTN_ID}-spinner"></span>`;
    btn.disabled = true;
  }
  function hideSpinner() {
    const btn = document.getElementById(BTN_ID);
    if (!btn) return;
    btn.innerHTML = BTN_ICON;
    btn.disabled = false;
  }

  // --- LOAD TURNDOWN ---
  function loadTurndown(callback) {
    if (window.TurndownService) return callback();
    const script = document.createElement('script');
    script.src = TURNDOWN_CDN;
    script.onload = callback;
    script.onerror = () => {
      alert('Failed to load Turndown library. Please check your connection.');
      hideSpinner();
      createButton();
    };
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

  // --- FILENAME SANITIZATION ---
  function sanitizeFilename(name) {
    let fname = name.replace(/[^a-z0-9-]+/gi, '-').replace(/^-+|-+$/g, '');
    if (!fname) fname = 'page';
    if (fname.length > 64) fname = fname.slice(0, 64);
    return fname + '.md';
  }

  // --- MAIN ACTION ---
  function onClick() {
    const btn = document.getElementById(BTN_ID);
    if (!btn) return;
    showSpinner();
    setTimeout(() => {
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
          clone.querySelector('main') ||
          clone.querySelector('article') ||
          clone;

        // --- TURNDOWN ---
        const turndownService = new window.TurndownService();
        let md = turndownService.turndown(root.innerHTML);

        // --- MARKDOWN POST-PROCESSING ---
        // Remove base64 images
        md = md.replace(/!\[[^\]]*\]\(data:image\/[^)]+\)/g, '');
        // Collapse multiple blank lines
        md = md.replace(/\n{3,}/g, '\n\n');

        const defaultName = sanitizeFilename(document.title || 'page');
        const filename =
          prompt('Filename for Markdown download:', defaultName) || defaultName;
        downloadMarkdown(md, sanitizeFilename(filename));
        // Restore button after download
        setTimeout(createButton, 500);
      });
    }, 100);
  }

  // --- KEYBOARD SHORTCUT ---
  function onKeydown(e) {
    if (
      e.ctrlKey === !!SHORTCUT.ctrl &&
      e.shiftKey === !!SHORTCUT.shift &&
      e.altKey === !!SHORTCUT.alt &&
      e.key &&
      e.key.toUpperCase() === SHORTCUT.key.toUpperCase()
    ) {
      e.preventDefault();
      onClick();
    }
  }

  // --- INIT ---
  createButton();
  window.addEventListener('keydown', onKeydown, true);
})();

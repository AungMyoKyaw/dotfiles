// ==UserScript==
// @name         Gemini: New Chat Shortcut
// @match        *://gemini.google.com/*
// @grant        none
// @run-at       document-start
// @include      *://gemini.google.com/*
// ==/UserScript==

// Listen for Ctrl/Cmd + N to go to new chat
(() => {
  console.log('Gemini new chat shortcut script loaded (Cmd/Ctrl+N)');
  window.addEventListener(
    'keydown',
    (e) => {
      // Check if Ctrl (Windows/Linux) or Cmd (macOS) key is pressed and the key is 'n'
      // Avoid interfering with browser's default new tab/window shortcut unless focus is in Gemini
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'n') {
        // Only override if Gemini is focused and not in an input/textarea/contenteditable
        const active = document.activeElement;
        const isEditable =
          active &&
          (active.tagName === 'INPUT' ||
            active.tagName === 'TEXTAREA' ||
            active.isContentEditable);
        if (!isEditable && window.location.hostname === 'gemini.google.com') {
          e.preventDefault();
          e.stopPropagation();
          window.location.href = 'https://gemini.google.com/app';
        }
      }
    },
    { capture: true }
  );
})();

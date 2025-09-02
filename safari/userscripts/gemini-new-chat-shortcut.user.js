// ==UserScript==
// @name         Gemini: New Chat Shortcut
// @match        *://gemini.google.com/*
// @grant        none
// @run-at       document-start
// @include      *://gemini.google.com/*
// ==/UserScript==

// Listen for Ctrl/Cmd + J to go to new chat
(() => {
  console.log('Gemini new chat shortcut script loaded');
  window.addEventListener(
    'keydown',
    (e) => {
      // Check if Ctrl (Windows/Linux) or Cmd (macOS) key is pressed and the key is 'j'
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'j') {
        e.preventDefault();
        e.stopPropagation();
        window.location.href = 'https://gemini.google.com/app';
      }
    },
    { capture: true } // This is the important part!
  );
})();

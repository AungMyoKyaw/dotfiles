// ==UserScript==
// @name         Gemini: New Chat Shortcut
// @match        https://*.gemini.google.com/*
// @grant        none
// @run-at       document-end
// @include      https://gemini.google.com/*
// ==/UserScript==

// Listen for Ctrl/Cmd + J to go to new chat
(() => {
  console.log('Gemini new chat shortcut script loaded');
  window.addEventListener('keydown', (e) => {
    // Check if Ctrl (Windows/Linux) or Cmd (macOS) key is pressed and the key is 'j'
    console.log(
      'Keydown detected:',
      e.key,
      'ctrl:',
      e.ctrlKey,
      'meta:',
      e.metaKey
    );
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'j') {
      e.preventDefault();
      e.stopPropagation();

      // Redirect to the new chat URL
      window.location.href = 'https://gemini.google.com/app';
    }
  });
})();

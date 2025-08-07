// ==UserScript==
// @name         AI Studio: New Chat Shortcut
// @namespace    https://github.com/AungMyoKyaw
// @version      1.0
// @description  Open new chat in AI Studio with Ctrl+J or Cmd+J
// @author       Aung Myo Kyaw
// @match        https://aistudio.google.com/*
// @include      https://aistudio.google.com/*
// @grant        none
// @run-at       document-end
// ==/UserScript==

(() => {
  // Listen for Ctrl/Cmd + J to open new chat in a new tab
  window.addEventListener('keydown', (e) => {
    // Ignore if focus is in an input, textarea, or contenteditable element
    const active = document.activeElement;
    if (
      active &&
      (active.tagName === 'INPUT' ||
        active.tagName === 'TEXTAREA' ||
        active.isContentEditable)
    ) {
      return;
    }
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'j') {
      e.preventDefault();
      e.stopPropagation();
      window.open('https://aistudio.google.com/prompts/new_chat', '_self');
    }
  });
})();

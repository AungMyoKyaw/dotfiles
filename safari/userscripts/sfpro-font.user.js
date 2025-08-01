// ==UserScript==
// @name         SF Pro Font Everywhere
// @namespace    http://github.com/aungmyokyaw
// @version      1.0
// @description  Change font family for all alphanumeric characters to 'SF Pro Text', 'SF Pro Display' on every website
// @author       Aung Myo Kyaw
// @match        *://*/*
// @grant        none
// ==/UserScript==

(() => {
  // Font family string
  const sfFont =
    '"SF Pro Display", "SF Pro Text", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif';

  // Helper: Check if element is excluded (code, pre, input, textarea, icon classes)
  function isExcluded(el) {
    if (!el || !el.classList) return false;
    const iconClasses = [
      'fa',
      'fas',
      'far',
      'fal',
      'fab',
      'material-icons',
      'icon',
      'mdi',
      'glyph',
      'ion',
      'bi',
      'octicon',
      'svg-icon'
    ];
    for (const cls of iconClasses) {
      if (el.classList.contains(cls)) return true;
    }
    const tag = el.tagName?.toLowerCase();
    if (['input', 'textarea', 'code', 'pre', 'svg', 'button'].includes(tag))
      return true;
    return false;
  }

  // Wrap alphanumeric text nodes in a span with SF Pro font
  function wrapAlphaNumeric(node) {
    if (node.nodeType === Node.TEXT_NODE) {
      if (
        /([A-Za-z0-9])/.test(node.nodeValue) &&
        node.parentElement &&
        !isExcluded(node.parentElement)
      ) {
        const frag = document.createDocumentFragment();
        let lastIndex = 0;
        const regex = /([A-Za-z0-9]+)/g;
        let match;
        match = regex.exec(node.nodeValue);
        while (match !== null) {
          // Add text before match
          if (match.index > lastIndex) {
            frag.appendChild(
              document.createTextNode(
                node.nodeValue.slice(lastIndex, match.index)
              )
            );
          }
          // Wrap match
          const span = document.createElement('span');
          span.style.fontFamily = sfFont;
          span.textContent = match[0];
          frag.appendChild(span);
          lastIndex = match.index + match[0].length;
          match = regex.exec(node.nodeValue);
        }
        // Add remaining text
        if (lastIndex < node.nodeValue.length) {
          frag.appendChild(
            document.createTextNode(node.nodeValue.slice(lastIndex))
          );
        }
        node.parentNode.replaceChild(frag, node);
      }
    } else if (node.nodeType === Node.ELEMENT_NODE && !isExcluded(node)) {
      for (const child of Array.from(node.childNodes)) {
        wrapAlphaNumeric(child);
      }
    }
  }

  // Traverse all shadow roots in the document
  function traverseShadowRoots(node, cb) {
    if (!node) return;
    if (node.shadowRoot) {
      cb(node.shadowRoot);
      traverseShadowRoots(node.shadowRoot, cb);
    }
    for (const child of node.children || []) {
      traverseShadowRoots(child, cb);
    }
  }

  // Initial run
  wrapAlphaNumeric(document.body);
  traverseShadowRoots(document.body, (shadowRoot) => {
    wrapAlphaNumeric(shadowRoot);
  });

  // MutationObserver for dynamic content and shadow roots
  const observer = new MutationObserver((mutations) => {
    for (const m of mutations) {
      for (const node of m.addedNodes) {
        if (node.nodeType === Node.ELEMENT_NODE) {
          wrapAlphaNumeric(node);
          traverseShadowRoots(node, (shadowRoot) => {
            wrapAlphaNumeric(shadowRoot);
          });
        } else if (node.nodeType === Node.TEXT_NODE) {
          wrapAlphaNumeric(node);
        }
      }
    }
  });
  observer.observe(document.body, { childList: true, subtree: true });
})();

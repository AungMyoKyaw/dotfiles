// ==UserScript==
// @name         Safari Tab Suspender
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Suspend inactive tabs after 5 minutes to save system resources
// @author       You
// @match        *://*/*
// @grant        none
// ==/UserScript==

(function () {
  'use strict';

  // Configurable inactivity timeout (ms)
  const INACTIVITY_TIMEOUT = 5 * 60 * 1000; // 5 minutes
  let inactivityTimer;
  let suspended = false;
  let originalBody, originalTitle;

  function resetTimer() {
    if (suspended) return;
    clearTimeout(inactivityTimer);
    inactivityTimer = setTimeout(suspendTab, INACTIVITY_TIMEOUT);
  }

  function suspendTab() {
    // Save original content
    originalBody = document.body.innerHTML;
    originalTitle = document.title;
    suspended = true;
    document.body.innerHTML = `<div style='display:flex;flex-direction:column;align-items:center;justify-content:center;height:100vh;background:#222;color:#fff;font-size:2em;'>
            <div>🔋 Tab Suspended to Save Resources</div>
            <button id='restoreTab' style='margin-top:2em;padding:1em 2em;font-size:1em;'>Restore Tab</button>
        </div>`;
    document.title = '[Suspended] ' + originalTitle;
    document.getElementById('restoreTab').onclick = restoreTab;
  }

  function restoreTab() {
    if (!suspended) return;
    document.body.innerHTML = originalBody;
    document.title = originalTitle;
    suspended = false;
    resetTimer();
    // Re-attach listeners if needed
    attachListeners();
  }

  function attachListeners() {
    ['mousemove', 'keydown', 'mousedown', 'touchstart', 'scroll'].forEach(
      (evt) => {
        window.addEventListener(evt, resetTimer, true);
      }
    );
  }

  // Warn if there are unsaved form fields
  window.addEventListener('beforeunload', function (e) {
    if (suspended) return;
    const forms = document.querySelectorAll('form');
    for (let form of forms) {
      if (
        form.querySelector('input,textarea') &&
        form.checkValidity &&
        !form.checkValidity()
      ) {
        e.preventDefault();
        e.returnValue = '';
        return '';
      }
    }
  });

  attachListeners();
  resetTimer();
})();

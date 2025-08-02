// ==UserScript==
// @name         Safari Tab Suspender
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Suspend inactive tabs after 5 minutes to save system resources
// @author       You
// @match        *://*/*
// @grant        none
// ==/UserScript==

(() => {
  'use strict';

  // Configurable inactivity timeout (ms)
  const INACTIVITY_TIMEOUT = 5 * 60 * 1000; // 5 minutes
  let inactivityTimer;
  let suspended = false;
  let originalBody, originalTitle;
  let tabIsActive = document.visibilityState === 'visible';

  function resetTimer() {
    if (suspended) return;
    clearTimeout(inactivityTimer);
    // Only start timer if tab is not active (not visible)
    if (!tabIsActive) {
      inactivityTimer = setTimeout(suspendTab, INACTIVITY_TIMEOUT);
    }
  }

  function suspendTab() {
    // Never suspend if tab is active
    if (tabIsActive) return;
    // Save original content
    originalBody = document.body.innerHTML;
    originalTitle = document.title;
    suspended = true;
    document.body.innerHTML = `
      <style id="tabSuspenderStyles">
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@500;700&display=swap');
        body, #tabSuspenderCard * { font-family: 'Inter', system-ui, sans-serif !important; }
        #tabSuspenderOverlay {
          position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
          background: linear-gradient(135deg, #232526 0%, #414345 100%);
          display: flex; align-items: center; justify-content: center; z-index: 999999;
        }
        #tabSuspenderCard {
          background: rgba(34, 34, 40, 0.7);
          box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
          backdrop-filter: blur(16px) saturate(180%);
          -webkit-backdrop-filter: blur(16px) saturate(180%);
          border-radius: 24px;
          border: 1.5px solid rgba(255,255,255,0.12);
          padding: 3em 2.5em 2.5em 2.5em;
          min-width: 340px; max-width: 90vw;
          display: flex; flex-direction: column; align-items: center;
          animation: fadeInCard 0.7s cubic-bezier(.4,0,.2,1);
        }
        @keyframes fadeInCard {
          from { opacity: 0; transform: translateY(40px) scale(0.98); }
          to { opacity: 1; transform: none; }
        }
        #tabSuspenderIcon {
          font-size: 3.5em; margin-bottom: 0.5em; filter: drop-shadow(0 2px 8px #00e67644);
          animation: pulseIcon 2.5s infinite cubic-bezier(.4,0,.2,1);
        }
        @keyframes pulseIcon {
          0%, 100% { filter: drop-shadow(0 2px 8px #00e67644) brightness(1); }
          50% { filter: drop-shadow(0 4px 16px #00e67699) brightness(1.15); }
        }
        #tabSuspenderTitle {
          font-size: 1.5em; font-weight: 700; color: #fff; margin-bottom: 0.5em; letter-spacing: 0.01em;
          text-shadow: 0 2px 8px #0006;
        }
        #tabSuspenderWebsite {
          font-size: 1.1em; color: #b2dfdb; margin-bottom: 1.5em; text-align: center;
        }
        #tabSuspenderWebsite span {
          color: #fff; font-weight: 500;
        }
        #restoreTab {
          background: linear-gradient(90deg, #00e676 0%, #00bfae 100%);
          color: #222; font-size: 1.1em; font-weight: 700;
          border: none; border-radius: 12px; padding: 0.9em 2.2em;
          box-shadow: 0 2px 12px #00e67633;
          cursor: pointer; transition: background 0.2s, box-shadow 0.2s, transform 0.1s;
          outline: none; margin-top: 0.5em;
        }
        #restoreTab:active {
          transform: scale(0.97);
        }
        #restoreTab:focus {
          box-shadow: 0 0 0 3px #00e67677;
        }
        @media (max-width: 500px) {
          #tabSuspenderCard { padding: 1.5em 0.5em; min-width: 0; }
          #tabSuspenderTitle { font-size: 1.1em; }
        }
      </style>
      <div id="tabSuspenderOverlay" role="dialog" aria-modal="true" tabindex="-1">
        <div id="tabSuspenderCard">
          <div id="tabSuspenderIcon" aria-hidden="true">🔋</div>
          <div id="tabSuspenderTitle">Tab Suspended to Save Resources</div>
          <div id="tabSuspenderWebsite">
            Website: <span>${originalTitle ? originalTitle : '(No Title)'}</span>
          </div>
          <button id="restoreTab" aria-label="Restore Tab" autofocus>Restore Tab</button>
        </div>
      </div>
    `;
    document.title = '[Suspended] ' + originalTitle;
    document.getElementById('restoreTab').onclick = restoreTab;
    // Trap focus for accessibility
    setTimeout(() => {
      const btn = document.getElementById('restoreTab');
      if (btn) btn.focus();
    }, 50);
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
    // Listen for tab visibility changes
    document.addEventListener(
      'visibilitychange',
      handleVisibilityChange,
      false
    );
  }

  function handleVisibilityChange() {
    tabIsActive = document.visibilityState === 'visible';
    if (tabIsActive) {
      // Tab became active, cancel suspension timer
      clearTimeout(inactivityTimer);
      // If suspended, offer restore UI (handled by user)
    } else {
      // Tab became inactive, start timer
      resetTimer();
    }
  }

  // Warn if there are unsaved form fields
  window.addEventListener('beforeunload', (e) => {
    if (suspended) return;
    const forms = document.querySelectorAll('form');
    for (const form of forms) {
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
  // Set initial state
  if (!tabIsActive) {
    resetTimer();
  }
})();

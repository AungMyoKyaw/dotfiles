// ==UserScript==
// @name         Safari Tab Suspender
// @namespace    https://github.com/AungMyoKyaw
// @version      0.1
// @description  Suspend inactive tabs after 5 minutes to save system resources
// @author       You
// @match        *://*/*
// @exclude      *://www.youtube.com/*
// @exclude      *://youtube.com/*
// @exclude      *://*.youtube.com/*
// @exclude      *://gemini.google.com/*
// @exclude      *://aistudio.google.com/*
// @exclude      *://tasks.google.com/*
// @exclude      *://*withgoogle.com/*
// @exclude      *://www.coursera.org/*
// @grant        none
// ==/UserScript==

(() => {
  // Configurable exclusion list (domains to skip suspension)
  const EXCLUDED_DOMAINS = [
    // Add more domains as needed, or use @exclude in the header for static exclusions
    // Exclude both www.coursera.org and all subdomains of coursera.org
    'www.coursera.org',
    'coursera.org',
    // Exclude all withgoogle.com domains
    'withgoogle.com'
  ];
  // Check if current hostname matches any excluded domain (for dynamic/user-configurable exclusions)
  if (
    EXCLUDED_DOMAINS.length &&
    EXCLUDED_DOMAINS.some(
      (domain) =>
        location.hostname === domain || location.hostname.endsWith('.' + domain)
    )
  )
    return;

  // Configurable inactivity timeout (ms)
  const INACTIVITY_TIMEOUT = 5 * 60 * 1000; // 5 minutes
  let inactivityTimer;
  let tabIsActive = document.visibilityState === 'visible';
  let suspended = false;
  // Store original URL in sessionStorage for session restore safety
  const SUSPENDER_KEY = '__tabSuspenderOriginalUrl';
  let originalUrl = location.href;
  // If we are on a suspended overlay after a crash/restart, try to restore originalUrl from sessionStorage
  if (sessionStorage.getItem(SUSPENDER_KEY)) {
    originalUrl = sessionStorage.getItem(SUSPENDER_KEY);
  } else {
    sessionStorage.setItem(SUSPENDER_KEY, originalUrl);
  }
  const originalTitle = document.title;

  function resetTimer() {
    if (suspended) return;
    clearTimeout(inactivityTimer);
    if (!tabIsActive) {
      inactivityTimer = setTimeout(suspendTab, INACTIVITY_TIMEOUT);
    }
  }

  function suspendTab() {
    if (tabIsActive || suspended) return;
    // Warn if there are unsaved form fields
    const forms = document.querySelectorAll('form');
    for (const form of forms) {
      if (form.querySelector('input,textarea')) {
        // User has unsaved/invalid form data, do not suspend
        return;
      }
    }
    suspended = true;
    // Save originalUrl in sessionStorage for session restore
    sessionStorage.setItem(SUSPENDER_KEY, originalUrl);
    // Replace page with a minimal overlay, freeing all memory
    document.open();
    document.write(`
      <html><head>
        <title>[Suspended] ${originalTitle}</title>
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <style>
          body { margin:0; background:linear-gradient(135deg,#232526 0%,#414345 100%); min-height:100vh; display:flex; align-items:center; justify-content:center; }
          #tabSuspenderCard { background:rgba(34,34,40,0.7); box-shadow:0 8px 32px 0 rgba(31,38,135,0.37); backdrop-filter:blur(16px) saturate(180%); -webkit-backdrop-filter:blur(16px) saturate(180%); border-radius:24px; border:1.5px solid rgba(255,255,255,0.12); padding:2.5em 2em; min-width:320px; max-width:90vw; display:flex; flex-direction:column; align-items:center; }
          #tabSuspenderIcon { font-size:3.5em; margin-bottom:0.5em; filter:drop-shadow(0 2px 8px #00e67644); }
          #tabSuspenderTitle { font-size:1.5em; font-weight:700; color:#fff; margin-bottom:0.5em; letter-spacing:0.01em; text-shadow:0 2px 8px #0006; }
          #tabSuspenderWebsite { font-size:1.1em; color:#b2dfdb; margin-bottom:1.5em; text-align:center; }
          #tabSuspenderWebsite span { color:#fff; font-weight:500; }
          #restoreTab { background:linear-gradient(90deg,#00e676 0%,#00bfae 100%); color:#222; font-size:1.1em; font-weight:700; border:none; border-radius:12px; padding:0.9em 2.2em; box-shadow:0 2px 12px #00e67633; cursor:pointer; outline:none; margin-top:0.5em; }
          #restoreTab:active { transform:scale(0.97); }
          #restoreTab:focus { box-shadow:0 0 0 3px #00e67677; }
          @media (max-width:500px) { #tabSuspenderCard { padding:1.5em 0.5em; min-width:0; } #tabSuspenderTitle { font-size:1.1em; } }
        </style>
      </head><body>
        <div id="tabSuspenderCard">
          <div id="tabSuspenderIcon" aria-hidden="true">🔋</div>
          <div id="tabSuspenderTitle">Tab Suspended to Save Resources</div>
          <div id="tabSuspenderWebsite">Website: <span>${
            originalTitle ? originalTitle : '(No Title)'
          }</span></div>
          <button id="restoreTab" aria-label="Restore Tab" autofocus>Restore Tab</button>
        </div>
        <script>
          document.getElementById('restoreTab').onclick = function() {
            // Remove backup from sessionStorage after restoring
            try { sessionStorage.removeItem('${SUSPENDER_KEY}'); } catch(e){}
            location.replace('${originalUrl.replace(/'/g, "\\'")}');
          };
          setTimeout(function() {
            var btn = document.getElementById('restoreTab');
            if (btn) btn.focus();
          }, 50);
        <\/script>
      </body></html>
    `);
    document.close();
  }

  function handleVisibilityChange() {
    tabIsActive = document.visibilityState === 'visible';
    if (tabIsActive) {
      clearTimeout(inactivityTimer);
    } else {
      resetTimer();
    }
  }

  function attachListeners() {
    ['mousemove', 'keydown', 'mousedown', 'touchstart', 'scroll'].forEach(
      (evt) => {
        window.addEventListener(evt, resetTimer, true);
      }
    );
    document.addEventListener(
      'visibilitychange',
      handleVisibilityChange,
      false
    );
  }

  attachListeners();
  if (!tabIsActive) {
    resetTimer();
  }
})();

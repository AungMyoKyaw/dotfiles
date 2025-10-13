// ==UserScript==
// @name         Safari Tab Suspender Pro
// @namespace    https://github.com/AungMyoKyaw
// @version      2.0
// @description  Advanced tab suspension with performance optimization, modern UI, and smart detection
// @author       AungMyoKyaw
// @match        *://*/*
// @exclude      *://www.youtube.com/*
// @exclude      *://youtube.com/*
// @exclude      *://*.youtube.com/*
// @exclude      *://gemini.google.com/*
// @exclude      *://aistudio.google.com/*
// @exclude      *://tasks.google.com/*
// @exclude      *://*.withgoogle.com/*
// @exclude      *://www.coursera.org/*
// @grant        none
// ==/UserScript==

(() => {
  'use strict';

  // Performance optimized configuration
  const CONFIG = {
    INACTIVITY_TIMEOUT: 5 * 60 * 1000, // 5 minutes
    DEBOUNCE_DELAY: 1000, // 1 second debounce for user activity
    HEARTBEAT_INTERVAL: 30000, // 30 seconds heartbeat check
    ANIMATION_DURATION: 300, // UI animation duration
    MEMORY_CLEANUP_THRESHOLD: 50 * 1024 * 1024 // 50MB
  };

  // Enhanced exclusion system with regex support
  const EXCLUSION_PATTERNS = [
    /^.*\.?youtube\.com$/,
    /^.*\.?google\.com$/,
    /^.*\.?coursera\.org$/,
    /^.*\.?withgoogle\.com$/,
    /^localhost(:\d+)?$/,
    /^127\.0\.0\.1(:\d+)?$/,
    /^192\.168\.\d+\.\d+(:\d+)?$/,
    /^10\.\d+\.\d+\.\d+(:\d+)?$/
  ];

  // Smart detection for dynamic content
  const DYNAMIC_CONTENT_SELECTORS = [
    'video',
    'audio',
    'iframe',
    'embed',
    'object',
    '[data-live]',
    '[data-streaming]',
    '[data-realtime]',
    '.chat',
    '.messaging',
    '.notification',
    '.websocket'
  ];

  // Form elements that should prevent suspension
  const CRITICAL_FORM_SELECTORS = [
    'form[data-pending="true"]',
    'input[required]:not(:placeholder-shown)',
    'textarea:not(:placeholder-shown)',
    'select:not([value=""])',
    '[data-unsaved="true"]'
  ];

  // Theme system
  const THEMES = {
    dark: {
      bg: 'linear-gradient(135deg,#0f0f0f 0%,#1a1a1a 100%)',
      cardBg: 'rgba(20, 20, 20, 0.8)',
      text: '#ffffff',
      accent: '#00ff88',
      secondary: '#88ffcc',
      border: 'rgba(255, 255, 255, 0.1)'
    },
    light: {
      bg: 'linear-gradient(135deg,#f8f9fa 0%,#e9ecef 100%)',
      cardBg: 'rgba(255, 255, 255, 0.9)',
      text: '#212529',
      accent: '#0066cc',
      secondary: '#4d94ff',
      border: 'rgba(0, 0, 0, 0.1)'
    }
  };

  // State management with performance monitoring
  const state = {
    isActive: document.visibilityState === 'visible',
    isSuspended: false,
    originalUrl: location.href,
    originalTitle: document.title,
    theme: window.matchMedia('(prefers-color-scheme: dark)').matches
      ? 'dark'
      : 'light',
    activityTimer: null,
    heartbeatTimer: null,
    debounceTimer: null,
    lastActivity: Date.now(),
    memoryUsage: 0,
    eventListeners: new Map(),
    performanceMetrics: {
      suspensionCount: 0,
      memorySaved: 0,
      lastSuspensionTime: 0
    }
  };

  // Constants
  const SUSPENDER_KEY = '__tabSuspenderPro';
  const STORAGE_PREFIX = '__tabSuspender_';

  // Initialize storage
  function initializeStorage() {
    try {
      if (!sessionStorage.getItem(SUSPENDER_KEY + '_originalUrl')) {
        sessionStorage.setItem(
          SUSPENDER_KEY + '_originalUrl',
          state.originalUrl
        );
      } else {
        state.originalUrl = sessionStorage.getItem(
          SUSPENDER_KEY + '_originalUrl'
        );
      }

      // Load user preferences
      const prefs = localStorage.getItem(STORAGE_PREFIX + 'preferences');
      if (prefs) {
        const userPrefs = JSON.parse(prefs);
        Object.assign(state, userPrefs);
      }
    } catch (error) {
      console.warn('Tab Suspender: Storage initialization failed', error);
    }
  }

  // Enhanced domain exclusion check
  function isExcludedDomain() {
    return EXCLUSION_PATTERNS.some((pattern) =>
      pattern.test(location.hostname)
    );
  }

  // Smart content detection
  function hasActiveContent() {
    return DYNAMIC_CONTENT_SELECTORS.some((selector) => {
      const elements = document.querySelectorAll(selector);
      return Array.from(elements).some((el) => {
        // Check if element is actually active
        if (el.matches('video, audio')) {
          return !el.paused && !el.ended;
        }
        if (el.matches('iframe')) {
          return el.src && !el.src.includes('about:blank');
        }
        return el.dataset.active === 'true' || el.classList.contains('active');
      });
    });
  }

  // Advanced form validation
  function hasUnsavedForms() {
    return CRITICAL_FORM_SELECTORS.some((selector) => {
      return document.querySelector(selector) !== null;
    });
  }

  // Memory usage estimation
  function estimateMemoryUsage() {
    if (performance.memory) {
      return performance.memory.usedJSHeapSize;
    }

    // Fallback estimation based on DOM size
    const nodes = document.querySelectorAll('*').length;
    const scripts = document.querySelectorAll('script').length;
    const images = document.querySelectorAll('img').length;

    return nodes * 200 + scripts * 50000 + images * 100000; // Rough estimation
  }

  // Debounced activity handler
  function handleActivity() {
    state.lastActivity = Date.now();

    if (state.debounceTimer) {
      clearTimeout(state.debounceTimer);
    }

    state.debounceTimer = setTimeout(() => {
      if (!state.isSuspended && !state.isActive) {
        resetSuspensionTimer();
      }
    }, CONFIG.DEBOUNCE_DELAY);
  }

  // Optimized timer management
  function resetSuspensionTimer() {
    if (state.isSuspended) return;

    if (state.activityTimer) {
      clearTimeout(state.activityTimer);
    }

    if (!state.isActive) {
      state.activityTimer = setTimeout(suspendTab, CONFIG.INACTIVITY_TIMEOUT);
    }
  }

  // Enhanced suspension with cleanup
  function suspendTab() {
    if (state.isActive || state.isSuspended) return;

    // Pre-suspension checks
    if (hasActiveContent() || hasUnsavedForms()) {
      console.log(
        'Tab Suspender: Suspension prevented - active content or unsaved forms detected'
      );
      resetSuspensionTimer();
      return;
    }

    // Check memory usage
    state.memoryUsage = estimateMemoryUsage();
    if (state.memoryUsage < CONFIG.MEMORY_CLEANUP_THRESHOLD) {
      console.log(
        'Tab Suspender: Suspension prevented - memory usage below threshold'
      );
      resetSuspensionTimer();
      return;
    }

    state.isSuspended = true;
    state.performanceMetrics.suspensionCount++;
    state.performanceMetrics.lastSuspensionTime = Date.now();

    // Cleanup event listeners
    cleanupEventListeners();

    // Save state
    try {
      sessionStorage.setItem(SUSPENDER_KEY + '_originalUrl', state.originalUrl);
      sessionStorage.setItem(
        SUSPENDER_KEY + '_metrics',
        JSON.stringify(state.performanceMetrics)
      );
    } catch (error) {
      console.warn('Tab Suspender: Failed to save state', error);
    }

    // Create suspension overlay
    createSuspensionOverlay();
  }

  // Modern suspension overlay with animations
  function createSuspensionOverlay() {
    const theme = THEMES[state.theme];

    document.open();
    document.write(`
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>[Suspended] ${state.originalTitle}</title>
        <style>
          * { margin: 0; padding: 0; box-sizing: border-box; }

          body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: ${theme.bg};
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
          }

          .particles {
            position: absolute;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: 1;
          }

          .particle {
            position: absolute;
            width: 4px;
            height: 4px;
            background: ${theme.accent};
            border-radius: 50%;
            opacity: 0.3;
            animation: float 20s infinite linear;
          }

          @keyframes float {
            from {
              transform: translateY(100vh) rotate(0deg);
              opacity: 0;
            }
            10% {
              opacity: 0.3;
            }
            90% {
              opacity: 0.3;
            }
            to {
              transform: translateY(-100vh) rotate(360deg);
              opacity: 0;
            }
          }

          .suspension-card {
            background: ${theme.cardBg};
            backdrop-filter: blur(20px) saturate(180%);
            -webkit-backdrop-filter: blur(20px) saturate(180%);
            border: 1px solid ${theme.border};
            border-radius: 24px;
            padding: 3em 2.5em;
            max-width: 450px;
            width: 90vw;
            text-align: center;
            z-index: 10;
            position: relative;
            box-shadow:
              0 20px 40px rgba(0, 0, 0, 0.3),
              0 0 100px rgba(0, 255, 136, 0.1);
            animation: slideIn 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
          }

          @keyframes slideIn {
            from {
              opacity: 0;
              transform: translateY(30px) scale(0.9);
            }
            to {
              opacity: 1;
              transform: translateY(0) scale(1);
            }
          }

          .icon-wrapper {
            width: 80px;
            height: 80px;
            margin: 0 auto 1.5em;
            background: linear-gradient(135deg, ${theme.accent}, ${theme.secondary});
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 32px rgba(0, 255, 136, 0.3);
            animation: pulse 2s infinite ease-in-out;
          }

          @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
          }

          .icon {
            font-size: 2.5em;
            filter: drop-shadow(0 2px 8px rgba(0, 0, 0, 0.3));
          }

          .title {
            font-size: 1.8em;
            font-weight: 700;
            color: ${theme.text};
            margin-bottom: 0.5em;
            background: linear-gradient(135deg, ${theme.accent}, ${theme.secondary});
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
          }

          .website-info {
            font-size: 1.1em;
            color: ${theme.text};
            opacity: 0.8;
            margin-bottom: 2em;
            line-height: 1.4;
          }

          .website-url {
            font-weight: 600;
            color: ${theme.accent};
            word-break: break-all;
          }

          .stats {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1em;
            margin-bottom: 2em;
            padding: 1.5em;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 16px;
            backdrop-filter: blur(10px);
          }

          .stat {
            text-align: center;
          }

          .stat-value {
            font-size: 1.5em;
            font-weight: 700;
            color: ${theme.accent};
            display: block;
          }

          .stat-label {
            font-size: 0.9em;
            color: ${theme.text};
            opacity: 0.7;
            margin-top: 0.2em;
          }

          .restore-button {
            background: linear-gradient(135deg, ${theme.accent}, ${theme.secondary});
            color: #000;
            border: none;
            border-radius: 16px;
            padding: 1em 2.5em;
            font-size: 1.1em;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 20px rgba(0, 255, 136, 0.4);
            outline: none;
            position: relative;
            overflow: hidden;
          }

          .restore-button::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
          }

          .restore-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 30px rgba(0, 255, 136, 0.6);
          }

          .restore-button:active {
            transform: translateY(0);
          }

          .restore-button:focus::before {
            width: 300px;
            height: 300px;
          }

          .keyboard-hint {
            margin-top: 1.5em;
            font-size: 0.9em;
            color: ${theme.text};
            opacity: 0.6;
          }

          .keyboard-hint kbd {
            background: rgba(0, 0, 0, 0.3);
            padding: 0.2em 0.5em;
            border-radius: 4px;
            font-family: monospace;
            margin: 0 0.2em;
          }

          @media (max-width: 500px) {
            .suspension-card {
              padding: 2em 1.5em;
              margin: 1em;
            }

            .title {
              font-size: 1.4em;
            }

            .stats {
              grid-template-columns: 1fr;
              gap: 0.5em;
            }

            .icon-wrapper {
              width: 60px;
              height: 60px;
            }

            .icon {
              font-size: 2em;
            }
          }

          @media (prefers-reduced-motion: reduce) {
            * {
              animation-duration: 0.01ms !important;
              animation-iteration-count: 1 !important;
              transition-duration: 0.01ms !important;
            }
          }
        </style>
      </head>
      <body>
        <div class="particles" id="particles"></div>

        <main class="suspension-card" role="main">
          <div class="icon-wrapper">
            <div class="icon" aria-hidden="true">🔋</div>
          </div>

          <h1 class="title">Tab Suspended</h1>

          <div class="website-info">
            <div>Website:</div>
            <div class="website-url">${state.originalTitle || location.hostname}</div>
          </div>

          <div class="stats">
            <div class="stat">
              <span class="stat-value">${Math.round(state.memoryUsage / 1024 / 1024)}MB</span>
              <span class="stat-label">Memory Saved</span>
            </div>
            <div class="stat">
              <span class="stat-value">${state.performanceMetrics.suspensionCount}</span>
              <span class="stat-label">Total Suspensions</span>
            </div>
          </div>

          <button
            class="restore-button"
            id="restoreTab"
            aria-label="Restore tab and continue browsing"
            autofocus
          >
            Restore Tab
          </button>

          <div class="keyboard-hint">
            Press <kbd>Space</kbd> or <kbd>Enter</kbd> to restore
          </div>
        </main>

        <script>
          // Create particle effects
          function createParticles() {
            const container = document.getElementById('particles');
            const particleCount = window.innerWidth > 768 ? 50 : 25;

            for (let i = 0; i < particleCount; i++) {
              const particle = document.createElement('div');
              particle.className = 'particle';
              particle.style.left = Math.random() * 100 + '%';
              particle.style.animationDelay = Math.random() * 20 + 's';
              particle.style.animationDuration = (15 + Math.random() * 10) + 's';
              container.appendChild(particle);
            }
          }

          // Restore functionality
          function restoreTab() {
            try {
              sessionStorage.removeItem('${SUSPENDER_KEY}_originalUrl');
              sessionStorage.removeItem('${SUSPENDER_KEY}_metrics');
            } catch (e) {
              console.warn('Failed to clear storage:', e);
            }
            location.replace('${state.originalUrl.replace(/'/g, "\\'")}');
          }

          // Initialize
          document.addEventListener('DOMContentLoaded', function() {
            createParticles();

            const restoreButton = document.getElementById('restoreTab');
            restoreButton.addEventListener('click', restoreTab);

            // Keyboard navigation
            document.addEventListener('keydown', function(e) {
              if (e.code === 'Space' || e.code === 'Enter') {
                e.preventDefault();
                restoreTab();
              }
            });

            // Focus management
            setTimeout(() => {
              restoreButton.focus();
            }, 100);
          });
        </script>
      </body>
      </html>
    `);
    document.close();
  }

  // Event listener management
  function addEventListenerWithCleanup(element, event, handler, options = {}) {
    element.addEventListener(event, handler, options);

    if (!state.eventListeners.has(element)) {
      state.eventListeners.set(element, []);
    }

    state.eventListeners.get(element).push({ event, handler, options });
  }

  function cleanupEventListeners() {
    state.eventListeners.forEach((listeners, element) => {
      listeners.forEach(({ event, handler, options }) => {
        element.removeEventListener(event, handler, options);
      });
    });
    state.eventListeners.clear();
  }

  // Visibility change handler
  function handleVisibilityChange() {
    const wasActive = state.isActive;
    state.isActive = document.visibilityState === 'visible';

    if (state.isActive && !wasActive) {
      // Tab became active
      clearTimeout(state.activityTimer);
      startHeartbeat();
    } else if (!state.isActive && wasActive) {
      // Tab became inactive
      stopHeartbeat();
      resetSuspensionTimer();
    }
  }

  // Heartbeat monitoring for performance
  function startHeartbeat() {
    if (state.heartbeatTimer) {
      clearInterval(state.heartbeatTimer);
    }

    state.heartbeatTimer = setInterval(() => {
      if (!state.isSuspended && !state.isActive) {
        const now = Date.now();
        const timeSinceActivity = now - state.lastActivity;

        if (timeSinceActivity >= CONFIG.INACTIVITY_TIMEOUT) {
          suspendTab();
        }
      }
    }, CONFIG.HEARTBEAT_INTERVAL);
  }

  function stopHeartbeat() {
    if (state.heartbeatTimer) {
      clearInterval(state.heartbeatTimer);
      state.heartbeatTimer = null;
    }
  }

  // Theme detection
  function handleThemeChange() {
    const prefersDark = window.matchMedia(
      '(prefers-color-scheme: dark)'
    ).matches;
    state.theme = prefersDark ? 'dark' : 'light';
  }

  // Initialize event listeners
  function attachEventListeners() {
    // User activity events with passive listeners for performance
    const activityEvents = [
      'mousemove',
      'keydown',
      'mousedown',
      'touchstart',
      'scroll',
      'wheel'
    ];
    activityEvents.forEach((event) => {
      addEventListenerWithCleanup(window, event, handleActivity, {
        passive: true,
        capture: true
      });
    });

    // Page visibility
    addEventListenerWithCleanup(
      document,
      'visibilitychange',
      handleVisibilityChange,
      { passive: true }
    );

    // Theme changes
    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    addEventListenerWithCleanup(mediaQuery, 'change', handleThemeChange);

    // Page unload
    addEventListenerWithCleanup(window, 'beforeunload', () => {
      cleanupEventListeners();
      stopHeartbeat();
    });
  }

  // Main initialization
  function initialize() {
    // Check if domain is excluded
    if (isExcludedDomain()) {
      console.log('Tab Suspender: Domain excluded from suspension');
      return;
    }

    // Initialize storage and state
    initializeStorage();

    // Load performance metrics
    try {
      const metrics = sessionStorage.getItem(SUSPENDER_KEY + '_metrics');
      if (metrics) {
        state.performanceMetrics = JSON.parse(metrics);
      }
    } catch (error) {
      console.warn('Tab Suspender: Failed to load metrics', error);
    }

    // Check if we're already on a suspended page
    if (document.title.includes('[Suspended]')) {
      console.log('Tab Suspender: Already on suspended page');
      return;
    }

    // Initialize event listeners
    attachEventListeners();

    // Start heartbeat if tab is active
    if (state.isActive) {
      startHeartbeat();
    } else {
      resetSuspensionTimer();
    }

    console.log('Tab Suspender Pro initialized successfully');
  }

  // Start the application
  initialize();
})();

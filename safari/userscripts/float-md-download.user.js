// ==UserScript==
// @name         Float MD Download Button
// @namespace    http://tampermonkey.net/
// @version      3.0.0
// @description  Modern floating button to convert page to Markdown and download as .md file
// @author       You
// @match        *://*/*
// @grant        none
// @run-at       document-end
// ==/UserScript==

(() => {
  'use strict';

  // ==================== CONFIGURATION ====================
  const CONFIG = Object.freeze({
    BUTTON: {
      ID: 'float-md-download-btn',
      ICON: 'MD',
      LABEL: 'Download page as Markdown',
      POSITION: { bottom: '20px', right: '20px' },
      SIZE: '50px',
      Z_INDEX: 99999
    },
    TURNDOWN_CDN: 'https://unpkg.com/turndown@7.1.2/dist/turndown.js',
    KEYBOARD_SHORTCUT: { ctrl: true, shift: true, key: 'M' },
    SELECTORS: {
      EXCLUDE: [
        'nav',
        'aside',
        'footer',
        'header',
        'script',
        'style',
        'noscript',
        'iframe',
        '.ad',
        '.advertisement',
        '.sidebar',
        '.navigation',
        '.comments',
        '.social-share',
        '.cookie-banner',
        '.popup',
        '.modal'
      ],
      CONTENT_PRIORITY: [
        'main',
        'article',
        '[role="main"]',
        '.content',
        '#content',
        '.post-content',
        '.article-body',
        '.entry-content',
        'body'
      ]
    },
    ANIMATION: {
      DURATION: 300,
      EASING: 'cubic-bezier(0.4, 0, 0.2, 1)'
    }
  });

  // ==================== UTILITIES ====================
  class Utils {
    static sanitizeFilename(name) {
      return (
        name
          .replace(/[^a-z0-9\s-_]/gi, '')
          .replace(/\s+/g, '-')
          .replace(/^-+|-+$/g, '')
          .slice(0, 60) || 'page'
      );
    }

    static debounce(func, wait) {
      let timeout;
      return function executedFunction(...args) {
        const later = () => {
          clearTimeout(timeout);
          func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
      };
    }

    static createElement(tag, className, attributes = {}) {
      const element = document.createElement(tag);
      if (className) element.className = className;
      Object.entries(attributes).forEach(([key, value]) => {
        element.setAttribute(key, value);
      });
      return element;
    }

    static async loadScript(src) {
      return new Promise((resolve, reject) => {
        if (window.TurndownService) {
          resolve();
          return;
        }

        const script = document.createElement('script');
        script.src = src;
        script.async = true;

        script.onload = () => resolve();
        script.onerror = () =>
          reject(new Error(`Failed to load script: ${src}`));

        document.head.appendChild(script);
      });
    }

    static showFeedback(message, type = 'info', duration = 3000) {
      const existing = document.querySelector('.md-feedback');
      if (existing) existing.remove();

      const feedback = Utils.createElement(
        'div',
        `md-feedback md-feedback-${type}`
      );
      feedback.textContent = message;

      document.body.appendChild(feedback);

      requestAnimationFrame(() => feedback.classList.add('show'));

      setTimeout(() => {
        feedback.classList.remove('show');
        setTimeout(() => feedback.remove(), CONFIG.ANIMATION.DURATION);
      }, duration);
    }
  }

  // ==================== THEME MANAGER ====================
  class ThemeManager {
    constructor() {
      this.isDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      this.setupThemeListener();
    }

    setupThemeListener() {
      const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
      mediaQuery.addEventListener('change', (e) => {
        this.isDark = e.matches;
        this.updateTheme();
      });
    }

    getThemeColors() {
      return this.isDark
        ? {
            background: 'rgba(255, 255, 255, 0.9)',
            color: '#1a1a1a',
            border: '1px solid rgba(255, 255, 255, 0.3)',
            shadow: '0 4px 20px rgba(0, 0, 0, 0.3)'
          }
        : {
            background: '#1a1a1a',
            color: '#ffffff',
            border: 'none',
            shadow: '0 4px 20px rgba(0, 0, 0, 0.4)'
          };
    }

    updateTheme() {
      const button = document.getElementById(CONFIG.BUTTON.ID);
      if (button) {
        const colors = this.getThemeColors();
        Object.assign(button.style, {
          background: colors.background,
          color: colors.color,
          border: colors.border,
          boxShadow: colors.shadow
        });
      }
    }

    generateCSS() {
      const colors = this.getThemeColors();
      return `
        .float-md-btn {
          position: fixed;
          bottom: ${CONFIG.BUTTON.POSITION.bottom};
          right: ${CONFIG.BUTTON.POSITION.right};
          width: ${CONFIG.BUTTON.SIZE};
          height: ${CONFIG.BUTTON.SIZE};
          background: ${colors.background};
          color: ${colors.color};
          border: ${colors.border};
          border-radius: 50%;
          font-family: 'SF Mono', 'Monaco', monospace;
          font-weight: bold;
          font-size: 14px;
          cursor: pointer;
          z-index: ${CONFIG.BUTTON.Z_INDEX};
          display: flex;
          align-items: center;
          justify-content: center;
          box-shadow: ${colors.shadow};
          transition: all ${CONFIG.ANIMATION.DURATION}ms ${CONFIG.ANIMATION.EASING};
          backdrop-filter: blur(10px);
          -webkit-backdrop-filter: blur(10px);
          user-select: none;
        }

        .float-md-btn:hover {
          transform: scale(1.1);
          opacity: 1;
        }

        .float-md-btn:active {
          transform: scale(0.95);
        }

        .float-md-btn.dragging {
          opacity: 0.7;
          cursor: grabbing;
        }

        .float-md-btn.loading {
          animation: spin 1s linear infinite;
        }

        .md-feedback {
          position: fixed;
          top: 20px;
          right: 20px;
          padding: 12px 16px;
          border-radius: 8px;
          color: white;
          font-family: -apple-system, BlinkMacSystemFont, sans-serif;
          font-size: 14px;
          z-index: ${CONFIG.BUTTON.Z_INDEX + 1};
          transform: translateX(100%);
          transition: transform ${CONFIG.ANIMATION.DURATION}ms ${CONFIG.ANIMATION.EASING};
          max-width: 300px;
          word-wrap: break-word;
        }

        .md-feedback.show {
          transform: translateX(0);
        }

        .md-feedback-info { background: rgba(0, 122, 255, 0.95); }
        .md-feedback-success { background: rgba(52, 199, 89, 0.95); }
        .md-feedback-error { background: rgba(255, 59, 48, 0.95); }

        @keyframes spin {
          to { transform: rotate(360deg); }
        }

        @media (prefers-reduced-motion: reduce) {
          .float-md-btn, .md-feedback {
            transition: none;
          }
          .float-md-btn.loading {
            animation: none;
          }
        }
      `;
    }
  }

  // ==================== MARKDOWN CONVERTER ====================
  class MarkdownConverter {
    constructor() {
      this.turndownService = null;
    }

    async initialize() {
      if (!this.turndownService) {
        await Utils.loadScript(CONFIG.TURNDOWN_CDN);
        this.turndownService = new window.TurndownService({
          headingStyle: 'atx',
          bulletListMarker: '-',
          codeBlockStyle: 'fenced',
          emDelimiter: '_',
          strongDelimiter: '**'
        });
        this.setupCustomRules();
      }
    }

    setupCustomRules() {
      // Custom conversion rules
      this.turndownService.addRule('strikethrough', {
        filter: ['del', 's', 'strike'],
        replacement: (content) => '~~' + content + '~~'
      });

      this.turndownService.addRule('highlight', {
        filter: ['mark'],
        replacement: (content) => '==' + content + '=='
      });
    }

    findBestContent() {
      for (const selector of CONFIG.SELECTORS.CONTENT_PRIORITY) {
        const element = document.querySelector(selector);
        if (element && element.textContent.trim().length > 100) {
          return element;
        }
      }
      return document.body;
    }

    cleanContent(element) {
      const clone = element.cloneNode(true);

      CONFIG.SELECTORS.EXCLUDE.forEach((selector) => {
        try {
          clone.querySelectorAll(selector).forEach((el) => el.remove());
        } catch (e) {
          console.warn(`Failed to remove selector: ${selector}`, e);
        }
      });

      // Remove the download button itself
      const downloadBtn = clone.querySelector(`#${CONFIG.BUTTON.ID}`);
      if (downloadBtn) downloadBtn.remove();

      return clone;
    }

    async convert() {
      await this.initialize();

      const contentElement = this.findBestContent();
      const cleanElement = this.cleanContent(contentElement);

      let markdown = this.turndownService.turndown(cleanElement.innerHTML);

      // Post-process markdown
      markdown = this.postProcessMarkdown(markdown);

      return markdown;
    }

    postProcessMarkdown(markdown) {
      // Clean up common issues
      return markdown
        .replace(/\n{4,}/g, '\n\n\n') // Reduce excessive blank lines
        .replace(/!\[[^\]]*\]\(data:image\/[^)]+\)/g, '[Image]') // Remove base64 images
        .replace(/\[(\s+)\]/g, '') // Remove empty links
        .trim();
    }

    generateMetadata() {
      return `---
title: ${document.title}
source: ${window.location.href}
extracted: ${new Date().toISOString()}
---

`;
    }
  }

  // ==================== UI CONTROLLER ====================
  class UIController {
    constructor(themeManager, markdownConverter) {
      this.themeManager = themeManager;
      this.markdownConverter = markdownConverter;
      this.button = null;
      this.isDragging = false;
      this.dragOffset = { x: 0, y: 0 };
    }

    initialize() {
      this.injectStyles();
      this.createButton();
      this.setupEventListeners();
    }

    injectStyles() {
      const style = Utils.createElement('style');
      style.textContent = this.themeManager.generateCSS();
      document.head.appendChild(style);
    }

    createButton() {
      this.button = Utils.createElement('button', 'float-md-btn', {
        id: CONFIG.BUTTON.ID,
        title: CONFIG.BUTTON.LABEL,
        'aria-label': CONFIG.BUTTON.LABEL,
        tabindex: '0'
      });

      this.button.textContent = CONFIG.BUTTON.ICON;
      document.body.appendChild(this.button);

      // Add entrance animation
      setTimeout(() => this.button.classList.add('show'), 100);
    }

    setupEventListeners() {
      // Button interactions
      this.button.addEventListener('click', () => this.handleButtonClick());
      this.button.addEventListener('keydown', (e) => this.handleKeyDown(e));

      // Drag functionality
      this.setupDragFunctionality();

      // Keyboard shortcut
      document.addEventListener('keydown', (e) =>
        this.handleKeyboardShortcut(e)
      );
    }

    setupDragFunctionality() {
      let startPos = { x: 0, y: 0 };
      let buttonPos = { x: 0, y: 0 };
      let hasMoved = false;

      const startDrag = (e) => {
        if (e.button !== 0) return; // Left click only

        this.isDragging = true;
        hasMoved = false;
        startPos = { x: e.clientX, y: e.clientY };

        const rect = this.button.getBoundingClientRect();
        buttonPos = { x: rect.left, y: rect.top };

        this.button.classList.add('dragging');
        e.preventDefault();
      };

      const drag = (e) => {
        if (!this.isDragging) return;

        const deltaX = e.clientX - startPos.x;
        const deltaY = e.clientY - startPos.y;

        if (Math.abs(deltaX) > 5 || Math.abs(deltaY) > 5) {
          hasMoved = true;
        }

        const newX = Math.max(
          0,
          Math.min(
            buttonPos.x + deltaX,
            window.innerWidth - this.button.offsetWidth
          )
        );
        const newY = Math.max(
          0,
          Math.min(
            buttonPos.y + deltaY,
            window.innerHeight - this.button.offsetHeight
          )
        );

        this.button.style.left = `${newX}px`;
        this.button.style.top = `${newY}px`;
        this.button.style.right = 'auto';
        this.button.style.bottom = 'auto';
      };

      const endDrag = () => {
        if (!this.isDragging) return;

        this.isDragging = false;
        this.button.classList.remove('dragging');

        // Prevent click if button was moved
        if (hasMoved) {
          this.button.dataset.dragged = 'true';
          setTimeout(() => delete this.button.dataset.dragged, 100);
        }
      };

      this.button.addEventListener('mousedown', startDrag);
      document.addEventListener('mousemove', drag);
      document.addEventListener('mouseup', endDrag);
    }

    handleKeyDown(e) {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        this.handleButtonClick();
      }
    }

    handleKeyboardShortcut(e) {
      const { ctrl, shift, key } = CONFIG.KEYBOARD_SHORTCUT;

      if (
        e.ctrlKey === ctrl &&
        e.shiftKey === shift &&
        e.key.toUpperCase() === key.toUpperCase()
      ) {
        e.preventDefault();
        this.handleButtonClick();
      }
    }

    async handleButtonClick() {
      if (
        this.button.dataset.dragged === 'true' ||
        this.button.classList.contains('loading')
      ) {
        return;
      }

      try {
        this.setLoadingState(true);
        Utils.showFeedback('Converting to Markdown...', 'info', 0);

        // Hide button temporarily to avoid including it in conversion
        const originalDisplay = this.button.style.display;
        this.button.style.display = 'none';

        const markdown = await this.markdownConverter.convert();
        const metadata = this.markdownConverter.generateMetadata();
        const fullContent = metadata + markdown;

        // Restore button
        this.button.style.display = originalDisplay;

        // Prompt for filename and download
        const defaultName = Utils.sanitizeFilename(document.title) + '.md';
        const filename = prompt('Save as:', defaultName) || defaultName;

        // Store download data for immediate use
        this.pendingDownload = {
          content: fullContent,
          filename: Utils.sanitizeFilename(filename)
        };

        // Trigger download immediately during user interaction
        this.downloadMarkdown(fullContent, Utils.sanitizeFilename(filename));

        Utils.showFeedback('Successfully downloaded!', 'success');
      } catch (error) {
        console.error('Conversion failed:', error);
        Utils.showFeedback('Conversion failed. Please try again.', 'error');
      } finally {
        this.setLoadingState(false);
      }
    }

    setLoadingState(loading) {
      if (loading) {
        this.button.classList.add('loading');
        this.button.disabled = true;
        this.button.textContent = '⏳';
      } else {
        this.button.classList.remove('loading');
        this.button.disabled = false;
        this.button.textContent = CONFIG.BUTTON.ICON;
      }
    }

    downloadMarkdown(content, filename) {
      const blob = new Blob([content], { type: 'text/markdown' });
      const url = URL.createObjectURL(blob);

      // Safari-compatible download method
      const a = Utils.createElement('a', {
        href: url,
        download: filename,
        style: 'display: none',
        target: '_blank'
      });

      document.body.appendChild(a);

      // Method 1: Direct click (works in most cases)
      try {
        a.click();

        // Keep the element longer for Safari to process the download
        setTimeout(() => {
          document.body.removeChild(a);
          URL.revokeObjectURL(url);
        }, 100);
      } catch (error) {
        console.error('Direct click failed:', error);

        // Method 2: Event dispatch
        try {
          const clickEvent = new MouseEvent('click', {
            view: window,
            bubbles: true,
            cancelable: true
          });
          a.dispatchEvent(clickEvent);

          setTimeout(() => {
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
          }, 100);
        } catch (error2) {
          console.error('Event dispatch failed:', error2);

          // Method 3: Fallback - open in new tab
          document.body.removeChild(a);
          URL.revokeObjectURL(url);

          const newUrl = URL.createObjectURL(blob);
          const fallbackWindow = window.open(newUrl, '_blank');

          if (!fallbackWindow) {
            Utils.showFeedback(
              'Popup blocked. Please allow popups for this site.',
              'error'
            );

            // Method 4: Last resort - copy to clipboard
            this.copyToClipboard(content, filename);
          } else {
            Utils.showFeedback(
              'Please save the file from the new tab (File > Save As)',
              'info'
            );
            setTimeout(() => URL.revokeObjectURL(newUrl), 5000);
          }
        }
      }
    }

    copyToClipboard(content, filename) {
      try {
        // Copy content to clipboard as fallback
        if (navigator.clipboard && window.isSecureContext) {
          navigator.clipboard
            .writeText(content)
            .then(() => {
              Utils.showFeedback(
                `Content copied to clipboard. Paste into a new file named "${filename}"`,
                'info'
              );
            })
            .catch(() => {
              this.fallbackCopyMethod(content, filename);
            });
        } else {
          this.fallbackCopyMethod(content, filename);
        }
      } catch (error) {
        console.error('Copy failed:', error);
        Utils.showFeedback(
          'Download failed. Please manually copy the content.',
          'error'
        );
      }
    }

    fallbackCopyMethod(content, filename) {
      const textArea = Utils.createElement('textarea');
      textArea.value = content;
      textArea.style.position = 'fixed';
      textArea.style.opacity = '0';
      document.body.appendChild(textArea);
      textArea.select();

      try {
        document.execCommand('copy');
        Utils.showFeedback(
          `Content copied to clipboard. Paste into a new file named "${filename}"`,
          'info'
        );
      } catch (error) {
        Utils.showFeedback(
          'All download methods failed. Please manually copy the content.',
          'error'
        );
      }

      document.body.removeChild(textArea);
    }
  }

  // ==================== MAIN APPLICATION ====================
  class FloatMarkdownApp {
    constructor() {
      this.themeManager = null;
      this.markdownConverter = null;
      this.uiController = null;
      this.initialized = false;
    }

    async initialize() {
      if (this.initialized) return;

      try {
        // Initialize components
        this.themeManager = new ThemeManager();
        this.markdownConverter = new MarkdownConverter();
        this.uiController = new UIController(
          this.themeManager,
          this.markdownConverter
        );

        // Setup UI
        this.uiController.initialize();

        this.initialized = true;

        // Show welcome message for first-time users
        if (!localStorage.getItem('float-md-welcomed')) {
          setTimeout(() => {
            Utils.showFeedback(
              'Markdown download ready! Press Ctrl+Shift+M or click the button.',
              'info',
              5000
            );
            localStorage.setItem('float-md-welcomed', 'true');
          }, 1000);
        }
      } catch (error) {
        console.error('Failed to initialize Float Markdown:', error);
        Utils.showFeedback(
          'Failed to initialize. Please refresh the page.',
          'error'
        );
      }
    }
  }

  // ==================== INITIALIZATION ====================
  const app = new FloatMarkdownApp();

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => app.initialize());
  } else {
    app.initialize();
  }

  // Preload Turndown script in background
  if ('requestIdleCallback' in window) {
    requestIdleCallback(() => {
      const link = Utils.createElement('link', '', {
        rel: 'prefetch',
        href: CONFIG.TURNDOWN_CDN
      });
      document.head.appendChild(link);
    });
  }
})();

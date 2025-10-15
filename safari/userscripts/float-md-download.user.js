// ==UserScript==
// @name         AI-Ready MD Clipboard
// @namespace    http://tampermonkey.net/
// @version      4.2.0
// @description  Click floating button to copy AI-ready Markdown content to clipboard. Optimized for direct pasting into AI chatboxes.
// @author       You
// @match        *://*.coursera.org/*
// @grant        none
// @run-at       document-end
// ==/UserScript==

(() => {
  'use strict';

  // ==================== CONFIGURATION ====================
  const CONFIG = {
    BUTTON: {
      ID: 'ai-clipboard-btn',
      ICON: '🤖',
      LABEL: 'Copy AI-Ready Content',
      POSITION: { bottom: '20px', right: '20px' },
      SIZE: '50px',
      Z_INDEX: 99999
    },
    TURNDOWN_CDN: 'https://unpkg.com/turndown@7.1.2/dist/turndown.js',
    AI_CONTENT_SELECTORS: {
      // Coursera-specific content selectors for course materials
      PRIMARY: [
        '[data-testid="lecture-content"]',
        '.rc-lecture-viewer-content',
        '.lecture-content',
        '.course-content',
        '[data-testid="content"]',
        'main[role="main"] article',
        '.content-area'
      ],
      SECONDARY: [
        '.rc-LessonViewer',
        '.rc-VerticalView',
        '.lesson-content',
        '.reading-content',
        '[data-track-component="lecture-viewer"]'
      ],
      FALLBACK: ['body']
    },
    AI_CLEANUP_SELECTORS: [
      // Remove these elements for clean AI content
      'script',
      'style',
      'noscript',
      'iframe',
      'embed',
      'object',
      'nav',
      'header',
      'footer',
      'aside',
      '.sidebar',
      '.navigation',
      '.breadcrumb',
      '.pagination',
      '.toolbar',
      '.controls',
      'button',
      'input',
      'select',
      'textarea',
      '.btn',
      '[role="button"]',
      '[role="tab"]',
      '[role="menu"]',
      '.ad',
      '.advertisement',
      '.social-share',
      '.comments',
      '.cookie-banner',
      '.popup',
      '.modal',
      '.overlay',
      '[data-testid*="nav"]',
      '[data-testid*="menu"]',
      '[data-testid*="script"]',
      '[data-testid*="ad"]',
      '[aria-label*="navigation"]',
      '[aria-label*="menu"]',
      '[src*="ads"]',
      '[src*="analytics"]',
      '[src*="tracking"]'
    ],
    ANIMATION: {
      DURATION: 300,
      EASING: 'cubic-bezier(0.4, 0, 0.2, 1)'
    }
  };

  // ==================== UTILITIES ====================
  class Utils {
    static createButton(text, className = '', attributes = {}) {
      const button = document.createElement('button');
      button.textContent = text;
      if (className) button.className = className;
      Object.entries(attributes).forEach(([key, value]) => {
        button.setAttribute(key, value);
      });
      return button;
    }

    static createDiv(className = '', attributes = {}) {
      const div = document.createElement('div');
      if (className) div.className = className;
      Object.entries(attributes).forEach(([key, value]) => {
        div.setAttribute(key, value);
      });
      return div;
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
        script.onerror = () => reject(new Error(`Failed to load: ${src}`));
        document.head.appendChild(script);
      });
    }

    static showNotification(message, type = 'success', duration = 3000) {
      const existing = document.querySelector('.ai-notification');
      if (existing) existing.remove();

      const notification = Utils.createDiv(
        `ai-notification ai-notification-${type}`
      );
      notification.innerHTML = `
        <div class="ai-notification-icon">
          ${type === 'success' ? '✅' : '❌'}
        </div>
        <div class="ai-notification-message">${message}</div>
      `;

      document.body.appendChild(notification);

      requestAnimationFrame(() => notification.classList.add('show'));

      setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => notification.remove(), CONFIG.ANIMATION.DURATION);
      }, duration);
    }

    static sanitizeForAI(text) {
      return (
        text
          // Remove JavaScript code blocks and inline scripts
          .replace(/```javascript[\s\S]*?```/gi, '')
          .replace(/```js[\s\S]*?```/gi, '')
          .replace(/<script[\s\S]*?<\/script>/gi, '')
          .replace(/javascript:[\s\S]*?;/gi, '')
          .replace(/function\s*\([^)]*\)\s*{[\s\S]*?}/gi, '')
          .replace(/\w+\s*:\s*function\s*\([^)]*\)\s*{[\s\S]*?}/gi, '')
          .replace(/console\.\w+\([^)]*\);?/gi, '')
          .replace(/alert\s*\([^)]*\);?/gi, '')
          .replace(/document\.\w+\([^)]*\);?/gi, '')
          .replace(/window\.\w+\([^)]*\);?/gi, '')
          // Remove event handlers
          .replace(/on\w+\s*=\s*["'][^"']*["']/gi, '')
          .replace(/on\w+\s*=\s*[^;\s]+/gi, '')
          // Remove excessive whitespace
          .replace(/\n{3,}/g, '\n\n')
          // Fix common OCR/formatting issues
          .replace(/([a-z])([A-Z])/g, '$1 $2')
          // Clean up bullet points
          .replace(/^[\s•·o]\s*/gm, '- ')
          // Clean up numbered lists
          .replace(/^(\d+)\.?\s*/gm, '$1. ')
          // Remove HTML entities
          .replace(/&nbsp;/g, ' ')
          .replace(/&amp;/g, '&')
          .replace(/&lt;/g, '<')
          .replace(/&gt;/g, '>')
          .replace(/&quot;/g, '"')
          .replace(/&#39;/g, "'")
          // Remove multiple spaces
          .replace(/ {2,}/g, ' ')
          // Clean up any remaining script-like patterns
          .replace(
            /\b(function|var|let|const|if|else|for|while|do|switch|case|break|continue|return|try|catch|finally|throw|new|this|class|extends|import|export|default|async|await)\b[^;{}]*[;{}]?/gi,
            ''
          )
          // Enhanced JavaScript removal
          .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
          .replace(/\s*on\w+="[^"]*"/gi, '')
          .replace(/\s*on\w+='[^']*'/gi, '')
          .replace(/\s*on\w+=[^\s>]*/gi, '')
          .replace(/href=["']javascript:[^"']*["']/gi, '')
          .replace(/href=['"]javascript:[^'"]*['"]/gi, '')
          // Preserve math notation for AI understanding
          .replace(/\\\$/g, '$')
          .replace(/\\\$/g, '$')
          // Remove MathJax script tags specifically
          .replace(/<script type="math\/tex[^>]*>[\s\S]*?<\/script>/gi, '')
          .replace(/<span class="MathJax[^>]*>[\s\S]*?<\/span>/gi, '')
          // Clean up any remaining script-like patterns
          .replace(/eval\s*\([^)]*\)/gi, '')
          .replace(/setTimeout\s*\([^)]*\)/gi, '')
          .replace(/setInterval\s*\([^)]*\)/gi, '')
          .replace(/location\s*\.[\s\S]*?;/gi, '')
          .replace(/history\s*\.[\s\S]*?;/gi, '')
          .replace(/navigator\s*\.[\s\S]*?;/gi, '')
          .trim()
      );
    }

    static detectContentType(element) {
      const text = element.textContent.toLowerCase();
      const html = element.innerHTML.toLowerCase();

      // Detect if it's code-heavy content
      const hasCodeBlocks = /<code|<pre|```/.test(html);
      const hasMath = /\$\$|\\begin|\\end|\\frac|\\sqrt/.test(text);
      const hasTables = /<table|<th|<td/.test(html);

      return {
        isCode: hasCodeBlocks,
        hasMath: hasMath,
        hasTables: hasTables,
        wordCount: text.split(/\s+/).length
      };
    }
  }

  // ==================== AI CONTENT PROCESSOR ====================
  class AIContentProcessor {
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
          strongDelimiter: '**',
          linkStyle: 'inlined'
        });

        this.setupAIRules();
      }
    }

    setupAIRules() {
      // Enhanced rules for AI-ready content
      this.turndownService.addRule('code-blocks', {
        filter: ['pre', 'code'],
        replacement: (content, node) => {
          if (node.tagName === 'PRE') {
            const language = this.detectLanguage(content);
            return `\`\`\`${language}\n${content}\n\`\`\`\n\n`;
          }
          return `\`${content}\``;
        }
      });

      this.turndownService.addRule('math', {
        filter: (node) => {
          return (
            node.textContent.includes('$') ||
            node.textContent.includes('\\') ||
            node.className?.includes('math')
          );
        },
        replacement: (content) => {
          // Preserve math notation for AI understanding
          return `\\[\\ ${content} \\]\\]\n\n`;
        }
      });

      this.turndownService.addRule('tables', {
        filter: ['table'],
        replacement: (content, node) => {
          // Convert tables to clean markdown
          const rows = Array.from(node.querySelectorAll('tr'));
          if (rows.length === 0) return '';

          let tableMd = '\n';
          rows.forEach((row, index) => {
            const cells = Array.from(row.querySelectorAll('td, th')).map(
              (cell) => cell.textContent.trim()
            );
            tableMd += '| ' + cells.join(' | ') + ' |\n';

            if (index === 0) {
              tableMd += '|' + cells.map(() => ' --- ').join('|') + '|\n';
            }
          });
          tableMd += '\n';
          return tableMd;
        }
      });

      this.turndownService.addRule('emphasis', {
        filter: ['strong', 'b', 'em', 'i'],
        replacement: (content, node) => {
          const tag = node.tagName.toLowerCase();
          if (tag === 'strong' || tag === 'b') {
            return `**${content}**`;
          }
          return `_${content}_`;
        }
      });
    }

    detectLanguage(code) {
      // Simple language detection for code blocks
      if (
        code.includes('def ') ||
        code.includes('import ') ||
        code.includes('print(')
      )
        return 'python';
      if (
        code.includes('function ') ||
        code.includes('const ') ||
        code.includes('=>')
      )
        return 'javascript';
      if (code.includes('public class ') || code.includes('System.out'))
        return 'java';
      if (code.includes('#include') || code.includes('int main')) return 'cpp';
      if (
        code.includes('<html') ||
        code.includes('<div') ||
        code.includes('function')
      )
        return 'html';
      return '';
    }

    extractBestContent() {
      // Try all content selectors in order of preference
      for (const selector of CONFIG.AI_CONTENT_SELECTORS.PRIMARY) {
        const element = document.querySelector(selector);
        if (element && this.isValidContent(element)) {
          return element;
        }
      }

      for (const selector of CONFIG.AI_CONTENT_SELECTORS.SECONDARY) {
        const element = document.querySelector(selector);
        if (element && this.isValidContent(element)) {
          return element;
        }
      }

      for (const selector of CONFIG.AI_CONTENT_SELECTORS.FALLBACK) {
        const element = document.querySelector(selector);
        if (element && this.isValidContent(element)) {
          return element;
        }
      }

      return document.body;
    }

    isValidContent(element) {
      const text = element.textContent.trim();
      return text.length > 100; // Only consider substantial content
    }

    cleanContent(element) {
      const clone = element.cloneNode(true);

      // Remove unwanted elements
      CONFIG.AI_CLEANUP_SELECTORS.forEach((selector) => {
        try {
          clone.querySelectorAll(selector).forEach((el) => el.remove());
        } catch (e) {
          console.warn(`Failed to remove selector: ${selector}`, e);
        }
      });

      // Remove our own button
      const aiButton = clone.querySelector(`#${CONFIG.BUTTON.ID}`);
      if (aiButton) aiButton.remove();

      // Additional deep cleaning for script content
      this.deepCleanContent(clone);

      // Validate that no JavaScript content remains
      const cleanedHTML = clone.innerHTML;
      if (this.containsJavaScript(cleanedHTML)) {
        console.warn(
          'JavaScript content still detected, applying additional cleaning'
        );
        this.aggressiveClean(clone);
      }

      return clone;
    }

    containsJavaScript(text) {
      const jsPatterns = [
        /javascript:/gi,
        /<script/i,
        /on\w+\s*=/gi,
        /function\s*\(/gi,
        /console\./gi,
        /document\./gi,
        /window\./gi,
        /alert\s*\(/gi,
        /var\s+\w+/gi,
        /let\s+\w+/gi,
        /const\s+\w+/gi,
        /eval\s*\(/gi,
        /setTimeout\s*\(/gi,
        /setInterval\s*\(/gi
      ];

      return jsPatterns.some((pattern) => pattern.test(text));
    }

    aggressiveClean(element) {
      // More aggressive cleanup for stubborn JavaScript content
      const walker = document.createTreeWalker(
        element,
        NodeFilter.SHOW_TEXT,
        null,
        false
      );

      const textNodes = [];
      let node;
      while ((node = walker.nextNode())) {
        textNodes.push(node);
      }

      textNodes.forEach((textNode) => {
        // Remove any remaining JavaScript-like content
        textNode.textContent = textNode.textContent
          .replace(/javascript:[^\s]*/gi, '')
          .replace(/function[^(]*\([^)]*\)[^{]*{[^}]*}/gi, '')
          .replace(/on\w+\s*=\s*['"][^'"]*['"]/gi, '')
          .replace(/console\.[a-zA-Z]+\([^)]*\)/gi, '')
          .replace(/\b(var|let|const)\s+\w+\s*=\s*[^;]+;?/gi, '')
          .replace(
            /\b(if|for|while|do|switch|try|catch|throw|return)\b[^;{}]*[;{}]?/gi,
            ''
          )
          .replace(/eval\s*\([^)]*\)/gi, '')
          .replace(/setTimeout\s*\([^)]*\)/gi, '')
          .replace(/setInterval\s*\([^)]*\)/gi, '');
      });
    }

    deepCleanContent(element) {
      // Remove all script-related content that might be missed
      const allElements = element.querySelectorAll('*');

      allElements.forEach((el) => {
        // Remove script-related attributes
        const attrsToRemove = [
          'onclick',
          'onload',
          'onerror',
          'onmouseover',
          'onmouseout',
          'onchange',
          'onsubmit',
          'onfocus',
          'onblur',
          'onkeydown',
          'onkeyup',
          'onkeypress',
          'onmousedown',
          'onmouseup',
          'onmousemove',
          'ontouchstart',
          'ontouchend',
          'ontouchmove'
        ];

        attrsToRemove.forEach((attr) => {
          if (el.hasAttribute(attr)) {
            el.removeAttribute(attr);
          }
        });

        // Remove elements with javascript: hrefs
        if (
          el.tagName === 'A' &&
          el.getAttribute('href')?.startsWith('javascript:')
        ) {
          el.remove();
        }

        // Remove data attributes that might contain scripts
        Array.from(el.attributes).forEach((attr) => {
          if (
            attr.name.startsWith('data-') &&
            (attr.value.includes('function') ||
              attr.value.includes('javascript:') ||
              attr.value.includes('alert(') ||
              attr.value.includes('console.'))
          ) {
            el.removeAttribute(attr.name);
          }
        });

        // Remove inline event handlers and scripts from text content
        if (el.textContent) {
          el.textContent = el.textContent
            .replace(/javascript:/gi, '')
            .replace(/function\s*\(/gi, 'function(')
            .replace(/alert\s*\(/gi, 'alert(')
            .replace(/console\./gi, 'console.')
            .replace(/onclick\s*=/gi, 'onclick=')
            .replace(/onload\s*=/gi, 'onload=')
            .replace(/eval\s*\(/gi, '')
            .replace(/setTimeout\s*\(/gi, '')
            .replace(/setInterval\s*\(/gi, '');
        }
      });
    }

    async processToAIReady() {
      await this.initialize();

      const contentElement = this.extractBestContent();
      const cleanElement = this.cleanContent(contentElement);
      const contentType = Utils.detectContentType(cleanElement);

      let markdown = this.turndownService.turndown(cleanElement.innerHTML);

      // AI-optimized post-processing
      markdown = Utils.sanitizeForAI(markdown);

      // Add AI context header
      const contextHeader = this.generateAIContext(contentType);

      return contextHeader + markdown;
    }

    generateAIContext(contentType) {
      const title = document.title || 'Untitled Content';
      const url = window.location.href;
      const timestamp = new Date().toISOString();

      return `---
Content: ${title}
Source: ${url}
Extracted: ${timestamp}
Content Type: ${contentType.isCode ? 'Code/Programming' : contentType.hasMath ? 'Mathematical' : contentType.hasTables ? 'Tabular Data' : 'General Text'}
Word Count: ~${contentType.wordCount} words
AI-Ready: Optimized for LLM processing

---

`;
    }
  }

  // ==================== UI MANAGER ====================
  class UIManager {
    constructor() {
      this.button = null;
      this.processor = new AIContentProcessor();
      this.isDarkMode = window.matchMedia(
        '(prefers-color-scheme: dark)'
      ).matches;
    }

    initialize() {
      this.injectStyles();
      this.createFloatingButton();
      this.setupEventListeners();
      this.setupThemeListener();
    }

    injectStyles() {
      const style = document.createElement('style');
      style.textContent = this.generateCSS();
      document.head.appendChild(style);
    }

    generateCSS() {
      const colors = this.isDarkMode
        ? {
            bg: 'rgba(30, 30, 30, 0.95)',
            color: '#ffffff',
            border: '1px solid rgba(255, 255, 255, 0.2)',
            shadow: '0 8px 32px rgba(0, 0, 0, 0.4)',
            hoverBg: 'rgba(255, 255, 255, 0.1)'
          }
        : {
            bg: 'rgba(255, 255, 255, 0.95)',
            color: '#1a1a1a',
            border: '1px solid rgba(0, 0, 0, 0.1)',
            shadow: '0 8px 32px rgba(0, 0, 0, 0.15)',
            hoverBg: 'rgba(0, 0, 0, 0.05)'
          };

      return `
        .ai-clipboard-btn {
          position: fixed;
          bottom: ${CONFIG.BUTTON.POSITION.bottom};
          right: ${CONFIG.BUTTON.POSITION.right};
          width: ${CONFIG.BUTTON.SIZE};
          height: ${CONFIG.BUTTON.SIZE};
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          border: none;
          border-radius: 50%;
          font-size: 20px;
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

        .ai-clipboard-btn:hover {
          transform: scale(1.1) rotate(5deg);
          box-shadow: 0 12px 40px rgba(102, 126, 234, 0.4);
        }

        .ai-clipboard-btn:active {
          transform: scale(0.95);
        }

        .ai-clipboard-btn.copied {
          background: linear-gradient(135deg, #52c234 0%, #3da831 100%);
          animation: pulse 0.6s ease-in-out;
        }

        @keyframes pulse {
          0% { transform: scale(1); }
          50% { transform: scale(1.2); }
          100% { transform: scale(1); }
        }

        .ai-notification {
          position: fixed;
          top: 20px;
          right: 20px;
          background: ${colors.bg};
          color: ${colors.color};
          border: ${colors.border};
          border-radius: 12px;
          padding: 16px 20px;
          display: flex;
          align-items: center;
          gap: 12px;
          z-index: ${CONFIG.BUTTON.Z_INDEX + 1};
          transform: translateX(400px);
          transition: all ${CONFIG.ANIMATION.DURATION}ms ${CONFIG.ANIMATION.EASING};
          box-shadow: ${colors.shadow};
          backdrop-filter: blur(10px);
          -webkit-backdrop-filter: blur(10px);
          max-width: 350px;
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        .ai-notification.show {
          transform: translateX(0);
        }

        .ai-notification-icon {
          font-size: 20px;
          flex-shrink: 0;
        }

        .ai-notification-message {
          font-size: 14px;
          line-height: 1.4;
        }

        .ai-notification-success {
          border-left: 4px solid #52c234;
        }

        .ai-notification-error {
          border-left: 4px solid #ff4444;
        }

        @media (max-width: 768px) {
          .ai-clipboard-btn {
            width: 45px;
            height: 45px;
            font-size: 18px;
          }

          .ai-notification {
            right: 10px;
            left: 10px;
            max-width: none;
          }
        }

        @media (prefers-reduced-motion: reduce) {
          .ai-clipboard-btn, .ai-notification {
            transition: none;
          }
          .ai-clipboard-btn.copied {
            animation: none;
          }
        }
      `;
    }

    createFloatingButton() {
      this.button = Utils.createButton(CONFIG.BUTTON.ICON, 'ai-clipboard-btn', {
        id: CONFIG.BUTTON.ID,
        title: CONFIG.BUTTON.LABEL,
        'aria-label': CONFIG.BUTTON.LABEL
      });

      document.body.appendChild(this.button);

      // Entrance animation
      setTimeout(() => {
        this.button.style.opacity = '1';
        this.button.style.transform = 'scale(1)';
      }, 500);
    }

    setupEventListeners() {
      this.button.addEventListener('click', () => this.handleCopyToClipboard());
      this.button.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          this.handleCopyToClipboard();
        }
      });
    }

    setupThemeListener() {
      const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
      mediaQuery.addEventListener('change', (e) => {
        this.isDarkMode = e.matches;
        this.injectStyles(); // Re-inject styles with new theme
      });
    }

    async handleCopyToClipboard() {
      if (this.button.classList.contains('copied')) return;

      try {
        // Show processing state
        this.button.classList.add('copied');
        this.button.textContent = '⏳';
        Utils.showNotification('🔄 Processing content...', 'success', 1000);

        // Process content for AI
        const aiReadyContent = await this.processor.processToAIReady();

        // Copy to clipboard
        if (navigator.clipboard && window.isSecureContext) {
          await navigator.clipboard.writeText(aiReadyContent);
        } else {
          this.fallbackCopyToClipboard(aiReadyContent);
        }

        // Show success state
        this.button.textContent = '✅';

        // Check if JavaScript was cleaned
        const hasJavaScript = this.processor.containsJavaScript(aiReadyContent);
        const message = hasJavaScript
          ? '✅ AI-ready content copied! JavaScript has been removed for safety.'
          : '✅ AI-ready content copied! Paste into any AI chatbox.';

        Utils.showNotification(message, 'success', 4000);

        // Reset button after delay
        setTimeout(() => {
          this.button.classList.remove('copied');
          this.button.textContent = CONFIG.BUTTON.ICON;
        }, 3000);
      } catch (error) {
        console.error('Failed to copy content:', error);
        this.button.classList.remove('copied');
        this.button.textContent = '❌';
        Utils.showNotification(
          '❌ Failed to copy content. Please try again.',
          'error',
          4000
        );

        setTimeout(() => {
          this.button.textContent = CONFIG.BUTTON.ICON;
        }, 3000);
      }
    }

    fallbackCopyToClipboard(text) {
      const textarea = document.createElement('textarea');
      textarea.value = text;
      textarea.style.position = 'fixed';
      textarea.style.opacity = '0';
      document.body.appendChild(textarea);
      textarea.select();

      try {
        document.execCommand('copy');
      } catch (error) {
        console.error('Fallback copy failed:', error);
        throw error;
      }

      document.body.removeChild(textarea);
    }
  }

  // ==================== INITIALIZATION ====================
  class AIClipboardApp {
    constructor() {
      this.uiManager = null;
      this.initialized = false;
    }

    async initialize() {
      if (this.initialized) return;

      try {
        this.uiManager = new UIManager();
        this.uiManager.initialize();
        this.initialized = true;

        // Show welcome message
        setTimeout(() => {
          Utils.showNotification(
            '🤖 AI Clipboard Ready! Click the robot to copy content optimized for AI chatboxes.',
            'success',
            5000
          );
        }, 1000);
      } catch (error) {
        console.error('Failed to initialize AI Clipboard:', error);
        Utils.showNotification(
          '❌ Failed to initialize. Please refresh the page.',
          'error',
          5000
        );
      }
    }
  }

  // ==================== APP STARTUP ====================
  const app = new AIClipboardApp();

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => app.initialize());
  } else {
    app.initialize();
  }
})();

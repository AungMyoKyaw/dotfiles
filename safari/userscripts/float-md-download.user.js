// ==UserScript==
// @name         AI-Ready MD Clipboard
// @namespace    http://tampermonkey.net/
// @version      5.1.0
// @description  Copy web content as clean, AI-ready Markdown. Works on any website with a floating button.
// @author       You
// @match        *://*/*
// @grant        none
// @run-at       document-end
// ==/UserScript==

(() => {
  'use strict';

  console.log('🚀 AI MD Clipboard: Script starting...');

  // Configuration
  const CONFIG = {
    BUTTON_ID: 'ai-md-downloader-btn',
    BUTTON_STYLE: `
      position: fixed !important;
      bottom: 20px !important;
      right: 20px !important;
      width: 60px !important;
      height: 60px !important;
      background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%) !important;
      border: 2px solid white !important;
      border-radius: 50% !important;
      color: white !important;
      font-size: 24px !important;
      cursor: pointer !important;
      z-index: 2147483647 !important;
      display: block !important;
      align-items: center !important;
      justify-content: center !important;
      box-shadow: 0 4px 20px rgba(59, 130, 246, 0.5) !important;
      transition: all 0.2s ease !important;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important;
      opacity: 1 !important;
      transform: scale(1) !important;
      user-select: none !important;
      text-align: center !important;
      line-height: 1 !important;
      padding: 0 !important;
      margin: 0 !important;
    `,
    BUTTON_HOVER_STYLE: `
      transform: scale(1.1) !important;
      box-shadow: 0 6px 30px rgba(59, 130, 246, 0.7) !important;
    `,
    BUTTON_ACTIVE_STYLE: `
      transform: scale(0.95) !important;
    `,
    NOTIFICATION_STYLE: `
      position: fixed !important;
      top: 20px !important;
      right: 20px !important;
      background: white !important;
      color: #333 !important;
      border: 1px solid #ddd !important;
      border-radius: 8px !important;
      padding: 16px 20px !important;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1) !important;
      z-index: 2147483647 !important;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important;
      font-size: 14px !important;
      max-width: 350px !important;
      opacity: 0 !important;
      transform: translateX(100%) !important;
      transition: all 0.3s ease !important;
    `,
    NOTIFICATION_SHOW_STYLE: `
      opacity: 1 !important;
      transform: translateX(0) !important;
    `,
    // Content selectors in order of preference
    CONTENT_SELECTORS: [
      'main',
      'article',
      '[role="main"]',
      '.content',
      '.main-content',
      '.post-content',
      '.entry-content',
      '.article-content',
      '.page-content',
      '#content',
      '#main',
      '.container',
      '.wrapper'
    ],
    // Elements to remove from content
    UNWANTED_SELECTORS: [
      'script',
      'style',
      'noscript',
      'nav',
      'header',
      'footer',
      'aside',
      '.navigation',
      '.menu',
      '.sidebar',
      '.ads',
      '.advertisement',
      '.social-share',
      '.comments',
      '.popup',
      '.modal',
      '.toolbar',
      '.breadcrumb',
      '.pagination',
      'button',
      'input',
      'select',
      'textarea',
      '[role="button"]',
      '[role="navigation"]',
      '[role="menu"]'
    ]
  };

  // Main button element
  let downloadButton = null;
  let isProcessing = false;
  let isInitialized = false;

  // Create and inject styles
  function injectStyles() {
    console.log('🎨 AI MD Clipboard: Injecting styles...');

    // Remove existing styles if any
    const existingStyle = document.getElementById('ai-md-clipboard-styles');
    if (existingStyle) existingStyle.remove();

    const style = document.createElement('style');
    style.id = 'ai-md-clipboard-styles';
    style.textContent = `
      #${CONFIG.BUTTON_ID} { ${CONFIG.BUTTON_STYLE} }
      #${CONFIG.BUTTON_ID}:hover { ${CONFIG.BUTTON_HOVER_STYLE} }
      #${CONFIG.BUTTON_ID}:active { ${CONFIG.BUTTON_ACTIVE_STYLE} }
      #${CONFIG.BUTTON_ID}.processing {
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%) !important;
        animation: spin 1s linear infinite !important;
      }
      #${CONFIG.BUTTON_ID}.success {
        background: linear-gradient(135deg, #10b981 0%, #059669 100%) !important;
      }
      #${CONFIG.BUTTON_ID}.error {
        background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%) !important;
      }
      @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
      }
      .ai-md-notification { ${CONFIG.NOTIFICATION_STYLE} }
      .ai-md-notification.show { ${CONFIG.NOTIFICATION_SHOW_STYLE} }
      .ai-md-notification.success {
        border-left: 4px solid #10b981 !important;
        background: #f0fdf4 !important;
      }
      .ai-md-notification.error {
        border-left: 4px solid #ef4444 !important;
        background: #fef2f2 !important;
      }
      @media (max-width: 768px) {
        #${CONFIG.BUTTON_ID} {
          width: 50px !important;
          height: 50px !important;
          font-size: 20px !important;
        }
        .ai-md-notification {
          right: 10px !important;
          left: 10px !important;
          max-width: none !important;
        }
      }
    `;

    // Add to head or body as fallback
    if (document.head) {
      document.head.appendChild(style);
    } else if (document.body) {
      document.body.appendChild(style);
    } else {
      console.warn('⚠️ AI MD Clipboard: No head or body element found');
    }

    console.log('✅ AI MD Clipboard: Styles injected');
  }

  // Show notification
  function showNotification(message, type = 'success', duration = 3000) {
    // Remove existing notification
    const existing = document.querySelector('.ai-md-notification');
    if (existing) existing.remove();

    const notification = document.createElement('div');
    notification.className = `ai-md-notification ${type}`;
    notification.innerHTML = `
      <div style="display: flex; align-items: center; gap: 8px;">
        <span style="font-size: 16px;">${type === 'success' ? '✅' : '❌'}</span>
        <span>${message}</span>
      </div>
    `;

    document.body.appendChild(notification);

    // Animate in
    requestAnimationFrame(() => {
      notification.classList.add('show');
    });

    // Remove after duration
    setTimeout(() => {
      notification.classList.remove('show');
      setTimeout(() => notification.remove(), 300);
    }, duration);
  }

  // Find the best content element
  function findBestContent() {
    for (const selector of CONFIG.CONTENT_SELECTORS) {
      const element = document.querySelector(selector);
      if (element && element.textContent.trim().length > 200) {
        return element;
      }
    }

    // Fallback to body
    return document.body;
  }

  // Clean content by removing unwanted elements
  function cleanContent(element) {
    const clone = element.cloneNode(true);

    // Remove unwanted elements
    CONFIG.UNWANTED_SELECTORS.forEach((selector) => {
      try {
        clone.querySelectorAll(selector).forEach((el) => el.remove());
      } catch (e) {
        console.warn(`Failed to remove selector: ${selector}`, e);
      }
    });

    // Remove our own button
    const ourButton = clone.querySelector(`#${CONFIG.BUTTON_ID}`);
    if (ourButton) ourButton.remove();

    // Remove any remaining notifications
    const notifications = clone.querySelectorAll('.ai-md-notification');
    notifications.forEach((el) => el.remove());

    return clone;
  }

  // Convert HTML to Markdown
  function htmlToMarkdown(html) {
    let markdown = html;

    // Basic HTML to Markdown conversion
    markdown = markdown.replace(/<h1[^>]*>(.*?)<\/h1>/gi, '# $1\n\n');
    markdown = markdown.replace(/<h2[^>]*>(.*?)<\/h2>/gi, '## $1\n\n');
    markdown = markdown.replace(/<h3[^>]*>(.*?)<\/h3>/gi, '### $1\n\n');
    markdown = markdown.replace(/<h4[^>]*>(.*?)<\/h4>/gi, '#### $1\n\n');
    markdown = markdown.replace(/<h5[^>]*>(.*?)<\/h5>/gi, '##### $1\n\n');
    markdown = markdown.replace(/<h6[^>]*>(.*?)<\/h6>/gi, '###### $1\n\n');

    // Bold and italic
    markdown = markdown.replace(/<strong[^>]*>(.*?)<\/strong>/gi, '**$1**');
    markdown = markdown.replace(/<b[^>]*>(.*?)<\/b>/gi, '**$1**');
    markdown = markdown.replace(/<em[^>]*>(.*?)<\/em>/gi, '*$1*');
    markdown = markdown.replace(/<i[^>]*>(.*?)<\/i>/gi, '*$1*');

    // Links
    markdown = markdown.replace(
      /<a[^>]*href="([^"]*)"[^>]*>(.*?)<\/a>/gi,
      '[$2]($1)'
    );

    // Code blocks
    markdown = markdown.replace(
      /<pre[^>]*><code[^>]*>(.*?)<\/code><\/pre>/gis,
      '```\n$1\n```\n\n'
    );
    markdown = markdown.replace(/<code[^>]*>(.*?)<\/code>/gi, '`$1`');

    // Lists
    markdown = markdown.replace(/<ul[^>]*>/gi, '');
    markdown = markdown.replace(/<\/ul>/gi, '\n');
    markdown = markdown.replace(/<ol[^>]*>/gi, '');
    markdown = markdown.replace(/<\/ol>/gi, '\n');
    markdown = markdown.replace(/<li[^>]*>(.*?)<\/li>/gi, '- $1\n');

    // Paragraphs and line breaks
    markdown = markdown.replace(/<p[^>]*>(.*?)<\/p>/gi, '$1\n\n');
    markdown = markdown.replace(/<br[^>]*>/gi, '\n');
    markdown = markdown.replace(/<div[^>]*>/gi, '\n');
    markdown = markdown.replace(/<\/div>/gi, '\n');

    // Blockquotes
    markdown = markdown.replace(
      /<blockquote[^>]*>(.*?)<\/blockquote>/gis,
      '> $1\n\n'
    );

    // Tables (basic conversion)
    markdown = markdown.replace(/<table[^>]*>/gi, '\n');
    markdown = markdown.replace(/<\/table>/gi, '\n');
    markdown = markdown.replace(/<tr[^>]*>/gi, '');
    markdown = markdown.replace(/<\/tr>/gi, '\n');
    markdown = markdown.replace(/<th[^>]*>(.*?)<\/th>/gi, '| $1 ');
    markdown = markdown.replace(/<td[^>]*>(.*?)<\/td>/gi, '| $1 ');

    // Clean up extra whitespace
    markdown = markdown.replace(/\n{3,}/g, '\n\n');
    markdown = markdown.replace(/ +/g, ' ');

    // Remove remaining HTML tags
    markdown = markdown.replace(/<[^>]*>/g, '');

    // Decode HTML entities
    markdown = markdown.replace(/&nbsp;/g, ' ');
    markdown = markdown.replace(/&amp;/g, '&');
    markdown = markdown.replace(/&lt;/g, '<');
    markdown = markdown.replace(/&gt;/g, '>');
    markdown = markdown.replace(/&quot;/g, '"');
    markdown = markdown.replace(/&#39;/g, "'");

    return markdown.trim();
  }

  // Copy text to clipboard
  async function copyToClipboard(text) {
    try {
      if (navigator.clipboard && window.isSecureContext) {
        await navigator.clipboard.writeText(text);
      } else {
        // Fallback method
        const textarea = document.createElement('textarea');
        textarea.value = text;
        textarea.style.position = 'fixed';
        textarea.style.opacity = '0';
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);
      }
      return true;
    } catch (error) {
      console.error('Failed to copy to clipboard:', error);
      return false;
    }
  }

  // Main copy function
  async function copyContentAsMarkdown() {
    if (isProcessing) return;

    isProcessing = true;
    downloadButton.classList.add('processing');
    downloadButton.innerHTML = '⏳';

    try {
      showNotification('🔄 Processing content...', 'success', 1000);

      // Find and clean content
      const contentElement = findBestContent();
      const cleanElement = cleanContent(contentElement);

      // Convert to markdown
      let markdown = htmlToMarkdown(cleanElement.innerHTML);

      // Add metadata header
      const metadata = `---
# ${document.title || 'Untitled Content'}
**Source:** ${window.location.href}
**Extracted:** ${new Date().toLocaleString()}
**Word Count:** ~${markdown.split(/\s+/).length} words

---

`;

      markdown = metadata + markdown;

      // Copy to clipboard
      const success = await copyToClipboard(markdown);

      if (success) {
        downloadButton.classList.remove('processing');
        downloadButton.classList.add('success');
        downloadButton.innerHTML = '✅';
        showNotification(
          '✅ Content copied as Markdown! Ready to paste into AI chat.',
          'success',
          3000
        );

        setTimeout(() => {
          downloadButton.classList.remove('success');
          downloadButton.innerHTML = '📋';
        }, 3000);
      } else {
        throw new Error('Clipboard copy failed');
      }
    } catch (error) {
      console.error('Error processing content:', error);
      downloadButton.classList.remove('processing');
      downloadButton.classList.add('error');
      downloadButton.innerHTML = '❌';
      showNotification(
        '❌ Failed to copy content. Please try again.',
        'error',
        3000
      );

      setTimeout(() => {
        downloadButton.classList.remove('error');
        downloadButton.innerHTML = '📋';
      }, 3000);
    } finally {
      isProcessing = false;
    }
  }

  // Create the download button
  function createButton() {
    console.log('🔘 AI MD Clipboard: Creating button...');

    // Remove existing button if any
    const existing = document.getElementById(CONFIG.BUTTON_ID);
    if (existing) {
      console.log('🗑️ AI MD Clipboard: Removing existing button');
      existing.remove();
    }

    downloadButton = document.createElement('button');
    downloadButton.id = CONFIG.BUTTON_ID;
    downloadButton.innerHTML = '📋';
    downloadButton.title = 'Copy content as AI-ready Markdown';
    downloadButton.setAttribute(
      'aria-label',
      'Copy content as AI-ready Markdown'
    );
    downloadButton.textContent = '📋'; // Ensure text content is set

    // Add event listeners
    downloadButton.addEventListener('click', (e) => {
      console.log('🖱️ AI MD Clipboard: Button clicked');
      e.preventDefault();
      e.stopPropagation();
      copyContentAsMarkdown();
    });

    downloadButton.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') {
        console.log('⌨️ AI MD Clipboard: Button activated via keyboard');
        e.preventDefault();
        e.stopPropagation();
        copyContentAsMarkdown();
      }
    });

    // Try to append to body, fallback to documentElement
    if (document.body) {
      document.body.appendChild(downloadButton);
      console.log('✅ AI MD Clipboard: Button appended to body');
    } else if (document.documentElement) {
      document.documentElement.appendChild(downloadButton);
      console.log('✅ AI MD Clipboard: Button appended to documentElement');
    } else {
      console.error('❌ AI MD Clipboard: Cannot find place to add button');
      return false;
    }

    // Verify button was added
    const addedButton = document.getElementById(CONFIG.BUTTON_ID);
    if (addedButton) {
      console.log(
        '✅ AI MD Clipboard: Button successfully created and added to DOM'
      );

      // Force visibility
      addedButton.style.display = 'block';
      addedButton.style.visibility = 'visible';
      addedButton.style.opacity = '1';

      // Test click in console
      console.log('🔍 AI MD Clipboard: Button element:', addedButton);
      console.log(
        '🔍 AI MD Clipboard: Button visible?',
        addedButton.offsetParent !== null,
        'Window width:',
        window.innerWidth,
        'Button styles:',
        addedButton.style.cssText
      );

      return true;
    } else {
      console.error('❌ AI MD Clipboard: Failed to add button to DOM');
      return false;
    }
  }

  // Initialize the userscript
  function initialize() {
    if (isInitialized) {
      console.log('🔄 AI MD Clipboard: Already initialized, skipping...');
      return;
    }

    console.log('🚀 AI MD Clipboard: Starting initialization...');
    console.log('📄 AI MD Clipboard: Page title:', document.title);
    console.log('🌐 AI MD Clipboard: Page URL:', window.location.href);
    console.log(
      '📏 AI MD Clipboard: Document ready state:',
      document.readyState
    );

    // Wait for body to be available
    if (!document.body) {
      console.log('⏳ AI MD Clipboard: Waiting for body...');
      setTimeout(initialize, 100);
      return;
    }

    try {
      injectStyles();
      const buttonCreated = createButton();

      if (buttonCreated) {
        isInitialized = true;
        console.log('✅ AI MD Clipboard: Initialization complete!');

        // Show welcome notification
        setTimeout(() => {
          showNotification(
            '📋 AI Markdown Ready! Click the clipboard button to copy content.',
            'success',
            4000
          );
        }, 1000);

        // Setup monitoring for button removal
        setupButtonMonitor();
      } else {
        console.error(
          '❌ AI MD Clipboard: Failed to create button, retrying...'
        );
        setTimeout(initialize, 2000);
      }
    } catch (error) {
      console.error('❌ AI MD Clipboard: Initialization error:', error);
      setTimeout(initialize, 2000);
    }
  }

  // Setup monitoring for button removal
  function setupButtonMonitor() {
    console.log('👁️ AI MD Clipboard: Setting up button monitor...');

    const observer = new MutationObserver((mutations) => {
      let buttonRemoved = false;

      mutations.forEach((mutation) => {
        if (mutation.type === 'childList') {
          // Check if our button was removed
          if (!document.getElementById(CONFIG.BUTTON_ID)) {
            buttonRemoved = true;
          }
        }
      });

      if (buttonRemoved) {
        console.log('🔄 AI MD Clipboard: Button was removed, re-creating...');
        isInitialized = false;
        setTimeout(initialize, 1000);
      }
    });

    // Monitor the body for changes
    if (document.body) {
      observer.observe(document.body, {
        childList: true,
        subtree: true
      });
      console.log('✅ AI MD Clipboard: Button monitor active');
    }
  }

  // Wait for page to be ready
  function startInitialization() {
    console.log('⏰ AI MD Clipboard: Starting initialization process...');

    if (document.readyState === 'loading') {
      console.log(
        '📄 AI MD Clipboard: Document still loading, waiting for DOMContentLoaded...'
      );
      document.addEventListener('DOMContentLoaded', initialize);
    } else {
      console.log('📄 AI MD Clipboard: Document ready, initializing now...');
      // Small delay to ensure page is stable
      setTimeout(initialize, 100);
    }
  }

  // Start the initialization
  startInitialization();

  // Also try to initialize after a delay as a fallback
  setTimeout(() => {
    if (!isInitialized) {
      console.log('⏰ AI MD Clipboard: Fallback initialization...');
      initialize();
    }
  }, 3000);

  console.log(
    '🏁 AI MD Clipboard: Script loaded, initialization process started'
  );
})();

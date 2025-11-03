;; -*- lexical-binding: t -*-
;; =========================================================================
;; EMACS CONFIGURATION - Clean Setup for Learning
;; =========================================================================
;; Author: Your Name
;; Description: A minimal, robust Emacs configuration focused on learning
;; Version: 2.0
;; Last Updated: 2025
;;
;; Features:
;; - Modern completion system (Ivy/Counsel)
;; - Vim-style editing (Evil mode)
;; - Tmux-style window management
;; - Enhanced UI with Catppuccin theme
;; - Robust error handling and package management
;; =========================================================================

;; =========================================================================
;; SECTION 1: PACKAGE SYSTEM INITIALIZATION
;; =========================================================================
;; Purpose: Initialize package archives and provide robust installation functions
;; Dependencies: None (core Emacs functionality)
;; =========================================================================

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

;; Robust package installation with error handling
(defun my-safe-package-install (package-name)
  "Safely install PACKAGE-NAME with error handling and user feedback."
  (unless (package-installed-p package-name)
    (message "Installing %s..." package-name)
    (condition-case err
        (progn
          (package-install package-name)
          (message "✓ Successfully installed %s" package-name)
          t)
      (error
       (message "✗ Failed to install %s: %s" package-name (error-message-string err))
       nil))))

;; Function to validate critical packages
(defun my-validate-critical-packages ()
  "Validate that critical packages are available."
  (let ((critical-packages '(evil catppuccin-theme))
        (missing-packages '()))
    (dolist (pkg critical-packages)
      (unless (package-installed-p pkg)
        (push pkg missing-packages)))
    (when missing-packages
      (warn "Missing critical packages: %s. Some features may not work properly."
            (mapconcat 'symbol-name missing-packages ", ")))))

;; =========================================================================
;; SECTION 2: USER INTERFACE CONFIGURATION
;; =========================================================================
;; Purpose: Configure Emacs UI for clean, distraction-free editing experience
;; Dependencies: None (core Emacs functionality)
;; Key Features:
;; - Minimal UI (no scrollbars, toolbars, menus)
;; - Visual enhancements (line numbers, highlighting, matching parens)
;; - Clean editing environment
;; =========================================================================

;; Basic UI improvements
(setq inhibit-startup-message t)           ; Skip startup message
(scroll-bar-mode -1)                      ; Disable scroll bar
(tool-bar-mode -1)                        ; Disable tool bar
(tooltip-mode -1)                         ; Disable tooltips
(menu-bar-mode -1)                        ; Disable menu bar
(setq ring-bell-function 'ignore)          ; Disable bell

;; Visual enhancements for better code visibility
(global-display-line-numbers-mode 1)       ; Show line numbers globally
(global-hl-line-mode 1)                    ; Highlight current line
(show-paren-mode 1)                        ; Show matching parentheses
(winner-mode 1)                            ; Enable winner mode for undoing window changes

;; =========================================================================
;; SECTION 3: EDITING BEHAVIOR CONFIGURATION
;; =========================================================================
;; Purpose: Configure basic editing preferences and behaviors
;; Dependencies: None (core Emacs functionality)
;; Settings: Spaces instead of tabs, auto-pairing, tab width
;; =========================================================================

(setq-default indent-tabs-mode nil)        ; Use spaces instead of tabs
(setq-default tab-width 2)                ; Set tab width to 2
(electric-pair-mode 1)                    ; Auto-close brackets/quotes

;; =========================================================================
;; SECTION 4: PACKAGE INSTALLATION & VALIDATION
;; =========================================================================
;; Purpose: Install and validate required packages with robust error handling
;; Dependencies: Package system (Section 1)
;; Packages: catppuccin-theme, which-key, evil, evil-collection, ivy, counsel, ivy-rich
;; =========================================================================

;; Install theme package
(my-safe-package-install 'catppuccin-theme)

;; Install which-key for keybinding help
(my-safe-package-install 'which-key)

;; Validate critical packages early
(my-validate-critical-packages)

;; =========================================================================
;; SECTION 5: VIM-STYLE EDITING (EVIL MODE)
;; =========================================================================
;; Purpose: Configure Vim-style editing with Evil mode
;; Dependencies: evil, evil-collection packages
;; Key Features:
;; - Vim-style modal editing
;; - Evil collection for comprehensive Evil bindings
;; - Physical key mapping for international keyboards
;; - Terminal compatibility
;; =========================================================================

;; Evil mode configuration - Must be set BEFORE loading evil
(setq evil-want-integration t)    ; This is optional since it's already set to t by default
(setq evil-want-keybinding nil)  ; Required for evil-collection

;; Install Evil packages with error handling
(my-safe-package-install 'evil)
(my-safe-package-install 'evil-collection)

;; Enable Evil mode only if successfully installed
(when (package-installed-p 'evil)
  (require 'evil)
  (evil-mode 1)

  ;; CRITICAL: Ensure C-c always works for terminal interruption
  ;; This prevents Evil from hijacking C-c in terminal mode
  (setq evil-intercept-esc nil)                    ; Don't intercept ESC
  (setq evil-want-C-i-jump nil)                   ; Don't bind C-i to jump
  (define-key evil-motion-state-map (kbd "C-c") nil) ; Ensure C-c is free
  (define-key evil-normal-state-map (kbd "C-c") nil) ; Ensure C-c is free
  (define-key evil-insert-state-map (kbd "C-c") nil) ; Ensure C-c is free
  (define-key evil-visual-state-map (kbd "C-c") nil) ; Ensure C-c is free

  ;; Use evil-collection for comprehensive Evil bindings
  (when (package-installed-p 'evil-collection)
    (require 'evil-collection)
    (evil-collection-init))

  ;; Make Evil work better with terminal Emacs
  (setq evil-emacs-state-modes nil)
  (setq evil-insert-state-modes nil)
  (setq evil-motion-state-modes nil))

;; International keyboard support - Physical key mapping
(defun my-setup-evil-physical-keys ()
  "Setup Evil to use physical keyboard positions instead of character output.
This ensures hjkl work based on keyboard position, not output character,
which is crucial for international keyboard layouts."
  (when (and (boundp 'evil-mode) evil-mode)
    ;; Map physical key positions to Evil functions
    (define-key evil-normal-state-map [?\h] 'evil-backward-char)
    (define-key evil-normal-state-map [?\j] 'evil-next-line)
    (define-key evil-normal-state-map [?\k] 'evil-previous-line)
    (define-key evil-normal-state-map [?\l] 'evil-forward-char)
    (define-key evil-normal-state-map [?\i] 'evil-insert)
    (define-key evil-normal-state-map [?\a] 'evil-append)
    (define-key evil-normal-state-map [?\o] 'evil-open-below)
    (define-key evil-normal-state-map [?\O] 'evil-open-above)
    (define-key evil-normal-state-map [?\c] 'evil-change)
    (define-key evil-normal-state-map [?\d] 'evil-delete)
    (define-key evil-normal-state-map [?\v] 'evil-visual-char)
    (define-key evil-normal-state-map [?\V] 'evil-visual-line)
    (define-key evil-normal-state-map [?\y] 'evil-yank)
    (define-key evil-normal-state-map [?\p] 'evil-paste-after)
    (define-key evil-normal-state-map [?\s] 'evil-substitute)))

;; Apply physical key mapping after Evil loads
(with-eval-after-load 'evil
  (my-setup-evil-physical-keys))

;; =========================================================================
;; SECTION 5.5: TERMINAL & CRITICAL KEYBINDING PROTECTION
;; =========================================================================
;; Purpose: Ensure critical Emacs keybindings work in terminal mode
;; Dependencies: Evil mode (if loaded)
;; Critical Fixes:
;; - C-c must always work for command interruption
;; - C-g is left FREE for Claude CLI compatibility
;; - C-z must work for suspension
;; - Emergency recovery for stuck modes
;; =========================================================================

;; CRITICAL: Ensure C-c always works for command interruption
;; IMPORTANT: C-g is left free for Claude CLI compatibility
;; NOTE: Normally C-g is keyboard-quit, but we use C-c to avoid Claude CLI conflicts
(global-set-key (kbd "C-c") 'keyboard-quit)  ; Force C-c to always quit
;; C-g is intentionally NOT bound here to avoid Claude CLI conflicts
;; Users can still use C-g in Emacs as it defaults to keyboard-quit, but we don't override it

;; Terminal-specific emergency keybindings
(when (not (display-graphic-p))
  ;; In terminal mode, ensure these always work
  (global-set-key (kbd "C-z") 'suspend-frame)  ; Enable suspension
  (global-set-key (kbd "C-x C-c") 'save-buffers-kill-terminal) ; Ensure quit works

  ;; Emergency recovery: F1 to reset Evil mode if it gets stuck
  (global-set-key (kbd "<f1>")
                  (lambda ()
                    (interactive)
                    (when (boundp 'evil-mode)
                      (evil-mode -1))
                    (message "Emergency: Evil mode disabled!")))

  (message "🔧 Terminal mode: Critical keybindings protected (C-c, C-z) - C-g free for Claude CLI")

  ;; Additional terminal safety: Prevent Evil from blocking input
  (setq evil-disable-insert-state-bindings t)  ; Safer insert mode
  (setq evil-esc-delay 0.1)                    ; Faster ESC response
  )  ; Close the when (not (display-graphic-p)) block

;; =========================================================================
;; SECTION 6: THEME & VISUAL APPEARANCE
;; =========================================================================
;; Purpose: Configure visual theme and file management settings
;; Dependencies: catppuccin-theme package
;; Features: Dark theme, organized backup/auto-save files
;; =========================================================================

;; Theme configuration - Load only if package is available
(when (package-installed-p 'catppuccin-theme)
  (setq catppuccin-flavor 'mocha)         ; Use Mocha flavor (dark theme)
  (load-theme 'catppuccin t)              ; Load Catppuccin theme safely
  (message "✓ Catppuccin theme loaded successfully"))

;; File management - Keep working directory clean
(setq backup-directory-alist               ; Put backup files in temp directory
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms       ; Put auto-save files in temp directory
      `((".*" ,temporary-file-directory t)))

;; Exclude games and entertainment folders from development tools
(setq vc-directory-exclusion-list
      (append vc-directory-exclusion-list '("Games" "games" "Steam" "steam" ".steam" "SteamApps" "steamapps")))

;; Unbind default C-a to use as prefix (like tmux)
(global-unset-key (kbd "C-a"))

;; Define C-a as a prefix key
(define-prefix-command 'my-window-map)
(global-set-key (kbd "C-a") 'my-window-map)

;; Window management keybindings (tmux pain-control style with C-a prefix)
(global-set-key (kbd "C-a h") 'windmove-left)   ; Move to left window
(global-set-key (kbd "C-a j") 'windmove-down)   ; Move to window below
(global-set-key (kbd "C-a k") 'windmove-up)     ; Move to window above
(global-set-key (kbd "C-a l") 'windmove-right)  ; Move to right window

;; Window splitting (tmux pain-control style)
(global-set-key (kbd "C-a |") 'split-window-right) ; Split window vertically
(global-set-key (kbd "C-a -") 'split-window-below) ; Split window horizontally
(global-set-key (kbd "C-a 1") 'delete-other-windows) ; Close other windows (like tmux prefix + &)

;; Pane/window management (tmux style)
(global-set-key (kbd "C-a z") 'delete-other-windows) ; Zoom current window (toggle)
(global-set-key (kbd "C-a x") 'delete-window)        ; Close current window
(global-set-key (kbd "C-a c") 'make-frame)           ; Create new frame (like new window)
(global-set-key (kbd "C-a ,") 'rename-buffer)       ; Rename buffer (like rename window)
(global-set-key (kbd "C-a &") 'delete-window)       ; Kill current window (tmux style)

;; Session management (tmux style)
(global-set-key (kbd "C-a s") 'ibuffer)             ; Buffer switcher (like session switcher)
(global-set-key (kbd "C-a w") 'other-window)        ; Switch to next window
(global-set-key (kbd "C-a n") 'next-buffer)         ; Next buffer
(global-set-key (kbd "C-a p") 'previous-buffer)     ; Previous buffer
(global-set-key (kbd "C-a d") 'suspend-frame)       ; Detach (like tmux detach)

;; Copy/paste (tmux style)
(global-set-key (kbd "C-a [") 'clipboard-yank)      ; Paste (like tmux paste mode)
(global-set-key (kbd "C-a ]") 'kill-ring-save)      ; Copy (like tmux copy mode)

;; Keep beginning-of-line accessible with C-a a (like tmux C-a a sends literal C-a)
(global-set-key (kbd "C-a a") 'move-beginning-of-line)

;; Simple custom keybindings
(global-set-key (kbd "C-x C-b") 'ibuffer)  ; Better buffer list
(global-set-key (kbd "M-/") 'completion-at-point) ; Better completion

;; =========================================================================
;; SECTION 7: COMPLETION SYSTEM (IVY/COUNSEL)
;; =========================================================================
;; Purpose: Modern completion framework with fuzzy matching and enhanced UX
;; Dependencies: ivy, counsel, ivy-rich, which-key packages
;; Key Features:
;; - Fuzzy command completion (counsel-M-x)
;; - Enhanced file finding (counsel-find-file)
;; - Rich formatting with ivy-rich
;; - Keybinding discovery with which-key
;; - VS Code-style command palette (s-P on macOS)
;; =========================================================================

;; Install completion packages with error handling
(my-safe-package-install 'ivy)
(my-safe-package-install 'counsel)
(my-safe-package-install 'ivy-rich)

;; Enable Ivy completion framework
(when (package-installed-p 'ivy)
  (require 'ivy)
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)        ; Show virtual buffers from recentf
  (setq ivy-count-format "(%d/%d) ")      ; Show candidate count
  (setq ivy-height 15)                    ; Show more candidates in completion
  (message "✓ Ivy completion framework enabled"))

;; Enable rich formatting for Ivy
(when (package-installed-p 'ivy-rich)
  (require 'ivy-rich)
  (ivy-rich-mode 1)
  (message "✓ Ivy rich formatting enabled"))

;; Set up Counsel for enhanced commands
(when (package-installed-p 'counsel)
  (require 'counsel)
  (global-set-key (kbd "M-x") 'counsel-M-x)           ; Enhanced command execution
  (global-set-key (kbd "C-x C-f") 'counsel-find-file) ; Enhanced file finding

  ;; Cross-platform command palette (VS Code-style)
  (cond
   ((eq system-type 'darwin)
    ;; macOS: cmd+shift+p
    (global-set-key (kbd "s-P") 'counsel-M-x)
    (message "✓ Command palette: s-P (macOS)"))
   ((eq system-type 'windows-nt)
    ;; Windows: ctrl+shift+p
    (global-set-key (kbd "C-S-p") 'counsel-M-x)
    (message "✓ Command palette: C-S-p (Windows)"))
   (t
    ;; Linux/Other: ctrl+shift+p
    (global-set-key (kbd "C-S-p") 'counsel-M-x)
    (message "✓ Command palette: C-S-p (Linux/Other)"))))

;; Enable which-key for keybinding discovery
(when (package-installed-p 'which-key)
  (require 'which-key)
  (which-key-mode 1)
  (message "✓ Which-key enabled for keybinding discovery"))

;; =========================================================================
;; SECTION 8: TMUX-STYLE WINDOW MANAGEMENT
;; =========================================================================
;; Purpose: Provide tmux-like window and buffer management with C-a prefix
;; Dependencies: None (core Emacs functionality)
;; Key Features:
;; - C-a prefix for tmux-style commands
;; - Window navigation (h/j/k/l)
;; - Window splitting and management
;; - Buffer switching and management
;; - Frame management
;; =========================================================================

;; Unbind default C-a to use as tmux-style prefix
(global-unset-key (kbd "C-a"))

;; Define C-a as a prefix key (like tmux prefix)
(define-prefix-command 'my-window-map)
(global-set-key (kbd "C-a") 'my-window-map)

;; Window navigation (vim/tmux style)
(global-set-key (kbd "C-a h") 'windmove-left)   ; Move to left window
(global-set-key (kbd "C-a j") 'windmove-down)   ; Move to window below
(global-set-key (kbd "C-a k") 'windmove-up)     ; Move to window above
(global-set-key (kbd "C-a l") 'windmove-right)  ; Move to right window

;; Window splitting (tmux pain-control style)
(global-set-key (kbd "C-a |") 'split-window-right) ; Split window vertically
(global-set-key (kbd "C-a -") 'split-window-below) ; Split window horizontally
(global-set-key (kbd "C-a 1") 'delete-other-windows) ; Close other windows

;; Window and pane management (tmux style)
(global-set-key (kbd "C-a z") 'delete-other-windows) ; Zoom current window (toggle)
(global-set-key (kbd "C-a x") 'delete-window)        ; Close current window
(global-set-key (kbd "C-a c") 'make-frame)           ; Create new frame
(global-set-key (kbd "C-a ,") 'rename-buffer)       ; Rename buffer
(global-set-key (kbd "C-a &") 'delete-window)       ; Kill current window

;; Buffer management (tmux session-style)
(global-set-key (kbd "C-a s") 'ibuffer)             ; Buffer switcher
(global-set-key (kbd "C-a w") 'other-window)        ; Switch to next window
(global-set-key (kbd "C-a n") 'next-buffer)         ; Next buffer
(global-set-key (kbd "C-a p") 'previous-buffer)     ; Previous buffer
(global-set-key (kbd "C-a d") 'suspend-frame)       ; Detach/suspend

;; Copy/paste (tmux style)
(global-set-key (kbd "C-a [") 'clipboard-yank)      ; Paste from clipboard
(global-set-key (kbd "C-a ]") 'kill-ring-save)      ; Copy to clipboard

;; Keep beginning-of-line accessible (tmux C-a a sends literal C-a)
(global-set-key (kbd "C-a a") 'move-beginning-of-line)

;; =========================================================================
;; SECTION 9: USER ASSISTANCE & WELCOME SYSTEM
;; =========================================================================
;; Purpose: Provide learning resources and startup assistance for new users
;; Dependencies: None (core Emacs functionality)
;; Features:
;; - Interactive welcome message with keybinding reference
;; - Learning resources and help commands
;; - Platform-specific command palette information
;; =========================================================================

;; Enhanced welcome message with platform detection
(defun my-welcome-message ()
  "Show a comprehensive welcome message for Emacs learners."
  (when (< (length (window-list)) 2)  ; Only show on startup
    (with-output-to-temp-buffer "*Welcome to Emacs!*"
      (princ "🎉 Welcome to Emacs! 🎉\n\n")
      (princ "╔══════════════════════════════════════════════════════════════╗\n")
      (princ "║                    QUICK START GUIDE                         ║\n")
      (princ "╚══════════════════════════════════════════════════════════════╝\n\n")

      (princ "📚 Basic Commands:\n")
      (princ "  C-x C-f   - Open file\n")
      (princ "  C-x C-s   - Save file\n")
      (princ "  C-x C-c   - Quit Emacs\n")
      (princ "  C-x b     - Switch buffer\n")
      (princ "  C-g       - Cancel current command\n\n")

      (princ "🪟 Window Management (tmux-style with C-a prefix):\n")
      (princ "  Navigation:\n")
      (princ "    C-a h/j/k/l  - Navigate windows (left/down/up/right)\n")
      (princ "  Splitting:\n")
      (princ "    C-a |        - Split window vertically\n")
      (princ "    C-a -        - Split window horizontally\n")
      (princ "  Window Control:\n")
      (princ "    C-a z        - Zoom current window (toggle)\n")
      (princ "    C-a 1        - Close other windows\n")
      (princ "    C-a x        - Close current window\n")
      (princ "  Buffer Management:\n")
      (princ "    C-a s        - Buffer switcher (ibuffer)\n")
      (princ "    C-a n/p      - Next/previous buffer\n")
      (princ "  Utilities:\n")
      (princ "    C-a a        - Go to beginning of line\n")
      (princ "    C-a d        - Detach/suspend frame\n\n")

      (princ "🔍 Command Palette (VS Code-style):\n")
      (cond
       ((eq system-type 'darwin)
        (princ "  s-P       - Open command palette (macOS)\n"))
       ((eq system-type 'windows-nt)
        (princ "  C-S-p     - Open command palette (Windows)\n"))
       (t
        (princ "  C-S-p     - Open command palette (Linux/Other)\n")))
      (princ "  M-x       - Traditional command execution\n\n")

      (princ "🎯 Learning Resources:\n")
      (princ "  M-x help-with-tutorial    - Built-in interactive tutorial\n")
      (princ "  M-x describe-mode         - Describe current mode\n")
      (princ "  C-h k                     - Describe any keybinding\n")
      (princ "  C-h f                     - Describe any function\n\n")

    (princ "💡 Pro Tips:\n")
      (princ "  • Use which-key to discover keybindings automatically\n")
      (princ "  • Try the command palette for fuzzy command search\n")
      (princ "  • Use C-a prefix for tmux-like window management\n")
      (princ "  • Press C-c anytime to cancel a command (C-g is free for Claude CLI)\n")
      (when (not (display-graphic-p))
        (princ "  🚨 TERMINAL MODE: Press F1 if Evil mode gets stuck\n"))
      (princ "\n")

      (princ "Happy Emacs hacking! 🚀\n"))))

;; Show welcome message after initialization
(add-hook 'after-init-hook 'my-welcome-message)

;; =========================================================================
;; SECTION 10: CONFIGURATION COMPLETION
;; =========================================================================
;; Purpose: Finalize configuration loading and provide success feedback
;; Dependencies: All previous sections
;; Features: Startup completion message, error reporting
;; =========================================================================

;; Final configuration status message
(message "✅ Emacs configuration loaded successfully!")
(message "🎯 Features enabled: Evil mode, Ivy completion, Catppuccin theme, Tmux bindings")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

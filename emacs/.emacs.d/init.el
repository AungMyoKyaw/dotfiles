;; -*- lexical-binding: t -*-
;; Emacs Configuration - Clean Setup for Learning
;; This is a minimal configuration to get started with Emacs

;; Initialize package system
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

;; Basic UI improvements
(setq inhibit-startup-message t)           ; Skip startup message
(scroll-bar-mode -1)                      ; Disable scroll bar
(tool-bar-mode -1)                        ; Disable tool bar
(tooltip-mode -1)                         ; Disable tooltips
(menu-bar-mode -1)                        ; Disable menu bar
(setq ring-bell-function 'ignore)          ; Disable bell

;; Show line numbers
(global-display-line-numbers-mode 1)

;; Highlight current line
(global-hl-line-mode 1)

;; Show matching parentheses
(show-paren-mode 1)

;; Enable winner mode for undoing window changes
(winner-mode 1)

;; Basic editing preferences
(setq-default indent-tabs-mode nil)        ; Use spaces instead of tabs
(setq-default tab-width 2)                ; Set tab width to 2
(electric-pair-mode 1)                    ; Auto-close brackets/quotes

;; Install required packages if not already installed
(unless (package-installed-p 'catppuccin-theme)
  (package-install 'catppuccin-theme))

;; Evil mode configuration - Must be set before loading evil
(setq evil-want-integration t)    ;; This is optional since it's already set to t by default
(setq evil-want-keybinding nil)  ;; Required for evil-collection

;; Install Evil packages if not already installed
(unless (package-installed-p 'evil)
  (package-install 'evil))
(unless (package-installed-p 'evil-collection)
  (package-install 'evil-collection))

;; Enable Evil mode
(require 'evil)
(evil-mode 1)

;; Use evil-collection to provide Evil bindings for many Emacs modes
(require 'evil-collection)
(evil-collection-init)

;; Make Evil work better with terminal Emacs
(setq evil-emacs-state-modes nil)
(setq evil-insert-state-modes nil)
(setq evil-motion-state-modes nil)

;; Fix Evil keybindings for international keyboards - use physical key positions
(defun my-setup-evil-physical-keys ()
  "Setup Evil to use physical keyboard positions instead of character output."
  (when (and (boundp 'evil-mode) evil-mode)
    ;; Map the actual physical key positions to Evil functions
    ;; This ensures hjkl work based on keyboard position, not output character
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

;; Apply the fix after Evil is loaded
(with-eval-after-load 'evil
  (my-setup-evil-physical-keys))

;; Theme
(setq catppuccin-flavor 'mocha)          ; Use Mocha flavor (dark)
(load-theme 'catppuccin t)                ; Load Catppuccin theme

;; Backup and auto-save settings
(setq backup-directory-alist               ; Put backup files in temp dir
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms       ; Put auto-save files in temp dir
      `((".*" ,temporary-file-directory t)))

;; Simple custom keybindings
(global-set-key (kbd "C-x C-b") 'ibuffer)  ; Better buffer list
(global-set-key (kbd "M-/") 'completion-at-point) ; Better completion

;; Enable Ivy and Counsel for better completion (will install if not present)
(when (package-installed-p 'ivy)
  (require 'ivy)
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

(when (package-installed-p 'counsel)
  (require 'counsel)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file))

;; Enable which-key to show available keybindings
(when (package-installed-p 'which-key)
  (require 'which-key)
  (which-key-mode 1))

;; Welcome message for learning
(defun my-welcome-message ()
  "Show a welcome message for Emacs learners."
  (when (< (length (window-list)) 2)  ; Only show on startup
    (with-output-to-temp-buffer "*Welcome to Emacs!*"
      (princ "Welcome to Emacs! 🎉\n\n")
      (princ "Basic commands to get started:\n")
      (princ "  C-x C-f   - Open file\n")
      (princ "  C-x C-s   - Save file\n")
      (princ "  C-x C-c   - Quit Emacs\n")
      (princ "  C-x b     - Switch buffer\n")
      (princ "  C-x 1     - Make current window fill screen\n")
      (princ "  C-x 2     - Split window horizontally\n")
      (princ "  C-x 3     - Split window vertically\n")
      (princ "  C-g       - Cancel current command\n\n")
      (princ "Learning resources:\n")
      (princ "  M-x help-with-tutorial    - Built-in tutorial\n")
      (princ "  M-x describe-mode         - Describe current mode\n")
      (princ "  C-h k                     - Describe keybinding\n\n")
      (princ "Happy Emacs hacking!"))))

;; Show welcome message after initialization
(add-hook 'after-init-hook 'my-welcome-message)

(message "Emacs configuration loaded successfully!")
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

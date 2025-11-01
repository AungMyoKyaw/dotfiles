;; -*- lexical-binding: t -*-
;; Early Initialization for Emacs
;; This file runs before package initialization

;; Improve garbage collection on startup
(setq gc-cons-threshold 402653184)    ; 384MB
(setq gc-cons-percentage 0.6)

;; Prevent unwanted package initialization at startup
(setq package-enable-at-startup nil)

;; Disable GUI elements early
(setq frame-inhibit-implied-resize t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Restore GC settings after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 16777216  ; 16MB
                  gc-cons-percentage 0.1)))
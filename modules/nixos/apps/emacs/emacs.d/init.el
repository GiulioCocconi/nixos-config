(defvar is-nix (getenv "NIX_EMACS")
  "If non-nil then consider emacs as configured by Nix Emacs Overlay")

(defvar language-list nil
  "The list of programming languages supported by this config that are manually managed  (if `is-nix' is non-nil then you can, and actually should, manage your programming languages with nix)")

(defun is-language-active (lang) 
  (or (and is-nix (getenv (concat "NIX_LANG_" (upcase lang))))
      (member lang language-list)))

(defun add-multiple-hooks (hooks fun)
  "Add function to multiple hooks"
  (dolist (hook hooks)
    (add-hook hook fun)))

(unless is-nix
  (require 'package)

  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
			   ("org" . "https://orgmode.org/elpa/")
			   ("elpa" . "https://elpa.gnu.org/packages/")))

  (package-initialize)
  (unless package-archive-contents
    (package-refresh-contents))
  (unless (package-installed-p 'use-package)
    (package-install 'use-package)))

(require 'use-package)
(setq use-package-always-ensure t)

(setq recentf-save-file "~/.emacs.d/recentf"
      recentf-filename-handlers '(file-truename)
      recentf-exclude (list "^/tmp/"))
(recentf-mode 1)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq-default inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(setq visible-bell nil)

(setq display-line-numbers-type 'relative)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(global-goto-address-mode)

(setq goto-address-url-face 'ansi-color-italic
      goto-address-url-mouse-face 'ansi-color-underline
      goto-address-mail-face 'ansi-color-italic
      goto-address-mail-mouse-face 'ansi-color-underline)

(use-package hl-todo)

(set-face-attribute 'default nil :font "Iosevka Nerd Font" :height 130)

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)

  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-multiple-hooks '(org-mode-hook text-mode-hook) 'visual-line-mode)

(use-package general
:config ())

(use-package counsel)
(use-package swiper) 
(use-package ivy
  :init (ivy-mode)
  :after counsel
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq search-default-mode #'char-fold-to-regexp)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)
  (global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
  (global-set-key (kbd "<f1> l") 'counsel-find-library)
  (global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history))

(use-package org)

(use-package magit)

(use-package evil
  :config (setq evil-want-keybinding nil)
  :init (evil-mode 1))

(use-package evil-collection
  :after evil
  :init (evil-collection-init))

(use-package company)

(when is-nix
  (use-package nix-mode
    :mode "\\.nix\\'"))

(when (is-language-active "clisp")
  (use-package slime
    :config (setq inferior-lisp-program "sbcl")))

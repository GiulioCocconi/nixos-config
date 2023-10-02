(when is-nix
  (setq user-emacs-directory "~/emacs.d"))

(unless is-nix
  (require 'package)

  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
			   ("org" . "https://orgmode.org/elpa/")
			   ("elpa" . "https://elpa.gnu.org/packages/")))

  (package-initialize)
  (unless package-archive-contents
    (package-refresh-contents)))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

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
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(setq visible-bell nil)

(setq initial-scratch-message (purecopy "\
;; CoGiSystems emacs
;; Remember to have fun :)

"))

(setq display-line-numbers-type 'relative)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq frame-resize-pixelwise t)

(global-goto-address-mode)

(setq goto-address-url-face 'ansi-color-italic
      goto-address-url-mouse-face 'ansi-color-underline
      goto-address-mail-face 'ansi-color-italic
      goto-address-mail-mouse-face 'ansi-color-underline)

(use-package hl-todo
  :hook ((prog-mode org-mode) . hl-todo-mode))

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

(use-package which-key
  :init (which-key-mode))

(advice-add 'eshell-life-is-too-much
	    :after #'(lambda ()
		       (unless (one-window-p)
			 (delete-window))))

(defun split-eshell ()
  "Create a split window below the current one, with an eshell"
  (interactive)
  (select-window (split-window-below))
  (eshell))

(use-package counsel)
(use-package swiper)
(use-package ivy
  :init (ivy-mode)
  :after counsel
  :bind (("C-c C-r" . ivy-resume)
	 ("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("<f1> f" . counsel-describe-function)
	 ("<f1> v" . counsel-describe-variable)
	 ("<f1> o" . counsel-describe-symbol)
	 ("<f1> l" . counsel-find-library)
	 ("<f2> i" . counsel-info-lookup-symbol)
	 ("<f2> u" . counsel-unicode-char)
	 ("C-c g" . counsel-git)
	 ("C-c j" . counsel-git-grep)
	 ("C-c k" . counsel-ag)
	 ("C-x l" . counsel-locate)
	 ("C-S-o" . counsel-rhythmbox))
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq search-default-mode #'char-fold-to-regexp))

(use-package org)

(add-hook 'after-save-hook (lambda ()
			     (when (and (string-equal (buffer-name) "config.org")
					(y-or-n-p "Tangle?"))
			       (org-babel-tangle))))

(use-package magit)

(setq evil-want-keybinding nil)
(use-package evil
  :init (evil-mode 1))

(use-package evil-collection
  :after evil
  :init (evil-collection-init))

(use-package company
  :init (global-company-mode))

(use-package helpful
  )

(when (is-language-active "nix")
  (use-package nix-mode
    :mode "\\.nix\\'"))

(when (is-language-active "clisp")
  (use-package slime
    :config (setq inferior-lisp-program "sbcl")))

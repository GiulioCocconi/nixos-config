(setq is-nix (string-equal (getenv "EMACS_NIX") "TRUE"))

					; --- Init ---

;; Speed up loadtime (from https://git.sr.ht/~knazarov/nixos/tree/master/item/emacs.el )

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(defvar saved--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Restore defaults
(add-hook 'after-init-hook #'(lambda ()
			       (setq gc-cons-threshold 16777216
				     gc-cons-percentage 0.1)
			       (setq file-name-handler-alist saved--file-name-handler-alist)))


					; --- Use-package ---

;; If is not managed by nix then download Melpa and Elpa archives,
;; If using nix then it's managed by emacs-overlay's
;; `emacsWithPackagesFromUsePackage' ( https://github.com/nix-community/emacs-overlay )

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

;; Setup use-package

(require 'use-package)
(setq use-package-always-ensure t)


					; --- State files ---

;; Save history
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode +1)
(setq savehist-save-minibuffer-history +1)

;; Recent files
(setq recentf-save-file "~/.emacs.d/recentf"
      recentf-max-menu-items 0
      recentf-max-saved-items 300
      recentf-filename-handlers '(file-truename)
      recentf-exclude
      (list "^/tmp/" "^/ssh:" "\\.?ido\\.last$" "\\.revive$" "/TAGS$"
	    "^/var/folders/.+$"
	    ))

(recentf-mode 1)

;; Backup files
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/backups" t)))


					; --- Appearence ---

;; Disable gui & bloat
(setq-default inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(setq visible-bell nil)

(global-goto-address-mode) ;; Highlight links

(setq goto-address-url-face 'ansi-color-italic
      goto-address-url-mouse-face 'ansi-color-underline
      goto-address-mail-face 'ansi-color-italic
      goto-address-mail-mouse-face 'ansi-color-underline)

;; Fonts, themes, etc.
(set-face-attribute 'default nil :font "Iosevka Nerd Font" :height 130)
(load-theme 'tango-dark)
(setq display-line-numbers-type 'relative)

(add-hook 'prog-mode-hook 'electric-pair-mode) ;; Autopairs in prog mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)

  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package minions) ;; Minor mode menu



					; --- Keybindings ---
(use-package general
  :config ())


					; --- Misc Packages ---
(when is-nix
  (use-package nix-mode
    :mode "\\.nix\\'"))

(use-package counsel)
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

(use-package magit)
(use-package org)

					; --- Evil ---

(setq evil-want-keybinding nil) ;; https://github.com/emacs-evil/evil-collection/issues/60
(use-package evil
  :init (evil-mode 1))

(use-package evil-collection
  :after evil
  :init (evil-collection-init))




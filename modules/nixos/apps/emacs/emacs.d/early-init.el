(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(defvar saved--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'after-init-hook #'(lambda ()
			       (setq gc-cons-threshold 16777216
				     gc-cons-percentage 0.1)
			       (setq file-name-handler-alist saved--file-name-handler-alist)))

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

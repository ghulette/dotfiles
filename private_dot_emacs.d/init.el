;;; init.el --- Minimal Emacs config: sane defaults, built-in completion, Lean 4  -*- lexical-binding: t; -*-

;;; Packages

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq use-package-always-ensure t)

;; Keep Customize's writes out of this file (and out of chezmoi).
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror)

;;; Defaults

(setq inhibit-startup-screen t
      ring-bell-function #'ignore
      use-short-answers t
      make-backup-files nil
      create-lockfiles nil
      auto-save-file-name-transforms
      `((".*" ,(locate-user-emacs-file "auto-save/") t)))
(make-directory (locate-user-emacs-file "auto-save/") t)

(setq-default indent-tabs-mode nil
              fill-column 80)

;; Absent in terminal-only builds.
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(unless (display-graphic-p) (menu-bar-mode -1))
(column-number-mode 1)
(global-auto-revert-mode 1)
(delete-selection-mode 1)
(electric-pair-mode 1)
(savehist-mode 1)
(recentf-mode 1)
(save-place-mode 1)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; VS Code Dark+, matching Ghostty and nvim.
(use-package vscode-dark-plus-theme
  :config (load-theme 'vscode-dark-plus t))

;; Built-in vertical completion in the minibuffer, and key hints.
(fido-vertical-mode 1)
(which-key-mode 1)

;;; macOS

;; GUI Emacs started from the Dock doesn't see the shell's PATH, so it can't
;; find lake/lean (~/.elan/bin) or Homebrew tools. Import it from zsh.
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config
  (setq exec-path-from-shell-arguments '("-l" "-i")) ; PATH is set in .zshrc
  (exec-path-from-shell-initialize))

;;; Lean 4

;; Installed as a lean4-mode dependency. Use built-in completion
;; (completion-at-point) and flymake rather than company and yasnippet.
(use-package lsp-mode
  :defer t
  :custom
  (lsp-completion-provider :none)
  (lsp-enable-snippet nil)
  (lsp-keymap-prefix "C-c l"))

;; Not on MELPA; installed from git. Pulls in lsp-mode, dash and magit-section.
;; C-c C-i toggles the infoview; type \to, \forall, ... for unicode.
(use-package lean4-mode
  :commands lean4-mode
  :vc (:url "https://github.com/leanprover-community/lean4-mode.git"
       :rev :last-release)
  :config
  ;; The Lean server sends workspace/inlayHint/refresh, which lsp-mode has no
  ;; handler for, so each one logs "Unknown request method". Ack and ignore.
  (puthash "workspace/inlayHint/refresh" #'ignore
           (lsp--client-request-handlers (gethash 'lean4-lsp lsp-clients))))

;;; init.el ends here

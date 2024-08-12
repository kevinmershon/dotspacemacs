;; parinfer-rust-mode config
;;
;; (requires parinfer-rust-mode be added to dotspacemacs-additional-packages)
;;
(use-package parinfer-rust-mode
  :hook emacs-lisp-mode
  ;; we have to build parinfer-rust-mode ourselves
  :init (setq parinfer-rust-auto-download nil))

;; treemacs config
(use-package treemacs
  :ensure t
  :config (progn
            (setq treemacs-toggle-show-dotfiles t
                  treemacs-sorting 'alphabetic-asc))
  :bind   (:map global-map ("<f2>" . treemacs)))

;; c# / Unity
(setenv "FrameworkPathOverride" "/lib/mono/4.5")
(use-package lsp-mode
  :ensure t
  :bind-keymap
  ("C-c l" . lsp-command-map)
  :custom
  (lsp-keymap-prefix "C-c l"))

(use-package csharp-mode
  :ensure t
  :init
  (defun my/csharp-mode-hook ()
    (setq-local lsp-auto-guess-root t)
    (editorconfig-mode 1)
    (lsp))
  (add-hook 'csharp-mode-hook #'my/csharp-mode-hook))

(use-package editorconfig
  :ensure t
  :demand t
  :mode ("\\.?editorconfig$" . editorconfig-conf-mode)
  ;;:config
  ;;(setq editorconfig-exec-path "/usr/local/bin/editorconfig")
  (editorconfig-mode 1))

;; disable global line highlight mode
(global-hl-line-mode 0)

;; only show line numbers in buffers with code
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; comment with double Control-C
(global-set-key (kbd "C-c C-c") 'comment-line)

;; web beautify with leader-j-f
;; Spacemacs default leader is SPC
(evil-leader/set-key "j f" 'web-beautify-js)

;; system clipboard integration with leader-o-y or leader-o-p
;; Spacemacs default leader is SPC
(defun copy-to-clipboard ()
      "Copies selection to x-clipboard."
      (interactive)
      (if (display-graphic-p)
          (progn
            (message "Yanked region to x-clipboard!")
            (call-interactively 'clipboard-kill-ring-save))
        (if (region-active-p)
            (progn
              (shell-command-on-region (region-beginning) (region-end) "pbcopy")
              (message "Yanked region to clipboard!")
              (deactivate-mark))
          (message "No region active; can't yank to clipboard!"))))

(defun paste-from-clipboard ()
  "Pastes from x-clipboard."
  (interactive)
  (if (display-graphic-p)
      (progn
        (clipboard-yank)
        (message "graphics active"))
    (insert (shell-command-to-string "pbpaste"))))
(evil-leader/set-key "o y" 'copy-to-clipboard)
(evil-leader/set-key "o p" 'paste-from-clipboard)

;; Removes all scratch buffers from after the mode has been set.
(setq initial-scratch-message "")
(defun remove-scratch-buffers ()
    (if (get-buffer "*emacs*")
        (kill-buffer "*emacs*"))
    (if (get-buffer "*Flycheck error messages*")
        (kill-buffer "*Flycheck error messages*"))
    (if (get-buffer "*scratch*")
        (kill-buffer "*scratch*")))
(add-hook 'after-change-major-mode-hook 'remove-scratch-buffers)

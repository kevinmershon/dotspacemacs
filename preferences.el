;; parinfer-rust-mode config
;;
;; (requires parinfer-rust-mode be added to dotspacemacs-additional-packages)
;;
(use-package parinfer-rust-mode
  :hook emacs-lisp-mode
  :init (setq parinfer-rust-auto-download t))

;; treemacs config
(use-package treemacs
  :ensure t
  :config (progn
            (setq treemacs-toggle-show-dotfiles t
                  treemacs-sorting 'alphabetic-asc))
  :bind   (:map global-map ("<f2>" . treemacs)))

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

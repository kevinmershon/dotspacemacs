;; Clojure related settings
(add-hook 'clojure-mode-hook
          (lambda ()
            (display-fill-column-indicator-mode)
            (define-clojure-indent
              (instrumenting '(1 (1)))
              (mocking       '(1 (1)))
              (stubbing      '(1 (1)))
              (match         '(1)))))

(setq cider-repl-history-file "~/.cider-history")

;; clojure key bindings
(defun clojure-key-bindings ()
  (parinfer-rust-mode)
  ;; eqp quick-eval in minibuffer
  (define-key evil-normal-state-map (kbd "e q p") 'cider-read-and-eval)
  ;; ens quickly hop to file namespace
  (define-key evil-normal-state-map (kbd "e n s") 'cider-repl-set-ns)
  ;; eV quickly hop to file namespace
  (define-key evil-normal-state-map (kbd "e p") 'cider-pprint-eval-last-sexp))
(add-hook 'clojure-mode-hook 'clojure-key-bindings)

;; auto-format before save, auto reload namespace after save
(add-hook 'cider-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'cider-format-buffer nil 'make-it-local)
            (when (and (stringp buffer-file-name)
                       (string-match "\\.clj\\'" buffer-file-name))
                  (add-hook 'after-save-hook 'cider-load-buffer nil 'make-it-local))))


;;; Code:
(setq doom-font (font-spec :family "Iosevka" :size 16))
(setq doom-big-font (font-spec :family "Iosevka" :size 28))

(setq doom-theme 'doom-nord-light)

(setq epa-pinentry-mode 'loopback)


(pinentry-start)

(setq tab-width 2)

;; Javascript settings
(setq javascript-indent-level 2)
(setq typescript-indent-level 2)
(setq web-mode-code-indent-offset 2)

(setq-hook! 'js2-mode-hook +format-with-lsp nil)
(setq-hook! 'typescript-mode-hook +format-with-lsp nil)
(setq-hook! 'typescript-tsx-mode-hook +format-with-lsp nil)

;; Org
(setq org-directory "~/.org")
(setq org-roam-directory "~/.org")
(setq org-roam-db-location "~/.org/org-roam.db")
(setq org-archive-location "::* HISTORY")
(setq org-agenda-files (directory-files-recursively "~/.org/" "\\.org$"))
(setq org-roam-tag-sources '(prop))

(setq ledger-post-amount-alignment-column 100)
(setq ledger-post-account-alignment-column 2)

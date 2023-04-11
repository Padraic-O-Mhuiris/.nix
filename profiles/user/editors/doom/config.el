;; ;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; (setq user-full-name "Patrick Morris"
;;       user-mail-address "patrick.morris.310@gmail.com")

;; (defun pm/font-size ()
;;   ""
;;   (cond ((string= (system-name) "Hydrogen") 24)
;;         (t 16)))

;; (defun pm/big-font-size ()
;;   ""
;;   (cond ((string= (system-name) "Hydrogen") 32)
;;         (t 24)))

;; (setq doom-font (font-spec :family "Iosevka" :size (pm/font-size) :slant 'normal :weight 'normal))
;; (setq doom-big-font (font-spec :family "Iosevka" :size (pm/big-font-size)))

;; (setq doom-theme 'doom-nord-light)

;; (setq auto-save-default t)

;; (setq tab-width 2)
;; (setq standard-indent 2)

;; (setq-hook! js2-mode-hook js-indent-level 2)
;; (setq-hook! typescript-mode-hook typescript-indent-level 2)

;; (after! typescript-mode
;;   (setq typescript-indent-level 2))

;; (setq org-directory "~/.org")
;; (setq org-roam-directory "~/.org")
;; (setq org-roam-db-location "~/.org/org-roam.db")
;; (setq org-roam-v2-ack t)

;; (setq time-stamp-active t
;;       time-stamp-start "#\\+LAST_MODIFIED:[ \t]*"
;;       time-stamp-end "$"
;;       time-stamp-format "\[%Y-%m-%d %a %H:%M:%S\]")

;; (add-hook 'before-save-hook 'time-stamp nil)

;; (setq flycheck-solidity-solium-soliumrcfile "$SOLHINT_PATH")

;; (after! org
;;   (setq org-hierarchical-todo-statistics t)

;;   (setq org-todo-keywords
;;       '((sequence "TODO" "IDEA" "GOAL" "PROJECT" "|" "DONE" "CANCELLED")))

;;   (setq org-format-latex-options (plist-put org-format-latex-options :scale 0.9)))

;; (after! evil-org-agenda
;;   (setq org-agenda-files (directory-files-recursively "~/.org/" "\\.org$")))

;; (setq org-archive-location "~/.org/archive/%s_archive::* Archived Tasks")

;; (setq org-download-screenshot-method  "flameshot gui --raw > %s")
;; (setq ledger-post-amount-alignment-column 100)
;; (setq ledger-post-account-alignment-column 2)

;; (setq all-the-icons-scale-factor 1.1)
;; (setq solidity-flycheck-solc-checker-active t)

;; (setq beancount-number-alignment-column 100)
;; (setq beancount-account-chars 60)

;; (add-hook 'beancount-mode-hook #'outline-minor-mode)

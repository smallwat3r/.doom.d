;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;
;;; Load configs

(load! "+ui")
(load! "+bindings")
(load! "+functions")
(load! "+eshell")

;;
;;; General

;; Some packages still use the "cl" package (replaced by "cl-lib") as a dependency
;; and Emacs triggers a warning on start-up. The below line is a temporary solution
;; to disable this warning. It's recommended to add it to the early-init.el file but
;; this seems to do the trick here also.
(setq byte-compile-warnings '(cl-functions))

;; Disable confirmation prompt when exiting Emacs.
(setq confirm-kill-emacs nil)

;; Echo the command names in minibuffer as they are being used
;; (add-hook! 'post-command-hook 'zz/echo-command-name)

;; Personal information
(setq user-full-name "Matthieu Petiteau"
      user-mail-address "mpetiteau.pro@gmail.com"
      user-mail-address-2 "matthieu@smallwatersolutions.com")

;; Some general settings
(setq evil-vsplit-window-right t
      evil-split-window-below t
      default-directory "~/"
      undo-limit 80000000
      evil-want-fine-undo t             ; fine grained undo history
      inhibit-compacting-font-caches t  ; improve general perfs
      scroll-margin 7                   ; top and bottom margins to trigger scroll
      which-key-idle-delay 0.2)         ; delay to show key bindings menu

;; My abbreviations. These are stored in abbrev.el
(setq abbrev-file-name (expand-file-name "abbrev.el" doom-private-dir))
(setq save-abbrevs 'silently)
(setq-default abbrev-mode t)

;; Custom file. File used by Emacs to cache some data relative to the config
(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))

;;
;;; Projectile

(after! projectile
  (setq projectile-sort-order 'recentf)
  (setq projectile-ignored-projects '("~/" "/tmp" "~/Downloads"))
  (setq projectile-project-search-path '("~/dotfiles/" "~/Projects/" "~/Code/" "~/Github/")))

;;
;;; Ivy

(after! ivy
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        +ivy-buffer-preview t)

  ;; Ask to pick an existing buffer when splitting the window
  (defadvice! prompt-for-buffer (&rest _)
    :after '(evil-window-split evil-window-vsplit)
    (+ivy/switch-buffer)))

;;
;;; Dired

(after! dired
  (setq delete-by-moving-to-trash t
        dired-listing-switches "-lat"))  ; sort by date

;; Narrowing searchs in dired
(use-package! dired-narrow
  :after dired
  :config (map! :map dired-mode-map
                :n "/" #'dired-narrow-fuzzy))

;; Toggle directories with TAB in dired
(use-package! dired-subtree
  :after dired
  :config (map! :map dired-mode-map
                "<tab>" #'dired-subtree-toggle
                "<backtab>" #'dired-subtree-cycle))

;;
;;; Company

(after! company
  (add-hook! 'evil-normal-state-entry-hook #'company-abort)  ; Make aborting less annoying

  (setq +lsp-company-backends
        '(:separate company-yasnippet company-capf))

  (setq company-idle-delay 0.1             ; Add minimal delay
        company-tooltip-limit 10           ; Dropdown of 10 lines long
        company-minimum-prefix-length 2))  ; Needs >2 chars before showing

;; Language specifics
(after! go-mode (set-company-backend! 'go-mode 'company-yasnippet))
(after! python-mode (set-company-backend! 'python-mode 'company-yasnippet))
(after! js2-mode (set-company-backend! 'js2-mode 'company-yasnippet))
(after! sh-script (set-company-backend! 'sh-mode))

;;
;;; Vterm

(after! vterm
  (setq vterm-max-scrollback 6000)
  (map!
   :map vterm-mode-map :n "B" #'vterm-beginning-of-line
   :map vterm-mode-map :n "<return>" #'evil-insert-resume
   :map vterm-mode-map "<C-backspace>" (lambda ()
                                         (interactive) (vterm-send-key (kbd "C-w")))))

;;
;;; Linters, checkers and programming language specifics

(add-hook! python-mode
  (setq python-shell-interpreter "/usr/local/opt/python@3.9/bin/python3.9"))

(after! flycheck
  ;; Pylint (python)
  (setq flycheck-python-pylint-executable "/usr/local/bin/pylint"
        flycheck-pylintrc "~/.config/pylintrc")
  (setq-hook! 'python-mode-hook
    flycheck-checker 'python-pylint)

  ;; Shellcheck (bash)
  (setq flycheck-shellcheck-excluded-warnings '("SC1091"))
  (setq-hook! 'sh-mode-hook
    flycheck-checker 'sh-shellcheck))

;; Grammar spell checker
(after! spell-fu
  (setq spell-fu-idle-delay 0.5))

;; Force grammar spell checking to be turn on manually
(remove-hook! (text-mode) #'spell-fu-mode)

;; Bash formatter settings (shfmt)
;; -i:  2 space identation
;; -ci: Indent switch cases
(set-formatter! 'shfmt "shfmt -i 2 -ci")

;; Python formatter settings (black)
(after! python
  (set-formatter! 'black
    '("black" "-q" "-l" "100" "-"
      ("--pyi" (string= (file-name-extension buffer-file-name) "pyi")))
    :modes '(python-mode)))

;; Delete all whitespace on save, except on markdown-mode
(add-hook! 'before-save-hook
  (lambda ()
    (unless (eq major-mode 'markdown-mode)
      (delete-trailing-whitespace))))

;; Scratch buffers
(use-package! scratch
  :config
  (map!
   (:leader
    (:prefix "o"
     :desc "scratch buffer current mode" "x" #'scratch
     :desc "scratch buffer restclient"   "h" #'zz/scratch-rest-mode)))

  ;; Auto add headers on scratch buffers in specific modes
  (add-hook! 'org-mode-hook (zz/add-scratch-buffer-header "#+TITLE: Scratch file"))
  (add-hook! 'sh-mode-hook (zz/add-scratch-buffer-header "#!/usr/bin/env bash"))
  (add-hook! 'restclient-mode-hook
    (zz/add-scratch-buffer-header
     "#
# restclient-mode
# Examples: https://raw.githubusercontent.com/pashky/restclient.el/master/examples/httpbin
#")))

;;
;;; magit

;; ;; Use zen-mode to center the buffer
;; (setq-hook! 'magit-status-mode-hook
;;   +zen-text-scale 0
;;   writeroom-width 80)

;; (add-hook 'magit-status-mode-hook #'writeroom-mode 'append)

;;
;;; Kubernetes

(use-package! kubernetes
  :commands (kubernetes-overview))

(use-package! kubernetes-evil
  :after kubernetes)

;;
;;; Emails

;; Emails are sent using msmtp
(setq sendmail-program "/usr/local/bin/msmtp")

(setq mail-user-agent 'message-user-agent
      mail-specify-envelope-from t
      mail-envelope-from 'header
      message-sendmail-envelope-from 'header)

(after! notmuch
  ;; Main buffer sections
  (setq notmuch-show-log nil
        notmuch-hello-sections `(notmuch-hello-insert-saved-searches
                                 notmuch-hello-insert-alltags))

  ;; Remove pop-up rule, so it opens in its own buffer
  (set-popup-rule! "^\\*notmuch-hello" :ignore t)

  ;; Email list formats
  (setq notmuch-search-result-format
        '(("date" . "%12s ")
          ("count" . "%-7s ")
          ("authors" . "%-15s ")
          ("tags" . "(%s) ")
          ("subject" . "%-72s")))

  ;; Use a custom command to fetch for new emails with mbsync
  (setq +notmuch-sync-backend 'custom
        +notmuch-sync-command "mbsync -a && notmuch new")

  ;; Set default tags on replies
  (setq notmuch-fcc-dirs
        '((user-mail-address . "personal/sent -inbox +sent -unread")
          (user-mail-address-2 . "sws/sent -inbox +sent -unread"))))

;;
;;; Org

(defvar my-notes-directory "~/org"
  "Where I'm storing my notes.")

;; deft
(after! deft
  (setq deft-directory my-notes-directory
        deft-recursive t))

;; org
(after! org
  (setq org-directory my-notes-directory
        org-hide-emphasis-markers nil))

;; org-journal
(after! org-journal
  (setq org-journal-dir (expand-file-name "journal/" my-notes-directory)
        org-journal-date-format "%A, %d %B %Y"
        org-journal-file-format "journal-%Y%m%d.org"))

;;
;;; Misc

;; Executable paths in Emacs as it works from the shell
(use-package! exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :init (setq exec-path-from-shell-arguments '("-l")  ; disable annoying warning
              exec-path-from-shell-variables '("PATH" "GOPATH"))
  :config (exec-path-from-shell-initialize))

;; google-translate
(use-package! google-translate
  :custom (google-translate-backend-method 'curl)
  :config
  ;; Fix - https://github.com/atykhonov/google-translate/issues/137#issuecomment-723938431
  (defun google-translate--search-tkk () (list 430675 2721866130))

  (map!
   (:leader
    (:prefix ("T" . "translate")
     :desc "Translate query"    "q" #'google-translate-query-translate
     :desc "Translate at point" "t" #'google-translate-at-point
     :desc "Translate buffer"   "b" #'google-translate-buffer))))

;; lorem-ipsum
(use-package! lorem-ipsum
  :config (map!
           (:leader
            (:prefix ("l" . "lorem ipsum")
             :desc "Insert paragraphs" "p" #'lorem-ipsum-insert-paragraphs
             :desc "Insert sentences"  "s" #'lorem-ipsum-insert-sentences
             :desc "Insert list"       "l" #'lorem-ipsum-insert-list))))

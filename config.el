;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;
;;; Load configs

(load! "+ui")
(load! "+functions")
(load! "+eshell")

;;
;;; General

;; Disable confirmation prompt when exiting Emacs.
(setq confirm-kill-emacs nil)

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

;; Custom File. File used by Emacs to cache some data relative to the config
(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))

;;
;;; Bindings

;; Make sure M-3 prints a hash symbol
(map! (:map key-translation-map "M-3" "#"))

(map!
 (:leader
  (:prefix "f" :desc "Cycle through frame" "j" #'other-frame)
  (:prefix "o" :desc "Open link at point" "l" #'browse-url-at-point)))

(map!
 (:map evil-normal-state-map
  "C-2"   #'zz/scroll-up
  "C-1"   #'zz/scroll-down
  "S-C-h" #'zz/enlarge-window-horizontally
  "S-C-l" #'zz/shrink-window-horizontally
  "S-C-k" #'zz/enlarge-window
  "S-C-j" #'zz/shrink-window
  "M-SPC" #'cycle-spacing
  "M-o"   #'delete-blank-lines
  ";f"    #'format-all-buffer
  ";q"    #'evil-save-and-close
  ";w"    #'evil-write
  "C-k"   #'join-line))

;;
;;; Projectile

;; Run `projectile-discover-projects-in-search-path' to autoload all the projects from the
;; `projectile-project-search-path' list.

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

(use-package! all-the-icons-ivy-rich
  :after ivy-rich
  :init (all-the-icons-ivy-rich-mode 1)
  :config (setq all-the-icons-ivy-rich-icon-size 0.7))

(custom-set-faces!
  '(ivy-minibuffer-match-face-1 :background nil :foreground "gray27")
  '(ivy-minibuffer-match-face-2 :background nil :foreground "orchid")
  '(ivy-minibuffer-match-face-3 :background nil :foreground "turquoise")
  '(ivy-minibuffer-match-face-4 :background nil :foreground "DarkGoldenrod1"))

;;
;;; Dired

(add-hook! 'dired-mode-hook 'dired-hide-details-mode)

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
  (setq company-idle-delay 0.1
        company-tooltip-limit 10
        company-minimum-prefix-length 1))

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

(after! flycheck
  ;; Pylint (python)
  (setq flycheck-python-pylint-executable "/usr/local/bin/pylint"
        flycheck-pylintrc "~/.config/pylintrc")
  (setq-hook! 'python-mode-hook flycheck-checker 'python-pylint)

  ;; Shellcheck (bash)
  (setq flycheck-shellcheck-excluded-warnings '("SC1091"))
  (setq-hook! 'sh-mode-hook flycheck-checker 'sh-shellcheck))

;; Grammar spell checker
(after! spell-fu
  (setq spell-fu-idle-delay 0.5))

;; Force grammar spell checking to be turn on manually
(remove-hook! (text-mode) #'spell-fu-mode)

;; Bash
(after! sh-script
  (set-company-backend! 'sh-mode nil)  ; disable backend because of slowliness
  ;; shfmt formatter settings
  ;; -i:  2 space identation
  ;; -ci: Indent switch cases
  (set-formatter! 'shfmt "shfmt -i 2 -ci"
    :modes '(sh-mode)))

;; Python
(after! python
  (setq python-shell-interpreter "/usr/local/opt/python@3.9/bin/python3.9")
  (set-formatter! 'black
    '("black" "-q" "-l" "100" "-"
      ("--pyi" (string= (file-name-extension buffer-file-name) "pyi")))
    :modes '(python-mode)))

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
;;; Docker

(map!
 (:leader
  (:prefix ("d" . "docker")
   :desc "List images"     "i" #'docker-images
   :desc "List containers" "c" #'docker-containers
   :desc "Exec into"       "e" #'docker-container-shell)))

;;
;;; Kubernetes

(use-package! kubernetes
  :config
  (map!
   (:leader
    (:prefix ("k" . "kubernetes")
     :desc "Overview"           "o" #'kubernetes-overview
     :desc "Set context"        "c" #'kubernetes-use-context
     :desc "Set namespace"      "n" #'kubernetes-set-namespace
     :desc "Display logs"       "l" #'kubernetes-logs-fetch-all
     :desc "Display service"    "s" #'kubernetes-display-service
     :desc "Display deployment" "d" #'kubernetes-display-deployment
     :desc "Describe"           "D" #'kubernetes-describe-pod
     :desc "Exec into"          "e" #'kubernetes-exec-into))))

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

(map!
 (:leader
  (:prefix "n"
   :desc "Deft open" "D" #'deft
   :desc "Deft new"  "d" #'deft-new-file)))

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

;; google-this
(use-package! google-this
  :config
  (map!
   (:leader
    (:prefix ("G" . "google")
     :desc "Query google"     "q" #'google-this
     :desc "Google this word" "w" #'google-this-word
     :desc "Google this line" "l" #'google-this-line))))

;; lorem-ipsum
(use-package! lorem-ipsum
  :config
  (map!
   (:leader
    (:prefix ("l" . "lorem ipsum")
     :desc "Insert paragraphs" "p" #'lorem-ipsum-insert-paragraphs
     :desc "Insert sentences"  "s" #'lorem-ipsum-insert-sentences
     :desc "Insert list"       "l" #'lorem-ipsum-insert-list))))

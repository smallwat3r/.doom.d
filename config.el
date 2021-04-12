;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;
;;; Load configs

(load! "+ui")
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
  (:prefix "o" :desc "Open in Alacritty"   "a" #'zz/alacritty-here)
  (:prefix "o" :desc "Open link at point"  "l" #'browse-url-at-point)))

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
  "C-k"   #'join-line
  "B"     #'beginning-of-line-text
  "E"     #'end-of-line))

;;
;;; Projectile

;; doc: https://github.com/bbatsov/projctile
;;      https://docs.projectile.mx/projectile/index.html
;;
;; Run `projectile-discover-projects-in-search-path' to autoload all the projects from the
;; `projectile-project-search-path' list.

(after! projectile
  (setq projectile-sort-order 'recentf
        projectile-mode-line-prefix "PJ"
        projectile-mode-line-function '(lambda () (format " PJ[%s]" (projectile-project-name)))
        projectile-ignored-projects '("~/" "/tmp" "~/Downloads")
        projectile-project-search-path '("~/dotfiles/" "~/Projects/" "~/Code/" "~/Github/")))

;;
;;; Ivy

;; doc: https://writequit.org/denver-emacs/presentations/2017-04-11-ivy.html#org121eea9
(after! ivy
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        +ivy-buffer-preview t)

  ;; Ask to pick an existing buffer when splitting the window
  (defadvice! prompt-for-buffer (&rest _)
    :after '(evil-window-split evil-window-vsplit)
    (+ivy/switch-buffer))

  (custom-set-faces!
    '(ivy-minibuffer-match-face-1 :background nil :foreground "gray27")
    '(ivy-minibuffer-match-face-2 :background nil :foreground "orchid")
    '(ivy-minibuffer-match-face-3 :background nil :foreground "turquoise")
    '(ivy-minibuffer-match-face-4 :background nil :foreground "DarkGoldenrod1")))

;; doc: https://github.com/asok/all-the-icons-ivy
(use-package! all-the-icons-ivy-rich
  :after ivy-rich
  :custom (all-the-icons-ivy-rich-icon-size 1)
  :init (all-the-icons-ivy-rich-mode 1))

;;
;;; Dired

;; doc: https://www.emacswiki.org/emacs/DiredMode
;;      https://github.com/Fuco1/dired-hacks

(add-hook! 'dired-mode-hook 'dired-hide-details-mode)

(after! dired
  (setq delete-by-moving-to-trash t
        dired-listing-switches "-lat"))  ; sort by date

;; Narrowing searchs in dired
(use-package! dired-narrow
  :after dired
  :commands (dired-narrow-fuzzy)
  :init (map! :map dired-mode-map :n "/" #'dired-narrow-fuzzy))

;; Toggle directories with TAB in dired
(use-package! dired-subtree
  :after dired
  :commands (dired-subtree-toggle dired-subtree-cycle)
  :custom-face
  (dired-subtree-depth-1-face ((t (:background nil))))
  (dired-subtree-depth-2-face ((t (:background nil))))
  (dired-subtree-depth-3-face ((t (:background nil))))
  (dired-subtree-depth-4-face ((t (:background nil))))
  (dired-subtree-depth-5-face ((t (:background nil))))
  (dired-subtree-depth-6-face ((t (:background nil))))
  :init (map! :map dired-mode-map
              "<tab>" #'dired-subtree-toggle
              "<backtab>" #'dired-subtree-cycle))

;;
;;; Company

;; doc: https://www.emacswiki.org/emacs/CompanyMode
(after! company
  (setq company-idle-delay 0.1
        company-tooltip-limit 10
        company-minimum-prefix-length 1))

;;
;;; Vterm

;; doc: https://github.com/akermu/emacs-libvterm
(after! vterm
  (setq vterm-max-scrollback 6000)

  ;; Keep mode-line
  (remove-hook 'vterm-mode-hook #'hide-mode-line-mode)

  ;; Bindings
  (map!
   :map vterm-mode-map :n "B" #'vterm-beginning-of-line
   :map vterm-mode-map :n "<return>" #'evil-insert-resume
   :map vterm-mode-map "<C-backspace>" (lambda ()
                                         (interactive) (vterm-send-key (kbd "C-w")))))

;;
;;; Linters, checkers and programming language specifics

;; doc: https://www.flycheck.org/en/latest/
(after! flycheck
  ;; Pylint (python)
  (setq flycheck-python-pylint-executable "/usr/local/bin/pylint"
        flycheck-pylintrc "~/.config/pylintrc")
  (setq-hook! 'python-mode-hook flycheck-checker 'python-pylint)

  ;; Shellcheck (bash)
  (setq flycheck-shellcheck-excluded-warnings '("SC1091"))
  (setq-hook! 'sh-mode-hook flycheck-checker 'sh-shellcheck))

;; Grammar spell checker
;; doc: https://gitlab.com/ideasman42/emacs-spell-fu
(after! spell-fu
  (setq spell-fu-idle-delay 0.5))

;; Force grammar spell checking to be turn on manually
(remove-hook! (text-mode) #'spell-fu-mode)

(after! sh-script
  (set-company-backend! 'sh-mode nil)  ; disable backend because of slowliness
  ;; shfmt formatter settings
  ;; -i:  2 space identation
  ;; -ci: Indent switch cases
  (set-formatter! 'shfmt "shfmt -i 2 -ci"
    :modes '(sh-mode)))

(after! python
  (setq python-shell-interpreter "/usr/local/opt/python@3.9/bin/python3.9")
  (set-formatter! 'black
    '("black" "-q" "-l" "100" "-"
      ("--pyi" (string= (file-name-extension buffer-file-name) "pyi")))
    :modes '(python-mode)))

(after! (:any js-mode json-mode)
  (setq js-indent-level 2))

(after! js2-mode
  (setq-default indent-tabs-mode nil)
  (setq-default js2-basic-offset 2))

(after! web-mode
  (setq web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-markup-indent-offset 2)

  (custom-set-faces!
    '(web-mode-html-attr-equal-face :foreground "gray60")
    '(web-mode-html-attr-name-face :foreground "gray60")
    '(web-mode-html-tag-face :foreground "gray60")
    '(web-mode-html-tag-bracket-face :foreground "gray45")))

;; Scratch buffers
;; doc: https://github.com/ieure/scratch-el
(use-package! scratch
  :config
  (defun zz/add-scratch-buffer-header (text)
    "Add an automatic header to a scratch buffer."
    (when scratch-buffer
      (save-excursion
        (goto-char (point-min))
        (insert text)
        (newline 2))
      (goto-char (point-max))))

  (defun zz/scratch-rest-mode ()
    "Start a scratch buffer in restclient-mode"
    (interactive)
    (scratch 'restclient-mode))

  (map!
   (:leader
    (:prefix "o"
     :desc "Scratch buffer current mode" "x" #'scratch
     :desc "Scratch buffer restclient"   "h" #'zz/scratch-rest-mode)))

  ;; Auto add headers on scratch buffers in specific modes
  (add-hook! 'org-mode-hook (zz/add-scratch-buffer-header "#+TITLE: Scratch file"))
  (add-hook! 'sh-mode-hook (zz/add-scratch-buffer-header "#!/usr/bin/env bash"))
  (add-hook! 'restclient-mode-hook (zz/add-scratch-buffer-header "#\n# restclient\n#")))

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

;; doc: https://github.com/chrisbarrett/kubernetes-el

(use-package! kubernetes
  :commands (kubernetes-overview)
  :init
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
  :delight
  :after kubernetes)

;;
;;; Emails

;; Emails are sent using msmtp
(setq sendmail-program "/usr/local/bin/msmtp")

(setq mail-user-agent 'message-user-agent
      mail-specify-envelope-from t
      mail-envelope-from 'header
      message-sendmail-envelope-from 'header)

;; doc: https://notmuchmail.org/emacstips/
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
;; doc: https://github.com/jrblevin/deft
(after! deft
  (setq deft-directory my-notes-directory
        deft-recursive t))

(map!
 (:leader
  (:prefix "n"
   :desc "Deft new file" "D" #'deft-new-file-named)))

;; org
;; doc: https://orgmode.org/manual/
(after! org
  (setq org-directory my-notes-directory
        org-hide-emphasis-markers t)

  (custom-set-faces!
    '(org-column :background nil)
    '(org-column-title :background nil)
    '(org-hide :background nil)
    '(org-indent :background nil)
    '(org-block :background "gray10")
    '(org-block-begin-line :background "gray10" :overline nil :underline nil :slant normal)
    '(org-block-end-line :background "gray10" :overline nil :underline nil :slant normal)))

;; doc: https://github.com/awth13/org-appear
(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autoemphasis t)
  (org-appear-autolinks t)
  (org-appear-autosubmarkers t)
  (org-appear-autoentities t))

;; org-journal
;; doc: https://github.com/bastibe/org-journal
(after! org-journal
  (setq org-journal-dir (expand-file-name "journal/" my-notes-directory)
        org-journal-date-format "%A, %d %B %Y"
        org-journal-file-format "journal-%Y%m%d.org"))

;;
;;; Misc

;; Executable paths in Emacs as it works from the shell
;; doc: https://github.com/purcell/exec-path-from-shell
(use-package! exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :custom
  (exec-path-from-shell-arguments '("-l"))
  (exec-path-from-shell-variables '("PATH" "GOPATH"))
  :config (exec-path-from-shell-initialize))

;; google-translate
;; doc: https://github.com/atykhonov/google-translate
(use-package! google-translate
  :commands (google-translate-at-point
             google-translate-query-translate
             google-translate-buffer)
  :init
  (set-popup-rule! "*Google Translate*" :size 0.4 :side 'bottom :select t :modeline t)

  (after! google-translate-backend
    (setq google-translate-backend-method 'curl))

  ;; fix
  (after! google-translate-tk
    (advice-add #'google-translate--search-tkk
                :override (lambda () "Search TKK fix." (list 430675 2721866130))))

  (map!
   (:leader
    (:prefix ("T" . "translate")
     :desc "Translate query"    "q" #'google-translate-query-translate
     :desc "Translate at point" "t" #'google-translate-at-point
     :desc "Translate buffer"   "b" #'google-translate-buffer))))

;; google-this
;; doc: https://github.com/Malabarba/emacs-google-this
(use-package! google-this
  :commands (google-this google-this-word google-this-line)
  :init (map!
         (:leader
          (:prefix ("G" . "google")
           :desc "Query google"     "q" #'google-this
           :desc "Google this word" "w" #'google-this-word
           :desc "Google this line" "l" #'google-this-line))))

;; lorem-ipsum
;; doc: https://github.com/jschaf/emacs-lorem-ipsum
(use-package! lorem-ipsum
  :commands (lorem-ipsum-insert-paragraphs
             lorem-ipsum-insert-sentences
             lorem-ipsum-insert-list)
  :init (map!
         (:leader
          (:prefix ("l" . "lorem ipsum")
           :desc "Insert paragraphs" "p" #'lorem-ipsum-insert-paragraphs
           :desc "Insert sentences"  "s" #'lorem-ipsum-insert-sentences
           :desc "Insert list"       "l" #'lorem-ipsum-insert-list))))

;; slack
;; doc: https://github.com/yuya373/emacs-slack
(use-package slack
  :commands (slack-start)
  :custom
  (slack-buffer-emojify t)
  (slack-prefer-current-team t)
  :custom-face
  (slack-message-mention-face ((t (:background nil :foreground "aquamarine2" :weight bold))))
  (slack-message-mention-face ((t (:background nil :foreground "aquamarine2" :weight bold))))
  (slack-message-mention-keyword-face ((t (:background nil :foreground "purple1" :weight bold))))
  (slack-message-mention-me-face ((t (:background nil :foreground "gold" :weight bold))))
  (slack-mrkdwn-code-face ((t (:background nil :foreground "green3"))))
  (slack-mrkdwn-code-block-face ((t (:background nil :foreground "green3"))))
  :config
  (slack-register-team
   :default t
   :name (+pass-get-secret "slack/btl/name")
   :token (+pass-get-secret "slack/btl/token")
   :full-and-display-names t)

  (slack-register-team
   :name (+pass-get-secret "slack/sws/name")
   :token (+pass-get-secret "slack/sws/token")
   :full-and-display-names t)

  (evil-define-key 'normal slack-mode-map
    ",ra" 'slack-message-add-reaction
    ",rr" 'slack-message-remove-reaction
    ",rs" 'slack-message-show-reaction-users
    ",me" 'slack-message-edit
    ",md" 'slack-message-delete
    ",mu" 'slack-message-embed-mention
    ",mc" 'slack-message-embed-channel)

  (evil-define-key 'normal slack-edit-message-mode-map
    ",k" 'slack-message-cancel-edit
    ",mu" 'slack-message-embed-mention
    ",mc" 'slack-message-embed-channel))

;; doc: https://github.com/jwiegley/alert
(use-package alert
  :commands (alert)
  :custom (aleter-default-style 'notifier))

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;
;;; Frame

(setq default-frame-alist
      (append default-frame-alist
              '((width . 105)
                (height . 65)
                (drag-internal-border . 1)
                (internal-border-width . 0))))

(setq-default frame-title-format '("Emacs@" emacs-version))

(setq ns-use-proxy-icon nil)  ; hide file icon from titlebar

;;
;;; General

;; Personal information
(setq user-full-name "Matthieu Petiteau"
      user-mail-address "mpetiteau.pro@gmail.com"
      user-mail-address-2 "matthieu@smallwatersolutions.com")

;; Disable confirmation prompt when exiting Emacs.
(setq confirm-kill-emacs nil)

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
;;; Fonts

(setq doom-font (font-spec :family "MonacoB2" :size 13)
      doom-variable-pitch-font (font-spec :family "Geneva")
      doom-font-increment 1
      doom-big-font-increment 2)

(setq-default line-spacing 0)
(setq-default tab-width 8)

;;
;;; Themes

;; Set up our default theme
(setq doom-theme 'sanityinc-tomorrow-bright)
(load! "+custom-faces")

;;
;;; Bindings

;; Make sure M-3 prints a hash symbol
(map! (:map key-translation-map "M-3" "#"))

(map!
 (:leader
  (:prefix "f" :desc "Cycle through frame" "j" #'other-frame)
  (:prefix "o" :desc "Open in Alacritty"   "a" #'my/alacritty-here)
  (:prefix "o" :desc "Open link at point"  "l" #'browse-url-at-point)
  (:prefix "p" :desc "Run project Makefile target" "m" #'makefile-executor-execute-project-target)))

(map!
 (:leader
  (:prefix "o" :desc "Open vterm @ project root"   "T" #'+vterm/here)
  (:prefix "o" :desc "Toggle vterm @ project root" "t" #'+vterm/toggle)
  (:prefix "o" :desc "Open vterm @ buffer dir"     "V" #'my/vterm/here-current-buffer)
  (:prefix "o" :desc "Toggle vterm @ buffer dir"   "v" #'my/vterm/toggle-current-buffer)))

(map!
 (:map evil-insert-state-map
  "C-h"   #'left-char
  "C-l"   #'right-char
  "C-k"   #'previous-line
  "C-j"   #'next-line)

 (:map evil-normal-state-map
  "C-2"   #'my/scroll-up
  "C-1"   #'my/scroll-down
  "S-C-h" #'my/enlarge-window-horizontally
  "S-C-l" #'my/shrink-window-horizontally
  "S-C-k" #'my/enlarge-window
  "S-C-j" #'my/shrink-window
  "M-SPC" #'cycle-spacing
  "M-o"   #'delete-blank-lines
  ";f"    #'format-all-buffer
  ";d"    #'my/save-and-close-buffer
  ";q"    #'evil-save-and-close
  ";w"    #'evil-write
  "C-k"   #'join-line
  "B"     #'beginning-of-line-text
  "E"     #'end-of-line))

;;
;;; Editor

;; I do like a blinking cursor
(blink-cursor-mode 1)

;; Treemacs
(after! treemacs
  (setq doom-themes-treemacs-enable-variable-pitch nil
        doom-themes-treemacs-line-spacing 0
        doom-themes-treemacs-theme "doom-colors"
        treemacs-width 35)
  (treemacs-resize-icons 14))

;; Git fringe
;; doc: https://github.com/emacsorphanage/git-gutter-fringe
(after! git-gutter-fringe
  (fringe-mode 1))

;; Disable line numbers by default
(setq display-line-numbers-type nil)

;; Disable hl-line
(remove-hook 'doom-first-buffer-hook #'global-hl-line-mode)

;; When hl-line is available, do not override the color of rainbow-mode
(add-hook! 'rainbow-mode-hook
  (hl-line-mode (if rainbow-mode -1 +1)))

;; Set window dividers width
(defvar global-window-divider-width 2
  "Default global width size of a window divider.")

(setq window-divider-default-right-width global-window-divider-width
      window-divider-default-bottom-width global-window-divider-width)

;; Writeroom
(after! writeroom-mode
  (setq +zen-window-divider-size global-window-divider-width
        +zen-text-scale 0))

;; Activate goto-address mode on some major modes
(add-hook! (prog-mode text-mode restclient-mode vterm-mode eshell-mode)
  (goto-address-mode t))

;; evil-goggles
;; doc: https://github.com/edkolev/evil-goggles
(after! evil-goggles
  (setq evil-goggles-duration 0.250))

;; beacon
;; doc: https://github.com/Malabarba/beacon
(use-package! beacon
  :delight
  :custom
  (beacon-size 15)
  (beacon-blink-when-window-scrolls nil)
  :init (beacon-mode 1))

;; Permanently display workspaces in minibuffer
(after! persp-mode
  (defun display-workspaces-in-minibuffer ()
    (with-current-buffer " *Minibuf-0*"
      (erase-buffer)
      (insert (+workspace--tabline))))
  (run-with-idle-timer 1 t #'display-workspaces-in-minibuffer)
  (+workspace/display))

;;
;;; Doom-dashboard

(setq +doom-dashboard-functions
      '(doom-dashboard-widget-shortmenu
        doom-dashboard-widget-loaded))

(setq +doom-dashboard-menu-sections
      '(("Open project"
         :action projectile-switch-project)
        ("Recently opened files"
         :action recentf-open-files)
        ("Reload last session"
         :when (cond ((require 'persp-mode nil t)
                      (file-exists-p
                       (expand-file-name persp-auto-save-fname persp-save-dir)))
                     ((require 'desktop nil t)
                      (file-exists-p (desktop-full-file-name))))
         :action doom/quickload-session)
        ("Open private configuration"
         :when (file-directory-p doom-private-dir)
         :action doom/open-private-config)
        ("Open documentation"
         :action doom/help)))

;;
;;; Modeline

;; Show counter while in search modes
;; doc: https://github.com/emacsorphanage/anzu
(use-package! anzu
  :delight
  :after-call isearch-mode)

;; doc: https://github.com/emacsorphanage/evil-anzu
(use-package! evil-anzu
  :delight
  :after-call evil-ex-start-search evil-ex-start-word-search evil-ex-search-activate-highlight
  :config (global-anzu-mode +1))

;; Manage how modes are displayed
;; doc: https://www.emacswiki.org/emacs/DelightedModes
(use-package! delight
  :config
  (delight
   '((pipenv-mode " pip" pipenv)
     (yas-minor-mode " Y" yasnippet)
     (git-gutter-mode " Gg" git-gutter)
     (dired-mode "δ" :major)
     (emacs-lisp-mode "ξ" :major)
     (python-mode "π" :major)
     (restclient-mode "Ɽest" :major)
     (sh-mode "Sh" :major)
     (org-mode "Org" :major)
     (js2-mode "Js" :major)

     ;; hidden minor-modes from modeline
     (company-mode nil company)
     (abbrev-mode nil abbrev)
     (ivy-mode nil ivy)
     (evil-org-mode nil evil-org)
     (which-key-mode nil which-key)
     (gcmh-mode nil gcmh)
     (ws-butler-mode nil ws-butler)
     (eldoc-mode nil eldoc)
     (dtrt-indent-mode nil dtrt-indent)
     (evil-escape-mode nil evil-escape)
     (evil-traces-mode nil evil-traces)
     (org-indent-mode nil org-indent)
     (outline-minor-mode nil outline)
     (persp-mode nil persp-mode)
     (whitespace-mode nil whitespace)
     (smartparens-mode nil smartparens)
     (evil-goggles-mode nil evil-goggles)
     (evil-snipe-local-mode nil evil-snipe))))

(setq-default mode-line-format
              '("%e"
                (:eval evil-mode-line-tag)
                mode-line-modified
                (:eval (shrink-path-file (buffer-file-name) nil))
                vc-mode
                "    "
                "%p (%l,%c)"
                "--"
                (:eval (format-time-string "%a %d %b %H:%M"))
                "--"
                mode-line-modes))

;;
;;; Projectile

;; doc: https://github.com/bbatsov/projectile
;;      https://docs.projectile.mx/projectile/index.html
;;
;; Run `projectile-discover-projects-in-search-path' to autoload all the projects from the
;; `projectile-project-search-path' list.

(after! projectile
  (setq projectile-sort-order 'recentf
        projectile-mode-line-prefix "P"
        projectile-mode-line-function '(lambda () (format " P[%s]" (projectile-project-name)))
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
    (+ivy/switch-buffer)))

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
        company-minimum-prefix-length 1)

  ;; Company icons
  (setq company-format-margin-function #'company-text-icons-margin
        company-text-icons-format " %s "
        company-text-icons-add-background nil)

  (setq company-text-icons-mapping
        '((array "[" default-inverse)
          (boolean "1" default-inverse)
          (class "C" default-inverse)
          (color "#" default-inverse)
          (constant "c" default-inverse)
          (enum-member "e" default-inverse)
          (enum "e" default-inverse)
          (field "f" default-inverse)
          (file "F" default-inverse)
          (folder "D" default-inverse)
          (interface "i" default-inverse)
          (keyword "k" default-inverse)
          (method "m" default-inverse)
          (function "f" default-inverse)
          (module "{" default-inverse)
          (numeric "n" default-inverse)
          (operator "o" default-inverse)
          (parameter "p" default-inverse)
          (property "p" default-inverse)
          (ruler "r" default-inverse)
          (snippet "S" default-inverse)
          (string "s" default-inverse)
          (struct "%" default-inverse)
          (text "w" default-inverse)
          (value "v" default-inverse)
          (variable "v" default-inverse)
          (t "." default-inverse))))

;; Disable company in shell mode
(add-hook! 'shell-mode-hook (company-mode -1))

;;
;;; Prog

(after! lsp-mode
  (setq lsp-enable-file-watchers nil))

(after! magit
  (setq git-commit-summary-max-length 70))

(after! flycheck
  ;; Pylint (python)
  (setq flycheck-python-pylint-executable "/usr/local/bin/pylint"
        flycheck-pylintrc "~/.config/pylintrc")
  (setq-hook! 'python-mode-hook flycheck-checker 'python-pylint)

  ;; Shellcheck (bash)
  (setq flycheck-shellcheck-excluded-warnings '("SC1091"))
  (setq-hook! 'sh-mode-hook flycheck-checker 'sh-shellcheck))

(after! spell-fu
  (setq spell-fu-idle-delay 0.5))

;; Force grammar spell checking to be turn on manually
(remove-hook! (text-mode) #'spell-fu-mode)

(after! sh-script
  (setq-default indent-tabs-mode nil)
  (set-formatter! 'shfmt
    '("shfmt"
      "-i" "2" ; nb of spaces used for indentation
      "-ci"    ; indent switch cases
      "-bn")   ; binary ops may start a line
    :modes '(sh-mode))
  (set-company-backend! 'sh-mode nil))  ; disable backend because of slowliness

(setq-hook! 'sh-mode-hook sh-basic-offset 2)

(after! python
  python-shell-interpreter "/usr/local/opt/python@3.9/bin/python3.9"
  (set-formatter! 'black
    '("black"
      "--quiet"
      "--line-length" "100"
      "-")  ; apply in file changes
    :modes '(python-mode)))

(after! js2-mode
  (set-formatter! 'prettier
    '("prettier"
      "--print-width" "120"
      ("--stdin-filepath" "%s" buffer-file-name))
    :modes '(js2-mode)))

(setq-hook! 'json-mode js-indent-level 2)
(setq-hook! 'js2-mode js2-basic-offset 2)
(setq-hook! 'go-mode indent-tabs-mode t)
(setq-hook! 'web-mode-hook
  tab-width 2
  web-mode-markup-indent-offset 2
  web-mode-css-indent-offset 2
  web-mode-script-padding 2
  web-mode-style-padding 2)

(setq-hook! 'html-mode-hook +format-with :none)
(setq-hook! 'web-mode-hook +format-with :none)

;;
;;; Vterm

;; doc: https://github.com/akermu/emacs-libvterm
(after! vterm
  (setq vterm-max-scrollback 6000)

  ;; Keep mode-line
  (remove-hook 'vterm-mode-hook #'hide-mode-line-mode)

  (defun my/vterm-delete-word ()
    "Delete a word in vterm."
    (interactive)
    (vterm-send-key (kbd "C-w")))

  ;; Bindings
  (map!
   :map vterm-mode-map :n "B" #'vterm-beginning-of-line
   :map vterm-mode-map :n "<return>" #'evil-insert-resume
   :map vterm-mode-map "<C-backspace>" #'my/vterm-delete-word))

;;
;;; Eshell

;; doc: https://www.gnu.org/software/emacs/manual/html_node/eshell/index.html

;; Remove the virtual env variable once the env has been deactivated, it will
;; get recreated once we reactivate the env. It's used in our eshell prompt
;; so we need to remove it when not in use.
(add-hook! 'pyvenv-post-deactivate-hooks (lambda () (setenv "VIRTUAL_ENV" nil)))

;; Disable company in eshell
;; (setq-hook! 'eshell-mode-hook company-idle-delay nil)
(add-hook! 'eshell-mode-hook (company-mode -1))

(after! eshell
  (defun my/eshell-current-git-branch ()
    "Get current branch name from repository."
    (let ((args '("symbolic-ref" "HEAD" "--short")))
      (with-temp-buffer
        (apply #'process-file "git" nil (list t nil) nil args)
        (unless (bobp)
          (goto-char (point-min))
          (buffer-substring-no-properties (point) (line-end-position))))))

  (defun my/eshell-prompt ()
    "Default Eshell prompt."
    (let ((base/dir (shrink-path-prompt default-directory))
          (base/branch (my/eshell-current-git-branch)))
      (concat
       ;; python venv
       (if (getenv "VIRTUAL_ENV")
           (let ((venv (file-name-nondirectory (getenv "VIRTUAL_ENV"))))
             (propertize (format "(%s) " venv) 'face 'default)))
       ;; directory path
       (propertize (car base/dir) 'face 'font-lock-comment-face)
       (propertize (cdr base/dir) 'face 'default)
       ;; git branch
       (if base/branch
           (propertize (format " (%s)" base/branch) 'face 'default))
       ;; user / super user
       (propertize (if (= (user-uid) 0) " # " " λ ") 'face 'default))))

  (setq eshell-history-size 1000000
        eshell-buffer-maximum-lines 5000
        eshell-modify-global-environment t
        eshell-destroy-buffer-when-process-dies t)

  ;; Keep mode-line
  (remove-hook 'eshell-mode-hook #'hide-mode-line-mode)

  ;; Prompt settings
  (setq eshell-prompt-regexp "^.* [#λ] "
        eshell-prompt-function #'my/eshell-prompt)

  ;; List of eshell aliases
  (set-eshell-alias!
   "d" "dired $1"
   "clear" "clear-scrollback"
   "c" "clear-scrollback"
   "g" "git $*"
   "qq" "exit"
   "gs" "magit-status"
   "gc" "magit-commit"
   "gd" "magit-diff-unstaged"
   "gds" "magit-diff-staged"
   "..." "cd ../.."
   "...." "cd ../../.."
   "....." "cd ../../../.."
   "k" "kubectl $*"
   "kt" "kubetail $*"
   "kgn" "kubectl get namespaces"
   "ls" "my/eshell/ls $*")

  ;; Custom Eshell functions

  (defun eshell/cr ()
    "Go to git repository root."
    (eshell/cd (locate-dominating-file default-directory ".git")))

  (defun eshell/md (dir)
    "mkdir and cd into directory."
    (eshell/mkdir dir)
    (eshell/cd dir))

  (defun eshell/dots ()
    "cd into my dotfiles directory."
    (eshell/cd "~/dotfiles"))

  (defun my/eshell/ls (&rest args)
    "ls to always list hidden files."
    (eshell/ls "-a" args))

  (defun eshell/sl (&rest args)
    "ls typo."
    (my/eshell/ls args))

  (defun eshell/o ()
    "Open in finder."
    (+macos/reveal-in-finder))

  (defun eshell/deactivate ()
    "Deactivate a python venv."
    (pyvenv-deactivate))

  (defun eshell/activate (&optional env)
    "Activate a python venv."
    (if env
        (pyvenv-activate env)
      (pyvenv-activate "env")))

  (defun eshell/e (&rest args)
    "Invoke `find-file' on the file.
\"e +42 foo\" also goes to line 42 in the buffer."
    (while args
      (if (string-match "\\`\\+\\([0-9]+\\)\\'" (car args))
          (let* ((line (string-to-number (match-string 1 (pop args))))
                 (file (pop args)))
            (find-file file)
            (forward-line line))
        (find-file (pop args)))))

  (defun eshell/extract (file)
    "Extract archive file."
    (let ((command
           (some (lambda (x)
                   (if (string-match-p (car x) file)
                       (cadr x)))
                 '((".*\.tar.bz2" "tar xjf")
                   (".*\.tar.gz" "tar xzf")
                   (".*\.bz2" "bunzip2")
                   (".*\.rar" "unrar x")
                   (".*\.gz" "gunzip")
                   (".*\.tar" "tar xf")
                   (".*\.tbz2" "tar xjf")
                   (".*\.tgz" "tar xzf")
                   (".*\.zip" "unzip")
                   (".*\.Z" "uncompress")
                   (".*" "echo 'Could not extract the file:'")))))
      (eshell-command-result (concat command " " file)))))

;;
;;; Docker

(use-package! docker
  :commands (docker-images docker-containers docker-container-shell)
  :init
  (map!
   (:leader
    (:prefix ("d" . "docker")
     :desc "List images"     "i" #'docker-images
     :desc "List containers" "c" #'docker-containers
     :desc "Exec into"       "e" #'docker-container-shell))))

;;
;;; Org

(defvar my-notes-directory "~/org"
  "Where I'm storing my notes.")

;; deft
;; doc: https://github.com/jrblevin/deft
(after! deft
  (setq deft-directory my-notes-directory))

(map!
 (:leader
  (:prefix "n"
   :desc "Open deft" "d" #'deft
   :desc "Deft new file" "D" #'deft-new-file-named)))

;; org
;; doc: https://orgmode.org/manual/
(after! org
  (setq org-directory my-notes-directory
        org-hide-emphasis-markers t))

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
;;; Mail

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
;;; Misc

;; shrink-path
(use-package! shrink-path
  :commands (shrink-path-file shrink-path-prompt))

;; grip-mode
(after! grip-mode
  (setq grip-github-user "smallwat3r"
        grip-github-password (+pass-get-secret "github/password")))

;; Scratch buffers
;; doc: https://github.com/ieure/scratch-el
(use-package! scratch
  :config
  (defun my/add-scratch-buffer-header (text)
    "Add an automatic header to a scratch buffer."
    (when scratch-buffer
      (save-excursion
        (goto-char (point-min))
        (insert text)
        (newline 2))
      (goto-char (point-max))))

  (defun my/scratch-rest-mode ()
    "Start a scratch buffer in restclient-mode"
    (interactive)
    (scratch 'restclient-mode))

  (map!
   (:leader
    (:prefix "o"
     :desc "Scratch buffer current mode" "x" #'scratch
     :desc "Scratch buffer restclient"   "h" #'my/scratch-rest-mode)))

  ;; Auto add headers on scratch buffers in specific modes
  (add-hook! 'org-mode-hook (my/add-scratch-buffer-header "#+TITLE: Scratch file"))
  (add-hook! 'sh-mode-hook (my/add-scratch-buffer-header "#!/usr/bin/env bash"))
  (add-hook! 'restclient-mode-hook (my/add-scratch-buffer-header "#\n# restclient\n#")))

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

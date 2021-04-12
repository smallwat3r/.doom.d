;;; $DOOMDIR/+ui.el -*- lexical-binding: t; -*-

;;
;;; Frame

(add-to-list 'default-frame-alist '(width . 105))
(add-to-list 'default-frame-alist '(height . 65))
(add-to-list 'default-frame-alist '(drag-internal-border . 1))
(add-to-list 'default-frame-alist '(internal-border-width . 0))

;; In case there is a titlebar, this shows the current running Emacs version and
;; the title of the current file and a flag (**) if the file has been modified
;; (eg. **<filename>)
(setq-default frame-title-format
              '("Emacs @ " emacs-version " - "
                (:eval
                 (if (buffer-modified-p) " **"))
                (:eval
                 (if (buffer-file-name)
                     (replace-regexp-in-string
                      ".*/[0-9]*-?" " "
                      (subst-char-in-string ?_ ? buffer-file-name)) "%b"))))

;; Hide file icon from titlebar
(setq ns-use-proxy-icon nil)

;;
;;; Fonts

(setq doom-font (font-spec :family "MonacoB2" :size 13)
      doom-variable-pitch-font (font-spec :family "Geneva")
      doom-font-increment 1
      doom-big-font-increment 2)

(setq-default line-spacing 0)

;;
;;; Themes config

;; Set up our default theme
(setq doom-theme 'sanityinc-tomorrow-bright)

(custom-set-faces!
  ;; Eye saver
  '(default :background "gray0")

  ;; turn off background on some elements
  '(company-tooltip :background nil)
  '(magit-diff-context :background nil)
  '(magit-diff-context-highlight :background nil)
  '(markdown-code-face :background nil)
  '(whitespace-tab :background nil)
  '(whitespace-space :background nil)
  '(whitespace-newline :background nil)
  '(whitespace-hspace :background nil)
  '(whitespace-indentation :background nil)

  ;; Remove some additional code syntax highlighting, keep it simple
  '(font-lock-function-name-face :foreground nil)
  '(font-lock-variable-name-face :foreground nil)
  '(font-lock-constant-face :foreground nil)
  '(font-lock-type-face :foreground nil)

  ;; Make diff-refine less aggressive
  '(magit-diff-added-highlight :weight regular)
  '(magit-diff-removed-highlight :weight regular)
  '(magit-diff-base-highlight :weight regular)
  '(diff-refine-added :inherit magit-diff-added-highlight :inverse-video nil :weight bold)
  '(diff-refine-removed :inherit magit-diff-removed-highlight :inverse-video nil :weight bold)
  '(diff-refine-changed :inverse-video nil :weight bold)

  ;; Comments and docstrings colors
  '(font-lock-comment-face :foreground "#329400" :slant normal)
  '(font-lock-comment-delimiter-face :foreground "#0a4700" :slant normal)
  '(font-lock-doc-face :foreground "#329400" :slant normal)

  ;; Miscellaneous
  '(+workspace-tab-selected-face :background nil :foreground "#b294bb" :weight bold)
  '(cursor :background "#d7ff00")
  '(show-paren-match :foreground "#d7ff00" :background "#ff5f5f" :slant normal :box nil)
  '(show-paren-mismatch :foreground "#ffffff" :background "#db0000" :slant normal :box nil)
  '(link :background nil :foreground "PaleTurquoise2" :weight regular :underline t)
  '(link-visited :background nil :foreground "maroon4" :weight regular :underline t)
  '(minibuffer-prompt :background nil :foreground "#f6df92")
  '(nav-flash-face :background "#313131")
  '(persp-face-lighter-buffer-not-in-persp :background nil))

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

  (custom-set-faces!
    '(doom-themes-treemacs-file-face :foreground "#dbdbdb")))

;; Git fringe
;; doc: https://github.com/emacsorphanage/git-gutter-fringe
(after! git-gutter-fringe
  (fringe-mode 1) ; thinest possible

  (custom-set-faces!
    '(git-gutter-fr:added :foreground "chartreuse3")
    '(git-gutter-fr:modified :foreground "gold")
    '(git-gutter-fr:deleted :foreground "red3")))

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
(when (featurep! :ui zen)
  (after! writeroom-mode
    (setq +zen-window-divider-size global-window-divider-width
          +zen-text-scale 0)))

;; Activate goto-address mode on some major modes
(add-hook! (prog-mode text-mode restclient-mode) (goto-address-mode t))

;; evil-goggles
;; doc: https://github.com/edkolev/evil-goggles
(after! evil-goggles
  (setq evil-goggles-duration 0.250)

  (custom-set-faces!
    '(evil-goggles-delete-face :background "#2f001a")
    '(evil-goggles-paste-face :background "#172f00")
    '(evil-goggles-yank-face :background "#363636")))

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

(custom-set-faces!
  '(mode-line :box nil :foreground "#000000" :background "#dfdfdf" :box "#222222")
  '(mode-line-highlight :box nil)
  '(mode-line-inactive :box nil :foreground "#000000" :background "#5c5c5c" :box "#222222"))

;; Show counter while in search modes
;; doc: https://github.com/emacsorphanage/anzu
(use-package! anzu
  :after-call isearch-mode
  :config (custom-set-faces!
            '(anzu-mode-line :foreground "#870052" :weight bold)))

;; doc: https://github.com/emacsorphanage/evil-anzu
(use-package! evil-anzu
  :after-call evil-ex-start-search evil-ex-start-word-search evil-ex-search-activate-highlight
  :config (global-anzu-mode +1))

;; Manage how modes are displayed
;; doc: https://www.emacswiki.org/emacs/DelightedModes
(use-package! delight
  :config
  (delight
   '((abbrev-mode " Abv" abbrev)
     (pipenv-mode " pip" pipenv)
     (yas-minor-mode " υ" yasnippet)
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
     (ivy-mode nil ivy)
     (anzu-mode nil anzu)
     (evil-org-mode nil evil-org)
     (which-key-mode nil which-key)
     (gcmh-mode nil gcmh)
     (ws-butler-mode nil ws-butler)
     (eldoc-mode nil eldoc)
     (dtrt-indent-mode nil dtrt-indent)
     (evil-escape-mode nil evil-escape)
     (evil-traces-mode nil evil-traces)
     (outline-minor-mode nil outline)
     (whitespace-mode nil whitespace)
     (smartparens-mode nil smartparens)
     (evil-goggles-mode nil evil-goggles)
     (evil-snipe-local-mode nil evil-snipe))))

(setq-default mode-line-format
              '("%e"
                (:eval evil-mode-line-tag)
                mode-line-modified
                "%b"
                vc-mode
                "    "
                "%p (%l,%c)"
                "--"
                (:eval (format-time-string "%a %d %b %H:%M"))
                "--"
                mode-line-modes))

;;; $DOOMDIR/+ui.el -*- lexical-binding: t; -*-

;;
;;; Frame

;; Default frame size on start-up
(add-to-list 'default-frame-alist '(width . 109))
(add-to-list 'default-frame-alist '(height . 65))

;; No titlebar and borders, keep it super simple
(add-to-list 'default-frame-alist '(drag-internal-border . 1))
(add-to-list 'default-frame-alist '(internal-border-width . 0))

;; Frame transparency
(set-frame-parameter (selected-frame) 'alpha '(98 98))
(add-to-list 'default-frame-alist '(alpha 98 98))

;; Hide file icon from frame window
(setq ns-use-proxy-icon nil)

;; Disable UI fluff
(toggle-scroll-bar -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; In case I want a titlebar, this shows the title of the current file and a
;; flag if the file has been modified eg. (+)
(setq-default frame-title-format
              '("Emacs - " user-login-name "@" system-name " - "
                (:eval
                 (if (buffer-file-name)
                     (replace-regexp-in-string
                      ".*/[0-9]*-?" " "
                      (subst-char-in-string ?_ ? buffer-file-name)) "%b"))
                (:eval
                 (if (buffer-modified-p) " (+)"))))

;;
;;; Fonts

(defvar default-monospace-font "Fira Code"
  "Default Monospace font")

(defvar default-serif-font "Verdana"
  "Default Serif font")

(setq doom-font (font-spec :family default-monospace-font :size 14)
      doom-variable-pitch-font (font-spec :family default-serif-font)
      doom-font-increment 1
      doom-big-font-increment 3)

;;
;;; Themes config

(use-package! modus-vivendi-theme  ; dark theme
  :init (setq
         modus-vivendi-theme-slanted-constructs nil
         modus-vivendi-theme-bold-constructs nil
         modus-vivendi-theme-intense-hl-line nil
         modus-vivendi-theme-subtle-diffs t
         modus-vivendi-theme-intense-paren-match t
         modus-vivendi-theme-org-blocks 'rainbow
         modus-vivendi-theme-completions 'opinionated
         modus-vivendi-theme-faint-syntax nil)
  :config (modus-vivendi-theme-with-color-variables
            (custom-theme-set-faces! 'modus-vivendi
              `(default :background "grey3" :foreground "grey90"))))

(use-package! modus-operandi-theme  ; light theme
  :init (setq
         modus-operandi-theme-slanted-constructs nil
         modus-operandi-theme-bold-constructs nil
         modus-operandi-theme-intense-hl-line nil
         modus-operandi-theme-intense-paren-match t
         modus-operandi-theme-org-blocks 'rainbow
         modus-operandi-theme-completions 'opinionated)
  :config (modus-operandi-theme-with-color-variables
            (custom-theme-set-faces! 'modus-operandi
              `(default :background "papaya whip")
              `(term :background "papaya whip"))))

;; HACK: Change default background color when using vterm within modus-operandi.
;; Changing it by setting vterm-color-default above doesn't seems to work anymore.
(add-hook 'vterm-mode-hook
          (lambda()
            (when (string= doom-theme "modus-operandi")
              (set (make-local-variable 'buffer-face-mode-face)
                   '(:background "bisque"))
              (buffer-face-mode t))))

;; Do not show standard themes
(delq! t custom-theme-load-path)

;; High contrast override
;; (setq simplicity-override-colors-alist
;;       '(("simplicity-background" . "#000000")
;;         ("simplicity-foreground" . "#eeeeee")))

;; Set up our default theme
(setq doom-theme 'simplicity)

;; Overwrite global theme faces
(custom-set-faces!
  '(line-number :background nil :foreground "#3b3b3b" :height 100)
  '(line-number-current-line :background nil :height 100)
  '(whitespace-newline :background nil :inherit font-lock-comment-face)
  '(+workspace-tab-selected-face :background nil :foreground "PeachPuff" :weight bold))

;;
;;; Editor

;; Git fringe
(after! git-gutter-fringe
  (fringe-mode 2))

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

;; Do not change the divider border width when using writeroom
(setq +zen-window-divider-size global-window-divider-width)

;; Writeroom font scaling
(setq +zen-text-scale 1)

;; Line spacing
(setq-default line-spacing 1)

;; Show indicator for empty lines (eg. the tildes in vim after eof)
;; (setq-default indicate-empty-lines t)

;; Enable word-wrap (almost) everywhere
(+global-word-wrap-mode +1)

;; Disable global by default word-wrap in a few modes
(add-to-list '+word-wrap-disabled-modes 'vterm-mode)
(add-to-list '+word-wrap-disabled-modes 'notmuch-search-mode)

;; Terminal line wrap symbols
(set-display-table-slot standard-display-table 'truncation ?›)
(set-display-table-slot standard-display-table 'wrap ?↵)

;; whitespace-mode
;; (global-whitespace-mode +1)  ; turns on whitespace mode globally
(setq whitespace-style '(trailing tabs newline tab-mark newline-mark))
(setq whitespace-display-mappings '((newline-mark 10 [?◦ 10])))  ; eol character

;; ;; Auto-activate writeroom on text-mode
;; (add-hook! 'text-mode-hook writeroom-mode)

;; Activate goto-address mode on some major modes
(add-hook! (prog-mode text-mode restclient-mode) (goto-address-mode t))

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
;;; Mini-modeline

;; Evil uses the term state for what is called a "mode" in regular vi usage,
;; because modes are understood in Emacs terms to mean something else.
;; Set-up the different states faces, we can then display these on the modeline.
(setq
 evil-normal-state-tag   (propertize "N" 'face '((:weight bold)))
 evil-insert-state-tag   (propertize "I" 'face '((:weight bold :foreground "LimeGreen")))
 evil-replace-state-tag  (propertize "R" 'face '((:weight bold :foreground "DarkGoldenrod")))
 evil-visual-state-tag   (propertize "V" 'face '((:weight bold :foreground "DarkOrange")))
 evil-emacs-state-tag    (propertize "E" 'face '((:weight bold)))
 evil-motion-state-tag   (propertize "M" 'face '((:weight bold)))
 evil-operator-state-tag (propertize "O" 'face '((:weight bold))))

(use-package! mini-modeline
  :init
  ;; Turn off some default settings, like to keep it as clean as possible. Also
  ;; keep the modeline information on the right side of the mini-buffer so it still
  ;; has enough space to display useful information on the left side (eg. commands
  ;; information, echos, documentation etc).
  (setq
   mini-modeline-enhance-visual nil
   mini-modeline-display-gui-line nil
   mini-modeline-r-format
   (list
    '(:eval (propertize                ; Current filename
             " %b"
             'help-echo (buffer-file-name)))
    '(vc-mode vc-mode)                 ; Current git branch
    " "
    (propertize "%02l,%02c "           ; Current line and column
                'help-echo "Line and column index")
    '(:eval (propertize                ; Major Mode
             "%m"
             'help-echo "Buffer major mode"))
    '(:eval (when (buffer-modified-p)  ; Modified?
              (propertize
               " [Mod]"
               'help-echo "Buffer has been modified"
               'face 'font-lock-warning-face)))
    '(:eval (when buffer-read-only     ; Read only?
              (propertize
               " [RO]"
               'help-echo "Buffer is read-only"
               'face 'font-lock-type-face)))
    '(:eval (propertize                ; Time
             (format-time-string " %a %b %d %H:%M ")
             'help-echo (concat (format-time-string "%c; week %V; ")
                                (emacs-uptime "Uptime: %hh"))))
    '(:eval evil-mode-line-tag)))      ; Evil mode
  :config (mini-modeline-mode t))

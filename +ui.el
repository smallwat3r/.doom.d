;;; $DOOMDIR/+ui.el -*- lexical-binding: t; -*-

;;
;;; Frame

;; Default frame size on start-up
(add-to-list 'default-frame-alist '(width . 100))
(add-to-list 'default-frame-alist '(height . 55))

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

(defvar default-monospace-font "Sometype Mono"
  "Default Monospace font")

(defvar default-serif-font "Verdana"
  "Default Serif font")

(setq doom-font (font-spec :family default-monospace-font :size 15)
      doom-variable-pitch-font (font-spec :family default-serif-font)
      doom-font-increment 1
      doom-big-font-increment 2)

;;
;;; Themes config

;; Do not show standard themes
(delq! t custom-theme-load-path)

;; Set up our default theme
(setq doom-solarized-dark-brighter-text t)
(setq doom-theme 'doom-solarized-dark)

;; Overwrite global theme faces
(custom-set-faces!
  '(default :background "#00212B")  ; darker bg for solarized-dark
  '(line-number :background nil :foreground "#3b3b3b" :height 100)
  '(line-number-current-line :background nil :height 100)
  '(whitespace-newline :background nil :inherit font-lock-comment-face)
  '(+workspace-tab-selected-face :background nil :foreground "yellow" :weight bold))

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
(setq-default line-spacing 0)

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

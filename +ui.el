;;; $DOOMDIR/+ui.el -*- lexical-binding: t; -*-

;;
;;; Frame

;; Default frame size on start-up
(add-to-list 'default-frame-alist '(width . 100))
(add-to-list 'default-frame-alist '(height . 55))

;; Keep titlebar and borders super simple
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

;; In case there is a titlebar, this shows the title of the current file and a
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

(defvar default-monospace-font "Inconsolata"
  "Default Monospace font")

(defvar default-serif-font "Verdana"
  "Default Serif font")

(setq doom-font (font-spec :family default-monospace-font :size 15)
      doom-variable-pitch-font (font-spec :family default-serif-font)
      doom-font-increment 1
      doom-big-font-increment 2
      doom-themes-treemacs-enable-variable-pitch nil)

;;
;;; Themes config

;; Do not show standard themes
(delq! t custom-theme-load-path)

(after! doom-themes
  (remove-hook 'doom-load-theme-hook #'doom-themes-treemacs-config))

;; Set up our default theme
(setq doom-theme 'doom-laserwave)

;; Overwrite global theme faces
(custom-set-faces!
  ;; Darkest background possible
  '(default :background "#000000")

  ;; Comments and docstrings should always be green
  '(font-lock-comment-face :foreground "#329400")
  '(font-lock-doc-face :foreground "#329400")

  ;; Remove some additional syntax highlighting, keep it simple
  '(font-lock-function-name-face :foreground nil)
  '(font-lock-variable-name-face :foreground nil)
  '(font-lock-constant-face :foreground nil)
  '(font-lock-type-face :foreground nil)

  ;; Line numbers
  '(line-number :background nil :foreground "#3b3b3b" :height 120)
  '(line-number-current-line :background nil :height 120)

  ;; Miscellaneous
  '(+workspace-tab-selected-face :background nil :foreground "#329400" :weight bold)
  '(show-paren-match :foreground "cyan" :underline "cyan" :weight bold)

  ;; git-gutter-fringe
  '(git-gutter-fr:added :foreground "#329400")
  '(git-gutter-fr:modified :foreground "#f0da00")
  '(git-gutter-fr:deleted :foreground "#d11141"))

;;
;;; Editor

;; Git fringe
(after! git-gutter-fringe
  (fringe-mode 2))

;; Treemacs
(after! treemacs
  (treemacs-resize-icons 12))

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
;; Set-up the different states faces so we can display these on the modeline.
(setq
 evil-normal-state-tag   (propertize "●" 'face '((:weight bold :foreground "LimeGreen")))
 evil-insert-state-tag   (propertize "●" 'face '((:weight bold :foreground "red")))
 evil-replace-state-tag  (propertize "●" 'face '((:weight bold :foreground "DarkGoldenrod")))
 evil-visual-state-tag   (propertize "●" 'face '((:weight bold :foreground "yellow")))
 evil-emacs-state-tag    (propertize "●")
 evil-motion-state-tag   (propertize "●")
 evil-operator-state-tag (propertize "●"))

(use-package! mini-modeline
  :init
  ;; Turn off some default settings, like to keep it as clean as possible. Also
  ;; keep the modeline information on the right side of the mini-buffer so it still
  ;; has enough space to display useful information on the left side (eg. commands
  ;; information, echos, documentation etc).
  (setq mini-modeline-enhance-visual nil
        mini-modeline-display-gui-line nil)
  ;; Modeline format
  (setq mini-modeline-r-format
        '("%e"
          evil-mode-line-tag
          mode-line-modified
          (:eval (propertize "%b" 'face '((t (:weight bold)))))
          " %l:%c %p "
          (:eval (propertize "%m" 'face '((t (:weight bold)))))
          vc-mode
          (:eval (format-time-string " %a.%b.%d %H:%M"))))
  :config (mini-modeline-mode t))

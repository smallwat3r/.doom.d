;;; $DOOMDIR/+ui.el -*- lexical-binding: t; -*-

;;
;;; Frame

;; Inital frame settings
(setq initial-frame-alist
      '((width . 110)
        (height . 60)
        (drag-internal-border . 1)
        (internal-border-width . 0)))

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

(setq ns-use-thin-smoothing t)

(setq doom-font (font-spec :family "Menlo" :size 14)
      doom-variable-pitch-font (font-spec :family "Verdana")
      doom-font-increment 1
      doom-big-font-increment 2)

;;
;;; Themes config

;; Do not show standard themes
(delq! t custom-theme-load-path)

;; Set up our default theme
(setq doom-theme 'doom-tomorrow-night)

;; Overwrite global theme faces
(custom-set-faces!
  ;; Eye saver
  '(default :background "gray0")

  ;; turn off background on some elements
  '(company-tooltip :background nil)
  '(magit-diff-context :background nil)
  '(magit-diff-context-highlight :background nil)

  ;; Make diff-refine less aggressive
  '(magit-diff-added-highlight :weight regular)
  '(magit-diff-removed-highlight :weight regular)
  '(magit-diff-base-highlight :weight regular)
  '(diff-refine-added :inherit magit-diff-added-highlight :inverse-video nil :weight bold)
  '(diff-refine-removed :inherit magit-diff-removed-highlight :inverse-video nil :weight bold)
  '(diff-refine-changed :inverse-video nil :weight bold)

  ;; ivy
  '(ivy-minibuffer-match-face-1 :background nil :foreground "gray27")
  '(ivy-minibuffer-match-face-2 :background nil :foreground "orchid")
  '(ivy-minibuffer-match-face-3 :background nil :foreground "turquoise")
  '(ivy-minibuffer-match-face-4 :background nil :foreground "DarkGoldenrod1")

  ;; org
  '(org-block :background "gray10")
  '(org-block-begin-line :background "gray10" :overline nil :underline nil)
  '(org-block-end-line :background "gray10" :overline nil :underline nil)

  ;; Comments and docstrings should always be green
  '(font-lock-comment-face :foreground "#329400")
  '(font-lock-doc-face :foreground "#329400")

  ;; Remove some additional syntax highlighting, keep it simple
  '(font-lock-function-name-face :foreground nil)
  '(font-lock-variable-name-face :foreground nil)
  '(font-lock-constant-face :foreground nil)
  '(font-lock-type-face :foreground nil)

  ;; Miscellaneous
  '(+workspace-tab-selected-face :background nil :foreground "#b294bb" :weight bold)
  '(show-paren-match :foreground "cyan" :underline "cyan" :weight bold)
  '(link :background nil :foreground "PaleTurquoise2" :weight bold :underline t)
  '(link-visited :background nil :foreground "maroon4" :weight bold :underline t)
  '(minibuffer-prompt :background nil :foreground "gold")
  '(nav-flash-face :background nil :weight regular :underline (:color "gold"))

  ;; git-gutter-fringe
  '(git-gutter-fr:added :foreground "green4")
  '(git-gutter-fr:modified :foreground "burlywood2")
  '(git-gutter-fr:deleted :foreground "firebrick3"))

;;
;;; Editor

;; I do like a blinking cursor
(blink-cursor-mode 1)

;; Treemacs
(after! doom-themes
  (remove-hook 'doom-load-theme-hook #'doom-themes-treemacs-config))

(after! treemacs
  (setq doom-themes-treemacs-enable-variable-pitch nil)
  (treemacs-resize-icons 12))

;; Git fringe
(after! git-gutter-fringe
  (fringe-mode 1))  ; thinest fringe possible

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
;;; Modeline

(use-package! anzu
  :after-call isearch-mode)

(use-package! evil-anzu
  :after-call evil-ex-start-search evil-ex-start-word-search evil-ex-search-activate-highlight
  :config (global-anzu-mode +1))

(defun zz/simple-mode-line-render (left right)
  "Allow rendering of mode-line with left and right parts"
  (let ((available-width
         (- (window-total-width)
            (+ (length (format-mode-line left))
               (length (format-mode-line right))))))
    (append left
            (list (format (format "%%%ds" available-width) ""))
            right)))

(setq-default mode-line-format
              '((:eval
                 (zz/simple-mode-line-render
                  (quote ("%e"  ; out of mem flag
                          evil-mode-line-tag
                          mode-line-modified
                          "%b"
                          vc-mode))
                  (quote ("%l:%c %p "
                          "(" mode-name ")"
                          (:eval (format-time-string " %a %d %b %H:%M "))))))))

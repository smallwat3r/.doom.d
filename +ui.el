;;; $DOOMDIR/+ui.el -*- lexical-binding: t; -*-

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
;;; Fonts

(setq doom-font (font-spec :family "MonacoB2" :size 13)
      doom-variable-pitch-font (font-spec :family "Geneva")
      doom-font-increment 1
      doom-big-font-increment 2)

(setq-default line-spacing 0)
(setq-default tab-width 8)

;;
;;; Themes config

;; Set up our default theme
(setq doom-theme 'sanityinc-tomorrow-bright)

(load! "+faces")

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
  (fringe-mode 1)

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
(after! writeroom-mode
  (setq +zen-window-divider-size global-window-divider-width
        +zen-text-scale 0))

;; Activate goto-address mode on some major modes
(add-hook! (prog-mode text-mode restclient-mode vterm-mode eshell-mode)
  (goto-address-mode t))

;; evil-goggles
;; doc: https://github.com/edkolev/evil-goggles
(after! evil-goggles
  (setq evil-goggles-duration 0.250)

  (custom-set-faces!
    '(evil-goggles-delete-face :background "#2f001a")
    '(evil-goggles-paste-face :background "#172f00")
    '(evil-goggles-yank-face :background "#363636")))

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

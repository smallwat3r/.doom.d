;;; smallwat3r/modeline/config.el -*- lexical-binding: t; -*-

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
     (beacon-mode nil beacon)
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

;;
;;; Set default modeline format

(setq-default mode-line-format
              '("%e"
                (:eval evil-mode-line-tag)
                mode-line-modified
                " %b "
                vc-mode
                "    "
                "%p (%l,%c)"
                "--"
                (:eval (format-time-string "%a %d %b %H:%M"))
                "--"
                mode-line-modes))

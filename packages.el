; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(package! exec-path-from-shell)
(package! mini-modeline)
(package! kubernetes)
(package! kubernetes-evil)
(package! jinja2-mode)
(package! dired-narrow)
(package! dired-subtree)
(package! ripgrep)
(package! scratch)
(package! esh-autosuggest)
(package! google-translate)
(package! lorem-ipsum)
(package! perfect-margin)
(package! git-gutter)
(package! git-gutter-fringe :disable t)

;;
;;; Themes

(package! modus-vivendi-theme)
(package! modus-operandi-theme)

(package! simplicity-theme :recipe
  (:host github
   :repo "smallwat3r/emacs-simplicity-theme"))

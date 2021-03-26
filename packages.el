;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(disable-packages!
 solaire-mode
 evil-snipe
 better-jumper)

(package! exec-path-from-shell)

(package! mini-modeline)

(package! kubernetes)
(package! kubernetes-evil)

(package! jinja2-mode)

(package! dired-narrow)
(package! dired-subtree)

(package! deadgrep)

(package! scratch)

(package! esh-autosuggest)

(package! google-translate)
(package! google-this)

(package! lorem-ipsum)

(package! all-the-icons-ivy-rich)

(package! simplicity-theme :recipe
  (:host github
   :repo "smallwat3r/emacs-simplicity-theme"))

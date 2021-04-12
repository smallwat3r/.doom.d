;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(disable-packages!
 solaire-mode
 better-jumper)

(package! exec-path-from-shell)

(package! kubernetes)
(package! kubernetes-evil)

(package! dired-narrow)
(package! dired-subtree)

(package! scratch)

(package! beacon)

(package! org-appear)

(package! google-translate)
(package! google-this)

(package! lorem-ipsum)

(package! all-the-icons-ivy-rich)

(package! delight)

(package! anzu)
(package! evil-anzu)

(package! slack)
(package! alert)

(package! color-theme-sanityinc-tomorrow)
(package! simplicity-theme :recipe
  (:host github
   :repo "smallwat3r/emacs-simplicity-theme"))

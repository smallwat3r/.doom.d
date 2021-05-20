;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

(disable-packages!
 solaire-mode
 better-jumper
 lsp-ui)

(package! exec-path-from-shell)

(package! dired-narrow)
(package! dired-subtree)

(package! scratch)

(package! beacon)

(package! org-appear)

(package! lorem-ipsum)

(package! all-the-icons-ivy-rich)

(package! delight)

(package! anzu)
(package! evil-anzu)

(package! color-theme-sanityinc-tomorrow)
(package! simplicity-theme :recipe
  (:host github
   :repo "smallwat3r/emacs-simplicity-theme"))

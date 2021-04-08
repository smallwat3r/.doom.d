;;; init.el -*- lexical-binding: t; -*-

(setq comp-speed 2)  ; native compilation (gccEmacs)

(doom!
 :completion
 company
 (ivy +fuzzy)

 :ui
 deft
 doom
 doom-dashboard
 (emoji +unicode)
 hl-todo
 nav-flash
 ophints
 (popup +defaults)
 treemacs
 vc-gutter
 workspaces
 zen

 :editor
 (evil +everywhere)
 file-templates
 (fold +vimish-fold +evil-vimish-fold)
 format
 snippets

 :emacs
 (dired +icons)
 electric
 undo
 vc

 :term
 eshell
 vterm

 :checkers
 (spell +aspell)
 syntax

 :tools
 docker
 (eval +overlay)
 (lookup +dictionary +docsets)
 lsp
 magit
 make
 pass
 pdf
 rgb

 :os
 tty
 (:if IS-MAC macos)

 :lang
 cc
 (dart +lsp +flutter)
 emacs-lisp
 (go +lsp)
 (javascript +lsp)
 json
 (markdown +grip)
 (org +journal)
 (python +lsp)
 rest
 (sh +lsp)
 web
 yaml

 :email
 notmuch

 :config
 (default +bindings +smartparens))

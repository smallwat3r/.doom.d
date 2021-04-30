;;; smallwat3r/tree-sitter/config.el -*- lexical-binding: t; -*-

;; doc: https://ubolonton.github.io/emacs-tree-sitter

(use-package! tree-sitter
  :custom-face
  (tree-sitter-hl-face:property ((t (:slant normal))))
  (tree-sitter-hl-face:method.call ((t (:foreground nil))))
  (tree-sitter-hl-face:function.call ((t (:foreground nil))))
  (tree-sitter-hl-face:label ((t (:foreground nil))))
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package! tree-sitter-langs
  :after tree-sitter)

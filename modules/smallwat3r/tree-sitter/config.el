;;; smallwat3r/tree-sitter/config.el -*- lexical-binding: t; -*-

;; doc: https://ubolonton.github.io/emacs-tree-sitter

(use-package! tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package! tree-sitter-langs
  :after tree-sitter
  :config
  ;; Deactivate theming on some nodes
  (add-function :before-while tree-sitter-hl-face-mapping-function
                (lambda (capture-name)
                  (not (string= capture-name "property"))))
  (add-function :before-while tree-sitter-hl-face-mapping-function
                (lambda (capture-name)
                  (not (string= capture-name "method.call"))))
  (add-function :before-while tree-sitter-hl-face-mapping-function
                (lambda (capture-name)
                  (not (string= capture-name "function.call"))))
  (add-function :before-while tree-sitter-hl-face-mapping-function
                (lambda (capture-name)
                  (not (string= capture-name "label")))))

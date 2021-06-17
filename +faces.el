;;; $DOOMDIR/+faces.el -*- lexical-binding: t; -*-

(custom-set-faces!
  '(default-inverse :background default :inverse-video t)

  '(cursor :background "#d7ff00")
  '(show-paren-match :foreground "#d7ff00" :background "#ff5f5f" :slant normal :box nil)
  '(show-paren-mismatch :foreground "#ffffff" :background "#db0000" :slant normal :box nil)
  '(link :background nil :foreground "DarkGoldenrod3" :weight regular :underline t)
  '(link-visited :background nil :foreground "DarkGoldenrod4" :weight regular :underline t)

  ;; Remove some additional code syntax highlighting, keep it simple
  '(font-lock-function-name-face :foreground nil)
  '(font-lock-variable-name-face :foreground nil)
  '(font-lock-constant-face :foreground nil)
  '(font-lock-type-face :foreground nil)

  ;; We then need to remap the colors from web-mode
  '(web-mode-html-attr-equal-face :inherit font-lock-keyword-face)
  '(web-mode-html-attr-name-face :inherit font-lock-keyword-face)
  '(web-mode-html-tag-face :inherit font-lock-keyword-face)
  '(web-mode-html-tag-bracket-face :inherit font-lock-builtin-face)

  ;; Make diff-refine less aggressive
  '(magit-diff-added-highlight :weight regular)
  '(magit-diff-removed-highlight :weight regular)
  '(magit-diff-base-highlight :weight regular)
  '(diff-refine-added :inherit magit-diff-added-highlight :inverse-video nil :weight bold)
  '(diff-refine-removed :inherit magit-diff-removed-highlight :inverse-video nil :weight bold)
  '(diff-refine-changed :inverse-video nil :weight bold)

  ;; Comments and docstrings colors
  '(font-lock-comment-face :foreground "#2e8900" :slant normal)
  '(font-lock-comment-delimiter-face :foreground "#0a4700" :slant normal)
  '(font-lock-doc-face :foreground "#2e8900" :slant normal)

  ;; Keep company really simple
  '(company-preview :background "moccasin" :foreground "black")
  '(company-preview-common :foreground "darkred")
  '(company-preview-search :foreground "darkred")
  '(company-tooltip :foreground "black" :background "moccasin")
  '(company-tooltip-selection :inverse-video nil :background "light blue" :foreground "black")
  '(company-tooltip-common :foreground "darkred")
  '(company-tooltip-common-selection :foreground "darkred")
  '(company-tooltip-search :background "tan1")
  '(company-tooltip-search-selection :background "tan1")
  '(company-tooltip-mouse :background "tan1")
  '(company-tooltip-annotation :foreground "firebrick4")
  '(company-tooltip-annotation-selection :foreground "firebrick4")
  '(company-scrollbar-bg :background "moccasin")
  '(company-scrollbar-fg :background "darkred")
  '(company-echo-common :foreground "firebrick4"))

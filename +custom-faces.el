;;; $DOOMDIR/+custom-faces.el -*- lexical-binding: t; -*-

(custom-set-faces!
  '((default term) :foreground "black" :background "cornsilk")
  '(link :background nil :foreground "LightSeaGreen" :underline t)
  '(link-visited :background nil :foreground "DeepSkyBlue4" :underline t)
  '(minibuffer-prompt :background nil :foreground "maroon4")
  '(fringe :background "#EAFFFF")
  '(region :background "#eeee9e")
  '((isearch lazy-highlight) :background "yellow" :foreground nil)
  '(magit-diff-context-highlight :background nil)

  ;; Modeline
  '(mode-line
    :foreground nil
    :background "PaleTurquoise2"
    :box nil
    :inherit variable-pitch)
  '(mode-line-inactive
    :foreground nil
    :background "azure"
    :box nil
    :inherit variable-pitch)

  ;; Remove some code syntax highlighting, keep it simple
  '((font-lock-function-name-face
     font-lock-variable-name-face
     font-lock-constant-face
     font-lock-type-face)
    :foreground nil)

  ;; But we then need to re-map some of the colors from web-mode, just so we can have
  ;; some syntax highlighting when reading HTML code
  '(web-mode-html-attr-equal-face :inherit font-lock-keyword-face)
  '(web-mode-html-attr-name-face :inherit font-lock-keyword-face)
  '(web-mode-html-tag-face :inherit font-lock-keyword-face)
  '(web-mode-html-tag-bracket-face :inherit font-lock-builtin-face)

  ;; Comments and docstrings colors
  '(font-lock-comment-delimiter-face :foreground "#AF8700" :slant normal :weight bold)
  '(font-lock-comment-face :foreground "#AF8700" :slant normal)

  ;; Keep company really simple
  '(company-preview
    :background "wheat"
    :foreground "black")
  '((company-preview-common
     company-preview-search)
    :foreground "darkred")
  '(company-tooltip
    :foreground "black"
    :background "wheat")
  '(company-tooltip-selection
    :inverse-video nil
    :background "light blue"
    :foreground "black")
  '((company-tooltip-common
     company-tooltip-common-selection)
    :foreground "darkred")
  '((company-tooltip-search
     company-tooltip-mouse
     company-tooltip-search-selection)
    :background "tan1")
  '((company-tooltip-annotation
     company-tooltip-annotation-selection)
    :foreground "firebrick4")
  '(company-scrollbar-bg :background "wheat")
  '(company-scrollbar-fg :background "darkred")
  '(company-echo-common :foreground "firebrick4")

  ;; org / markdown
  '((org-column org-column-title org-hide org-indent) :background nil)
  '(org-block :background "honeydew")

  ;; markdown
  '((markdown-pre-face markdown-code-face) :background "honeydew")
  '((markdown-inline-code-face markdown-language-keyword-face) :background nil)

  ;; git-gutter-fr
  '(git-gutter-fr:added :foreground "LimeGreen")
  '(git-gutter-fr:modified :foreground "DarkTurquoise")
  '(git-gutter-fr:deleted :foreground "OrangeRed"))

;;; $DOOMDIR/+custom-faces.el -*- lexical-binding: t; -*-

(custom-set-faces!
  '((default term) :foreground "black" :background "cornsilk")
  '(font-lock-comment-delimiter-face :foreground "#AF8700" :slant normal :weight bold)
  '(font-lock-comment-face :foreground "#AF8700" :slant normal)

  '(link :background unspecified :foreground "LightSeaGreen" :underline t)
  '(link-visited :background unspecified :foreground "DeepSkyBlue4" :underline t)

  '(minibuffer-prompt :background unspecified :foreground "maroon4")
  '(fringe :background "azure")
  '(region :background "#eeee9e")

  '(magit-diff-context-highlight :background unspecified)
  '((magit-section-highlight magit-diff-file-heading-highlight) :background "honeydew")
  '(magit-diff-hunk-heading :background "grey28" :foreground "grey98")
  '(magit-diff-hunk-heading-highlight :background "turquoise2" :foreground "black")

  '(mode-line
    :foreground  unspecified
    :background "PaleTurquoise2"
    :box nil
    :inherit variable-pitch)
  '(mode-line-inactive
    :foreground unspecified
    :background "azure"
    :box nil
    :inherit variable-pitch)

  ;; Search stuff
  '((isearch
     lazy-highlight
     evil-ex-lazy-highlight
     evil-ex-search)
    :background "yellow" :foreground "black")
  '(evil-ex-substitute-matches :background "salmon" :foreground "black")

  ;; Remove some code syntax highlighting, keep it simple
  '((font-lock-function-name-face
     font-lock-variable-name-face
     font-lock-constant-face
     font-lock-type-face)
    :foreground unspecified)

  ;; But we then need to re-map some of the colors from web-mode, just so we can have
  ;; some syntax highlighting when reading HTML code
  '(web-mode-html-attr-equal-face :inherit font-lock-keyword-face)
  '(web-mode-html-attr-name-face :inherit font-lock-keyword-face)
  '(web-mode-html-tag-face :inherit font-lock-keyword-face)
  '(web-mode-html-tag-bracket-face :inherit font-lock-builtin-face)

  ;; company
  '(company-preview
    :background "cornsilk2"
    :foreground "black")
  '((company-preview-common
     company-preview-search)
    :foreground "darkred")
  '(company-tooltip
    :foreground "black"
    :background "cornsilk2")
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
  '(company-scrollbar-bg :background "cornsilk2")
  '(company-scrollbar-fg :background "darkred")
  '(company-echo-common :foreground "firebrick4")

  ;; org
  '((org-column org-column-title org-hide org-indent) :background unspecified)
  '(org-block :background "honeydew")

  ;; markdown
  '((markdown-pre-face markdown-code-face) :background "honeydew")
  '((markdown-inline-code-face markdown-language-keyword-face) :background unspecified)

  ;; git-gutter-fr
  '(git-gutter-fr:added :foreground "LimeGreen")
  '(git-gutter-fr:modified :foreground "DarkTurquoise")
  '(git-gutter-fr:deleted :foreground "OrangeRed"))

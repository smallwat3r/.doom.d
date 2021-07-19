;;; $DOOMDIR/+custom-faces.el -*- lexical-binding: t; -*-

(custom-set-faces!
  '(default :inherit nil :extend nil :stipple nil :background "#fdf5e6"
     :foreground "black" :inverse-video nil :box nil :strike-through nil
     :overline nil :underline nil :slant normal :weight normal :height 1
     :width normal :foundry "default" :family "default")

  '(term :background unspecified)

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
    :background "cornsilk"
    :foreground "black"
    :inherit fixed-pitch)
  '((company-preview-common
     company-preview-search)
    :foreground "darkred"
    :inherit fixed-pitch)
  '(company-tooltip
    :foreground "black"
    :background "cornsilk"
    :inherit fixed-pitch)
  '(company-tooltip-selection
    :inverse-video nil
    :background "light blue"
    :foreground "black"
    :inherit fixed-pitch)
  '((company-tooltip-common
     company-tooltip-common-selection)
    :foreground "darkred"
    :inherit fixed-pitch)
  '((company-tooltip-search
     company-tooltip-mouse
     company-tooltip-search-selection)
    :background "tan1"
    :inherit fixed-pitch)
  '((company-tooltip-annotation
     company-tooltip-annotation-selection)
    :foreground "firebrick4"
    :inherit fixed-pitch)
  '(company-scrollbar-bg :background "cornsilk" :inherit fixed-pitch)
  '(company-scrollbar-fg :background "darkred" :inherit fixed-pitch)
  '(company-echo-common :foreground "firebrick4" :inherit fixed-pitch)

  ;; dired-subtree
  '(,(cl-loop for i from 0 to 6 collect (intern (format "dired-subtree-depth-%d-face" i)))
    :background unspecified)

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

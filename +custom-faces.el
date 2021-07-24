;;; $DOOMDIR/+custom-faces.el -*- lexical-binding: t; -*-

(custom-set-faces!
  '(cursor :background "white")
  '(term :background unspecified)

  '(font-lock-comment-delimiter-face :foreground "chartreuse4" :slant normal :weight bold)
  '(font-lock-comment-face :foreground "chartreuse4" :slant normal)

  '(magit-diff-context-highlight :background unspecified)
  '(magit-diff-hunk-heading :background "grey28" :foreground "grey98")
  '(magit-diff-hunk-heading-highlight :background "turquoise2" :foreground "black")

  '(show-paren-match :background "goldenrod1" :foreground "black")
  '(show-paren-mismatch :background "red2" :foreground "white")

  '(mode-line
    :foreground "white"
    :background "grey22"
    :inherit variable-pitch
    :box (:line-width 1 :color "gray48"))
  '(mode-line-inactive
    :foreground "gray48"
    :background "grey9"
    :inherit variable-pitch
    :box (:line-width 1 :color "gray48"))

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
    :background "honeydew1"
    :foreground "black"
    :inherit fixed-pitch)
  '((company-preview-common
     company-preview-search)
    :foreground "darkred"
    :inherit fixed-pitch)
  '(company-tooltip
    :foreground "black"
    :background "honeydew1"
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
  '(company-scrollbar-bg :background "honeydew1" :inherit fixed-pitch)
  '(company-scrollbar-fg :background "darkred" :inherit fixed-pitch)
  '(company-echo-common :foreground "firebrick4" :inherit fixed-pitch)

  ;; dired-subtree
  '(,(cl-loop for i from 0 to 6 collect (intern (format "dired-subtree-depth-%d-face" i)))
    :background unspecified)

  ;; git-gutter-fr
  '(git-gutter-fr:added :foreground "LimeGreen")
  '(git-gutter-fr:modified :foreground "DarkTurquoise")
  '(git-gutter-fr:deleted :foreground "OrangeRed"))

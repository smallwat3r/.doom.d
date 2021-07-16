;;; $DOOMDIR/+custom-faces.el -*- lexical-binding: t; -*-

(custom-set-faces!
  '((default term) :foreground "#000000" :background "#FFFFD7")

  '(link :background nil :foreground "#007777" :underline t)
  '(link-visited :background nil :foreground "#004d4d" :underline t)
  '(minibuffer-prompt :background nil :foreground "#76006b")
  '(fringe :background "#EAFFFF")
  '(region :background "#eeee9e")

  ;; Search
  '((isearch lazy-highlight) :background "yellow" :foreground nil)

  ;; Modeline
  '(mode-line
    :foreground nil
    :background "#AEEEEE"
    :box nil
    :inherit variable-pitch)
  '(mode-line-inactive
    :foreground nil
    :background "#EAFFFF"
    :box nil
    :inherit variable-pitch)

  ;; Remove some additional code syntax highlighting, keep it simple
  '((font-lock-function-name-face
     font-lock-variable-name-face
     font-lock-constant-face
     font-lock-type-face)
    :foreground nil)

  ;; We then need to remap the colors from web-mode
  '(web-mode-html-attr-equal-face :inherit font-lock-keyword-face)
  '(web-mode-html-attr-name-face :inherit font-lock-keyword-face)
  '(web-mode-html-tag-face :inherit font-lock-keyword-face)
  '(web-mode-html-tag-bracket-face :inherit font-lock-builtin-face)

  ;; Make diff-refine less aggressive
  '((magit-diff-added-highlight
     magit-diff-removed-highlight
     magit-diff-base-highlight)
    :weight normal)
  '((diff-refine-added diff-refine-removed)
    :inherit magit-diff-added-highlight :inverse-video nil :weight bold)
  '(diff-refine-changed :inverse-video nil :weight bold)

  ;; Comments and docstrings colors
  '(font-lock-comment-delimiter-face :foreground "#AF8700" :slant normal :weight bold)
  '(font-lock-comment-face :foreground "#AF8700" :slant normal)

  ;; Keep company really simple
  '(company-preview
    :background "cornsilk"
    :foreground "black")
  '((company-preview-common
     company-preview-search)
    :foreground "darkred")
  '(company-tooltip
    :foreground "black"
    :background "cornsilk")
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
  '(company-scrollbar-bg :background "cornsilk")
  '(company-scrollbar-fg :background "darkred")
  '(company-echo-common :foreground "firebrick4")

  ;; org
  '((org-column org-column-title org-hide org-indent) :background nil)

  ;; Rainbow delimiters
  '(rainbow-delimiters-depth-1-face :foreground "#000000" :background nil)
  '((rainbow-delimiters-depth-2-face rainbow-delimiters-depth-6-face)
    :foreground "#1054AF" :background nil)
  '((rainbow-delimiters-depth-3-face rainbow-delimiters-depth-7-face)
     :foreground "#555599" :background nil)
  '((rainbow-delimiters-depth-4-face rainbow-delimiters-depth-8-face)
    :foreground "#005500" :background nil)
  '((rainbow-delimiters-depth-5-face rainbow-delimiters-depth-9-face)
    :foreground "#007777" :background nil)

  ;; git-gutter-fr
  '(git-gutter-fr:added :foreground "#06c100")
  '(git-gutter-fr:modified :foreground "#d000c7")
  '(git-gutter-fr:deleted :foreground "#f60000"))

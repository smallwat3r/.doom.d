;;; $DOOMDIR/+custom-faces.el -*- lexical-binding: t; -*-

;; Lets use a default theme as a base and override some faces to my liking

(setq doom-theme 'sanityinc-tomorrow-bright)

(custom-set-faces!
  '((term
     magit-diff-context-highlight
     flycheck-error
     flycheck-warning)
    :background unspecified)

  '(cursor :background "#d7ff00")

  '(link :background nil :foreground "DarkGoldenrod3" :weight regular :underline t)
  '(link-visited :background nil :foreground "DarkGoldenrod4" :weight regular :underline t)

  '(font-lock-comment-delimiter-face :foreground "#0a4700" :slant normal :weight bold)
  '((font-lock-doc-face font-lock-comment-face) :foreground "#2e8900" :slant normal)

  '(diff-refine-added :inherit magit-diff-added-highlight :inverse-video nil :weight bold)
  '(diff-refine-removed :inherit magit-diff-removed-highlight :inverse-video nil :weight bold)
  '(diff-refine-changed :inverse-video nil :weight bold)

  '(git-gutter-fr:added :inherit diff-added)
  '(git-gutter-fr:modified :inherit diff-changed)
  '(git-gutter-fr:deleted :inherit diff-removed)

  '((show-paren-match show-paren-match-expression) :background "grey83")

  '(mode-line :foreground "white" :background "grey15" :box nil)
  '(mode-line-inactive :foreground "grey19" :background "grey5" :box nil)

  '((org-block org-verbatim) :inherit fixed-pitch)
  '((org-block-end-line org-block-begin-line) :inherit org-block :foreground "SlateGrey")

  '(slack-preview-face :background unspecified)
  '((slack-mrkdwn-code-face slack-mrkdwn-code-block-face)
    :foreground "grey51" :inherit fixed-pitch)

  ;; Keep company really simple
  '(company-preview :background "moccasin" :foreground "black")
  '((company-preview-common company-preview-search) :foreground "darkred")
  '(company-tooltip :foreground "black" :background "moccasin")
  '(company-tooltip-selection :inverse-video nil :background "light blue" :foreground "black")
  '((company-tooltip-common company-tooltip-common-selection) :foreground "darkred")
  '((company-tooltip-search company-tooltip-search-selection) :background "tan1")
  '(company-tooltip-mouse :background "tan1")
  '((company-tooltip-annotation company-tooltip-annotation-selection) :foreground "firebrick4")
  '(company-scrollbar-bg :background "moccasin")
  '(company-scrollbar-fg :background "darkred")
  '(company-echo-common :foreground "firebrick4")

  '((org-column org-column-title org-hide org-indent) :background unspecified)
  '((org-block markdown-pre-face) :inherit fixed-pitch)
  '((org-block-end-line org-block-begin-line markdown-markup-face) :slant normal :inherit fixed-pitch)

  ;; Remove some code syntax highlighting, keep it simple, but we then need to re-map some
  ;; of the colors from web-mode, just so we can have some syntax highlighting when reading
  ;; HTML code
  '((font-lock-function-name-face
     font-lock-variable-name-face
     font-lock-constant-face
     font-lock-type-face)
    :foreground unspecified)
  '(web-mode-html-attr-equal-face :inherit font-lock-keyword-face)
  '(web-mode-html-attr-name-face :inherit font-lock-keyword-face)
  '(web-mode-html-tag-face :inherit font-lock-keyword-face)
  '(web-mode-html-tag-bracket-face :inherit font-lock-builtin-face))

;;; $DOOMDIR/+custom-faces.el -*- lexical-binding: t; -*-

;; Lets use a default theme as a base and override some faces to my liking

(setq doom-theme 'doom-solarized-dark
      doom-themes-enable-bold nil
      doom-themes-enable-italic nil)

(custom-set-faces!
  '((term
     magit-diff-context-highlight
     flycheck-error
     flycheck-warning)
    :background unspecified)

  '(font-lock-comment-face :slant normal)
  '(font-lock-comment-delimiter-face :slant normal :weight bold)

  '(diff-refine-added :inherit magit-diff-added-highlight :inverse-video nil :weight bold)
  '(diff-refine-removed :inherit magit-diff-removed-highlight :inverse-video nil :weight bold)
  '(diff-refine-changed :inverse-video nil :weight bold)

  '((show-paren-match show-paren-match-expression) :background "grey83")

  '((lazy-highlight
     lsp-face-highlight-read
     lsp-face-highlight-textual
     lsp-face-highlight-write
     magit-header-line)
    :foreground "gray64")

  '(org-block :inherit fixed-pitch)
  '((org-block-end-line org-block-begin-line) :inherit org-block :foreground "SlateGrey")

  '(slack-preview-face :background unspecified)
  '((slack-mrkdwn-code-face slack-mrkdwn-code-block-face)
    :foreground "grey51" :inherit fixed-pitch)

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

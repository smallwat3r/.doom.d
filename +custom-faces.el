;;; $DOOMDIR/+custom-faces.el -*- lexical-binding: t; -*-

;; Lets use a default theme as a base and override some faces to my liking

(setq doom-theme 'modus-vivendi)

(setq modus-themes-slanted-constructs nil
      modus-themes-bold-constructs nil
      modus-themes-syntax 'faint-yellow-comments
      modus-themes-region 'bg-only
      modus-themes-mode-line '3d
      modus-themes-org-blocks 'tinted-background
      modus-themes-completions 'opinionated
      modus-themes-paren-match 'intense-bold)

(custom-set-faces!
  '((term
     magit-diff-context-highlight
     flycheck-error
     flycheck-warning)
    :background unspecified)

  '(diff-refine-added :inherit magit-diff-added-highlight :inverse-video nil :weight bold)
  '(diff-refine-removed :inherit magit-diff-removed-highlight :inverse-video nil :weight bold)
  '(diff-refine-changed :inverse-video nil :weight bold)

  '(git-gutter-fr:added :inherit diff-added)
  '(git-gutter-fr:modified :inherit diff-changed)
  '(git-gutter-fr:deleted :inherit diff-removed)

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

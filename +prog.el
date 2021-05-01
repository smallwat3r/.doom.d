;;; $DOOMDIR/+email.el -*- lexical-binding: t; -*-

(after! lsp-mode
  (setq lsp-enable-file-watchers nil))

(after! flycheck
  ;; Pylint (python)
  (setq flycheck-python-pylint-executable "/usr/local/bin/pylint"
        flycheck-pylintrc "~/.config/pylintrc")
  (setq-hook! 'python-mode-hook flycheck-checker 'python-pylint)

  ;; Shellcheck (bash)
  (setq flycheck-shellcheck-excluded-warnings '("SC1091"))
  (setq-hook! 'sh-mode-hook flycheck-checker 'sh-shellcheck))

(after! spell-fu
  (setq spell-fu-idle-delay 0.5))

;; Force grammar spell checking to be turn on manually
(remove-hook! (text-mode) #'spell-fu-mode)

(after! sh-script
  (set-company-backend! 'sh-mode nil)  ; disable backend because of slowliness
  (set-formatter! 'shfmt "shfmt -i 2 -ci" :modes '(sh-mode)))

(after! python
  (setq python-shell-interpreter "/usr/local/opt/python@3.9/bin/python3.9")
  (set-formatter! 'black "black -q -l 100 -" :modes '(python-mode)))

(after! (:any html-mode web-mode)
  (set-formatter! 'html-tidy "tidy -q -indent -wrap 150" :modes '(html-mode web-mode)))

(after! (:any js-mode json-mode)
  (setq js-indent-level 2))

(after! js2-mode
  (setq-default indent-tabs-mode nil)
  (setq-default js2-basic-offset 2))

(after! web-mode
  (setq web-mode-indent-style 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-markup-indent-offset 2)

  (custom-set-faces!
    '(web-mode-html-attr-equal-face :foreground "gray60")
    '(web-mode-html-attr-name-face :foreground "gray60")
    '(web-mode-html-tag-face :foreground "gray60")
    '(web-mode-html-tag-bracket-face :foreground "gray45")))

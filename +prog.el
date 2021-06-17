;;; $DOOMDIR/+prog.el -*- lexical-binding: t; -*-

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
  (set-company-backend! 'sh-mode nil))  ; disable backend because of slowliness

(after! python
  python-shell-interpreter "/usr/local/opt/python@3.9/bin/python3.9")

(setq-hook! 'json-mode js-indent-level 2)

(setq-hook! 'js2-mode js2-basic-offset 2)

(setq-hook! 'web-mode-hook
  tab-width 2
  web-mode-markup-indent-offset 2
  web-mode-css-indent-offset 2
  web-mode-script-padding 2
  web-mode-style-padding 2)

(setq-hook! 'go-mode indent-tabs-mode t)

;;
;;; Formatters

(set-formatter! 'shfmt "shfmt -i 2 -ci" :modes '(sh-mode))
(set-formatter! 'black "black -q -l 100 -" :modes '(python-mode))
(set-formatter! 'prettier
  '("prettier"
    "--print-width" "120"
    ("--stdin-filepath" "%s" buffer-file-name)
    :modes '(js2-mode js-mode)))

(setq-hook! 'html-mode-hook +format-with :none)
(setq-hook! 'web-mode-hook +format-with :none)

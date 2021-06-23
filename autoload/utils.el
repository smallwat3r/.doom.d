;;; $DOOMDIR/autoload/utils.el -*- lexical-binding: t; -*-

;;;###autoload
(defun my/where-am-i ()
  "An interactive function showing function `buffer-file-name' or `buffer-name'."
  (interactive)
  (message (kill-new (if (buffer-file-name) (buffer-file-name) (buffer-name)))))

;;;###autoload
(defun my/arrayify (start end quote)
  "Turn strings on newlines into a QUOTEd, comma-separated one-liner."
  (interactive "r\nMQuote: ")
  (let ((insertion
         (mapconcat
          (lambda (x) (format "%s%s%s" quote x quote))
          (split-string (buffer-substring start end)) ", ")))
    (delete-region start end)
    (insert insertion)))

;;;###autoload
(defun my/locate-python-venv-path ()
  "Look for python virtual environments in the workspace"
  (interactive)
  (-when-let (venv-base-directory (locate-dominating-file default-directory "env/"))
    (concat venv-base-directory "env")))

;;;###autoload
(defun my/locate-python-venv-executable ()
  "Look for python executable in virtual environment"
  (interactive)
  (or (executable-find (f-expand "bin/python" (my/locate-python-venv-path)))
      (with-no-warnings (python-shell-interpreter))))

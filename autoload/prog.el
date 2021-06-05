;;; $DOOMDIR/autoload/prog.el -*- lexical-binding: t; -*-

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

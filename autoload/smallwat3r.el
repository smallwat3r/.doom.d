;;; $DOOMDIR/autoload/smallwat3r.el -*- lexical-binding: t; -*-

;;;###autoload
(defun zz/scroll-up ()
  "Scroll up by 3 lines."
  (interactive)
  (evil-scroll-line-up 3))

;;;###autoload
(defun zz/scroll-down ()
  "Scroll down by 3 lines."
  (interactive)
  (evil-scroll-line-down 3))

;;;###autoload
(defun zz/enlarge-window-horizontally ()
  "Enlarge window horizontally by 5 chars."
  (interactive)
  (enlarge-window-horizontally 5))

;;;###autoload
(defun zz/shrink-window-horizontally ()
  "Shrink window horizontally by 5 chars."
  (interactive)
  (shrink-window-horizontally 5))

;;;###autoload
(defun zz/enlarge-window ()
  "Enlarge window by 5 chars."
  (interactive)
  (enlarge-window 5))

;;;###autoload
(defun zz/shrink-window ()
  "Shrink window by 5 chars."
  (interactive)
  (shrink-window 5))

;;;###autoload
(defun zz/locate-python-venv-path ()
  "Look for python virtual environments in the workspace"
  (interactive)
  (-when-let (venv-base-directory (locate-dominating-file default-directory "env/"))
    (concat venv-base-directory "env")))

;;;###autoload
(defun zz/locate-python-venv-executable ()
  "Look for python executable in virtual environment"
  (interactive)
  (or (executable-find (f-expand "bin/python" (zz/locate-python-venv-path)))
      (with-no-warnings (python-shell-interpreter))))

;; https://news.ycombinator.com/item?id=22131815
;;;###autoload
(defun zz/arrayify (start end quote)
  "Turn strings on newlines into a QUOTEd, comma-separated one-liner."
  (interactive "r\nMQuote: ")
  (let ((insertion
         (mapconcat
          (lambda (x) (format "%s%s%s" quote x quote))
          (split-string (buffer-substring start end)) ", ")))
    (delete-region start end)
    (insert insertion)))

;; https://github.com/MatthewZMD/.emacs.d#where-am-i
;;;###autoload
(defun zz/where-am-i ()
  "An interactive function showing function `buffer-file-name' or `buffer-name'."
  (interactive)
  (message (kill-new (if (buffer-file-name) (buffer-file-name) (buffer-name)))))

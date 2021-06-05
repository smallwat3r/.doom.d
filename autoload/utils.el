;;; $DOOMDIR/autoload/utils.el -*- lexical-binding: t; -*-

;;;###autoload
(defun my/alacritty-here ()
  "Open alacritty from the current directory."
  (interactive "@")
  (shell-command
   (format "alacritty --working-directory %S >/dev/null 2>&1 & disown"
           default-directory)))

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

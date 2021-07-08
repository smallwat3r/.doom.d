;;; $DOOMDIR/autoload/utils.el -*- lexical-binding: t; -*-

;;;###autoload
(defun my/where-am-i ()
  "Show where I'm at."
  (interactive)
  (message (kill-new (if (buffer-file-name) (buffer-file-name) (buffer-name)))))

;;;###autoload
(defun my/arrayify (start end quote)
  "Turn strings on newlines into a comma-separated one-liner."
  (interactive "r\nMQuote: ")
  (let ((insertion
         (mapconcat
          (lambda (x) (format "%s%s%s" quote x quote))
          (split-string (buffer-substring start end)) ", ")))
    (delete-region start end)
    (insert insertion)))

;;;###autoload
(defun my/vterm/toggle-current-buffer ()
  "Toggles a terminal popup window to the directory of the current buffer."
  (interactive)
  (+vterm/toggle t))

;;;###autoload
(defun my/vterm/here-current-buffer ()
  "Open a terminal buffer in the current window to the directory of the current buffer."
  (interactive)
  (+vterm/here t))

;;;###autoload
(defun my/alacritty-here ()
  "Open alacritty from the current directory."
  (interactive "@")
  (shell-command
   (format "alacritty --working-directory %S >/dev/null 2>&1 & disown"
           default-directory)))

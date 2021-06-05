;;; $DOOMDIR/autoload/buffers.el -*- lexical-binding: t; -*-

;;;###autoload
(defun my/save-and-close-buffer ()
  "Save and close current buffer."
  (interactive)
  (save-buffer)
  (kill-this-buffer))

;;;###autoload
(defun my/count-buffers (&optional display-anyway)
  "Display or return the number of buffers."
  (interactive)
  (let ((buf-count (length (buffer-list))))
    (if (or (interactive-p) display-anyway)
        (message "%d buffers in total" buf-count))
    buf-count))

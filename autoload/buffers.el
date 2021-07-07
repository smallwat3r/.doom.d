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

;;;###autoload
(defun my/add-scratch-buffer-header (text)
  "Open scratch buffer with a header."
  (when scratch-buffer
    (save-excursion
      (goto-char (point-min))
      (insert text)
      (newline 2))
    (goto-char (point-max))))

;;;###autoload
(defun my/scratch-rest-mode ()
  "Open a scratch buffer with restclient."
  (interactive)
  (scratch 'restclient-mode))

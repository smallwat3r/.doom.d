;;; $DOOMDIR/+functions.el -*- lexical-binding: t; -*-

(defun zz/scroll-up ()
  "Scroll up by 3 lines."
  (interactive)
  (evil-scroll-line-up 3))

(defun zz/scroll-down ()
  "Scroll down by 3 lines."
  (interactive)
  (evil-scroll-line-down 3))

(defun zz/enlarge-window-horizontally ()
  "Enlarge window horizontally by 5 chars."
  (interactive)
  (enlarge-window-horizontally 5))

(defun zz/shrink-window-horizontally ()
  "Shrink window horizontally by 5 chars."
  (interactive)
  (shrink-window-horizontally 5))

(defun zz/enlarge-window ()
  "Enlarge window by 5 chars."
  (interactive)
  (enlarge-window 5))

(defun zz/shrink-window ()
  "Shrink window by 5 chars."
  (interactive)
  (shrink-window 5))

(defun zz/add-scratch-buffer-header (text)
  "Add an automatic header to a scratch buffer."
  (when scratch-buffer
    (save-excursion
      (goto-char (point-min))
      (insert text)
      (newline 2))
    (end-of-buffer)))

(defun zz/scratch-rest-mode ()
  "Start a scratch buffer in restclient-mode"
  (interactive)
  (scratch 'restclient-mode))

;; https://emacs.stackexchange.com/a/5583
(defun zz/insert-color-hex (&optional arg)
  "Select a color and insert its 24-bit hexadecimal RGB format.
With prefix argument \\[universal-argument] insert the 48-bit value."
  (interactive "*P")
  (let ((buf (current-buffer)))
    (list-colors-display
     nil nil `(lambda (name)
                (interactive)
                (quit-window)
                (with-current-buffer ,buf
                  (insert (apply #'color-rgb-to-hex
                                 (nconc (color-name-to-rgb name)
                                        (unless (consp ',arg)
                                          (list (or ,arg 2)))))))))))

;; https://news.ycombinator.com/item?id=22131815
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
(defun zz/where-am-i ()
  "An interactive function showing function `buffer-file-name' or `buffer-name'."
  (interactive)
  (message (kill-new (if (buffer-file-name) (buffer-file-name) (buffer-name)))))

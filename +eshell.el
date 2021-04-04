;;; $DOOMDIR/+eshell.el -*- lexical-binding: t; -*-

;; doc: https://www.gnu.org/software/emacs/manual/html_node/eshell/index.html

(use-package! shrink-path
  :after eshell
  :commands shrink-path-prompt)

(defun zz/eshell-current-git-branch ()
  "Get current branch name from repository."
  (let ((args '("symbolic-ref" "HEAD" "--short")))
    (with-temp-buffer
      (apply #'process-file "git" nil (list t nil) nil args)
      (unless (bobp)
        (goto-char (point-min))
        (buffer-substring-no-properties (point) (line-end-position))))))

(defun zz/eshell-prompt ()
  "Default Eshell prompt."
  (let ((base/dir (shrink-path-prompt default-directory))
        (base/branch (zz/eshell-current-git-branch)))
    (concat
                                        ; python venv
     (if (getenv "VIRTUAL_ENV")
         (let ((venv (file-name-nondirectory (getenv "VIRTUAL_ENV"))))
           (propertize (format "(%s) " venv) 'face 'default)))
                                        ; directory path
     (propertize (car base/dir) 'face 'font-lock-comment-face)
     (propertize (cdr base/dir) 'face 'default)
                                        ; git branch
     (if base/branch
         (propertize (format " (%s)" base/branch) 'face 'default))
                                        ; user / super user
     (propertize (if (= (user-uid) 0) " # " " → ") 'face 'default))))

;; Remove the virtual env variable once the env has been deactivated, it will
;; get recreated once we reactivate the env. It's used in our eshell prompt
;; so we need to remove it when not in use.
(add-hook! 'pyvenv-post-deactivate-hooks (lambda () (setenv "VIRTUAL_ENV" nil)))

(after! eshell
  ;; General
  (setq eshell-history-size 1000000
        eshell-buffer-maximum-lines 5000
        eshell-modify-global-environment t
        eshell-destroy-buffer-when-process-dies t)

  ;; Prompt settings
  (setq eshell-prompt-regexp "^.* [#→] "
        eshell-prompt-function #'zz/eshell-prompt)

  ;; List of eshell aliases
  (set-eshell-alias!
   "d" "dired $1"
   "clear" "clear-scrollback"
   "c" "clear-scrollback"
   "g" "git $*"
   "qq" "exit"
   "gs" "magit-status"
   "gc" "magit-commit"
   "gd" "magit-diff-unstaged"
   "gds" "magit-diff-staged"
   "..." "cd ../.."
   "...." "cd ../../.."
   "....." "cd ../../../.."
   "k" "kubectl $*"
   "kt" "kubetail $*"
   "kgn" "kubectl get namespaces"))

;;
;;; Custom Eshell functions

(defun eshell/cr ()
  "Go to git repository root."
  (eshell/cd (locate-dominating-file default-directory ".git")))

(defun eshell/md (dir)
  "mkdir and cd into directory."
  (eshell/mkdir dir)
  (eshell/cd dir))

(defun eshell/dots ()
  "cd into my dotfiles directory."
  (eshell/cd "~/dotfiles"))

(defun eshell/sl (&rest args)
  "same as ls."
  (eshell/ls args))

(defun eshell/o ()
  "Open in finder."
  (+macos/reveal-in-finder))

(defun eshell/deactivate ()
  "Deactivate a python venv."
  (pyvenv-deactivate))

(defun eshell/activate (&optional env)
  "Activate a python venv."
  (if env
      (pyvenv-activate env)
    (pyvenv-activate "env")))

(defun eshell/e (&rest args)
  "Invoke `find-file' on the file.
\"e +42 foo\" also goes to line 42 in the buffer."
  (while args
    (if (string-match "\\`\\+\\([0-9]+\\)\\'" (car args))
        (let* ((line (string-to-number (match-string 1 (pop args))))
               (file (pop args)))
          (find-file file)
          (forward-line line))
      (find-file (pop args)))))

(defun eshell/extract (file)
  "Extract archive file."
  (let ((command
         (some (lambda (x)
                 (if (string-match-p (car x) file)
                     (cadr x)))
               '((".*\.tar.bz2" "tar xjf")
                 (".*\.tar.gz" "tar xzf")
                 (".*\.bz2" "bunzip2")
                 (".*\.rar" "unrar x")
                 (".*\.gz" "gunzip")
                 (".*\.tar" "tar xf")
                 (".*\.tbz2" "tar xjf")
                 (".*\.tgz" "tar xzf")
                 (".*\.zip" "unzip")
                 (".*\.Z" "uncompress")
                 (".*" "echo 'Could not extract the file:'")))))
    (eshell-command-result (concat command " " file))))

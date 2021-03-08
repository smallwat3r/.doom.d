;;; $DOOMDIR/+bindings.el -*- lexical-binding: t; -*-

;; Make sure M-3 prints a hash symbol
(map! (:map key-translation-map "M-3" "#"))

;;
;;; evil-mode

(map!
 (:map evil-normal-state-map
  ;; Scrollin
  "C-2"   #'zz/scroll-up
  "C-1"   #'zz/scroll-down
  "C-y"   #'zz/scroll-up
  "C-e"   #'zz/scroll-down

  ;; Shrink and enlarge windows
  "S-C-h" #'shrink-window-horizontally
  "S-C-l" #'enlarge-window-horizontally
  "S-C-k" #'enlarge-window
  "S-C-j" #'shrink-window

  ;; Toggle spacing options
  "M-SPC" #'cycle-spacing

  ;; Delete blank lines below cursor position
  "M-o"   #'delete-blank-lines

  ;; Cycle through frames
  "M-`"   #'other-frame

  ;; Auto-format
  ";f"    #'format-all-buffer

  ;; General actions (write, save, close etc)
  ";w"    #'evil-write
  ";x"    #'evil-save
  ";q"    #'evil-save-and-close

  ;; Splitting current buffer
  ";vs"   #'evil-window-vsplit ; vertical
  ";sp"   #'evil-window-split  ; horizontal

  ;; Create new window (split screen)
  ";vw"   #'evil-window-vnew   ; vertical
  ";sw"   #'evil-window-new    ; horizontal

  ;; Clear search highlights
  ";,"    #'evil-ex-nohighlight)

 ;; Join lines instead of deleting region
 (:map (evil-insert-state-map evil-normal-state-map)
  "M-k"   #'evil-join))

;;
;;; Buffers

(map!
 (:leader
  (:prefix "b"
   :desc "Kill buffer" "d" #'evil-delete-buffer)))

;;
;;; Open stuff

(map!
 (:leader
  (:prefix "o"
   :desc "Emails"                   "m" #'notmuch
   :desc "Browse URL"               "u" #'browse-url-at-point
   :desc "Reveal in Finder"         "o" #'+macos/reveal-in-finder
   :desc "Reveal project in Finder" "O" #'+macos/reveal-project-in-finder)))

;;
;;; Toggle stuff

(map!
 (:leader
  (:prefix "t"
   :desc "Rainbow mode" "c" #'rainbow-mode)))

;;
;;; Docker

(map!
 (:leader
  (:prefix ("d" . "docker")
   :desc "List images"     "i" #'docker-images
   :desc "List containers" "c" #'docker-containers
   :desc "Exec into"       "e" #'docker-container-shell)))

;;
;;; Python

(map!
 (:map python-mode-map
  :after python
  :localleader
  (:prefix ("v" . "venv")  ; virtual env
   :desc "Workon"            "w" #'pyvenv-workon
   :desc "Activate pyvenv"   "a" #'pyvenv-activate
   :desc "Deactivate pyvenv" "d" #'pyvenv-deactivate)))

;;
;;; deft

(map!
 (:leader
  (:prefix "n"
   :desc "Deft open" "D" #'deft
   :desc "Deft new"  "d" #'deft-new-file)))

;;
;;; kubernetes

(map!
 (:leader
  (:prefix ("k" . "kubernetes")
   :desc "Overview"           "o" #'kubernetes-overview
   :desc "Set context"        "c" #'kubernetes-use-context
   :desc "Set namespace"      "n" #'kubernetes-set-namespace
   :desc "Display logs"       "l" #'kubernetes-logs-fetch-all
   :desc "Display service"    "s" #'kubernetes-display-service
   :desc "Display deployment" "d" #'kubernetes-display-deployment
   :desc "Describe"           "D" #'kubernetes-describe-pod
   :desc "Exec into"          "e" #'kubernetes-exec-into)))

;;
;;; flycheck

(map!
 (:leader
  (:prefix ("e" . "errors")
   :desc "Flycheck list errors"    "l" #'flycheck-list-errors
   :desc "Flycheck next error"     "n" #'flycheck-next-error
   :desc "Flycheck previous error" "p" #'flycheck-previous-error
   :desc "Flycheck explain error"  "e" #'flycheck-explain-error-at-point
   :desc "Flycheck verify setup"   "v" #'flycheck-verify-setup)))

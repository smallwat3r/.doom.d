;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;
;;; General

;; Disable confirmation prompt when exiting Emacs.
(setq confirm-kill-emacs nil)

;; Personal information
(setq user-full-name "Matthieu Petiteau"
      user-mail-address "mpetiteau.pro@gmail.com"
      user-mail-address-2 "matthieu@smallwatersolutions.com")

;; Some general settings
(setq evil-vsplit-window-right t
      evil-split-window-below t
      default-directory "~/"
      undo-limit 80000000
      evil-want-fine-undo t             ; fine grained undo history
      inhibit-compacting-font-caches t  ; improve general perfs
      scroll-margin 7                   ; top and bottom margins to trigger scroll
      which-key-idle-delay 0.2)         ; delay to show key bindings menu

;; My abbreviations. These are stored in abbrev.el
(setq abbrev-file-name (expand-file-name "abbrev.el" doom-private-dir))
(setq save-abbrevs 'silently)
(setq-default abbrev-mode t)

;; Custom File. File used by Emacs to cache some data relative to the config
(setq-default custom-file (expand-file-name ".custom.el" doom-private-dir))
(when (file-exists-p custom-file)
  (load custom-file))

;;
;;; Bindings

;; Make sure M-3 prints a hash symbol
(map! (:map key-translation-map "M-3" "#"))

(map!
 (:leader
  (:prefix "f" :desc "Cycle through frame" "j" #'other-frame)
  (:prefix "o" :desc "Open in Alacritty"   "a" #'my/alacritty-here)
  (:prefix "o" :desc "Open link at point"  "l" #'browse-url-at-point)))

(map!
 (:map evil-normal-state-map
  "C-2"   #'my/scroll-up
  "C-1"   #'my/scroll-down
  "S-C-h" #'my/enlarge-window-horizontally
  "S-C-l" #'my/shrink-window-horizontally
  "S-C-k" #'my/enlarge-window
  "S-C-j" #'my/shrink-window
  "M-SPC" #'cycle-spacing
  "M-o"   #'delete-blank-lines
  ";f"    #'format-all-buffer
  ";d"    #'my/save-and-close-buffer
  ";q"    #'evil-save-and-close
  ";w"    #'evil-write
  "C-k"   #'join-line
  "B"     #'beginning-of-line-text
  "E"     #'end-of-line))

;;
;;; Projectile

;; doc: https://github.com/bbatsov/projectile
;;      https://docs.projectile.mx/projectile/index.html
;;
;; Run `projectile-discover-projects-in-search-path' to autoload all the projects from the
;; `projectile-project-search-path' list.

(after! projectile
  (setq projectile-sort-order 'recentf
        projectile-mode-line-prefix "P"
        projectile-mode-line-function '(lambda () (format " P[%s]" (projectile-project-name)))
        projectile-ignored-projects '("~/" "/tmp" "~/Downloads")
        projectile-project-search-path '("~/dotfiles/" "~/Projects/" "~/Code/" "~/Github/")))

;;
;;; Ivy

;; doc: https://writequit.org/denver-emacs/presentations/2017-04-11-ivy.html#org121eea9
(after! ivy
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        +ivy-buffer-preview t)

  ;; Ask to pick an existing buffer when splitting the window
  (defadvice! prompt-for-buffer (&rest _)
    :after '(evil-window-split evil-window-vsplit)
    (+ivy/switch-buffer)))

;; doc: https://github.com/asok/all-the-icons-ivy
(use-package! all-the-icons-ivy-rich
  :after ivy-rich
  :custom (all-the-icons-ivy-rich-icon-size 1)
  :init (all-the-icons-ivy-rich-mode 1))

;;
;;; Dired

;; doc: https://www.emacswiki.org/emacs/DiredMode
;;      https://github.com/Fuco1/dired-hacks

(add-hook! 'dired-mode-hook 'dired-hide-details-mode)

(after! dired
  (setq delete-by-moving-to-trash t
        dired-listing-switches "-lat"))  ; sort by date

;; Narrowing searchs in dired
(use-package! dired-narrow
  :after dired
  :commands (dired-narrow-fuzzy)
  :init (map! :map dired-mode-map :n "/" #'dired-narrow-fuzzy))

;; Toggle directories with TAB in dired
(use-package! dired-subtree
  :after dired
  :commands (dired-subtree-toggle dired-subtree-cycle)
  :custom-face
  (dired-subtree-depth-1-face ((t (:background nil))))
  (dired-subtree-depth-2-face ((t (:background nil))))
  (dired-subtree-depth-3-face ((t (:background nil))))
  (dired-subtree-depth-4-face ((t (:background nil))))
  (dired-subtree-depth-5-face ((t (:background nil))))
  (dired-subtree-depth-6-face ((t (:background nil))))
  :init (map! :map dired-mode-map
              "<tab>" #'dired-subtree-toggle
              "<backtab>" #'dired-subtree-cycle))

;;
;;; Company

;; doc: https://www.emacswiki.org/emacs/CompanyMode
(after! company
  (setq company-idle-delay 0.1
        company-tooltip-limit 10
        company-minimum-prefix-length 1)

  ;; Company icons
  (setq company-format-margin-function #'company-text-icons-margin
        company-text-icons-format "%s "
        company-text-icons-add-background nil)

  (setq company-text-icons-mapping
        '((array "[" default-inverse)
          (boolean "1" default-inverse)
          (class "C" default-inverse)
          (color "#" default-inverse)
          (constant "c" default-inverse)
          (enum-member "e" default-inverse)
          (enum "e" default-inverse)
          (field "f" default-inverse)
          (file "F" default-inverse)
          (folder "D" default-inverse)
          (interface "i" default-inverse)
          (keyword "k" default-inverse)
          (method "m" default-inverse)
          (function "f" default-inverse)
          (module "{" default-inverse)
          (numeric "n" default-inverse)
          (operator "o" default-inverse)
          (parameter "p" default-inverse)
          (property "p" default-inverse)
          (ruler "r" default-inverse)
          (snippet "S" default-inverse)
          (string "s" default-inverse)
          (struct "%" default-inverse)
          (text "w" default-inverse)
          (value "v" default-inverse)
          (variable "v" default-inverse)
          (t "." default-inverse))))

;; Disable company in shell mode
(add-hook! 'shell-mode-hook (company-mode -1))

;;
;;; Vterm

;; doc: https://github.com/akermu/emacs-libvterm
(after! vterm
  (setq vterm-max-scrollback 6000)

  ;; Keep mode-line
  (remove-hook 'vterm-mode-hook #'hide-mode-line-mode)

  (defun my/vterm-delete-word ()
    "Delete a word in vterm."
    (interactive)
    (vterm-send-key (kbd "C-w")))

  ;; Bindings
  (map!
   :map vterm-mode-map :n "B" #'vterm-beginning-of-line
   :map vterm-mode-map :n "<return>" #'evil-insert-resume
   :map vterm-mode-map "<C-backspace>" #'my/vterm-delete-word))

;;
;;; Docker

(use-package! docker
  :commands (docker-images docker-containers docker-container-shell)
  :init
  (map!
   (:leader
    (:prefix ("d" . "docker")
     :desc "List images"     "i" #'docker-images
     :desc "List containers" "c" #'docker-containers
     :desc "Exec into"       "e" #'docker-container-shell))))

;;
;;; Org

(defvar my-notes-directory "~/org"
  "Where I'm storing my notes.")

;; deft
;; doc: https://github.com/jrblevin/deft
(after! deft
  (setq deft-directory my-notes-directory))

(map!
 (:leader
  (:prefix "n"
   :desc "Open deft" "d" #'deft
   :desc "Deft new file" "D" #'deft-new-file-named)))

;; org
;; doc: https://orgmode.org/manual/
(after! org
  (setq org-directory my-notes-directory
        org-hide-emphasis-markers t)

  (custom-set-faces!
    '(org-column :background nil)
    '(org-column-title :background nil)
    '(org-hide :background nil)
    '(org-indent :background nil)
    '(org-block :background "gray10")
    '(org-block-begin-line :background "gray10" :overline nil :underline nil :slant normal)
    '(org-block-end-line :background "gray10" :overline nil :underline nil :slant normal)))

;; doc: https://github.com/awth13/org-appear
(use-package! org-appear
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autoemphasis t)
  (org-appear-autolinks t)
  (org-appear-autosubmarkers t)
  (org-appear-autoentities t))

;; org-journal
;; doc: https://github.com/bastibe/org-journal
(after! org-journal
  (setq org-journal-dir (expand-file-name "journal/" my-notes-directory)
        org-journal-date-format "%A, %d %B %Y"
        org-journal-file-format "journal-%Y%m%d.org"))

;;
;;; Misc

;; grip-mode
(after! grip-mode
  (setq grip-github-user "smallwat3r"
        grip-github-password (+pass-get-secret "github/password")))

;; Scratch buffers
;; doc: https://github.com/ieure/scratch-el
(use-package! scratch
  :config
  (defun my/add-scratch-buffer-header (text)
    "Add an automatic header to a scratch buffer."
    (when scratch-buffer
      (save-excursion
        (goto-char (point-min))
        (insert text)
        (newline 2))
      (goto-char (point-max))))

  (defun my/scratch-rest-mode ()
    "Start a scratch buffer in restclient-mode"
    (interactive)
    (scratch 'restclient-mode))

  (map!
   (:leader
    (:prefix "o"
     :desc "Scratch buffer current mode" "x" #'scratch
     :desc "Scratch buffer restclient"   "h" #'my/scratch-rest-mode)))

  ;; Auto add headers on scratch buffers in specific modes
  (add-hook! 'org-mode-hook (my/add-scratch-buffer-header "#+TITLE: Scratch file"))
  (add-hook! 'sh-mode-hook (my/add-scratch-buffer-header "#!/usr/bin/env bash"))
  (add-hook! 'restclient-mode-hook (my/add-scratch-buffer-header "#\n# restclient\n#")))

;; lorem-ipsum
;; doc: https://github.com/jschaf/emacs-lorem-ipsum
(use-package! lorem-ipsum
  :commands (lorem-ipsum-insert-paragraphs
             lorem-ipsum-insert-sentences
             lorem-ipsum-insert-list)
  :init (map!
         (:leader
          (:prefix ("l" . "lorem ipsum")
           :desc "Insert paragraphs" "p" #'lorem-ipsum-insert-paragraphs
           :desc "Insert sentences"  "s" #'lorem-ipsum-insert-sentences
           :desc "Insert list"       "l" #'lorem-ipsum-insert-list))))

;;
;;; Load configs

(load! "+email")
(load! "+eshell")
(load! "+prog")
(load! "+ui")

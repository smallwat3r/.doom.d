;;; smallwat3r/slack/config.el -*- lexical-binding: t; -*-

;; slack
;; doc: https://github.com/yuya373/emacs-slack
(use-package slack
  :commands (slack-start)
  :custom
  (slack-buffer-emojify t)
  (slack-prefer-current-team t)
  :custom-face
  (slack-message-mention-face ((t (:background nil :foreground "aquamarine2" :weight bold))))
  (slack-message-mention-face ((t (:background nil :foreground "aquamarine2" :weight bold))))
  (slack-message-mention-keyword-face ((t (:background nil :foreground "purple1" :weight bold))))
  (slack-message-mention-me-face ((t (:background nil :foreground "gold" :weight bold))))
  (slack-mrkdwn-code-face ((t (:background nil :foreground "green3"))))
  (slack-mrkdwn-code-block-face ((t (:background nil :foreground "green3"))))
  :config
  (slack-register-team
   :default t
   :name (+pass-get-secret "slack/btl/name")
   :token (+pass-get-secret "slack/btl/token")
   :full-and-display-names t)

  (slack-register-team
   :name (+pass-get-secret "slack/sws/name")
   :token (+pass-get-secret "slack/sws/token")
   :full-and-display-names t)

  (evil-define-key 'normal slack-mode-map
    ",ra" 'slack-message-add-reaction
    ",rr" 'slack-message-remove-reaction
    ",rs" 'slack-message-show-reaction-users
    ",me" 'slack-message-edit
    ",md" 'slack-message-delete
    ",mu" 'slack-message-embed-mention
    ",mc" 'slack-message-embed-channel)

  (evil-define-key 'normal slack-edit-message-mode-map
    ",k" 'slack-message-cancel-edit
    ",mu" 'slack-message-embed-mention
    ",mc" 'slack-message-embed-channel))

;; doc: https://github.com/jwiegley/alert
(use-package alert
  :commands (alert)
  :custom (alert-default-style 'notifier))

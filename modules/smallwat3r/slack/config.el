;;; smallwat3r/slack/config.el -*- lexical-binding: t; -*-

;; Slack
;; doc: https://github.com/yuya373/emacs-slack

;; To get a token:
;;   - Open Chrome and sign into slack at https://my.slack.com/customize
;;   - From the dev tools console type: TS.boot_data.api_token

(use-package! slack
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
   :name "B"
   :token (+pass-get-secret "slack/b/token")
   :full-and-display-names t)

  (slack-register-team
   :name "S"
   :token (+pass-get-secret "slack/s/token")
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

;; Trigger alerts
;; doc: https://github.com/jwiegley/alert

(use-package! alert
  :commands (alert)
  :custom (alert-default-style 'notifier))

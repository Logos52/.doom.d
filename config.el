(setq user-full-name "Jay Cantimbuhan"
      user-mail-address "nxlogos@gmail.com")

;(unless (equal "Battery status not available"
;  (battery))
;  (display-battery-mode 1))                           ; On laptops it's nice to know how much power you have
                                        ;
(use-package doom-themes
  :ensure t
  :config
  ;; Global defaults
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t
        load-prefer-newer t
        doom-font (font-spec :family "Dank Mono" :size 14.0)
        ;doom-variable-pitch-font (font-spec :family "Roboto" :size 14)
        doom-variable-pitch-font (font-spec :family "Dank Mono" :size 14)
        doom-serif-font (font-spec :family "Libre Baskerville")
        doom-theme 'doom-oceanic-next
        display-line-numbers-type nil
        load-prefer-newer t
        +zen-text-scale 1
        writeroom-extra-line-spacing 0.3
        prettify-symbols-mode t
        scroll-error-top-bottom t)
  (custom-set-faces!
        '(font-lock-keyword-face :slant italic))

  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;(doom-themes-org-config)
  (solaire-global-mode +1)
  )

(autoload 'ffap-guesser "ffap")
(setq minibuffer-default-add-function
      (defun minibuffer-default-add-function+ ()
        (with-selected-window (minibuffer-selected-window)
          (delete-dups
           (delq nil
                 (list (thing-at-point 'symbol)
                       (thing-at-point 'list)
                       (ffap-guesser)
                       (thing-at-point-url-at-point)))))))

(require 'org)

(after! org
  (setq org-attach-dir-relative t))

(with-eval-after-load 'flycheck
  (flycheck-add-mode 'proselint 'org-mode))

(if (eq initial-window-system 'x)                 ; if started by emacs command or desktop file
        (toggle-frame-maximized))

(setq-default word-wrap t)
(setq fill-column 90
      visual-fill-column-width 90
      global-visual-fill-column-mode +1
      +global-word-wrap-mode +1)
(setq
 org-directory "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/"
 projectile-project-search-path '("~/Documents/Projects/")
 org-hugo-section "notes"
 org-hugo-base-dir "~/website/"
 fancy-splash-image "/Users/n1/Documents/Projects/Emacs/Images/emacs-e-logo.png"
 deft-directory "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/"
 display-line-numbers-type t
 deft-recursive t
 deft-extensions '("org" "txt")
 deft-default-extension "org"
 deft-use-filter-string-for-filename t
 deft-text-mode 'org-mode
 org-mode-hide-leading-stars t
 org-startup-with-inline-images t
 org-image-actual-width nil
 org-support-shift-select t
;;Evil mode revert
 evil-move-cursor-back nil
 evil-move-beyond-eol t
;;org-hugo export options
 org-hugo-front-matter-format "yaml"
 )

(use-package org-super-agenda
  :after org-agenda
  :init
  (setq org-super-agenda-groups '((:name "Today"
                                        :time-grid t
                                        :scheduled today)
                                  (:name "Due today"
                                        :deadline today)
                                  (:name "Important"
                                        :priority "A")
                                  (:name "Overdue"
                                        :deadline past)
                                  (:name "Due soon"
                                        :deadline future)
                                  (:name "Big Outcomes"
                                        :tag ""today"bo")
                                  ))

  :config
  (org-super-agenda-mode)
  )



;; CUA type customizations
(require 'simpleclip)
(setq simpleclip-mode 1)
(map! :gin "C-S-x" #'simpleclip-cut ;Was: C-x chord
      :gin "C-S-c" #'simpleclip-copy ;Was: C-x chord
      :gin "C-S-v" #'clipboard-yank ;freezing on Ubuntu: 'simpleclip-paste ;Was: C-x chord
      :gin "C-z" #'undo ; Was: enable Emacs state
      :gin "C-S-z" #'redo ;Was: C-x chor
      :gin "C-<tab>" #'switch-to-next-buffer ;Was: aya-create snippet
      :gin "C-S-<tab>" #'switch-to-prev-buffer ;Was: C-x chord
      :gin "C-q" #'kill-buffer ;Was: evil-window-map
      :gin "C-a" #'mark-whole-buffer ;Was: doom/backward-to-bol-or-indent
      )
(map! "C-s" #'save-buffer)
(map! "C-S-s" #'write-file)
(map! "C-S-p" #'execute-extended-command)

;; Org Journal -------------------
(use-package org-journal
  :custom
  (org-journal-dir "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/Journal/")
  (org-journal-date-prefix "#+title: ")
  (org-journal-date-format "%Y-%m-%d")
  (org-journal-time-prefix "* ")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-is-journal false))

;; Org Roam ---------------------------------------
;; ------------------------------------------------
(use-package! org-roam
  :init
  (setq org-roam-directory "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/Capture/"
        org-id-link-to-org-use-id t)
  :config
    (setq org-roam-completion-everywhere t)
    (org-roam-db-autosync-mode +1)
    (setq org-roam-capture-templates
     '(("d" "default" plain "%?"
       :immediate-finish t
      :if-new (file+head "${slug}.org"
                         "#+TITLE: ${title}\n#+hugo_lastmod: Time-stamp: <>\n\n")
      :unarrowed t)))
    (setq org-roam-mode-sections
        (list #'org-roam-backlinks-insert-section
              #'org-roam-reflinks-insert-section
              #'org-roam-unlinked-references-insert-section))
  (org-roam-setup)
  (org-roam-db-autosync-mode)
  (setq org-roam-v2-ack t)
    (add-hook 'org-roam-mode-hook #'turn-on-visual-line-mode)
   )
(setq org-id-extra-files (org-roam--list-files org-roam-directory))
;; --------------------------------------------------


;;  Code source: https://github.com/jrblevin/deft/issues/75
;;  "Parse the given FILE and CONTENTS and determine the title. If `deft-use-filename-as-title' is nil, the title is taken to be the first non-empty line of the FILE.  Else the base name of the FILE used as title."
(defun my/deft-parse-title (file contents)
      (let ((begin (string-match "^#\\+[tT][iI][tT][lL][eE]: .*$" contents)))
        (if begin
            (string-trim (substring contents begin (match-end 0)) "#\\+[tT][iI][tT][lL][eE]: *" "[\n\t ]+")
          (deft-base-filename file))))

(advice-add 'deft-parse-title :override #'my/deft-parse-title)

(setq deft-strip-summary-regexp
          (concat "\\("
                  "[\n\t]" ;; blank
                  "\\|^#\\+[[:alpha:]_]+:.*$" ;; org-mode metadata
                  "\\|^:PROPERTIES:\n\\(.+\n\\)+:END:\n"
                  "\\)"))

;; Misc -------------------
(defun org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (push arg args))
        (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

;(remove-hook 'text-mode-hook #'vi-tilde-fringe-mode)
;(remove-hook 'org-mode-hook #'vi-tilde-fringe-mode)

(add-hook 'before-save-hook 'time-stamp)
(add-hook 'markdown-mode-hook 'my/buffer-face-mode-variable)
(setq org-return-follows-link t)

;; Setting up Org md
(setq org-todo-keywords
    (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
            (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))

(setq org-todo-keyword-faces
    (quote (("TODO" :foreground "red" :weight bold)
            ("NEXT" :foreground "blue" :weight bold)
            ("DONE" :foreground "forest green" :weight bold)
            ("WAITING" :foreground "orange" :weight bold)
            ("HOLD" :foreground "magenta" :weight bold)
            ("CANCELLED" :foreground "forest green" :weight bold)
            ("MEETING" :foreground "forest green" :weight bold)
            ("PHONE" :foreground "forest green" :weight bold))))
(setq-default org-export-with-todo-keywords nil)

;; https://github.com/integral-dw/org-superstar-mode
;; remove keywords from org files & replace them with icons
(with-eval-after-load 'org-superstar
  (setq org-superstar-item-bullet-alist
        '((?* . ?•)
          (?+ . ?➤)
          (?- . ?•)))
  (setq org-superstar-headline-bullets-list '(?\s))
  (setq org-superstar-special-todo-items t)
  (setq org-superstar-remove-leading-stars t)
  (setq org-superstar-todo-bullet-alist
        '(("TODO" . ?☐)
          ("NEXT" . ?✒)
          ("HOLD" . ?✰)
          ("WAITING" . ?☕)
          ("CANCELLED" . ?✘)
          ("DONE" . ?✔)))
  (org-superstar-restart))
(setq org-ellipsis " ... ")
(setq org-hide-emphasis-markers t)

;;Org files, buffer face, general styles,
(defun my/buffer-face-mode-variable ()
  (interactive)
  (setq buffer-face-mode-face '(:family "Roboto"
                                :height 150
                                :width normal))
  (buffer-face-mode)
  )
;; ---
(defun my/set-general-faces-org ()
  (org-indent-mode -1)
  (my/buffer-face-mode-variable)
  (setq line-spacing 0.1
        org-pretty-entities t
        org-startup-indented t
        org-adapt-indentation nil)
  (variable-pitch-mode +1)
  (mapc
   (lambda (face) ;; Other fonts that require it are set to fixed-pitch.
     (set-face-attribute face nil :inherit 'fixed-pitch))
   (list 'org-block
         'org-table
         'org-verbatim
         'org-block-begin-line
         'org-block-end-line
         'org-meta-line
         'org-date
         'org-drawer
         'org-property-value
         'org-special-keyword
         'org-document-info-keyword))
  (mapc ;; This sets the fonts to a smaller size
   (lambda (face)
     (set-face-attribute face nil :height 0.8))
   (list 'org-document-info-keyword
         'org-block-begin-line
         'org-block-end-line
         'org-meta-line
         'org-drawer
         'org-property-value
         )))
;;---
(defun my/set-specific-faces-org ()
  (set-face-attribute 'org-code nil
                      :inherit '(shadow fixed-pitch))
  ;; Without indentation the headlines need to be different to be visible
  (set-face-attribute 'org-level-1 nil
                      :height 1.25
                      :foreground "#BEA4DB")
  (set-face-attribute 'org-level-2 nil
                      :height 1.15
                      :foreground "#A382FF"
                      :slant 'italic)
  (set-face-attribute 'org-level-3 nil
                      :height 1.1
                      :foreground "#A382FF"
                      :slant 'italic)
  (set-face-attribute 'org-level-4 nil
                      :height 1.05
                      :foreground "#ABABFF")
  (set-face-attribute 'org-level-5 nil
                      :foreground "#2843FB")
  (set-face-attribute 'org-date nil
                      :foreground "#ECBE7B"
                      :height 0.8)
  (set-face-attribute 'org-document-title nil
                      :foreground "DarkOrange3"
                      :height 1.3)
  (set-face-attribute 'org-ellipsis nil
                      :foreground "#4f747a" :underline nil)
  ;(set-face-attribute 'variable-pitch nil
  ;                    :family "Roboto" :size 14)
  )
;;---
(defun my/set-keyword-faces-org ()
  (mapc (lambda (pair) (push pair prettify-symbols-alist))
        '(;; Syntax
          ;("TODO" .     "")
          ;("DONE" .     "")
          ;("WAITING" .  "")
          ;("HOLD" .     "")
          ;("NEXT" .     "")
          ;("CANCELLED" . "")
          ("#+begin_quote" . "“")
          ("#+end_quote" . "”")))
  (prettify-symbols-mode +1)
  (org-superstar-mode +1)
  )
;;---
(defun my/style-org ()
  (my/set-general-faces-org)
  (my/set-specific-faces-org)
  (my/set-keyword-faces-org)
  )
;; =====================
(add-hook 'org-mode-hook 'my/style-org)
;;(add-hook 'markdown-mode-hook 'my/buffer-face-mode-variable)
;;(add-hook 'mixed-pitch-mode-hook)

(use-package! ox-hugo
  :after ox)

(use-package! yaml-mode
  :mode ("\\.yml\\'" . yaml-mode))

(remove-hook 'text-mode-hook #'auto-fill-mode)
(add-hook 'message-mode-hook #'word-wrap-mode)

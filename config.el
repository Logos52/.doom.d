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
        doom-themes-enable-italic t)
  (load-theme 'doom-gruvbox t)
   ;https://github.com/doomemacs/themes/tree/screenshots
  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  (doom-themes-org-config))
                                        ;
(if (eq initial-window-system 'x)                 ; if started by emacs command or desktop file
        (toggle-frame-maximized))

;;Take all lines and soft wrap to 90 characters
(setq-default word-wrap t)
(setq fill-column 90
      visual-fill-column-width 90
      global-visual-fill-column-mode +1
      +global-word-wrap-mode +1)

(setq
 org-roam-directory "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/Capture/"
 org-roam-index-file "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/Capture/index.org"
 org-directory "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/"
 projectile-project-search-path '("~/Documents/Projects")
 display-line-numbers-type t
 fancy-splash-image "/Users/n1/Documents/Projects/Emacs/Images/emacs-e-logo.png"
 deft-directory "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/"
 deft-recursive t
 deft-extensions '("org" "txt")
 deft-default-extension "org"
 deft-use-filter-string-for-filename t
 deft-text-mode 'org-mode
 org-mode-hide-leading-stars t
 ;org-bullets-bullet-list '("⁖")
 org-superstar-headline-bullets-list '("⁖" "○" "⚬" "∙" "∘")
 org-ellipsis " ... "
 org-startup-with-inline-images t
 org-image-actual-width nil)
;org-todo-keyword-faces
;   '(("TODO" :foreground "#7c7c75" :weight normal :underline t)
;     ("WAITING" :foreground "#9f7efe" :weight normal :underline t)
;     ("INPROGRESS" :foreground "#0098dd" :weight normal :underline t)
;     ("DONE" :foreground "#50a14f" :weight normal :underline t)
;     ("CANCELLED" :foreground "#ff6480" :weight normal :underline t))
;   org-priority-faces '((65 :foreground "#e45649")
;                        (66 :foreground "#da8548")
;                        (67 :foreground "#0098dd"))
;   ))


 ;+doom-dashboard-banner-file (expand-file-name "logo.png" doom-private-dir)

;; CUA type customizations via Simpleclip =====================================
;; Bindings + access to system clipboard
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

;; Save. Was: isearch-forward
(map! "C-s" #'save-buffer)
;; Save as. Was: nil
(map! "C-S-s" #'write-file)

;; Ctrl shift P like Sublime Text Editor for command launching
(map! "C-S-p" #'execute-extended-command)
;; ============================================================================

;; Org Journal -------------------
(use-package org-journal
  ;:bind
  ;("C-c n j" . org-journal-new-entry)
  :custom
  (org-journal-dir "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/Journal/")
  (org-journal-date-prefix "#+title: ")
  ;(org-journal-date-format "%A, %d %B %Y")
  (org-journal-date-format "%Y-%m-%d, %a")
  (org-journal-time-prefix "* ")
  (org-journal-file-format "%Y-%m-%d.org"))

;; Org Roam -------------------
(use-package org-roam
  ;:ensure t
  ;:init
  ;(setq org-roam-v2-a   fck t) ;shows a warning if you migrated from Org Roam, shouldn't need this
  :custom
    (org-roam-completion-everywhere t)
    (org-roam-capture-templates
     '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)))
    (org-roam-dailies-directory "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/Journal/")
    (org-roam-dailies-capture-templates
         '(("d" "default" entry "* %<%H:%M>: %?"
         :if-new (file+head "%<%Y-%m-%d>.org" "%<%Y-%m-%d>\n"))))
    :config
        (org-roam-setup)
        (org-roam-db-autosync-mode)
   )

;; Org-yt package for in-line youtube videos

;;  Code source: https://github.com/jrblevin/deft/issues/75
;;  "Parse the given FILE and CONTENTS and determine the title. If `deft-use-filename-as-title' is nil, the title is taken to be the first non-empty line of the FILE.  Else the base name of the FILE used as title."
(defun cm/deft-parse-title (file contents)
      (let ((begin (string-match "^#\\+[tT][iI][tT][lL][eE]: .*$" contents)))
        (if begin
            (string-trim (substring contents begin (match-end 0)) "#\\+[tT][iI][tT][lL][eE]: *" "[\n\t ]+")
          (deft-base-filename file))))

    (advice-add 'deft-parse-title :override #'cm/deft-parse-title)

    (setq deft-strip-summary-regexp
          (concat "\\("
                  "[\n\t]" ;; blank
                  "\\|^#\\+[[:alpha:]_]+:.*$" ;; org-mode metadata
                  "\\|^:PROPERTIES:\n\\(.+\n\\)+:END:\n"
                  "\\)"))
  ;(deft-directory org-roam-directory)

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
    :after org-roam ;; or :after org
;;  :hook (after-init . org-roam-ui-mode) ;use if you don't care about startup time
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

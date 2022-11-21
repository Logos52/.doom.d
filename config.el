(setq user-full-name "Jay Cantimbuhan"
      user-mail-address "nxlogos@gmail.com")

;(unless (equal "Battery status not available"
;  (battery))
;  (display-battery-mode 1))    ; On laptops it's nice to know how much power you have
                                        ;
(use-package doom-themes
  :ensure t
  :config
  ;; Global defaults
  (setq org-directory "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/Org"
        projectile-project-search-path '("~/Documents/Projects/")
        org-hugo-section "notes"
        org-hugo-base-dir "~/website/"
        fancy-splash-image "/Users/n1/Documents/Projects/Emacs/Images/emacs-e-logo.png"
        deft-directory "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/"
        ;---
        doom-themes-enable-bold t
        doom-themes-enable-italic t
        load-prefer-newer t
        doom-font (font-spec :family "Dank Mono" :size 14.0)
        doom-variable-pitch-font (font-spec :family "iA Writer Duospace" :size 15)
        doom-serif-font (font-spec :family "Libre Baskerville")
        doom-theme 'doom-one
        display-line-numbers-mode t
        +zen-text-scale 1
        writeroom-extra-line-spacing 0.3
        prettify-symbols-mode t
        scroll-error-top-bottom t
        search-highlight t
        )
  (custom-set-faces!
        '(font-lock-keyword-face :slant italic))

;; (doom-themes-visual-bell-config)
;; (doom-themes-neotree-config)
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
;; (doom-themes-treemacs-config)
;; (doom-themes-org-config)
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
  (setq org-attach-dir-relative t
        org-startup-with-inline-images 1
        ;org-startup-indented nil
        ;line-spacing 3
        )
  )

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

;; Org-Agenda
(setq org-agenda-files '("/Users/n1/Library/Mobile\ Documents/com\~apple\~CloudDocs/NX/Agenda/")
      org-agenda-custom-commands
        '(("c" "Simple agenda view"
         ((agenda "")
          (alltodo "")))))

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



;; Org Roam ---------------------------------------
;; ------------------------------------------------
(use-package! org-roam
  :ensure t
  :init
  (setq org-roam-directory "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/Capture/"
        org-roam-dailies-directory "/Users/n1/Library/Mobile Documents/com~apple~CloudDocs/NX/Journal/"
        org-id-link-to-org-use-id t)
  :config
    (setq org-roam-completion-everywhere t)
    (org-roam-db-autosync-mode +1)
    (setq org-roam-capture-templates
     '(("d" "default" plain "%?"
       :immediate-finish t
      :if-new (file+head "${slug}.org"
                         "#+title: ${title}\n#+hugo_lastmod: Time-stamp: <>\n\n")
      :unarrowed t))
        org-roam-dailies-capture-templates
         '(("d" "default" entry "* %?"
         :immediate-finish t
         ;:unarrowed t
         :target (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n"))))

     )
    (setq org-roam-mode-sections
        (list #'org-roam-backlinks-insert-section
              #'org-roam-reflinks-insert-section
              #'org-roam-unlinked-references-insert-section))
  (org-roam-db-autosync-mode)
  (org-roam-db-autosync-enable)
  (setq org-roam-v2-ack t)

   ;  --- Org Roam Dailies

(setq org-id-extra-files (directory-files-recursively org-roam-directory "\.org$")
      org-export-with-broken-links t
      org-export-preserve-breaks t
      )

;; --------------------------------------------------
;; ;; Org Journal -------------------


;;  Code source: https://github.com/jrblevin/deft/issues/75
;;  "Parse the given FILE and CONTENTS and determine the title.
;;  If `deft-use-filename-as-title' is nil, the title is taken to be
;;    the first non-empty line of the FILE.
;;  Else the base name of the FILE used as title."
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

(add-hook 'before-save-hook 'time-stamp)
(setq org-return-follows-link t)

;; Setting up Org markdown
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "DONE(d)")))

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
          ("DONE" . ?✔)))
  (org-superstar-restart))
(setq org-ellipsis " ... ")
(setq org-hide-emphasis-markers t)

;;Org files, buffer face, general styles,
;; ---
;;
(defun my/set-faces-org ()
  (setq line-spacing 0.1
        org-pretty-entities t
        electric-indent-mode t
        )
  (variable-pitch-mode +1)
  (mapc
   (lambda (face) ;; Other fonts that require this are set to fixed-pitch.
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
  (mapc ;; Sets the fonts to a smaller size
   (lambda (face)
     (set-face-attribute face nil :height 0.8))
   (list 'org-document-info-keyword
         'org-block-begin-line
         'org-block-end-line
         'org-meta-line
         'org-drawer
         'org-property-value
         ))
  (set-face-attribute 'org-code nil
                      :inherit '(shadow fixed-pitch))
  ;; Without indentation the headlines need to be different to be visible
  ;; https://coolors.co/bea4db-a382ff-9b77ff-9999ff-7385fc
  (set-face-attribute 'org-level-1 nil
                      ;:height 1.1
                      :foreground "#BEA4DB")
  (set-face-attribute 'org-level-2 nil
                      ;:height 1.075
                      :foreground "#A382FF")
  (set-face-attribute 'org-level-3 nil
                      ;:height 1.05
                      :foreground "#9B77FF")
  (set-face-attribute 'org-level-4 nil
                      ;:height 1.025
                      :foreground "#9999FF")
  (set-face-attribute 'org-level-5 nil
                      :foreground "#7385FC")
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
(add-hook 'org-mode-hook 'my/set-faces-org)

;(use-package! ox-hugo
;  :after ox)
(with-eval-after-load 'ox
  (require 'ox-hugo))

(setq org-hugo-front-matter-format "yaml"
      org-hugo-prefer-hyphen-in-tags t
      org-hugo-delete-trailing-ws nil
      )

(use-package! yaml-mode
  :mode ("\\.yml\\'" . yaml-mode))

(remove-hook 'text-mode-hook #'auto-fill-mode)
(add-hook 'message-mode-hook #'word-wrap-mode)

;; Org mode Misc customizations
(use-package! org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :config (setq
           ;org-appear-autolinks t
           org-appear-autoentities t
           org-appear-autosubmarkers t ))


(after! centaur-tabs
  (setq centaur-tabs-style "wave"))
;;Org mode Buffer  (https://github.com/tefkah/doom-emacs-config)
(defun org-roam-buffer-setup ()
  "Function to make org-roam-buffer more pretty."
  (progn
    (variable-pitch-mode 1)
    (centaur-tabs-local-mode -1)

  (set-face-background 'magit-section-highlight (face-background 'default))))

(after! org-roam
(add-hook! 'org-roam-mode-hook #'org-roam-buffer-setup))

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
         org-roam-ui-follow t
         org-roam-ui-update-on-save t)
  )

(use-package! org-roam-ui
    :after org-roam
    :config
    (setq
        org-roam-ui-open-on-start t))

;; Test function, remove stars
(defun org-mode-remove-stars ()
  (font-lock-add-keywords
   nil
   '(("^\\*+ "
      (0
       (prog1 nil
         (put-text-property (match-beginning 0) (match-end 0)
                            'invisible t)))))))

(add-hook! 'org-mode-hook #'org-mode-remove-stars)

;;; Ugly org hooks
(defun nicer-org ()
  (progn
  (+org-pretty-mode 1)
  (mixed-pitch-mode 1)
  (hl-line-mode -1)
  (display-line-numbers-mode -1)
  (org-superstar-mode -1)
  (electric-indent-mode 1)
  ))

(add-hook! 'org-mode-hook
           #'nicer-org
           'org-fragtog-mode
           )
; Org hugo export section
;;((nil . ((org-hugo-base-dir . "~/website")
;;         (org-hugo-section . "notes"))))

;(defun org-roam-file-p (&optional file)

;;Auto export on save 
(require 'find-lisp)
;(setq org-id-extra-files (find-lisp-find-files org-roam-directory "\.org$"))
;(defun org-hugo--org-roam-save-buffer(&optional no-trace-links)
;  "On save export to hugo"
;  ;(when (org-roam--org-roam-file-p)  ... )
;      (org-hugo-export-wim-to-md))

;; find lisp find files
;;
;(add-to-list 'after-save-hook #'org-hugo--org-roam-save-buffer)


; Sync Org-Roam capture files into Website notes directory
(defun my-org-hugo-org-roam-sync-all()
  ""
  (interactive)
  (dolist (fil (org-roam--list-files org-roam-directory))
    (with-current-buffer (find-file-noselect fil)
      (org-hugo-export-wim-to-md)
      (kill-buffer))))

(setq native-comp-async-jobs-number 1)
(setq org-fold-core-style 'overlays)

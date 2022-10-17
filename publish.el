;;; publish --- Summary
;;; Commentary:
(require 'find-lisp)

;;; Code:
;(defun my/publish (file)
  "Publish a note in FILE."
;  (interactive)
;  (with-current-buffer (find-file-noselect file)
;    (projectile-mode -1)
;    (setq org-hugo-section "notes"
;          org-hugo-base-dir "~/website/content/"
;          ;;citeproc-org-org-bib-header "* Bibliography\n<ol class=\"biblio-list\">"
;          ;;citeproc-org-org-bib-footer "</ol>")
;    (let ((org-id-extra-files (find-lisp-find-files org-roam-directory "\.org$")))
;        (org-hugo-export-wim-to-md))))

(defun my/publish (file)
  (with-current-buffer (find-file-noselect file)
    ;;(setq org-hugo-base-dir "..")
    (let ((org-id-extra-files (find-lisp-find-files org-roam-directory "\.org$")))
      (org-hugo-export-wim-to-md)))
  )

;(my/publish)

;(provide 'publish)
;;; publish.el ends here

;;; ox-gitbook.el --- Export your Org file to GitBook book format -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 milkhouse
;;
;; Author: milkhouse <https://github.com/milkhouse1990>
;; Maintainer: milkhouse <milkhouse1990@gmail.com>
;; Created: Mar 25, 2021
;; Modified: Mar 25, 2021
;; Version: 0.0.1
;; Keywords: org, gitbook
;; Homepage: https://github.com/milkhouse1990/ox-gitbook
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:

;; Org-mode export backend to produce books in the structure of GitBook.
;; `ox-gitbook' allows you to write your material entirely in Org mode, and
;; completely manages the markdown files required by GitBook.

;;; Code:

(require 'ox)

(defun org-gitbook-setup-menu ()
  "Set up the export menu entries within the Gitbook menu."
  (interactive)
  (org-export-define-derived-backend
      'gitbook-md
      'md
    :menu-entry
    '(?b "Export to gitbook"
         ( (?b "Current subtree"
              (lambda (a s v b)
                (org-gitbook-export-chapter a s v b)))
          (?B "Current subtree and update toc"
              (lambda (a s v b)
                (org-gitbook-export-chapter-toc a s v b)))
         (?j "Whole book"
              (lambda (a s v b)
                (org-gitbook-export-book a s v b)))
          ))))

(defun org-gitbook-export-chapter (&optional async subtreep visible-only body-only)
  "Exports current subtree to a gitbook page."
  (interactive)
  ;; select the subtree so that its headline is also exported (otherwise we get just the body)
  (org-mark-subtree)
  (let ((outfile (org-export-output-file-name ".md" t)))
    (org-export-to-file 'md outfile async subtreep visible-only body-only '(:with-toc nil))))

(defun org-gitbook-export-toc (&optional async subtreep visible-only body-only)
  "Update TOC."
  (interactive)
  ;; TODO
  )

(defun org-gitbook-export-readme (&optional async subtreep visible-only body-only)
  "Export `readme.org' to `readme.md'."
  (interactive)
  ;; TODO
  )

(defun org-gitbook-export-chapter-toc (&optional async subtreep visible-only body-only)
  "Export current subtree and update TOC."
  (interactive)
  (org-gitbook-export-chapter async subtreep visible-only body-only)
  (org-gitbook-export-toc async subtreep visivle-only body-only))

(defun org-gitbook-export-book (&optional async subtreep visible-only body-only)
  "Exports buffer to a gitbook book."
  (interactive)
  (org-gitbook-export-toc async subtreep visivle-only body-only)
  (org-gitbook-export-readme async subtreep visivle-only body-only)
  (save-mark-and-excursion
    (org-map-entries
     (lambda ()
       (when (org-at-heading-p)
         (org-gitbook-export-chapter async subtreep visible-only body-only))))))

(org-gitbook-setup-menu)

(provide 'ox-gitbook)
;;; ox-gitbook.el ends here

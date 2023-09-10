;; Copyright (C) 2023 by Lucas  Elvira Martín
;;  run emacs -Q --batch -l ./publish.el --funcall lem/publish


;; Initialize package source
(require 'package)
(setq package-user-dir (expand-file-name "./.package"))

;; Add some repositories
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.Melpa.org/packages/"))

;;  Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(require 'vc-git)
(require 'ox-publish)
(require 'subr-x)
(require 'cl-lib)

;; Install other dependencies
(use-package esxml
  :pin "melpa-stable"
  :ensure t)

(use-package htmlize
  :ensure t)

(use-package  org
  :ensure  t)
;(use-package  org-roam
;  :ensure t)


(setq user-full-name "Lucas Elvira Martín")
(setq user-mail-address "luelvira@pa.uc3m.es")

(defvar lem/site-url (if (string-equal (getenv "CI") "true")
			 "https://luelvira.github.io/interfaces-usuario"
		       "http://localhost:8080")
  "The url of the site")

(defun lem/get-commit ()
  "Get the short hash of the latest commit in the current repository."
  (concat  (string-trim-right
	     (with-output-to-string
	       (with-current-buffer standard-output
		 (vc-git-command t nil nil "log" "-1" "--date=format:\"%Y/%m/%d %T\"" "--format=%ad"))))
	   " "
	   (string-trim-right
	    (with-output-to-string
	      (with-current-buffer standard-output
		(vc-git-command t nil nil "rev-parse" "--short" "HEAD"))))))

(defun lem/include-date (publish-date)
  (list `(p "hola")))

(cl-defun  lem/generate-page (
			      title
			      content
			      info
			      &key
			      (publish-date))
  (concat
   "<!-- Generate from " (lem/get-commit) " with " org-export-creator-string " -->\n"
   "<!DOCTYPE html>"
   (sxml-to-xml
    `(html (@ (lang "en"))
	   (head
	    (meta (@ (charset "utf-8")))
	    (meta (@ (author ,user-full-name)))
	    (meta (@ (name "viewport")
		     (content "width=device-width, initial-scale=1")))
	    (link (@ (rel "stylesheet") (href ,(concat lem/site-url "/css/code.css"))))
	    (link (@ (rel "stylesheet") (href ,(concat lem/site-url "/css/style.css"))))
	    (title ,(concat title " - Jumble"))
	    (script (@ (defer "defer" )
		       (data-domain "luelvira.github.io/interfaces-usuario")
		       (src "https://plausible.io/js/script.js"))
		    ""))
	   (body
	    (header (@ (class "site-header"))
		    (h1 ,title)
		    ,(unless (= (length publish-date) 0) (concat "<p class=\"date\">Date: " publish-date "</p>"))
		    (nav (@ (class "nav-side"))
			 (ul (@ (class "nav-categories"))
			     (li (a (@ (href "/")) "Home"))
			     (li (a (@ (href "/sessions.html")) "Theory"))
			     (li (a (@ (href "/practice.html")) "Practice")))))
	    (main (@ (class "main-content"))
		  (section
		   (article (@ (class "post"))
			    ,content)))
	    (footer  (@ (class "footer-site"))
			     (div (@ (class "copyright"))
				  (p ,(concat "© 2023-2024 " (org-export-data (plist-get info :author) info)  " ")
				     (br)
				     (a (@ (href ,(concat "mailto:" user-mail-address)))
					,user-mail-address)))
			     (div (@ (class "Generated"))
				  (p ,(concat "Generated with " org-export-creator-string)))
			     (div (@ (class "colabore"))
				  (a (@ (href "https://github.com/luelvira/interfaces-usuario/")
					(target "_blank"))
				     (img (@ (src ,(concat lem/site-url "/img/github-mark-white.png"))
					     (alt "Link to the github repository")))))))))))
				       



  
(defun lem/html-template (contents info)
  (lem/generate-page (org-export-data (plist-get info :title) info)
		     contents
		     info
		     :publish-date (org-export-data (org-export-get-date info "%B %e, %Y") info)))

(defun lem/org-html-src-block (src-block _contents info)
  (let* ((lang (org-element-property :language src-block))
	       (code (org-html-format-code src-block info)))
    (format "<pre>%s</pre>" (string-trim code))))

(org-export-define-derived-backend 'site-html 'html
  :translate-alist
  '(
    (template . lem/html-template)
    (src-block . lem/org-html-src-block)
    ))

(defun org-html-publish-to-html (plist filename pub-dir)
  "Publish aan org file to html with the custom backend"
  (org-publish-org-to 'site-html
		      filename
		      (concat "." (or (plist-get plist :html-extension) "html"))
		      plist
		      pub-dir))


;; Define the configuration

(setq org-publish-use-timestamps-flag t
      org-publish-timestamp-directory "./.org-cache/"
      org-export-with-section-numbers nil
      org-export-use-babel nil
      org-export-with-smart-quotes t
      org-export-with-sub-superscripts t
      org-export-with-tags nil
      org-export-with-title  nil
      org-export-with-author  t
      org-export-with-date t
      org-export-with-timestamps t
      org-html-htmlize-output-type 'css
      org-html-prefer-user-labels t
      org-html-link-home lem/site-url
      org-html-html5-fancy t
      org-html-head-include-default-style  nil
      org-html-head-include-scripts  nil
      org-export-with-toc nil
      make-backup-files nil)

;; configure the project to be published

(defun format-entry-sitemap (entry style project)
  (format "%s - [[file:%s][%s]]"
	  (format-time-string "%Y-%m-%d" (org-publish-find-date entry project))
	  entry
	  (org-publish-find-title entry project)
	  ))

(setq org-publish-project-alist
      '(("jumble"
	 :base-directory "./content"
	 :recursive nil
	 :base-extension "org"
	 :publishing-directory "./public/"
	 :publishing-function org-html-publish-to-html
	 :headline-levels 4
	 )
	("theory"
	 :base-directory "./content/sessions/"
	 :base-extension "org"
	 :publishing-directory "./public/sessions"
	 :publishing-function org-html-publish-to-html
	 :headline-levels 4
	 :auto-sitemap t
	 :sitemap-style list
	 :sitemap-title ""
	 :sitemap-filename "sessions.org"
	 :sitemap-format-entry format-entry-sitemap
	 :sitemap-sort-files chronologically)
	("practice"
	 :base-directory "./content/practice/"
	 :base-extension "org"
	 :publishing-directory "./public/practice/"
	 :publishing-function org-html-publish-to-html
	 :headline-levels 4
	 :auto-sitemap t
	 :sitemap-style list
	 :sitemap-filename "practice.org"
	 :sitemap-title  ""
	 :sitemap-format-entry format-entry-sitemap
	 :sitemap-sort-files chronologically)
	("attachment"
	 :base-directory "./assets"
	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\\|ttf"
	 :publishing-directory "./public"
	 :recursive t
	 :publishing-function org-publish-attachment)
	("myproject" :components( "theory" "practice" "attachment" "jumble"))))

(defun lem/publish ()
  "Start the publish process"
  (interactive)
  (org-publish-all (string-equal (or (getenv "FORCE")
				     (getenv "CI"))
				 "true")))

(provide  'publish)



;;; Initialization file

;;; Config file copied from mcatania
;;;

(defvar current-user
      (getenv
       (if (equal system-type 'windows-nt) "USERNAME" "USER")))

(message "Loading  %s configuration" current-user)

(defvar initialize-dir (file-name-directory load-file-name)
  "The root dir of the Emacs Initialize distribution.")
(defvar initialize-core-dir (expand-file-name "core" initialize-dir)
  "The home of Initialize's core functionality.")
(defvar initialize-modules-dir (expand-file-name  "modules" initialize-dir)
  "This directory houses all of the lang-specific modules.")
(defvar initialize-external-dir (expand-file-name  "external" initialize-dir)
  "This directory houses external modules.")
(defvar initialize-personal-dir (expand-file-name "personal" initialize-dir)
  "This directory is for your personal configuration.

Users of Emacs Prelude are encouraged to keep their personal configuration
changes in this directory.  All Emacs Lisp files there are loaded automatically
by Prelude.")

(defun initialize-add-subfolders-to-load-path (parent-dir)
 "Add all level PARENT-DIR subdirs to the `load-path'."
 (dolist (f (directory-files parent-dir))
   (let ((name (expand-file-name f parent-dir)))
     (when (and (file-directory-p name)
                (not (equal f ".."))
                (not (equal f ".")))
       (add-to-list 'load-path name)
       (initialize-add-subfolders-to-load-path name)))))

;; add Initialize's directories to Emacs's `load-path'
(add-to-list 'load-path initialize-core-dir)
(add-to-list 'load-path initialize-modules-dir)
(add-to-list 'load-path initialize-external-dir)

;; the core stuff.


;; language-specific packages.
(require 'initialize-org)

;; config changes made through the customize UI will be store here
(setq custom-file (expand-file-name "custom.el" initialize-personal-dir))

;; load the personal settings (this includes `custom-file')
(when (file-exists-p initialize-personal-dir)
  (message "Loading personal configuration files in %s..." initialize-personal-dir)
  (mapc 'load (directory-files initialize-personal-dir 't "^[^#].*el$")))

(message "Initialize is ready")
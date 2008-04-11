
;;; Part of my .emacs file

;; by Phil Hagelberg
;; Much thanks to emacswiki.org and RMS.

;; Note: this relies on files found in my dotfiles repository:
;; http://git.caboo.se/?p=technomancy.git;a=summary

;;;; defuns

;;; Network stuff

(defun view-url (url)
  "Open a new buffer containing the contents of URL."
  (interactive "MUrl: ")
  (switch-to-buffer (url-retrieve-synchronously url))
  (rename-buffer url t)
  (html-mode))

(defun map-coords (lat lng)
  "Show a Yahoo map marked with the point LAT by LNG."
  (interactive "BLatitude: \nBLongitude")
  (w3m-browse-url (concat "http://maps.yahoo.com/maps_result?mag=12&lat="
                          lat "&lon=" lng)))

;;; Buffer/window stuff

(defun my-selective-display (column)
  "Rotate folding the buffer at no, 2, 4, and 6 columns."
  (interactive "P")
  (set-selective-display
   (if (< (or selective-display 0) 6)
       (or column (+ (or selective-display 0) 2))
     nil)))

(defun swap-buffers ()
  "Swap the current 2 buffers in their windows"
  (interactive)
  (if (one-window-p)
      (error "Frame doesn't have two windows")
    (let* ((cw (selected-window))
           (nw (next-window cw))
           (cb (buffer-name (window-buffer cw)))
           (nb (buffer-name (window-buffer nw))))
      (switch-to-buffer nb)
      (select-window nw)
      (switch-to-buffer cb))))

(defun current-window ()
  "Why get-buffer-window instead of buffer-window? Why isn't this defined already?"
  (get-buffer-window (current-buffer)))

(defun toggle-dedicated-window ()
  "Toggle the window-dedicated-p state of current window."
  (set-window-dedicated-p (current-window) (not (window-dedicated-p (current-window)))))

(defun my-coding-hook ()
  "Enable things I consider convenient across all coding buffers."
  ;; (indent-buffer)
  ;; (whitespace-mode t)
  (hl-line-mode)
  (setq indicate-empty-lines t)
  (font-lock-add-keywords nil
			  '(("\\<\\(FIX\\|TODO\\|FIXME\\|HACK\\|REFACTOR\\):" 1 font-lock-warning-face t))))

(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

;;; Cosmetic stuff

(defun pretty-lambdas ()
  (font-lock-add-keywords
   nil `(("(?\\(lambda\\>\\)"
	  (0 (progn (compose-region (match-beginning 1) (match-end 1)
				    ,(make-char 'greek-iso8859-7 107))
		    nil))))))

(defun terminus () (interactive) (set-default-font "-xos4-terminus-medium-r-normal--14-140-72-72-c-80-iso8859-1"))
(defun inconsolata () (interactive) (set-default-font "Inconsolata-12"))

;;; Random stuff

(defun my-recompile-init ()
  (interactive)
  (byte-recompile-directory (expand-file-name "~/.emacs.d") 0))

(defun my-generate-elisp-tags ()
  (interactive)
  (shell-command "find ~/.emacs.d ~/src/emacs -name \\*el | xargs etags -o ~/.emacs.d/TAGS"))

(defun my-generate-rails-tags ()
  (interactive)
  (shell-command (format "find %s -name *rb | xargs ctags-exuberant -a -e -f %s/TAGS --exclude=vendor"
			 (rails-root) (rails-root))))

(defun my-generate-ruby-tags ()
  (interactive)
  (flet ((rails-root () (cadr (split-string (pwd) " ")))) (my-generate-rails-tags)))

(defun sudo-edit ()
  (interactive)
  (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name)))

(defun lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
          "minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))

(defun todo ()
  (interactive)
  (switch-to-buffer "*todo*")
  (emacs-lisp-mode)
  (insert-file-contents "~/.emacs")
  (goto-char (point-max))
  (search-backward ";;; TODO")
  (kill-region (point-min) (point)))

(defun display-image ()
  "display images using imagemagick"
  (interactive)
  (shell-command (concat "display "
                         (thing-at-point 'filename))))

(defun ss () (interactive) (server-start))

(provide 'my-defuns)
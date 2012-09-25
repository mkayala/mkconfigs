;Matt Kayala - Elisp setup for org-mode and remember

;; Basic loading of org-mode
(setq load-path (cons "~/.emacs.d/vendor/org-6.36c/lisp" load-path))
(setq load-path (cons "~/.emacs.d/vendor/org-6.36c/contrib/lisp" load-path))

(require 'org-install)

;; Now babel
(require 'org-babel-init)
(require 'org-babel-R)
(require 'org-babel-python)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cb" 'org-iswitchb)

(global-font-lock-mode 1)
(setq org-log-done t)


(autoload 'org-mode "org" "Org mode" t)
(autoload 'org-diary "org" "Diary entries from Org mode")
(autoload 'org-agenda "org" "Multi-file agenda from Org mode" t)
(autoload 'org-store-link "org" "Store a link to the current location" t)
(autoload 'orgtbl-mode "org" "Org tables as a minor mode" t)
(autoload 'turn-on-orgtbl "org" "Org tables as a minor mode")

(setq org-agenda-include-diary nil)
(setq org-deadline-warning-days 7)
(setq org-timeline-show-empty-dates t)
(setq org-insert-mode-line-in-empty-file t)

; Include pomodoro mode
;(require 'pomodoro)

;(add-to-list 'load-path "~/.emacs.d/remember-2.0")

;(autoload 'remember "remember" nil t)
;(autoload 'remember-region "remember" nil t)

(setq org-directory "~/org/")
(setq org-default-notes-file "~/org/refile.org")

;;;  Load Org Remember Stuff
(require 'remember)
(org-remember-insinuate)

;; Start clock if a remember buffer includes :CLOCK-IN:
(add-hook 'remember-mode-hook 'bh/start-clock-if-needed 'append)

(defun bh/start-clock-if-needed ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward " *:CLOCK-IN: *" nil t)
      (replace-match "")
      (org-clock-in))))


(setq remember-annotation-functions '(org-remember-annotation))
(setq remember-handler-functions '(org-remember-handler))
(add-hook 'remember-mode-hook 'org-remember-apply-template)
(define-key global-map "\C-cr" 'org-remember)

(setq org-remember-templates (quote (("todo" ?t "* TODO %?\n  %u\n  %a" nil bottom nil)
                                     ("note" ?n "* %?                                        :NOTE:\n  %u\n  %a" nil bottom nil)
                                     ("phone" ?p "* PHONE %:name - %:company -                :PHONE:\n  Contact Info: %a\n  %u\n  :CLOCK-IN:\n  %?" nil bottom nil)
                                     ("Someday" ?s "* SOMEDAY %^{topic} %T \n%i%?\n" nil bottom nil )
                                     ("Meeting" ?m "* MEETING %:name %T :MEETING:\n        :CLOCK-IN:\n  %?" school.org Meetings nil)
                                     ("org-protocol" ?w "* TODO Review %c%!  :NEXT:\n  %U\n  :PROPERTIES:\n  :Effort: 0:10\n  :END:" nil bottom nil))))


;(setq org-remember-templates
;     '(
;      ("Todo" ?t "* TODO %^{Brief Description} %^g\n%?\nAdded: %U" "~/org/school.org" "Tasks")
;      ("Paper" ?p "* TODO %^{Brief Description} %^g\n%?\nAdded: %U" "~/org/school.org" "Papers")
;      ("Note" ?n "\n* %^{topic} %T \n%i%?\n" "~/org/notes.org")
;      ("Home" ?h "** TODO %^{Brief Description} %^g\n%?\nAdded: %U" "~/org/home.org" "Tasks")
;      
 ;     ))

(define-key global-map [f8] 'remember)



(setq org-agenda-exporter-settings
      '((ps-number-of-columns 1)
        (ps-landscape-mode t)
        (htmlize-output-type 'css)))

(setq org-agenda-custom-commands
'(

("P" "Projects"   
((tags "PROJECT")))

("S" "School Lists"
     ((agenda)
          (tags-todo "School")
))

("H" "Home Lists"
     ((agenda)
           (tags-todo "Home")
))


("D" "Daily Action List"
     (
          (agenda "" ((org-agenda-ndays 1)
                      (org-agenda-sorting-strategy
                       (quote ((agenda time-up priority-down tag-up) )))
                      (org-deadline-warning-days 0)
                      ))))
)
)

(setq org-agenda-files (file-expand-wildcards "~/org/[a-zA-Z]*.org"))


(defun runorg()
  (interactive)
  (find-file "~/org/school.org")
)
(global-set-key (kbd "C-c g") 'runorg)

; Use IDO for target completion
(setq org-completion-use-ido t)

; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 5) (nil :maxlevel . 5))))

; Targets start with the file name - allows creating level 1 tasks
(setq org-refile-use-outline-path (quote file))

; Targets complete in steps so we start with filename, TAB shows the next level of targets etc
(setq org-outline-path-complete-in-steps t)


(setq org-todo-keywords (quote ((sequence "TODO(t)" "STARTED(s!)" "|" "DONE(d!/!)")
 (sequence "WAITING(w@/!)" "SOMEDAY(S!)" "OPEN(O@)" "|" "CANCELLED(c@/!)")
)))

;; Change task state to STARTED when clocking in
(setq org-clock-in-switch-to-state "STARTED")

; set logging
(setq org-log-done (quote time))
(setq org-log-into-drawer t)


;;
;; Resume clocking tasks when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Yes it's long... but more is better ;)
(setq org-clock-history-length 35)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change task state to STARTED when clocking in
(setq org-clock-in-switch-to-state "STARTED")
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK" "CLOCK" "MKCODE")))
;; Save clock data in the CLOCK drawer and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer "CLOCK")
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Don't clock out when moving task to a done state
(setq org-clock-out-when-done nil)

;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist (quote history))

;; for clock reporting
(setq org-agenda-log-mode-items (quote (clock)))



(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t) ("NEXT"))
              ("SOMEDAY" ("WAITING" . t))
              (done ("NEXT") ("WAITING"))
              ("TODO" ("WAITING") ("CANCELLED") ("NEXT"))
              ("DONE" ("WAITING") ("CANCELLED") ("NEXT")))))


(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-keyword-faces (quote (("TODO" :foreground "red" :weight bold)
 ("STARTED" :foreground "blue" :weight bold)
 ("DONE" :foreground "forest green" :weight bold)
 ("WAITING" :foreground "orange" :weight bold)
 ("SOMEDAY" :foreground "magenta" :weight bold)
 ("CANCELLED" :foreground "forest green" :weight bold)
)))


; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")


; global Effort estimate values
(setq org-global-properties (quote (("Effort_ALL" . "0:10 0:30 1:00 2:00 4:00 6:00 8:00 12:00 16:00 24:00 40:00"))))

; Erase all reminders and rebuilt reminders for today from the agenda
(defun bh/org-agenda-to-appt ()
  (interactive)
  (setq appt-time-msg-list nil)
  (org-agenda-to-appt))

; Rebuild the reminders everytime the agenda is displayed
(add-hook 'org-finalize-agenda-hook 'bh/org-agenda-to-appt)

; This is at the end of my .emacs - so appointments are set up when Emacs starts
(bh/org-agenda-to-appt)

; Activate appointments so we get notifications
(appt-activate t)
;Actually turn this off.  It is annoying to lose focus 
(appt-activate -1)

; If we leave Emacs running overnight - reset the appointments one minute after midnight
;(run-at-time "24:01" nil 'bh/org-agenda-to-appt)

